classdef ConstrainedTensorSpline < TensorSpline
    % Tensor-product spline fit through noisy data values.
    %
    % ConstrainedTensorSpline fits a tensor-product spline basis to noisy
    % observations using iteratively reweighted least squares. Constraint
    % handling is intentionally omitted in this first version.
    %
    % - Topic: Initialization
    % - Topic: Primary attributes
    % - Topic: Operations
    % - Topic: Methodology (Static methods)
    % - Topic: Utility
    % - Declaration: classdef ConstrainedTensorSpline < TensorSpline

    properties (Access = public)
        % Error model used while fitting the tensor spline.
        %
        % - Topic: Primary attributes
        distribution

        % Observation locations as an N-by-D point matrix.
        %
        % - Topic: Primary attributes
        Xobs
        
        % Observation values as an N-by-1 vector.
        %
        % - Topic: Primary attributes
        x

        % Inverse coefficient covariance or normal-equation system matrix.
        %
        % - Topic: Primary attributes
        CmInv
        % Design matrix for the observation locations.
        %
        % - Topic: Primary attributes
        X
        % Weight matrix or weights used by the fit.
        %
        % - Topic: Primary attributes
        W
    end

    methods
        function self = ConstrainedTensorSpline(X, x, options)
            % Create a tensor-product spline fit to noisy observations.
            %
            % - Topic: Initialization
            % - Declaration: self = ConstrainedTensorSpline(X,x,options)
            % - Parameter X: observation locations as a point matrix or cell array of matching grids
            % - Parameter x: observation values
            % - Parameter options.K: optional spline order scalar or vector with one entry per dimension
            % - Parameter options.tKnot: optional cell array of knot vectors
            % - Parameter options.distribution: optional error model object for the fit
            % - Returns self: ConstrainedTensorSpline instance
            arguments
                X
                x {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBePositive} = 4
                options.tKnot cell = {}
                options.distribution = []
            end

            numDimensions = ConstrainedTensorSpline.inferNumDimensions(X, options.tKnot);
            pointMatrix = ConstrainedTensorSpline.normalizeObservationPoints(X, numDimensions);
            observations = reshape(x, [], 1);

            if numel(observations) ~= size(pointMatrix,1)
                error('ConstrainedTensorSpline:SizeMismatch', ...
                    'x must have one value for each observation point.');
            end

            K = ConstrainedTensorSpline.normalizeOrders(options.K, numDimensions);
            tKnot = ConstrainedTensorSpline.defaultKnotCell(pointMatrix, K, options.tKnot);
            distribution = options.distribution;
            if isempty(distribution)
                distribution = NormalDistribution(1);
            end

            tKnot = ConstrainedTensorSpline.normalizeKnotCell(tKnot, numDimensions);
            for iDim = 1:numDimensions
                tKnot{iDim} = ConstrainedSpline.terminatedKnotPoints(tKnot{iDim}, K(iDim));
            end

            Xbasis = TensorSpline.matrix(pointMatrix, tKnot, K);
            rho_X = [];
            if ~isempty(distribution.rho)
                rho_X = distribution.rho(ConstrainedTensorSpline.pairwiseDistanceMatrix(pointMatrix));
            end

            [coefficients,CmInv,W] = ConstrainedTensorSpline.tensorModelSolution( ...
                observations, Xbasis, distribution, rho_X);

            self@TensorSpline(K, tKnot, coefficients(:));
            self.distribution = distribution;
            self.Xobs = pointMatrix;
            self.x = observations;
            self.CmInv = CmInv;
            self.X = Xbasis;
            self.W = W;
        end

        function S = smoothingMatrix(self)
            % Return the smoothing matrix that maps observations to fitted values.
            %
            % - Topic: Operations
            % - Declaration: S = smoothingMatrix(self)
            % - Parameter self: ConstrainedTensorSpline instance
            % - Returns S: smoothing matrix
            if size(self.W,1) == length(self.x) && size(self.W,2) == 1
                S = (self.X*ConstrainedTensorSpline.leftSolve(self.CmInv, self.X.')).*(self.W.');
            else
                S = (self.X*ConstrainedTensorSpline.leftSolve(self.CmInv, self.X.'))*self.W;
            end
        end
    end

    methods (Static)
        function [xi,CmInv,W] = tensorModelSolution(x, X, distribution, rho_X)
            % Solve the tensor noisy-data model with iteratively reweighted least squares.
            %
            % - Topic: Methodology (Static methods)
            % - Declaration: [xi,CmInv,W] = tensorModelSolution(x,X,distribution,rho_X)
            % - Parameter x: observation values as an N-by-1 vector
            % - Parameter X: splines on the observation grid, N-by-M
            % - Parameter distribution: distribution describing the errors
            % - Parameter rho_X: optional observation correlation matrix
            % - Returns xi: fitted tensor spline coefficients
            % - Returns CmInv: inverse coefficient covariance or system matrix
            % - Returns W: final weight matrix or weights
            arguments
                x (:,1) double
                X (:,:) double
                distribution
                rho_X = []
            end

            XT = X';
            sigma2_previous = (distribution.sigma0)^2 * ones(size(x));
            W = ConstrainedTensorSpline.weightMatrixFromSigma2(sigma2_previous, rho_X);

            rel_error = 1.0;
            repeats = 1;
            while rel_error > 0.01 && repeats < 250
                if size(W,1) == length(x) && size(W,2) == length(x)
                    CmInv = XT*W*X;
                    XWx = XT*W*x;
                elseif isscalar(W)
                    CmInv = (XT*X)*W;
                    XWx = XT*W*x;
                elseif isvector(W) && numel(W) == length(x)
                    CmInv = XT*(W.*X);
                    XWx = XT*(W.*x);
                else
                    error('W must have the same length as x and X.');
                end

                xi = ConstrainedTensorSpline.leftSolve(CmInv, XWx);

                sigma2 = distribution.w(x - X*xi);
                rel_error = max(abs((sigma2-sigma2_previous)./sigma2), [], 'all');
                sigma2_previous = sigma2;
                W = ConstrainedTensorSpline.weightMatrixFromSigma2(sigma2, rho_X);
                repeats = repeats + 1;
            end
        end
    end

    methods (Static, Access = private)
        function K = normalizeOrders(K, numDimensions)
            % Normalize spline-order input to one order per dimension.
            validateattributes(K, {'numeric'}, {'vector','real','finite','positive','integer'});
            if isscalar(K)
                K = repmat(K, 1, numDimensions);
            else
                K = reshape(K, 1, []);
                if numel(K) ~= numDimensions
                    error('ConstrainedTensorSpline:InvalidOrderVector', ...
                        'K must be scalar or have one element per dimension.');
                end
            end
        end

        function tKnot = normalizeKnotCell(tKnot, numDimensions)
            % Normalize and validate a cell array of knot vectors.
            if ~iscell(tKnot) || numel(tKnot) ~= numDimensions
                error('ConstrainedTensorSpline:InvalidKnotCell', ...
                    'tKnot must be a cell array with one knot vector per dimension.');
            end

            for iDim = 1:numDimensions
                validateattributes(tKnot{iDim}, {'numeric'}, {'column','real','finite'});
                tKnot{iDim} = reshape(tKnot{iDim}, [], 1);
            end
        end

        function pointMatrix = normalizeObservationPoints(X, numDimensions)
            % Normalize observation locations to an N-by-D point matrix.
            if iscell(X)
                if numel(X) ~= numDimensions
                    error('ConstrainedTensorSpline:InvalidPointCell', ...
                        'Cell input must have one array per dimension.');
                end

                outputSize = size(X{1});
                pointMatrix = zeros(numel(X{1}), numDimensions);
                for iDim = 1:numDimensions
                    validateattributes(X{iDim}, {'numeric'}, {'real','finite'});
                    if ~isequal(size(X{iDim}), outputSize)
                        error('ConstrainedTensorSpline:InvalidPointCell', ...
                            'All observation arrays must have the same size.');
                    end
                    pointMatrix(:,iDim) = X{iDim}(:);
                end
                return;
            end

            validateattributes(X, {'numeric'}, {'real','finite'});
            if numDimensions == 1
                pointMatrix = reshape(X, [], 1);
            else
                if size(X,2) ~= numDimensions
                    error('ConstrainedTensorSpline:InvalidPointMatrix', ...
                        'Point matrix must have one column per dimension.');
                end
                pointMatrix = X;
            end
        end

        function numDimensions = inferNumDimensions(X, tKnot)
            % Infer the tensor dimensionality from the inputs.
            if ~isempty(tKnot)
                if ~iscell(tKnot)
                    error('ConstrainedTensorSpline:InvalidKnotCell', ...
                        'tKnot must be a cell array with one knot vector per dimension.');
                end
                numDimensions = numel(tKnot);
                return;
            end

            if iscell(X)
                numDimensions = numel(X);
                return;
            end

            validateattributes(X, {'numeric'}, {'real','finite'});
            if isvector(X)
                numDimensions = 1;
            else
                numDimensions = size(X, 2);
            end
        end

        function tKnot = defaultKnotCell(X, K, tKnot)
            % Create a minimal terminated knot cell when no knots are supplied.
            if ~isempty(tKnot)
                return;
            end

            numDimensions = size(X, 2);
            tKnot = cell(1, numDimensions);
            for iDim = 1:numDimensions
                xMin = min(X(:,iDim));
                xMax = max(X(:,iDim));
                tKnot{iDim} = [repmat(xMin, K(iDim), 1); repmat(xMax, K(iDim), 1)];
            end
        end

        function D = pairwiseDistanceMatrix(X)
            % Compute pairwise Euclidean distances between observation points.
            delta = permute(X, [1 3 2]) - permute(X, [3 1 2]);
            D = sqrt(sum(delta.^2, 3));
        end

        function W = weightMatrixFromSigma2(sigma2, rho_X)
            % Build the observation-weight matrix from per-observation variances.
            if ~isempty(rho_X)
                Sigma2 = (sqrt(sigma2) * sqrt(sigma2).') .* rho_X;
                W = inv(Sigma2);
            else
                W = 1./sigma2;
            end
        end

        function x = leftSolve(A, b)
            % Solve a linear system, falling back to a pseudoinverse if needed.
            if isempty(A)
                x = zeros(size(b));
                return;
            end

            if rcond(A) < eps(class(full(A)))
                x = pinv(A) * b;
            else
                x = A\b;
            end
        end
    end
end
