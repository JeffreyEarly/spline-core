classdef GlobalConstraint < SplineConstraint
    % Specify a global shape constraint for a constrained spline fit.
    %
    % Use `GlobalConstraint` to describe semantic whole-domain constraints
    % such as positivity or monotonicity. These objects are intended to be
    % compiled into linear coefficient inequalities by constrained fitting
    % classes.
    %
    % ## Basic usage
    %
    % ```matlab
    % c1 = GlobalConstraint.positive();
    % c2 = GlobalConstraint.monotonicIncreasing(Dimension=2);
    % ```
    %
    % - Topic: Specify global constraints
    % - Declaration: classdef GlobalConstraint

    properties (SetAccess = private)
        % Shape-constraint kind.
        %
        % - Topic: Inspect global constraint properties
        Shape (1,1) ShapeConstraint = ShapeConstraint.none

        % Tensor dimension associated with the constraint, when applicable.
        %
        % - Topic: Inspect global constraint properties
        Dimension = double.empty(1,0)
    end

    methods
        function self = GlobalConstraint(shape, options)
            % Create a global constraint specification.
            %
            % Use the static helper methods `positive`,
            % `monotonicIncreasing`, and `monotonicDecreasing` for the
            % intended public construction style.
            %
            % - Topic: Specify global constraints
            % - Declaration: self = GlobalConstraint(shape,options)
            % - Parameter shape: ShapeConstraint enumeration value
            % - Parameter options.Dimension: tensor dimension for directional constraints
            % - Returns self: GlobalConstraint instance
            arguments
                shape (1,1) ShapeConstraint = ShapeConstraint.none
                options.Dimension = double.empty(1,0)
            end

            if ~isempty(options.Dimension)
                validateattributes(options.Dimension, {'numeric'}, ...
                    {'scalar','real','finite','integer','positive'});
            end

            switch shape
                case {ShapeConstraint.none, ShapeConstraint.positive}
                    if ~isempty(options.Dimension)
                        error('GlobalConstraint:UnexpectedDimension', ...
                            'Dimension is not used for this global constraint.');
                    end
                    dimension = double.empty(1,0);
                case {ShapeConstraint.monotonicIncreasing, ShapeConstraint.monotonicDecreasing}
                    if isempty(options.Dimension)
                        error('GlobalConstraint:MissingDimension', ...
                            'Dimension must be specified for directional global constraints.');
                    end
                    dimension = options.Dimension;
                otherwise
                    error('GlobalConstraint:UnsupportedShape', ...
                        'Unsupported global constraint shape.');
            end

            self.Shape = shape;
            self.Dimension = dimension;
        end
    end

    methods (Static)
        function self = positive()
            % Create a positivity constraint.
            %
            % ```matlab
            % c = GlobalConstraint.positive();
            % ```
            %
            % - Topic: Specify global constraints
            % - Declaration: self = positive()
            % - Returns self: positivity GlobalConstraint
            self = GlobalConstraint(ShapeConstraint.positive);
        end

        function self = monotonicIncreasing(options)
            % Create a monotone-increasing constraint along one dimension.
            %
            % ```matlab
            % c = GlobalConstraint.monotonicIncreasing(Dimension=1);
            % ```
            %
            % - Topic: Specify global constraints
            % - Declaration: self = monotonicIncreasing(options)
            % - Parameter options.Dimension: tensor dimension, default 1
            % - Returns self: monotone-increasing GlobalConstraint
            arguments
                options.Dimension (1,1) double {mustBeInteger,mustBePositive} = 1
            end

            self = GlobalConstraint(ShapeConstraint.monotonicIncreasing, Dimension=options.Dimension);
        end

        function self = monotonicDecreasing(options)
            % Create a monotone-decreasing constraint along one dimension.
            %
            % ```matlab
            % c = GlobalConstraint.monotonicDecreasing(Dimension=2);
            % ```
            %
            % - Topic: Specify global constraints
            % - Declaration: self = monotonicDecreasing(options)
            % - Parameter options.Dimension: tensor dimension, default 1
            % - Returns self: monotone-decreasing GlobalConstraint
            arguments
                options.Dimension (1,1) double {mustBeInteger,mustBePositive} = 1
            end

            self = GlobalConstraint(ShapeConstraint.monotonicDecreasing, Dimension=options.Dimension);
        end

        function self = none()
            % Create an explicit no-op global constraint.
            %
            % ```matlab
            % c = GlobalConstraint.none();
            % ```
            %
            % - Topic: Specify global constraints
            % - Declaration: self = none()
            % - Returns self: no-op GlobalConstraint
            self = GlobalConstraint(ShapeConstraint.none);
        end
    end
end
