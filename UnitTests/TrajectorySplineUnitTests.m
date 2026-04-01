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
    end
end
