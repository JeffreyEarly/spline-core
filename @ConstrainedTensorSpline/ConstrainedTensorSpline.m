classdef ConstrainedTensorSpline < TensorSpline
    % Tensor-product spline fit through noisy data values.
    %
    % ConstrainedTensorSpline fits a tensor-product spline basis to noisy
    % observations using iteratively reweighted least squares together with
    % optional local point constraints and global shape constraints.
    %
    % ## Basic usage
    %
    % Use `ConstrainedTensorSpline` when you want to fit a tensor-product
    % spline to noisy multivariate data.
    %
    % ```matlab
    % spline = ConstrainedTensorSpline(X, x);
    % xFit = spline(X);
    % ```
    %
    % - Topic: Create a constrained tensor spline
    % - Topic: Inspect fit results
    % - Topic: Analyze the fit
    % - Declaration: classdef ConstrainedTensorSpline < TensorSpline

    properties (Access = public)
        % Error model used while fitting the tensor spline.
        %
        % - Topic: Inspect fit results
        distribution

        % Observation locations as an N-by-D point matrix.
        %
        % - Topic: Inspect fit results
        Xobs
        
        % Observation values as an N-by-1 vector.
        %
        % - Topic: Inspect fit results
        x

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
        function self = ConstrainedTensorSpline(X, x, options)
            % Create a tensor-product spline fit to noisy observations.
            %
            % Use this constructor with an `N x D` point matrix or a cell
            % array of matching grids when fitting noisy tensor-product
            % data.
            %
            % ```matlab
            % spline = ConstrainedTensorSpline(X, x, K=[4 4]);
            % xFit = spline(X);
            % ```
            %
            % - Topic: Create a constrained tensor spline
            % - Declaration: self = ConstrainedTensorSpline(X,x,options)
            % - Parameter X: observation locations as a point matrix or cell array of matching grids
            % - Parameter x: observation values
            % - Parameter options.K: optional spline order scalar or vector with one entry per dimension
            % - Parameter options.tKnot: optional cell array of knot vectors
            % - Parameter options.distribution: optional error model object for the fit
            % - Parameter options.pointConstraints: optional PointConstraint array
            % - Parameter options.globalConstraints: optional GlobalConstraint array
            % - Returns self: ConstrainedTensorSpline instance
            arguments
                X
                x {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBePositive} = 4
                options.tKnot cell = {}
                options.distribution = []
                options.pointConstraints = []
                options.globalConstraints = []
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

            pointConstraints = ConstrainedTensorSpline.normalizePointConstraints(options.pointConstraints, numDimensions);
            globalConstraints = ConstrainedTensorSpline.normalizeGlobalConstraints(options.globalConstraints, numDimensions);

            Xbasis = TensorSpline.matrix(pointMatrix, tKnot, K);
            rho_X = [];
            if ~isempty(distribution.rho)
                rho_X = distribution.rho(ConstrainedTensorSpline.pairwiseDistanceMatrix(pointMatrix));
            end

            [Aeq,beq,Aineq,bineq] = ConstrainedTensorSpline.compileConstraints( ...
                pointConstraints, globalConstraints, tKnot, K);

            [coefficients,CmInv,W] = ConstrainedTensorSpline.tensorModelSolution( ...
                observations, Xbasis, distribution, rho_X, Aeq, beq, Aineq, bineq);

            self@TensorSpline(K, tKnot, coefficients(:));
            self.distribution = distribution;
            self.Xobs = pointMatrix;
            self.x = observations;
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
            % xFit = S * spline.x;
            % ```
            %
            % - Topic: Analyze the fit
            % - Declaration: S = smoothingMatrix(self)
            % - Parameter self: ConstrainedTensorSpline instance
            % - Returns S: smoothing matrix
            if ~isempty(self.Aeq) || ~isempty(self.Aineq)
                error('ConstrainedTensorSpline:UnavailableSmoothingMatrix', ...
                    'smoothingMatrix is only available for unconstrained tensor fits.');
            end

            if size(self.W,1) == length(self.x) && size(self.W,2) == 1
                S = (self.X*ConstrainedTensorSpline.leftSolve(self.CmInv, self.X.')).*(self.W.');
            else
                S = (self.X*ConstrainedTensorSpline.leftSolve(self.CmInv, self.X.'))*self.W;
            end
        end
    end

    methods (Static)
        function [xi,CmInv,W] = tensorModelSolution(x, X, distribution, rho_X, Aeq, beq, Aineq, bineq)
            % Solve the tensor noisy-data model with iteratively reweighted least squares.
            %
            % - Topic: Methodology (Static methods)
            % - Developer: true
            % - Declaration: [xi,CmInv,W] = tensorModelSolution(x,X,distribution,rho_X,Aeq,beq,Aineq,bineq)
            % - Parameter x: observation values as an N-by-1 vector
            % - Parameter X: splines on the observation grid, N-by-M
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
                x (:,1) double
                X (:,:) double
                distribution
                rho_X = []
                Aeq = []
                beq = []
                Aineq = []
                bineq = []
            end

            sigma2_previous = (distribution.sigma0)^2 * ones(size(x));
            W = ConstrainedTensorSpline.weightMatrixFromSigma2(sigma2_previous, rho_X);

            rel_error = 1.0;
            repeats = 1;
            while rel_error > 0.01 && repeats < 250
                [normalMatrix, rhs] = ConstrainedTensorSpline.weightedNormalEquations(X, x, W);
                [xi, CmInv] = ConstrainedTensorSpline.constrainedWeightedSolution( ...
                    normalMatrix, rhs, Aeq, beq, Aineq, bineq);

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

            tKnot = reshape(tKnot, 1, []);
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

        function [Aeq, beq, Aineq, bineq] = compileConstraints(pointConstraints, globalConstraints, tKnot, K)
            % Compile point and global constraints into linear systems.
            basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
            numCoefficients = prod(basisSize);
            Aeq = sparse([], [], [], 0, numCoefficients);
            beq = zeros(0,1);
            Aineq = sparse([], [], [], 0, numCoefficients);
            bineq = zeros(0,1);

            [pointAeq, pointBeq, pointAineq, pointBineq] = ...
                ConstrainedTensorSpline.compilePointConstraints(pointConstraints, tKnot, K);
            [globalAineq, globalBineq] = ...
                ConstrainedTensorSpline.compileGlobalConstraints(globalConstraints, tKnot, K);

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
                        constraint.Points(isGroup,:), tKnot, K, D=groupOrders(iGroup,:)));
                    values = constraint.Value(isGroup);

                    switch constraint.Relation
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
                            error('ConstrainedTensorSpline:InvalidConstraintRelation', ...
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
                switch constraint.Shape
                    case ShapeConstraint.none
                        continue;
                    case ShapeConstraint.positive
                        constraintMatrix = -speye(numCoefficients);
                    case ShapeConstraint.monotonicIncreasing
                        constraintMatrix = ConstrainedTensorSpline.monotonicDifferenceMatrix( ...
                            basisSize, constraint.Dimension, "increasing");
                    case ShapeConstraint.monotonicDecreasing
                        constraintMatrix = ConstrainedTensorSpline.monotonicDifferenceMatrix( ...
                            basisSize, constraint.Dimension, "decreasing");
                    otherwise
                        error('ConstrainedTensorSpline:UnsupportedGlobalConstraint', ...
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
                    error('ConstrainedTensorSpline:InvalidMonotonicDirection', ...
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
                    xi = ConstrainedTensorSpline.leftSolve(normalMatrix, rhs);
                    systemMatrix = normalMatrix;
                else
                    systemMatrix = [normalMatrix, Aeq'; Aeq, zeros(size(Aeq,1))];
                    solution = ConstrainedTensorSpline.leftSolve(systemMatrix, [rhs; beq]);
                    xi = solution(1:numCoefficients);
                end
                return;
            end

            H = (normalMatrix + normalMatrix')*0.5;
            options = optimoptions('quadprog', 'Display', 'off', 'Algorithm', 'interior-point-convex');
            [xi, ~, exitflag] = quadprog(2*H, -2*rhs, Aineq, bineq, Aeq, beq, [], [], [], options);
            if exitflag <= 0
                error('ConstrainedTensorSpline:OptimizationFailed', ...
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

        function pointConstraints = normalizePointConstraints(pointConstraints, numDimensions)
            % Normalize and validate point-constraint specifications.
            if isempty(pointConstraints)
                pointConstraints = PointConstraint.empty(0,1);
                return;
            end

            if ~isa(pointConstraints, 'PointConstraint')
                error('ConstrainedTensorSpline:InvalidPointConstraints', ...
                    'pointConstraints must be a PointConstraint array.');
            end

            pointConstraints = reshape(pointConstraints, [], 1);
            for iConstraint = 1:numel(pointConstraints)
                if pointConstraints(iConstraint).numDimensions ~= numDimensions
                    error('ConstrainedTensorSpline:PointConstraintDimensionMismatch', ...
                        'Each point constraint must match the spline dimensionality.');
                end
            end
        end

        function globalConstraints = normalizeGlobalConstraints(globalConstraints, numDimensions)
            % Normalize and validate global-constraint specifications.
            if isempty(globalConstraints)
                globalConstraints = GlobalConstraint.empty(0,1);
                return;
            end

            if ~isa(globalConstraints, 'GlobalConstraint')
                error('ConstrainedTensorSpline:InvalidGlobalConstraints', ...
                    'globalConstraints must be a GlobalConstraint array.');
            end

            globalConstraints = reshape(globalConstraints, [], 1);
            for iConstraint = 1:numel(globalConstraints)
                if ~isempty(globalConstraints(iConstraint).Dimension) ...
                        && globalConstraints(iConstraint).Dimension > numDimensions
                    error('ConstrainedTensorSpline:GlobalConstraintDimensionMismatch', ...
                        'Global constraint dimensions must not exceed the spline dimensionality.');
                end
            end
        end
    end
end
