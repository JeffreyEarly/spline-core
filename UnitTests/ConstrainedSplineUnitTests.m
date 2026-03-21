classdef ConstrainedSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function constrainedSplineFitsLine(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0,1,11)';
            x = 2*t + 1;
            K = 2;
            tKnot = [t(1)*ones(K,1); t(end)*ones(K,1)];

            spline = ConstrainedSpline(t,x,K,tKnot,NormalDistribution(1),struct('t',[],'D',[]));

            testCase.assertThat(spline(t), IsEqualTo(x, 'Within', AbsoluteTolerance(10*eps)))
        end

        function constrainedSplineAcceptsEmptyConstraints(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0,1,11)';
            x = 2*t + 1;
            K = 2;
            tKnot = [t(1)*ones(K,1); t(end)*ones(K,1)];

            spline = ConstrainedSpline(t,x,K,tKnot,NormalDistribution(1),[]);

            testCase.assertThat(spline(t), IsEqualTo(x, 'Within', AbsoluteTolerance(10*eps)))
        end

        function constrainedSplineSupportsRobustDistribution(testCase)
            t = linspace(0,1,11)';
            x = 2*t + 1;
            K = 2;
            tKnot = [t(1)*ones(K,1); t(end)*ones(K,1)];

            spline = ConstrainedSpline(t,x,K,tKnot,StudentTDistribution(sigma=1,nu=3),[]);

            testCase.verifySize(spline(t), size(t))
        end
    end

end
