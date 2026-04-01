classdef TrajectorySplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function trajectorySplineConstructsFromValidSamples(testCase)
            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t);

            trajectory = TrajectorySpline(t, x, y, S=3);

            testCase.verifyClass(trajectory, 'TrajectorySpline')
            testCase.verifyClass(trajectory.x, 'ConstrainedSpline')
            testCase.verifyClass(trajectory.y, 'ConstrainedSpline')
            testCase.verifyEqual(trajectory.t, t)
        end

        function trajectorySplineInterpolatesXSamples(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t);
            trajectory = TrajectorySpline(t, x, y, S=3);

            testCase.assertThat(trajectory.x(t), IsEqualTo(x, 'Within', AbsoluteTolerance(10*eps)))
        end

        function trajectorySplineInterpolatesYSamples(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t);
            trajectory = TrajectorySpline(t, x, y, S=3);

            testCase.assertThat(trajectory.y(t), IsEqualTo(y, 'Within', AbsoluteTolerance(10*eps)))
        end

        function trajectorySplinePropagatesSharedDegree(testCase)
            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t);

            trajectory = TrajectorySpline(t, x, y, S=5);

            testCase.verifyEqual(trajectory.x.S, 5)
            testCase.verifyEqual(trajectory.y.S, 5)
            testCase.verifyEqual(trajectory.x.K, 6)
            testCase.verifyEqual(trajectory.y.K, 6)
        end

        function trajectorySplineExposesComponentFitData(testCase)
            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t);

            trajectory = TrajectorySpline(t, x, y, S=3);

            testCase.verifyEqual(trajectory.x.dataPoints, t)
            testCase.verifyEqual(trajectory.y.dataPoints, t)
            testCase.verifyEqual(trajectory.x.dataValues, x)
            testCase.verifyEqual(trajectory.y.dataValues, y)
        end

        function trajectorySplineStoresParameterAsColumnVector(testCase)
            t = linspace(0, 1, 11);
            x = cos(2*pi*t);
            y = sin(2*pi*t);

            trajectory = TrajectorySpline(t, x, y, S=3);

            testCase.verifySize(trajectory.t, [numel(t), 1])
            testCase.verifyEqual(trajectory.t, t(:))
        end

        function trajectorySplineRejectsMismatchedVectorLengths(testCase)
            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t(1:end-1));

            testCase.verifyError(@() TrajectorySpline(t, x, y, S=3), 'TrajectorySpline:SizeMismatch')
        end

        function trajectorySplineRejectsNonVectorInputs(testCase)
            t = repmat((0:2)', 1, 2);
            x = (0:5)';
            y = (0:5)';

            testCase.verifyError(@() TrajectorySpline(t, x, y, S=1), 'MATLAB:validators:mustBeVector')
        end

        function trajectorySplineRejectsEmptyInputs(testCase)
            testCase.verifyError(@() TrajectorySpline([], [], [], S=3), 'MATLAB:validators:mustBeNonempty')
        end

        function trajectorySplineWrapsPreFitComponentSplines(testCase)
            t = linspace(0, 1, 11)';
            x = cos(2*pi*t);
            y = sin(2*pi*t);
            xSpline = ConstrainedSpline(t, x, S=3);
            ySpline = ConstrainedSpline(t, y, S=3);

            trajectory = TrajectorySpline.fromComponentSplines(t, xSpline, ySpline);

            testCase.verifyEqual(trajectory.t, t)
            testCase.verifySameHandle(trajectory.x, xSpline)
            testCase.verifySameHandle(trajectory.y, ySpline)
            testCase.verifyEqual(trajectory.x(t), x, "AbsTol", 10*eps)
            testCase.verifyEqual(trajectory.y(t), y, "AbsTol", 10*eps)
        end

        function trajectorySplineWrapFactoryRejectsNonmonotonicParameter(testCase)
            t = [0; 0.5; 0.5; 1];
            xSpline = ConstrainedSpline([0; 0.5; 1], [0; 1; 0], S=2);
            ySpline = ConstrainedSpline([0; 0.5; 1], [0; 0; 1], S=2);

            testCase.verifyError(@() TrajectorySpline.fromComponentSplines(t, xSpline, ySpline), ...
                'TrajectorySpline:NonmonotonicParameter')
        end

        function trajectorySplineWrapFactoryRejectsMultidimensionalSplines(testCase)
            t = linspace(0, 1, 5)';
            xSpline = TensorSpline(S=[1 1], knotPoints={[-1; -1; 1; 1], [-1; -1; 1; 1]}, xi=zeros(4, 1));
            ySpline = ConstrainedSpline(t, sin(2*pi*t), S=3);

            testCase.verifyError(@() TrajectorySpline.fromComponentSplines(t, xSpline, ySpline), ...
                'TrajectorySpline:InvalidComponentSpline')
        end
    end
end
