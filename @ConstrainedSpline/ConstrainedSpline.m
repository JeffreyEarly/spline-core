classdef ConstrainedSpline < TensorSpline
    % Tensor-product spline fit through noisy data values.
    %
    % ConstrainedSpline fits a tensor-product spline basis to noisy
    % observations using iteratively reweighted least squares together with
    % optional local point constraints and global shape constraints.
    %
    % ## Basic usage
    %
    % Use `ConstrainedSpline` when you want to fit a tensor-product
    % spline to noisy multivariate data.
    %
    % ```matlab
    % spline = ConstrainedSpline(points, values);
    % valuesFit = spline(Xq, Yq);
    % ```
    %
    % - Topic: Create a constrained tensor spline
    % - Topic: Inspect fit results
    % - Topic: Analyze the fit
    % - Topic: Choose constraint locations
    % - Topic: Prepare knot sequences
    % - Declaration: classdef ConstrainedSpline < TensorSpline

    properties (Access = public)
        % Error model used while fitting the tensor spline.
        %
        % - Topic: Inspect fit results
        distribution

        % Observation locations as an N-by-D point matrix.
        %
        % - Topic: Inspect fit results
        points
        
        % Observation values as an N-by-1 vector.
        %
        % - Topic: Inspect fit results
        values

        % Local point constraints used during fitting.
        %
        % - Topic: Inspect fit results
        pointConstraints

        % Global shape constraints used during fitting.
        %
        % - Topic: Inspect fit results
        globalConstraints

        % Inverse coefficient covariance or normal-equation system matrix.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        CmInv
        % Design matrix for the observation locations.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        X
        % Weight matrix or weights used by the fit.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        W
        % Linear equality constraints applied to the coefficient solve.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        Aeq
        % Right-hand side for equality constraints.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        beq
        % Linear inequality constraints applied to the coefficient solve.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        Aineq
        % Right-hand side for inequality constraints.
        %
        % - Topic: Inspect fit results
        % - Developer: true
        bineq
    end

    methods
        function self = ConstrainedSpline(points, values, options)
            % Create a tensor-product spline fit to noisy observations.
            %
            % Use this constructor with an `N x D` point matrix when
            % fitting noisy tensor-product data.
            %
            % In one dimension, `K=N` together with `splineDOF=N` gives the
            % same least-squares polynomial fit as `polyfit(t,x,N-1)`.
            %
            % ```matlab
            % spline = ConstrainedSpline(points, values, K=[4 4]);
            % valuesFit = spline(Xq, Yq);
            % ```
            %
            % - Topic: Create a constrained tensor spline
            % - Declaration: self = ConstrainedSpline(points,values,options)
            % - Parameter points: observation locations as a point matrix
            % - Parameter values: observation values
            % - Parameter options.K: optional spline order scalar or vector with one entry per dimension
            % - Parameter options.S: optional spline degree scalar or vector with one entry per dimension
            % - Parameter options.tKnot: optional knot vector in 1-D or cell array of knot vectors
            % - Parameter options.dataDOF: optional stride used to subsample sorted coordinates before knot placement
            % - Parameter options.splineDOF: optional target number of splines per dimension
            % - Parameter options.distribution: optional error model object for the fit
            % - Parameter options.constraints: optional mixed SplineConstraint array
            % - Returns self: ConstrainedSpline instance
            arguments
                points {mustBeNumeric,mustBeReal,mustBeFinite}
                values {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBePositive} = 4
                options.S {mustBeNumeric,mustBeReal} = []
                options.tKnot = []
                options.dataDOF {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBePositive} = 1
                options.splineDOF {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative} = []
                options.distribution = []
                options.constraints = []
            end

            [pointMatrix, numDimensions, tKnot] = ConstrainedSpline.resolveGeometry(points, options.tKnot);
            observedValues = reshape(values, [], 1);

            if numel(observedValues) ~= size(pointMatrix,1)
                error('ConstrainedSpline:SizeMismatch', ...
                    'values must have one value for each observation point.');
            end

            K = ConstrainedSpline.splineOrderFromOptions(options, numDimensions);
            dataDOF = TensorSpline.normalizeOrders(options.dataDOF, numDimensions);
            splineDOF = ConstrainedSpline.normalizeOptionalOrders(options.splineDOF, numDimensions);
            if isempty(tKnot)
                tKnot = ConstrainedSpline.defaultKnotCell(pointMatrix, K, dataDOF, splineDOF);
            end
            distribution = options.distribution;
            if isempty(distribution)
                distribution = NormalDistribution(1);
            end

            for iDim = 1:numDimensions
                tKnot{iDim} = ConstrainedSpline.terminatedKnotPoints(tKnot{iDim}, K(iDim));
            end

            [pointConstraints, globalConstraints] = ConstrainedSpline.normalizeConstraintInputs( ...
                options.constraints, numDimensions);

            Xbasis = TensorSpline.matrix(pointMatrix, tKnot, K);
            rho_X = [];
            if ~isempty(distribution.rho)
                rho_X = distribution.rho(ConstrainedSpline.pairwiseDistanceMatrix(pointMatrix));
            end

            [Aeq,beq,Aineq,bineq] = ConstrainedSpline.compileConstraints( ...
                pointConstraints, globalConstraints, tKnot, K);

            [coefficients,CmInv,W] = ConstrainedSpline.tensorModelSolution( ...
                observedValues, Xbasis, distribution, rho_X, Aeq, beq, Aineq, bineq);

            self@TensorSpline(K, tKnot, coefficients(:));
            self.distribution = distribution;
            self.points = pointMatrix;
            self.values = observedValues;
            self.pointConstraints = pointConstraints;
            self.globalConstraints = globalConstraints;
            self.CmInv = CmInv;
            self.X = Xbasis;
            self.W = W;
            self.Aeq = Aeq;
            self.beq = beq;
            self.Aineq = Aineq;
            self.bineq = bineq;
        end

        function S = smoothingMatrix(self)
            % Return the smoothing matrix that maps observations to fitted values.
            %
            % Use this to inspect the linear action of the final weighted
            % fit on the observed data.
            %
            % ```matlab
            % S = spline.smoothingMatrix();
            % valuesFit = S * spline.values;
            % ```
            %
            % - Topic: Analyze the fit
            % - Declaration: S = smoothingMatrix(self)
            % - Parameter self: ConstrainedSpline instance
            % - Returns S: smoothing matrix
            if ~isempty(self.Aeq) || ~isempty(self.Aineq)
                error('ConstrainedSpline:UnavailableSmoothingMatrix', ...
                    'smoothingMatrix is only available for unconstrained tensor fits.');
            end

            if size(self.W,1) == length(self.values) && size(self.W,2) == 1
                S = (self.X*ConstrainedSpline.leftSolve(self.CmInv, self.X.')).*(self.W.');
            else
                S = (self.X*ConstrainedSpline.leftSolve(self.CmInv, self.X.'))*self.W;
            end
        end
    end

    methods (Static)
        function [xi,CmInv,W] = tensorModelSolution(values, designMatrix, distribution, rho_X, Aeq, beq, Aineq, bineq)
            % Solve the tensor noisy-data model with iteratively reweighted least squares.
            %
            % - Topic: Methodology (Static methods)
            % - Developer: true
            % - Declaration: [xi,CmInv,W] = tensorModelSolution(values,designMatrix,distribution,rho_X,Aeq,beq,Aineq,bineq)
            % - Parameter values: observation values as an N-by-1 vector
            % - Parameter designMatrix: splines on the observation grid, N-by-M
            % - Parameter distribution: distribution describing the errors
            % - Parameter rho_X: optional observation correlation matrix
            % - Parameter Aeq: optional equality-constraint matrix
            % - Parameter beq: optional equality-constraint values
            % - Parameter Aineq: optional inequality-constraint matrix
            % - Parameter bineq: optional inequality-constraint values
            % - Returns xi: fitted tensor spline coefficients
            % - Returns CmInv: inverse coefficient covariance or system matrix
            % - Returns W: final weight matrix or weights
            arguments
                values (:,1) double
                designMatrix (:,:) double
                distribution
                rho_X = []
                Aeq = []
                beq = []
                Aineq = []
                bineq = []
            end

            sigma2_previous = (distribution.sigma0)^2 * ones(size(values));
            W = ConstrainedSpline.weightMatrixFromSigma2(sigma2_previous, rho_X);

            rel_error = 1.0;
            repeats = 1;
            while rel_error > 0.01 && repeats < 250
                [normalMatrix, rhs] = ConstrainedSpline.weightedNormalEquations(designMatrix, values, W);
                [xi, CmInv] = ConstrainedSpline.constrainedWeightedSolution( ...
                    normalMatrix, rhs, Aeq, beq, Aineq, bineq);

                sigma2 = distribution.w(values - designMatrix*xi);
                rel_error = max(abs((sigma2-sigma2_previous)./sigma2), [], 'all');
                sigma2_previous = sigma2;
                W = ConstrainedSpline.weightMatrixFromSigma2(sigma2, rho_X);
                repeats = repeats + 1;
            end
        end

        function tKnot = terminatedKnotPoints(tKnot, K)
            % Ensure each knot vector has K repeated knots at its boundaries.
            %
            % Use this helper when you want to terminate a manually supplied
            % knot sequence before fitting. In 1-D it accepts a numeric knot
            % vector; in higher dimensions it accepts a cell array with one
            % knot vector per dimension.
            %
            % ```matlab
            % tKnot = ConstrainedSpline.terminatedKnotPoints(tKnot, 4);
            % ```
            %
            % - Topic: Prepare knot sequences
            % - Declaration: tKnot = terminatedKnotPoints(tKnot,K)
            % - Parameter tKnot: knot vector in 1-D or cell array of knot vectors
            % - Parameter K: spline order scalar or vector with one entry per dimension
            % - Returns tKnot: terminated knot sequence
            if isnumeric(tKnot)
                validateattributes(tKnot, {'numeric'}, {'vector','real','finite'});
                K = TensorSpline.normalizeOrders(K, 1);
                tKnot = reshape(tKnot, [], 1);

                nLeft = find(tKnot <= tKnot(1), 1, 'last');
                nRight = numel(tKnot) - find(tKnot == tKnot(end), 1, 'first') + 1;
                tKnot = [repmat(tKnot(1), K-nLeft, 1); tKnot; repmat(tKnot(end), K-nRight, 1)];
                return;
            end

            if ~iscell(tKnot)
                error('ConstrainedSpline:InvalidKnotCell', ...
                    'tKnot must be a knot vector in 1-D or a cell array with one knot vector per dimension.');
            end

            numDimensions = numel(tKnot);
            K = TensorSpline.normalizeOrders(K, numDimensions);
            tKnot = reshape(tKnot, 1, []);
            for iDim = 1:numDimensions
                tKnot{iDim} = ConstrainedSpline.terminatedKnotPoints(tKnot{iDim}, K(iDim));
            end
        end

        function tc = minimumConstraintPoints(tKnot, K, T)
            % Return a minimal set of one-dimensional locations for universal derivative constraints.
            %
            % For a terminated spline of order K, this chooses the smallest
            % set of 1-D points needed to constrain all segments at
            % polynomial degree T.
            %
            % ```matlab
            % tc = ConstrainedSpline.minimumConstraintPoints(tKnot, 4, 0);
            % ```
            %
            % - Topic: Choose constraint locations
            % - Declaration: tc = minimumConstraintPoints(tKnot,K,T)
            % - Parameter tKnot: one-dimensional knot sequence
            % - Parameter K: spline order
            % - Parameter T: constrained polynomial degree
            % - Returns tc: one-dimensional constraint locations
            arguments
                tKnot (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                T (1,1) double {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger}
            end

            t = unique(tKnot);
            D = K - 1 - T;
            if mod(D, 2) == 0
                ts = t(1) + (t(2)-t(1))/(D/2 + 2) * (1:(D/2 + 1)).';
                te = t(end-1) + (t(end)-t(end-1))/(D/2 + 2) * (1:(D/2 + 1)).';
                ti = t(2:end-2) + diff(t(2:end-1))/2;
                tc = cat(1, ts, ti, te);
            else
                ts = t(1) + (t(2)-t(1))/((D-1)/2 + 1) * (0:((D-1)/2)).';
                te = t(end) - (t(end)-t(end-1))/((D-1)/2 + 1) * (0:((D-1)/2)).';
                ti = t(2:end-1);
                tc = cat(1, ts, ti, te);
            end
        end

        function [constraintArguments, constrainedValues] = constraintArguments(constraints, sampleValues, options)
            % Normalize mixed constraint inputs into constructor arguments.
            %
            % - Topic: Methodology (Static methods)
            % - Developer: true
            % - Declaration: [constraintArguments,constrainedValues] = constraintArguments(constraints,sampleValues,options)
            % - Parameter constraints: optional mixed SplineConstraint array
            % - Parameter sampleValues: optional vector used for positivity heuristics
            % - Parameter options.enforcePositiveIfPossible: add positivity when sampleValues are nonnegative
            % - Returns constraintArguments: name-value arguments for constructor constraints
            % - Returns constrainedValues: possibly clipped sample values
            arguments
                constraints = []
                sampleValues (:,1) double = zeros(0,1)
                options.enforcePositiveIfPossible (1,1) logical = false
                options.numDimensions = []
            end

            [pointConstraints, globalConstraints] = ConstrainedSpline.normalizeConstraintInputs(constraints, options.numDimensions);
            constrainedValues = sampleValues;

            if options.enforcePositiveIfPossible && isempty(globalConstraints) ...
                    && all(isfinite(constrainedValues)) ...
                    && all(constrainedValues >= -10*eps(max(1, max(abs(constrainedValues)))))
                globalConstraints = GlobalConstraint.positive();
                constrainedValues = max(constrainedValues, 0);
            end

            if isempty(pointConstraints) && isempty(globalConstraints)
                constraintArguments = {};
                return;
            end

            constraintArguments = {'constraints', [pointConstraints; globalConstraints]};
        end
    end

    methods (Static, Access = private)
        function [pointMatrix, numDimensions, tKnot] = resolveGeometry(points, tKnot)
            % Resolve constructor geometry inputs to canonical point and knot representations.
            if isempty(tKnot)
                if isvector(points)
                    numDimensions = 1;
                else
                    numDimensions = size(points, 2);
                end
                [pointMatrix, ~] = TensorSpline.normalizePointMatrixInput(points, numDimensions);
                return;
            end

            if isnumeric(tKnot)
                validateattributes(tKnot, {'numeric'}, {'vector','real','finite'});
                tKnot = {reshape(tKnot, [], 1)};
            elseif iscell(tKnot)
                tKnot = TensorSpline.normalizeKnotCell(tKnot, numel(tKnot));
            else
                error('ConstrainedSpline:InvalidKnotCell', ...
                    'tKnot must be a knot vector in 1-D or a cell array with one knot vector per dimension.');
            end

            numDimensions = numel(tKnot);
            [pointMatrix, ~] = TensorSpline.normalizePointMatrixInput(points, numDimensions);
        end

        function K = splineOrderFromOptions(options, numDimensions)
            % Resolve spline order from mutually exclusive K and S options.
            if isempty(options.S)
                K = options.K;
            else
                validateattributes(options.S, {'numeric'}, {'vector','real','finite','nonnegative','integer'});
                if ~(isscalar(options.K) && options.K == 4)
                    error('ConstrainedSpline:ConflictingSplineOrder', ...
                        'Specify either K or S, but not both.');
                end
                K = options.S + 1;
            end

            K = TensorSpline.normalizeOrders(K, numDimensions);
        end

        function tKnot = defaultKnotCell(X, K, dataDOF, splineDOF)
            % Create a knot cell when no knots are supplied.
            numDimensions = size(X, 2);
            tKnot = cell(1, numDimensions);
            useSplineDOF = ~isempty(splineDOF);
            for iDim = 1:numDimensions
                coordinateValues = unique(X(:,iDim), 'sorted');
                if numel(coordinateValues) < K(iDim)
                    xMin = coordinateValues(1);
                    xMax = coordinateValues(end);
                    tKnot{iDim} = [repmat(xMin, K(iDim), 1); repmat(xMax, K(iDim), 1)];
                    continue;
                end

                if useSplineDOF
                    tKnot{iDim} = BSpline.knotPointsForDataPoints(coordinateValues, ...
                        K=K(iDim), splineDOF=splineDOF(iDim));
                else
                    tKnot{iDim} = BSpline.knotPointsForDataPoints(coordinateValues, ...
                        K=K(iDim), dataDOF=dataDOF(iDim));
                end
            end
        end

        function values = normalizeOptionalOrders(values, numDimensions)
            % Normalize an optional per-dimension nonnegative integer vector.
            if isempty(values)
                return;
            end

            validateattributes(values, {'numeric'}, {'vector','real','finite','nonnegative','integer'});
            values = reshape(values, 1, []);
            if isscalar(values)
                values = repmat(values, 1, numDimensions);
            elseif numel(values) ~= numDimensions
                error('ConstrainedSpline:InvalidDegreeOfFreedomOption', ...
                    'dataDOF and splineDOF must be scalar or have one element per dimension.');
            end
        end

        function D = pairwiseDistanceMatrix(X)
            % Compute pairwise Euclidean distances between observation points.
            delta = permute(X, [1 3 2]) - permute(X, [3 1 2]);
            D = sqrt(sum(delta.^2, 3));
        end

        function [Aeq, beq, Aineq, bineq] = compileConstraints(pointConstraints, globalConstraints, tKnot, K)
            % Compile point and global constraints into linear systems.
            basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
            numCoefficients = prod(basisSize);
            Aeq = sparse([], [], [], 0, numCoefficients);
            beq = zeros(0,1);
            Aineq = sparse([], [], [], 0, numCoefficients);
            bineq = zeros(0,1);

            [pointAeq, pointBeq, pointAineq, pointBineq] = ...
                ConstrainedSpline.compilePointConstraints(pointConstraints, tKnot, K);
            [globalAineq, globalBineq] = ...
                ConstrainedSpline.compileGlobalConstraints(globalConstraints, tKnot, K);

            Aeq = [Aeq; pointAeq];
            beq = [beq; pointBeq];
            Aineq = [Aineq; pointAineq; globalAineq];
            bineq = [bineq; pointBineq; globalBineq];
        end

        function [Aeq, beq, Aineq, bineq] = compilePointConstraints(pointConstraints, tKnot, K)
            % Compile point constraints into equality and inequality systems.
            basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
            numCoefficients = prod(basisSize);
            Aeq = sparse([], [], [], 0, numCoefficients);
            beq = zeros(0,1);
            Aineq = sparse([], [], [], 0, numCoefficients);
            bineq = zeros(0,1);

            for iConstraint = 1:numel(pointConstraints)
                constraint = pointConstraints(iConstraint);
                [groupOrders, ~, groupIndex] = unique(constraint.D, 'rows', 'stable');
                for iGroup = 1:size(groupOrders, 1)
                    isGroup = groupIndex == iGroup;
                    B = sparse(TensorSpline.matrix( ...
                        constraint.points(isGroup,:), tKnot, K, D=groupOrders(iGroup,:)));
                    values = constraint.value(isGroup);

                    switch constraint.relation
                        case "=="
                            Aeq = [Aeq; B];
                            beq = [beq; values];
                        case ">="
                            Aineq = [Aineq; -B];
                            bineq = [bineq; -values];
                        case "<="
                            Aineq = [Aineq; B];
                            bineq = [bineq; values];
                        otherwise
                            error('ConstrainedSpline:InvalidConstraintRelation', ...
                                'Unsupported point-constraint relation.');
                    end
                end
            end
        end

        function [Aineq, bineq] = compileGlobalConstraints(globalConstraints, tKnot, K)
            % Compile global constraints into coefficient inequalities.
            basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
            numCoefficients = prod(basisSize);
            Aineq = sparse([], [], [], 0, numCoefficients);
            bineq = zeros(0,1);

            for iConstraint = 1:numel(globalConstraints)
                constraint = globalConstraints(iConstraint);
                switch constraint.shape
                    case "positive"
                        constraintMatrix = -speye(numCoefficients);
                    case "monotonicIncreasing"
                        constraintMatrix = ConstrainedSpline.monotonicDifferenceMatrix( ...
                            basisSize, constraint.dimension, "increasing");
                    case "monotonicDecreasing"
                        constraintMatrix = ConstrainedSpline.monotonicDifferenceMatrix( ...
                            basisSize, constraint.dimension, "decreasing");
                    otherwise
                        error('ConstrainedSpline:UnsupportedGlobalConstraint', ...
                            'Unsupported global constraint shape.');
                end

                Aineq = [Aineq; constraintMatrix];
                bineq = [bineq; zeros(size(constraintMatrix,1),1)];
            end
        end

        function A = monotonicDifferenceMatrix(basisSize, dim, direction)
            % Build coefficient-difference inequalities along one dimension.
            basisSize = reshape(basisSize, 1, []);
            numCoefficients = prod(basisSize);
            if isscalar(basisSize)
                basisSize = [basisSize, 1];
            end
            coefficientGrid = reshape(1:numCoefficients, basisSize);

            lowerSubscripts = repmat({':'}, 1, numel(basisSize));
            upperSubscripts = lowerSubscripts;
            lowerSubscripts{dim} = 1:(basisSize(dim)-1);
            upperSubscripts{dim} = 2:basisSize(dim);

            lowerIndex = coefficientGrid(lowerSubscripts{:});
            upperIndex = coefficientGrid(upperSubscripts{:});
            lowerIndex = lowerIndex(:);
            upperIndex = upperIndex(:);
            numRows = numel(lowerIndex);

            switch string(direction)
                case "increasing"
                    rowValues = [ones(numRows,1); -ones(numRows,1)];
                case "decreasing"
                    rowValues = [-ones(numRows,1); ones(numRows,1)];
                otherwise
                    error('ConstrainedSpline:InvalidMonotonicDirection', ...
                        'direction must be "increasing" or "decreasing".');
            end

            rowIndex = [(1:numRows)'; (1:numRows)'];
            columnIndex = [lowerIndex; upperIndex];
            A = sparse(rowIndex, columnIndex, rowValues, numRows, numCoefficients);
        end

        function [normalMatrix, rhs] = weightedNormalEquations(X, x, W)
            % Assemble weighted normal equations.
            XT = X';
            if size(W,1) == length(x) && size(W,2) == length(x)
                normalMatrix = XT*W*X;
                rhs = XT*W*x;
            elseif isscalar(W)
                normalMatrix = (XT*X)*W;
                rhs = XT*W*x;
            elseif isvector(W) && numel(W) == length(x)
                normalMatrix = XT*(W.*X);
                rhs = XT*(W.*x);
            else
                error('W must have the same length as x and X.');
            end
        end

        function [xi, systemMatrix] = constrainedWeightedSolution(normalMatrix, rhs, Aeq, beq, Aineq, bineq)
            % Solve weighted least squares with optional linear constraints.
            numCoefficients = size(normalMatrix, 1);

            if isempty(Aeq)
                Aeq = zeros(0, numCoefficients);
                beq = zeros(0,1);
            end

            if isempty(Aineq)
                Aineq = zeros(0, numCoefficients);
                bineq = zeros(0,1);
            end

            if isempty(Aineq)
                if isempty(Aeq)
                    xi = ConstrainedSpline.leftSolve(normalMatrix, rhs);
                    systemMatrix = normalMatrix;
                else
                    systemMatrix = [normalMatrix, Aeq'; Aeq, zeros(size(Aeq,1))];
                    solution = ConstrainedSpline.leftSolve(systemMatrix, [rhs; beq]);
                    xi = solution(1:numCoefficients);
                end
                return;
            end

            H = (normalMatrix + normalMatrix')*0.5;
            options = optimoptions('quadprog', 'Display', 'off', 'Algorithm', 'interior-point-convex');
            [xi, ~, exitflag] = quadprog(2*H, -2*rhs, Aineq, bineq, Aeq, beq, [], [], [], options);
            if exitflag <= 0
                error('ConstrainedSpline:OptimizationFailed', ...
                    'The constrained tensor-spline fit failed to converge.');
            end

            systemMatrix = normalMatrix;
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

            if issparse(A)
                reciprocalCondition = rcond(full(A));
            else
                reciprocalCondition = rcond(A);
            end

            if reciprocalCondition < eps(class(full(A)))
                x = pinv(full(A)) * b;
            else
                x = A\b;
            end
        end

        function [pointConstraints, globalConstraints] = normalizeConstraintInputs(constraints, numDimensions)
            % Normalize mixed constraint inputs into separate arrays.
            if isempty(constraints)
                pointConstraints = PointConstraint.empty(0,1);
                globalConstraints = GlobalConstraint.empty(0,1);
                return;
            end

            if ~isa(constraints, 'SplineConstraint')
                error('ConstrainedSpline:InvalidConstraints', ...
                    'constraints must be a SplineConstraint array.');
            end

            constraints = reshape(constraints, [], 1);
            isPointConstraint = arrayfun(@(constraint) isa(constraint, 'PointConstraint'), constraints);
            if any(isPointConstraint)
                pointConstraints = reshape([constraints(isPointConstraint)], [], 1);
            else
                pointConstraints = PointConstraint.empty(0,1);
            end

            if any(~isPointConstraint)
                globalConstraints = reshape([constraints(~isPointConstraint)], [], 1);
            else
                globalConstraints = GlobalConstraint.empty(0,1);
            end

            for iConstraint = 1:numel(pointConstraints)
                if ~isempty(numDimensions) && pointConstraints(iConstraint).numDimensions ~= numDimensions
                    error('ConstrainedSpline:PointConstraintDimensionMismatch', ...
                        'Each point constraint must match the spline dimensionality.');
                end
            end

            for iConstraint = 1:numel(globalConstraints)
                if ~isempty(numDimensions) && ~isempty(globalConstraints(iConstraint).dimension) ...
                        && globalConstraints(iConstraint).dimension > numDimensions
                    error('ConstrainedSpline:GlobalConstraintDimensionMismatch', ...
                        'Global constraint dimensions must not exceed the spline dimensionality.');
                end
            end
        end
    end
end
