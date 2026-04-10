classdef TrajectorySpline < CAAnnotatedClass
    % Two-dimensional interpolating trajectory parameterized by time or arc parameter.
    %
    % `TrajectorySpline` stores a planar parametric trajectory as two
    % one-dimensional constrained splines,
    %
    % $$
    % x = x(t), \qquad y = y(t),
    % $$
    %
    % built from a shared parameter vector `t`. Use this class when the
    % trajectory should be represented componentwise so each coordinate can
    % be evaluated independently through `trajectory.x(tq)` and
    % `trajectory.y(tq)`, and the corresponding trajectory derivatives can
    % be evaluated through `trajectory.u(tq)` and `trajectory.v(tq)`.
    %
    % ```matlab
    % t = linspace(0, 1, 20)';
    % x = cos(2*pi*t);
    % y = sin(2*pi*t);
    %
    % trajectory = TrajectorySpline(t, x, y, S=3);
    % xq = trajectory.x(t);
    % yq = trajectory.y(t);
    % ```
    %
    % - Topic: Create a trajectory spline
    % - Topic: Inspect trajectory properties
    % - Topic: Evaluate trajectory derivatives
    % - Declaration: classdef TrajectorySpline < CAAnnotatedClass

    properties (SetAccess = private)
        % Parameter samples used to define the component splines.
        %
        % `t` is stored as a column vector and provides the shared
        % parameterization for both coordinate splines `x(t)` and `y(t)`.
        %
        % - Topic: Inspect trajectory properties
        t (:,1) double {mustBeReal,mustBeFinite}

        % Constrained spline for the x-coordinate trajectory component.
        %
        % Evaluate the x-coordinate along the trajectory with
        % `trajectory.x(tq)`. The returned object is a `ConstrainedSpline`,
        % so fit metadata such as `dataPoints` and `dataValues` remain
        % available on the coordinate component.
        %
        % - Topic: Inspect trajectory properties
        x

        % Constrained spline for the y-coordinate trajectory component.
        %
        % Evaluate the y-coordinate along the trajectory with
        % `trajectory.y(tq)`. The returned object is a `ConstrainedSpline`,
        % so fit metadata such as `dataPoints` and `dataValues` remain
        % available on the coordinate component.
        %
        % - Topic: Inspect trajectory properties
        y
    end

    methods
        function self = TrajectorySpline(t, x, y, options)
            % Create a two-dimensional trajectory from x(t) and y(t) samples.
            %
            % Use this constructor when the two coordinate components of a
            % planar trajectory are known at the same parameter samples and
            % should each be represented by a 1-D `ConstrainedSpline`
            % sharing the same parameter samples.
            %
            % The stored component splines are fit independently to
            % `x(t)` and `y(t)` while exposing the `ConstrainedSpline`
            % metadata for each coordinate.
            %
            % The resulting component models satisfy
            %
            % $$
            % x(t_i) = x_i, \qquad y(t_i) = y_i,
            % $$
            %
            % for each supplied sample pair `x_i`, `y_i` at parameter value
            % `t_i`.
            %
            % ```matlab
            % t = linspace(0, 1, 20)';
            % x = cos(2*pi*t);
            % y = sin(2*pi*t);
            % trajectory = TrajectorySpline(t, x, y, S=3);
            % ```
            %
            % - Topic: Create a trajectory spline
            % - Declaration: self = TrajectorySpline(t,x,y,options)
            % - Parameter t: numeric vector of shared trajectory parameter samples
            % - Parameter x: numeric vector of x-coordinate samples at t
            % - Parameter y: numeric vector of y-coordinate samples at t
            % - Parameter options.S: spline degree shared by both coordinate splines
            % - Returns self: TrajectorySpline instance
            arguments
                t = []
                x = []
                y = []
                options.S (1,1) double {mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative} = 3
            end

            if isa(x, 'TensorSpline') || isa(y, 'TensorSpline')
                if isempty(t) || isempty(x) || isempty(y)
                    error('TrajectorySpline:MissingComponentSpline', 'Persisted/component construction requires t, x, and y.');
                end
                if ~isa(x, 'TensorSpline') || ~isa(y, 'TensorSpline')
                    error('TrajectorySpline:InvalidComponentSpline', 'x and y must both be TensorSpline objects when using component-spline construction.');
                end
                validateattributes(t, {'numeric'}, {'vector','real','finite','nonempty'});
                t = TrajectorySpline.normalizeParameter(t, shouldRequireMonotonic=false);
                xSpline = x;
                ySpline = y;
            else
                validateattributes(t, {'numeric'}, {'vector','real','finite','nonempty'});
                validateattributes(x, {'numeric'}, {'vector','real','finite','nonempty'});
                validateattributes(y, {'numeric'}, {'vector','real','finite','nonempty'});
                t = TrajectorySpline.normalizeParameter(t, shouldRequireMonotonic=false);
                x = reshape(x, [], 1);
                y = reshape(y, [], 1);

                if numel(x) ~= numel(t) || numel(y) ~= numel(t)
                    error('TrajectorySpline:SizeMismatch', 't, x, and y must have the same number of elements.');
                end

                xSpline = ConstrainedSpline.fromGriddedValues(t, x, S=options.S);
                ySpline = ConstrainedSpline.fromGriddedValues(t, y, S=options.S);
            end

            self@CAAnnotatedClass();
            if xSpline.numDimensions ~= 1 || ySpline.numDimensions ~= 1
                error('TrajectorySpline:InvalidComponentSpline', 'x and y must be one-dimensional splines.');
            end
            self.t = t;
            self.x = xSpline;
            self.y = ySpline;
        end

        function values = u(self, t)
            % Evaluate the x-velocity $$u(t) = \dot{x}(t)$$ along the trajectory.
            %
            % Use this method when the x-component derivative should be
            % evaluated through the trajectory API rather than by reaching
            % into the component spline directly.
            %
            % - Topic: Evaluate trajectory derivatives
            % - Declaration: values = u(self,t)
            % - Parameter t: numeric query points with any shape
            % - Returns values: x-derivative values with the same shape as `t`
            arguments (Input)
                self (1,1) TrajectorySpline
                t {mustBeNumeric,mustBeReal,mustBeFinite}
            end
            arguments (Output)
                values
            end

            values = self.x.valueAtPoints(t, D=1);
        end

        function values = v(self, t)
            % Evaluate the y-velocity $$v(t) = \dot{y}(t)$$ along the trajectory.
            %
            % Use this method when the y-component derivative should be
            % evaluated through the trajectory API rather than by reaching
            % into the component spline directly.
            %
            % - Topic: Evaluate trajectory derivatives
            % - Declaration: values = v(self,t)
            % - Parameter t: numeric query points with any shape
            % - Returns values: y-derivative values with the same shape as `t`
            arguments (Input)
                self (1,1) TrajectorySpline
                t {mustBeNumeric,mustBeReal,mustBeFinite}
            end
            arguments (Output)
                values
            end

            values = self.y.valueAtPoints(t, D=1);
        end
    end

    methods (Static)
        function self = fromComponentSplines(t, xSpline, ySpline)
            % Create a trajectory spline from pre-fit component splines.
            %
            % Use this factory when the x- and y-coordinate trajectories
            % have already been fit as one-dimensional splines and should
            % be wrapped into a single `TrajectorySpline` container without
            % refitting either component.
            %
            % The resulting trajectory stores the supplied parameter vector
            % `t` together with the supplied component splines
            %
            % $$
            % x = x(t), \qquad y = y(t).
            % $$
            %
            % ```matlab
            % trajectory = TrajectorySpline.fromComponentSplines(t, xSpline, ySpline);
            % xq = trajectory.x(t);
            % yq = trajectory.y(t);
            % ```
            %
            % - Topic: Create a trajectory spline
            % - Declaration: self = fromComponentSplines(t,xSpline,ySpline)
            % - Parameter t: numeric vector of shared trajectory parameter samples
            % - Parameter xSpline: one-dimensional spline for the x-coordinate
            % - Parameter ySpline: one-dimensional spline for the y-coordinate
            % - Returns self: TrajectorySpline instance
            arguments (Input)
                t {mustBeNumeric,mustBeReal,mustBeFinite,mustBeNonempty,mustBeVector}
                xSpline (1,1) TensorSpline
                ySpline (1,1) TensorSpline
            end
            arguments (Output)
                self (1,1) TrajectorySpline
            end

            t = TrajectorySpline.normalizeParameter(t, shouldRequireMonotonic=true);
            if xSpline.numDimensions ~= 1 || ySpline.numDimensions ~= 1
                error('TrajectorySpline:InvalidComponentSpline', 'xSpline and ySpline must be one-dimensional splines.');
            end

            self = TrajectorySpline(t, xSpline, ySpline);
        end
    end

    methods (Static, Hidden)
        function self = annotatedClassFromFile(path)
            ncfile = NetCDFFile(path, shouldReadOnly=true);
            cleanup = onCleanup(@() ncfile.close()); %#ok<NASGU>
            if isKey(ncfile.attributes, 'AnnotatedClass')
                className = string(ncfile.attributes('AnnotatedClass'));
                if ncfile.hasGroupWithName(className)
                    group = ncfile.groupWithName(className);
                else
                    group = ncfile;
                end
            else
                error('TrajectorySpline:MissingAnnotatedClass', 'Unable to find the AnnotatedClass attribute in %s.', path);
            end
            self = TrajectorySpline.annotatedClassFromGroup(group);
        end

        function self = annotatedClassFromGroup(group)
            vars = CAAnnotatedClass.propertyValuesFromGroup(group, {'t'});
            xSpline = TensorSpline.annotatedClassFromGroup(group.groupWithName('x'));
            ySpline = TensorSpline.annotatedClassFromGroup(group.groupWithName('y'));
            self = TrajectorySpline(vars.t, xSpline, ySpline);
        end

        function propertyAnnotations = classDefinedPropertyAnnotations()
            propertyAnnotations = CAPropertyAnnotation.empty(0,0);
            propertyAnnotations(end+1) = CADimensionProperty('t', '', 'Trajectory parameter samples.');
            propertyAnnotations(end+1) = CAObjectProperty('x', 'Spline model for the x-coordinate trajectory component.');
            propertyAnnotations(end+1) = CAObjectProperty('y', 'Spline model for the y-coordinate trajectory component.');
        end

        function names = classRequiredPropertyNames()
            names = {'t', 'x', 'y'};
        end
    end

    methods (Static, Access = private)
        function t = normalizeParameter(t, options)
            arguments
                t
                options.shouldRequireMonotonic (1,1) logical = true
            end
            t = reshape(t, [], 1);
            if options.shouldRequireMonotonic && any(diff(t) <= 0)
                error('TrajectorySpline:NonmonotonicParameter', 't must be strictly increasing.');
            end
        end
    end
end
