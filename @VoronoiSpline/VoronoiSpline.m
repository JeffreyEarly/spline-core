classdef VoronoiSpline < handle
    % Voronoi-cell spline representation in 1-D and on 2-D Bravais lattices.
    %
    % In 1-D this class intentionally mirrors the BSpline API and uses an
    % exact BSpline representation internally. In 2-D the basis is built by
    % sampling the K-fold convolution of the Voronoi-cell indicator on a
    % Bravais lattice. The 2-D path is therefore approximate, but it makes
    % the geometry of Voronoi splines explicit and provides a concrete basis
    % matrix/evaluation path for experimentation.
    %
    % Basic 1-D usage:
    %
    % ```matlab
    % t = linspace(0,1,15)';
    % K = 4;
    % sites = VoronoiSpline.sitesForDataPoints(t, K=K);
    % X = VoronoiSpline.matrix(t, sites, K);
    % spline = VoronoiSpline(K, sites, X \ sin(2*pi*t));
    % ```
    %
    % Basic 2-D usage:
    %
    % ```matlab
    % lattice = VoronoiSpline.hexLattice([-1 1; -1 1], spacing=0.4, padding=2);
    % B = VoronoiSpline.matrix([0 0; 0.2 0.1], lattice, 2);
    % spline = VoronoiSpline(2, lattice, randn(size(lattice.sites,1),1));
    % ```
    properties (SetAccess = private)
        K
    end

    properties (Access = private)
        xi_
        supportSpec_
        oneDimSpline_
        basisCache_
    end

    properties
        xMean = 0
        xStd = 1
    end

    properties (Dependent)
        S
        xi
        support
        sites
        numDimensions
        domain
    end

    methods
        function self = VoronoiSpline(K, support, xi, options)
            % Create a Voronoi spline from support sites or a lattice specification.
            arguments
                K (1,1) double {mustBeInteger,mustBePositive}
                support
                xi (:,1) double = []
                options.xMean = 0
                options.xStd = 1
                options.oversampling (1,1) double {mustBePositive} = 24
            end

            spec = VoronoiSpline.normalizeSupportSpec(support, K, oversampling=options.oversampling);
            if isempty(xi)
                xi = zeros(size(spec.sites,1), 1);
            elseif numel(xi) ~= size(spec.sites,1)
                error('VoronoiSpline:InvalidCoefficientCount', ...
                    'xi must contain exactly one coefficient per support site.');
            end

            self.K = K;
            self.supportSpec_ = spec;
            self.xi_ = reshape(xi, [], 1);
            self.xMean = options.xMean;
            self.xStd = options.xStd;
            self.rebuildRepresentations();
        end

        function value = get.S(self)
            value = self.K - 1;
        end

        function value = get.xi(self)
            value = self.xi_;
        end

        function set.xi(self, value)
            arguments
                self (1,1) VoronoiSpline
                value (:,1) double
            end

            if numel(value) ~= size(self.supportSpec_.sites,1)
                error('VoronoiSpline:InvalidCoefficientCount', ...
                    'xi must contain exactly one coefficient per support site.');
            end

            self.xi_ = reshape(value, [], 1);
            if self.numDimensions == 1
                self.oneDimSpline_.xi = self.xi_;
            end
        end

        function value = get.support(self)
            value = rmfield(self.supportSpec_, {'numDimensions', 'mode'});
        end

        function value = get.sites(self)
            value = self.supportSpec_.sites;
        end

        function value = get.numDimensions(self)
            value = self.supportSpec_.numDimensions;
        end

        function value = get.domain(self)
            if self.numDimensions == 1
                value = [min(self.supportSpec_.sites), max(self.supportSpec_.sites)];
            else
                if isfield(self.supportSpec_, 'domain')
                    value = self.supportSpec_.domain;
                else
                    siteMin = min(self.supportSpec_.sites, [], 1);
                    siteMax = max(self.supportSpec_.sites, [], 1);
                    value = [siteMin(:), siteMax(:)];
                end
            end
        end

        function varargout = subsref(self, index)
            idx = index(1).subs;
            switch index(1).type
                case '()'
                    varargout{1} = self.valueAtPoints(idx{:});
                case '.'
                    [varargout{1:nargout}] = builtin('subsref', self, index);
                case '{}'
                    error('The VoronoiSpline class does not know what to do with {}.');
                otherwise
                    error('Unexpected syntax');
            end
        end

        function values = valueAtPoints(self, varargin)
            % Evaluate the spline or one of its derivatives.
            if isempty(varargin)
                error('VoronoiSpline:NotEnoughInputs', ...
                    'Specify one query input per spline dimension.');
            end

            if self.numDimensions == 1
                if numel(varargin) == 1
                    t = varargin{1};
                    derivativeOrders = 0;
                elseif numel(varargin) == 2
                    t = varargin{1};
                    derivativeOrders = VoronoiSpline.normalizeDerivativeOrders(varargin{2}, 1);
                else
                    error('VoronoiSpline:InvalidEvaluationInput', ...
                        'Use spline(t) or spline(t, D) in 1-D.');
                end

                values = self.oneDimSpline_.valueAtPoints(t, derivativeOrders);
                if ~isempty(self.xStd)
                    values = self.xStd * values;
                end
                if ~isempty(self.xMean) && derivativeOrders == 0
                    values = values + self.xMean;
                end
                return;
            end

            if numel(varargin) == self.numDimensions
                queryInputs = varargin;
                derivativeOrders = zeros(1, self.numDimensions);
            elseif numel(varargin) == self.numDimensions + 1
                queryInputs = varargin(1:end-1);
                derivativeOrders = VoronoiSpline.normalizeDerivativeOrders(varargin{end}, self.numDimensions);
            else
                error('VoronoiSpline:InvalidEvaluationInput', ...
                    'Use spline(X1,...,Xn) or spline(X1,...,Xn,D).');
            end

            if any(derivativeOrders ~= 0)
                error('VoronoiSpline:UnsupportedDerivative', ...
                    '2-D VoronoiSpline derivatives are not implemented in this version.');
            end

            [pointMatrix, outputSize] = VoronoiSpline.normalizeQueryInputs(queryInputs, self.numDimensions);
            basisMatrix = VoronoiSpline.matrix(pointMatrix, self.supportSpec_, self.K, ...
                D=derivativeOrders, Cache=self.basisCache_);
            values = basisMatrix * self.xi_;

            if ~isempty(self.xStd)
                values = self.xStd * values;
            end
            if ~isempty(self.xMean)
                values = values + self.xMean;
            end

            values = reshape(values, outputSize);
        end
    end

    methods (Static)
        function B = matrix(X, support, K, options)
            % Evaluate Voronoi-spline basis functions.
            arguments
                X
                support
                K (1,1) double {mustBeInteger,mustBePositive}
                options.D = 0
                options.Cache = []
                options.oversampling (1,1) double {mustBePositive} = 24
            end

            spec = VoronoiSpline.normalizeSupportSpec(support, K, oversampling=options.oversampling);
            derivativeOrders = VoronoiSpline.normalizeDerivativeOrders(options.D, spec.numDimensions);
            if spec.numDimensions == 1
                B = BSpline.matrix(reshape(X, [], 1), spec.tKnot, K, D=derivativeOrders);
                return;
            end

            if any(derivativeOrders ~= 0)
                error('VoronoiSpline:UnsupportedDerivative', ...
                    '2-D VoronoiSpline derivatives are not implemented in this version.');
            end

            [pointMatrix, ~] = VoronoiSpline.normalizePointMatrixInput(X, spec.numDimensions);
            if isempty(options.Cache)
                cache = VoronoiSpline.build2DBasisCache(spec, K);
            else
                cache = options.Cache;
            end

            B = VoronoiSpline.evaluate2DBasisMatrix(pointMatrix, spec.sites, cache);
        end

        function sites = sitesForDataPoints(t, options)
            % Return canonical 1-D Voronoi support sites from sample locations.
            arguments
                t (:,1) double {mustBeNumeric,mustBeReal}
                options.K (1,1) double {mustBePositive,mustBeInteger} = 4
                options.dataDOF (1,1) double {mustBePositive,mustBeInteger} = 1
                options.splineDOF (1,1) double = NaN
            end

            tKnot = BSpline.knotPointsForDataPoints(t, K=options.K, ...
                dataDOF=options.dataDOF, splineDOF=options.splineDOF);
            sites = VoronoiSpline.sitesFromBSplineKnots(tKnot, options.K);
        end

        function sites = pointsOfSupport(support, K, D)
            % Return one representative support site per basis function.
            arguments
                support
                K (1,1) double {mustBePositive,mustBeInteger}
                D (1,1) double {mustBeInteger,mustBeNonnegative} = 0
            end

            %#ok<INUSD> D is reserved for API compatibility.
            spec = VoronoiSpline.normalizeSupportSpec(support, K);
            sites = spec.sites;
        end

        function lattice = hexLattice(domain, options)
            % Construct a finite hexagonal lattice covering the supplied bounds.
            arguments
                domain (2,2) double {mustBeNumeric,mustBeReal,mustBeFinite}
                options.spacing (1,1) double {mustBePositive} = 1
                options.padding (1,1) double {mustBeInteger,mustBeNonnegative} = 1
                options.oversampling (1,1) double {mustBePositive} = 24
            end

            a1 = [options.spacing; 0];
            a2 = [0.5 * options.spacing; 0.5 * sqrt(3) * options.spacing];
            basis = [a1, a2];

            corners = [domain(1,1), domain(2,1); ...
                domain(1,1), domain(2,2); ...
                domain(1,2), domain(2,1); ...
                domain(1,2), domain(2,2)];
            latticeCoordinates = corners / basis.';
            iBounds = [floor(min(latticeCoordinates(:,1))) - options.padding, ...
                ceil(max(latticeCoordinates(:,1))) + options.padding];
            jBounds = [floor(min(latticeCoordinates(:,2))) - options.padding, ...
                ceil(max(latticeCoordinates(:,2))) + options.padding];

            [I, J] = ndgrid(iBounds(1):iBounds(2), jBounds(1):jBounds(2));
            sites = [I(:), J(:)] * basis.';

            lattice = struct();
            lattice.mode = '2d';
            lattice.basis = basis;
            lattice.sites = sites;
            lattice.indexBounds = [iBounds; jBounds];
            lattice.domain = domain;
            lattice.oversampling = options.oversampling;
            lattice.latticeType = "hex";
        end

        function lattice = hexLatticeForDataPoints(X, options)
            % Construct a hexagonal lattice covering a 2-D point cloud.
            arguments
                X (:,2) double {mustBeNumeric,mustBeReal,mustBeFinite}
                options.spacing (1,1) double {mustBePositive} = 1
                options.padding (1,1) double {mustBeInteger,mustBeNonnegative} = 1
                options.oversampling (1,1) double {mustBePositive} = 24
            end

            domain = [min(X(:,1)), max(X(:,1)); min(X(:,2)), max(X(:,2))];
            lattice = VoronoiSpline.hexLattice(domain, spacing=options.spacing, ...
                padding=options.padding, oversampling=options.oversampling);
        end
    end

    methods (Access = private)
        function rebuildRepresentations(self)
            if self.numDimensions == 1
                self.oneDimSpline_ = BSpline(self.K, self.supportSpec_.tKnot, self.xi_, xMean=0, xStd=1);
                self.basisCache_ = [];
            else
                self.oneDimSpline_ = [];
                self.basisCache_ = VoronoiSpline.build2DBasisCache(self.supportSpec_, self.K);
            end
        end
    end

    methods (Static, Access = private)
        function spec = normalizeSupportSpec(support, K, options)
            arguments
                support
                K (1,1) double {mustBePositive,mustBeInteger}
                options.oversampling (1,1) double {mustBePositive} = 24
            end

            if isnumeric(support)
                validateattributes(support, {'numeric'}, {'vector', 'real', 'finite'});
                sites = reshape(support, [], 1);
                if numel(sites) < 2
                    error('VoronoiSpline:InvalidSupportSites', ...
                        'At least two 1-D support sites are required.');
                end
                if any(diff(sites) <= 0)
                    error('VoronoiSpline:InvalidSupportSites', ...
                        '1-D support sites must be strictly increasing.');
                end

                spec = struct();
                spec.mode = '1d';
                spec.numDimensions = 1;
                spec.sites = sites;
                spec.tKnot = BSpline.knotPointsForDataPoints(sites, K=K);
                return;
            end

            if ~isstruct(support)
                error('VoronoiSpline:InvalidSupport', ...
                    'support must be a numeric site vector or a lattice specification struct.');
            end

            if isfield(support, 'tKnot')
                sites = reshape(support.sites, [], 1);
                tKnot = reshape(support.tKnot, [], 1);
                if any(diff(sites) <= 0)
                    error('VoronoiSpline:InvalidSupportSites', ...
                        '1-D support sites must be strictly increasing.');
                end

                spec = struct();
                spec.mode = '1d';
                spec.numDimensions = 1;
                spec.sites = sites;
                spec.tKnot = tKnot;
                return;
            end

            if ~isfield(support, 'basis') || ~isfield(support, 'sites')
                error('VoronoiSpline:InvalidSupport', ...
                    '2-D lattice support must provide basis and sites fields.');
            end

            basis = support.basis;
            sites = support.sites;
            validateattributes(basis, {'numeric'}, {'size', [2 2], 'real', 'finite'});
            validateattributes(sites, {'numeric'}, {'2d', 'real', 'finite'});
            if size(sites, 2) ~= 2
                error('VoronoiSpline:InvalidSupport', ...
                    '2-D lattice support sites must be an N-by-2 matrix.');
            end
            if size(sites,1) < 1
                error('VoronoiSpline:InvalidSupport', ...
                    '2-D lattice support must contain at least one support site.');
            end

            spec = struct();
            spec.mode = '2d';
            spec.numDimensions = 2;
            spec.basis = basis;
            spec.sites = sites;
            if isfield(support, 'indexBounds')
                spec.indexBounds = support.indexBounds;
            end
            if isfield(support, 'domain')
                spec.domain = support.domain;
            end
            if isfield(support, 'latticeType')
                spec.latticeType = support.latticeType;
            end
            if isfield(support, 'oversampling')
                spec.oversampling = support.oversampling;
            else
                spec.oversampling = options.oversampling;
            end
        end

        function derivativeOrders = normalizeDerivativeOrders(derivativeOrders, numDimensions)
            validateattributes(derivativeOrders, {'numeric'}, ...
                {'real', 'finite', 'nonnegative', 'integer'});
            if isscalar(derivativeOrders)
                if numDimensions == 1
                    derivativeOrders = derivativeOrders;
                elseif derivativeOrders == 0
                    derivativeOrders = zeros(1, numDimensions);
                else
                    error('VoronoiSpline:InvalidDerivativeOrders', ...
                        'Derivative orders must have one entry per dimension.');
                end
            else
                derivativeOrders = reshape(derivativeOrders, 1, []);
                if numel(derivativeOrders) ~= numDimensions
                    error('VoronoiSpline:InvalidDerivativeOrders', ...
                        'Derivative orders must have one entry per dimension.');
                end
            end
        end

        function [pointMatrix, outputSize] = normalizePointMatrixInput(X, numDimensions)
            validateattributes(X, {'numeric'}, {'real', 'finite'});
            if numDimensions == 1
                outputSize = size(X);
                pointMatrix = reshape(X, [], 1);
                return;
            end

            if size(X, 2) ~= numDimensions
                error('VoronoiSpline:InvalidPointMatrix', ...
                    'Point matrix must have one column per dimension.');
            end

            outputSize = [size(X, 1), 1];
            pointMatrix = X;
        end

        function [pointMatrix, outputSize] = normalizeQueryInputs(queryInputs, numDimensions)
            if numel(queryInputs) ~= numDimensions
                error('VoronoiSpline:InvalidEvaluationInput', ...
                    'Supply exactly one query input per spline dimension.');
            end

            validateattributes(queryInputs{1}, {'numeric'}, {'real', 'finite'});
            outputSize = size(queryInputs{1});
            pointMatrix = zeros(numel(queryInputs{1}), numDimensions);
            for iDim = 1:numDimensions
                validateattributes(queryInputs{iDim}, {'numeric'}, {'real', 'finite'});
                if ~isequal(size(queryInputs{iDim}), outputSize)
                    error('VoronoiSpline:InvalidQueryArrays', ...
                        'All query inputs must have the same size.');
                end
                pointMatrix(:, iDim) = queryInputs{iDim}(:);
            end
        end

        function sites = sitesFromBSplineKnots(tKnot, K)
            if K == 1
                sites = tKnot(1:end-1) + diff(tKnot)/2;
            else
                sites = BSpline.pointsOfSupport(tKnot, K);
            end
            sites = reshape(sites, [], 1);
        end

        function cache = build2DBasisCache(spec, K)
            polygon = VoronoiSpline.voronoiCellPolygon(spec.basis);
            minSpacing = min(vecnorm(spec.basis, 2, 1));
            h = minSpacing / spec.oversampling;

            maxExtent = max(abs(polygon), [], 1);
            nx = max(2, ceil(maxExtent(1) / h));
            ny = max(2, ceil(maxExtent(2) / h));
            xCell = h * (-nx:nx);
            yCell = h * (-ny:ny);

            [XCell, YCell] = ndgrid(xCell, yCell);
            indicator = double(inpolygon(XCell, YCell, polygon(:,1), polygon(:,2)));

            values = indicator;
            for iOrder = 2:K
                values = conv2(values, indicator, 'full') * h^2;
            end

            xGrid = h * (((1:size(values,1)) - 1) - (size(values,1) - 1) / 2);
            yGrid = h * (((1:size(values,2)) - 1) - (size(values,2) - 1) / 2);

            cache = struct();
            cache.polygon = polygon;
            cache.h = h;
            cache.xGrid = xGrid(:);
            cache.yGrid = yGrid(:);
            cache.values = values;
            cache.bounds = [cache.xGrid(1), cache.xGrid(end); cache.yGrid(1), cache.yGrid(end)];
        end

        function polygon = voronoiCellPolygon(basis)
            indexRange = -3:3;
            [I, J] = ndgrid(indexRange, indexRange);
            indices = [I(:), J(:)];
            originRow = find(indices(:,1) == 0 & indices(:,2) == 0, 1, 'first');
            if originRow ~= 1
                indices([1, originRow], :) = indices([originRow, 1], :);
            end

            points = indices * basis.';
            [vertices, cells] = voronoin(points);
            cellIndices = cells{1};
            cellIndices = cellIndices(cellIndices ~= 1);
            polygon = vertices(cellIndices, :);

            centroid = mean(polygon, 1);
            angles = atan2(polygon(:,2) - centroid(2), polygon(:,1) - centroid(1));
            [~, order] = sort(angles, 'ascend');
            polygon = polygon(order, :);
        end

        function B = evaluate2DBasisMatrix(pointMatrix, sites, cache)
            numPoints = size(pointMatrix, 1);
            numSites = size(sites, 1);
            B = zeros(numPoints, numSites);

            xLower = cache.bounds(1,1);
            xUpper = cache.bounds(1,2);
            yLower = cache.bounds(2,1);
            yUpper = cache.bounds(2,2);

            for iSite = 1:numSites
                dx = pointMatrix(:,1) - sites(iSite,1);
                dy = pointMatrix(:,2) - sites(iSite,2);
                active = dx >= xLower & dx <= xUpper & dy >= yLower & dy <= yUpper;
                if ~any(active)
                    continue;
                end

                B(active, iSite) = interpn(cache.xGrid, cache.yGrid, cache.values, ...
                    dx(active), dy(active), 'linear', 0);
            end
        end
    end
end
