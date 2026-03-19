classdef BSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function interpolatingSplineMatchesInputData(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) sin(2*pi*x);
            t = linspace(0,1,11)';

            spline = InterpolatingSpline(t,f(t),4);

            testCase.assertThat(spline(t), IsEqualTo(f(t), 'Within', AbsoluteTolerance(10*eps)))
        end

        function plusAddsScalarOffset(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),2);

            shifted = spline + 1;

            testCase.assertThat(shifted(t), IsEqualTo(f(t)+1, 'Within', AbsoluteTolerance(2*eps)))
        end

        function plusSupportsScalarOnLeft(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),2);

            shifted = 1 + spline;

            testCase.assertThat(shifted(t), IsEqualTo(f(t)+1, 'Within', AbsoluteTolerance(2*eps)))
        end

        function mtimesScalesSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),2);

            scaled = -2*spline;

            testCase.assertThat(scaled(t), IsEqualTo(-2*f(t), 'Within', AbsoluteTolerance(2*eps)))
        end

        function mtimesSupportsSplineOnLeft(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),2);

            scaled = spline * -2;

            testCase.assertThat(scaled(t), IsEqualTo(-2*f(t), 'Within', AbsoluteTolerance(2*eps)))
        end

        function plusRejectsNonScalarNumeric(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',2);
            testCase.verifyError(@() plus(spline,[1 2]), 'BSpline:plus:UnsupportedOperand')
        end

        function mtimesRejectsNonScalarNumeric(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',2);
            testCase.verifyError(@() mtimes(spline,[1 2]), 'BSpline:mtimes:UnsupportedOperand')
        end

        function interpolatingSplineDerivativeMatchesCubic(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance

            f = @(x) -x.^3 + x.^2 - 2*x + 1;
            df = @(x) -3*x.^2 + 2*x - 2;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t,f(t),4);

            testCase.assertThat(spline(t,1), IsEqualTo(df(t), 'Within', RelativeTolerance(100*eps)))
        end

        function diffOperatorMatchesDerivative(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance

            f = @(x) -x.^3 + x.^2 - 2*x + 1;
            df = @(x) -3*x.^2 + 2*x - 2;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t,f(t),4);
            dspline = diff(spline);

            testCase.assertThat(dspline(t), IsEqualTo(df(t), 'Within', RelativeTolerance(100*eps)))
        end

        function diffRejectsNegativeOrder(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',2);
            testCase.verifyError(@() diff(spline,-1), 'MATLAB:validators:mustBeNonnegative')
        end

        function cumsumOperatorMatchesIntegral(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x + ones(size(x));
            g = @(x) 0.5*x.^2 + x;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t,f(t),4);
            intspline = cumsum(spline);

            testCase.assertThat(intspline(t), IsEqualTo(g(t)-g(t(1)), 'Within', AbsoluteTolerance(10*eps)))
        end

        function matrixAndPPFormsAgree(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) cos(2*pi*x/3);
            K = 4;
            t = linspace(0,3,13)';
            tKnot = InterpolatingSpline.KnotPointsForPoints(t,K);

            X = BSpline.matrix(t,tKnot,K);
            xi = X\f(t);
            [C,tpp] = BSpline.ppCoefficientsFromSplineCoefficients(xi,tKnot,K);

            tq = linspace(t(1),t(end),301)';
            valuesFromMatrix = BSpline.matrix(tq,tKnot,K)*xi;
            valuesFromPP = BSpline.evaluateFromPPCoefficients(tq,C,tpp);

            testCase.assertThat(valuesFromPP, IsEqualTo(valuesFromMatrix, 'Within', AbsoluteTolerance(1e-10)))
        end

        function ppEvaluationHandlesUnsortedInputs(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) sin(2*pi*x/3);
            K = 4;
            t = linspace(0,3,13)';
            tKnot = InterpolatingSpline.KnotPointsForPoints(t,K);

            X = BSpline.matrix(t,tKnot,K);
            xi = X\f(t);
            [C,tpp] = BSpline.ppCoefficientsFromSplineCoefficients(xi,tKnot,K);

            tqSorted = linspace(t(1),t(end),31)';
            tqUnsorted = tqSorted([7 1 19 4 31 12 2 25 16 9 22 5 29 14 3 18 27 11 6 24 15 8 30 13 10 21 17 20 23 26 28]);

            expected = BSpline.matrix(tqUnsorted,tKnot,K)*xi;
            actual = BSpline.evaluateFromPPCoefficients(tqUnsorted,C,tpp);

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(1e-10)))
        end

        function valueAtPointsRejectsNegativeDerivativeOrder(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',2);
            testCase.verifyError(@() spline.valueAtPoints((0:2)',-1), 'MATLAB:validators:mustBeNonnegative')
        end

        function rootsStayWithinSplineDomain(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) mod(x,2)-0.5;
            t = linspace(0,10,11)';
            spline = InterpolatingSpline(t,f(t),2);

            expected = (0:9)' + 0.5;
            actual = roots(spline);

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(2*eps)))
        end

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

        function clearingCoefficientsClearsCachedState(testCase)
            K = 3;
            t = linspace(0,1,5)';
            tKnot = [t(1)*ones(K,1); t(2:end-1); t(end)*ones(K,1)];
            spline = BSpline(K,tKnot,ones(length(tKnot)-K,1));

            spline.xi = [];

            testCase.verifyEmpty(spline.C)
            testCase.verifyEmpty(spline.t_pp)
            testCase.verifyEmpty(spline.Xtpp)
        end

        function settingCoefficientsRebuildsCachedState(testCase)
            K = 3;
            t = linspace(0,1,5)';
            tKnot = [t(1)*ones(K,1); t(2:end-1); t(end)*ones(K,1)];
            spline = BSpline(K,tKnot,[]);

            spline.xi = ones(length(tKnot)-K,1);

            testCase.verifyNotEmpty(spline.C)
            testCase.verifyNotEmpty(spline.t_pp)
            testCase.verifyNotEmpty(spline.Xtpp)
        end

        function changingKnotsInvalidatesCoefficientsAndCaches(testCase)
            K = 3;
            t = linspace(0,1,5)';
            tKnot = [t(1)*ones(K,1); t(2:end-1); t(end)*ones(K,1)];
            spline = BSpline(K,tKnot,ones(length(tKnot)-K,1));

            spline.tKnot = [0; 0; 0; 0.5; 1; 1; 1];

            testCase.verifyEmpty(spline.xi)
            testCase.verifyEmpty(spline.C)
            testCase.verifyEmpty(spline.t_pp)
            testCase.verifyEmpty(spline.Xtpp)
        end
    end

end
