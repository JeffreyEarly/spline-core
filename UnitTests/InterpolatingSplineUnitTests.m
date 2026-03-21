classdef InterpolatingSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function interpolatingSplineMatchesInputData(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) sin(2*pi*x);
            t = linspace(0,1,11)';

            spline = InterpolatingSpline(t,f(t),K=4);

            testCase.assertThat(spline(t), IsEqualTo(f(t), 'Within', AbsoluteTolerance(10*eps)))
        end

        function interpolatingSplineSupportsNamedOrderArguments(testCase)
            t = linspace(0,1,11)';
            x = sin(2*pi*t);

            splineFromK = InterpolatingSpline(t,x,K=4);
            splineFromS = InterpolatingSpline(t,x,S=3);

            testCase.verifyEqual(splineFromK.K,4)
            testCase.verifyEqual(splineFromS.K,4)
            testCase.verifyEqual(splineFromK(t), splineFromS(t), AbsTol=10*eps)
        end

        function interpolatingSplineRejectsConflictingOrderOptions(testCase)
            t = linspace(0,1,11)';
            x = sin(2*pi*t);

            testCase.verifyError(@() InterpolatingSpline(t,x,K=5,S=3), 'InterpolatingSpline:ConflictingSplineOrder')
        end

        function plusAddsScalarOffset(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),K=2);

            shifted = spline + 1;

            testCase.assertThat(shifted(t), IsEqualTo(f(t)+1, 'Within', AbsoluteTolerance(2*eps)))
        end

        function plusSupportsScalarOnLeft(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),K=2);

            shifted = 1 + spline;

            testCase.assertThat(shifted(t), IsEqualTo(f(t)+1, 'Within', AbsoluteTolerance(2*eps)))
        end

        function mtimesScalesSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),K=2);

            scaled = -2*spline;

            testCase.assertThat(scaled(t), IsEqualTo(-2*f(t), 'Within', AbsoluteTolerance(2*eps)))
        end

        function mtimesSupportsSplineOnLeft(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x;
            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t,f(t),K=2);

            scaled = spline * -2;

            testCase.assertThat(scaled(t), IsEqualTo(-2*f(t), 'Within', AbsoluteTolerance(2*eps)))
        end

        function plusRejectsNonScalarNumeric(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',K=2);
            testCase.verifyError(@() plus(spline,[1 2]), 'TensorSpline:plus:UnsupportedOperand')
        end

        function mtimesRejectsNonScalarNumeric(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',K=2);
            testCase.verifyError(@() mtimes(spline,[1 2]), 'TensorSpline:mtimes:UnsupportedOperand')
        end

        function interpolatingSplineExposesVectorKnotSequenceInOneDimension(testCase)
            spline = InterpolatingSpline(linspace(0,1,11)', sin(2*pi*linspace(0,1,11)'), K=4);

            testCase.verifyTrue(isnumeric(spline.tKnot))
            testCase.verifySize(spline.tKnot, [numel(spline.tKnot), 1])
        end

        function interpolatingSplineDerivativeMatchesCubic(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance

            f = @(x) -x.^3 + x.^2 - 2*x + 1;
            df = @(x) -3*x.^2 + 2*x - 2;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t,f(t),K=4);

            testCase.assertThat(spline(t,1), IsEqualTo(df(t), 'Within', RelativeTolerance(100*eps)))
        end

        function interpolatingSplineMatchesGriddedInterpolantSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = [-1; -0.33; 0.33; 1];
            x = [0; 1; 2; 0];
            tq = linspace(t(1),t(end),401)';

            spline = InterpolatingSpline(t,x,K=4);
            interpolant = griddedInterpolant(t,x,'spline');

            testCase.assertThat(spline(tq), IsEqualTo(interpolant(tq), 'Within', AbsoluteTolerance(1e-12)))
        end

        function diffOperatorMatchesDerivative(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance

            f = @(x) -x.^3 + x.^2 - 2*x + 1;
            df = @(x) -3*x.^2 + 2*x - 2;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t,f(t),K=4);
            dspline = diff(spline);

            testCase.assertThat(dspline(t), IsEqualTo(df(t), 'Within', RelativeTolerance(100*eps)))
        end

        function diffRejectsNegativeOrder(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',K=2);
            testCase.verifyError(@() diff(spline,-1), 'MATLAB:validators:mustBeNonnegative')
        end

        function cumsumOperatorMatchesIntegral(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x + ones(size(x));
            g = @(x) 0.5*x.^2 + x;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t,f(t),K=4);
            intspline = cumsum(spline);

            testCase.assertThat(intspline(t), IsEqualTo(g(t)-g(t(1)), 'Within', AbsoluteTolerance(10*eps)))
        end

        function powerWithExponentOneReturnsOriginalSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0,1,11)';
            x = sin(2*pi*t);
            spline = InterpolatingSpline(t,x,K=4);

            powered = power(spline,1);

            testCase.assertThat(powered(t), IsEqualTo(spline(t), 'Within', AbsoluteTolerance(10*eps)))
        end

        function sqrtMatchesPositiveSplineOnSupport(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0,1,11)';
            x = (t + 1).^2;
            spline = InterpolatingSpline(t,x,K=4);

            rooted = sqrt(spline);

            testCase.assertThat(rooted(t), IsEqualTo(t + 1, 'Within', AbsoluteTolerance(1e-8)))
        end

        function valueAtPointsRejectsNegativeDerivativeOrder(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',K=2);
            testCase.verifyError(@() spline.valueAtPoints((0:2)',-1), 'MATLAB:expectedNonnegative')
        end

        function valueAtPointsReturnsZeroAboveSplineDegree(testCase)
            spline = InterpolatingSpline((0:2)',(0:2)',K=2);

            values = spline.valueAtPoints((0:2)',2);

            testCase.verifyEqual(values, zeros(3,1))
        end

        function rootsStayWithinSplineDomain(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) mod(x,2)-0.5;
            t = linspace(0,10,11)';
            spline = InterpolatingSpline(t,f(t),K=2);

            expected = (0:9)' + 0.5;
            actual = roots(spline);

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(2*eps)))
        end
    end

end
