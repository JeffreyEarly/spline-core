classdef TensorSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function tensorInterpolatingSplineMatchesGridData(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 .* Y.^3 + 2*X.*Y - 5;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);

            testCase.assertThat(spline(X, Y), IsEqualTo(F, 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplineMatchesPolynomialDerivative(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 .* Y.^3 + 2*X.*Y - 5;
            dFdx = 2*X.*Y.^3 + 2*Y;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);

            testCase.assertThat(spline(X, Y, [1 0]), IsEqualTo(dFdx, 'Within', AbsoluteTolerance(1e-9)))
        end

        function tensorSplineMatchesGriddedInterpolantSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,5)';
            y = linspace(0,2,6)';
            [X,Y] = ndgrid(x,y);
            F = sin(pi*X) + cos(0.5*pi*Y);

            spline = InterpolatingSpline(x, y, F, K=[4 4]);
            interpolant = griddedInterpolant({x,y}, F, 'spline');

            xq = linspace(x(1),x(end),21)';
            yq = linspace(y(1),y(end),25)';
            [Xq,Yq] = ndgrid(xq,yq);

            expected = interpolant({xq,yq});
            actual = spline(Xq, Yq);

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplineMatrixMatchesEvaluation(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 .* Y.^3 + 2*X.*Y - 5;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);
            queryPoints = [X(:), Y(:)];
            basisMatrix = TensorSpline.matrix(queryPoints, spline.tKnot, spline.K);
            values = reshape(basisMatrix * spline.xi(:), size(F));
            values = spline.xStd * values + spline.xMean;

            testCase.assertThat(values, IsEqualTo(F, 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorInterpolatingSplineRejectsNdgridConstructorInputs(testCase)
            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = sin(pi*X) .* cos(0.5*pi*Y);

            testCase.verifyError(@() InterpolatingSpline(X, Y, F, K=[4 4]), ...
                'InterpolatingSpline:InvalidGridInputs')
        end

        function tensorSplinePreservesQueryArrayShape(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 .* Y.^3 + 2*X.*Y - 5;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);
            actual = spline(X, Y);

            testCase.verifySize(actual, size(F))
            testCase.assertThat(actual, IsEqualTo(F, 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplinePlusAddsScalarOffset(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t, t, K=2);

            shifted = spline + 1;

            testCase.assertThat(shifted(t), IsEqualTo(t + 1, 'Within', AbsoluteTolerance(2*eps)))
        end

        function tensorSplineMtimesScalesSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(-1,1,11)';
            spline = InterpolatingSpline(t, t, K=2);

            scaled = -2 * spline;

            testCase.assertThat(scaled(t), IsEqualTo(-2*t, 'Within', AbsoluteTolerance(2*eps)))
        end

        function tensorSplineRejectsNonScalarAffineOperands(testCase)
            spline = InterpolatingSpline((0:2)', (0:2)', K=2);

            testCase.verifyError(@() plus(spline, [1 2]), 'TensorSpline:plus:UnsupportedOperand')
            testCase.verifyError(@() mtimes(spline, [1 2]), 'TensorSpline:mtimes:UnsupportedOperand')
        end

        function tensorSplineDiffReturnsMixedPartialSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 .* Y.^3 + 2*X.*Y - 5;
            d2Fdxy = 6*X.*Y.^2 + 2;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);
            dspline = diff(spline, [1 1]);

            testCase.assertThat(dspline(X, Y), IsEqualTo(d2Fdxy, 'Within', AbsoluteTolerance(1e-9)))
        end

        function tensorSplineCumsumMatchesIntegralInOneDimension(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) x + 1;
            g = @(x) 0.5*x.^2 + x;
            t = linspace(-1,1,11)';

            spline = InterpolatingSpline(t, f(t), K=4);
            intspline = cumsum(spline);

            testCase.assertThat(intspline(t), IsEqualTo(g(t) - g(t(1)), 'Within', AbsoluteTolerance(10*eps)))
        end

        function tensorSplineExposesDegreeVector(testCase)
            spline1D = InterpolatingSpline(linspace(0,1,5)', linspace(0,1,5)', K=4);
            spline2D = InterpolatingSpline(linspace(0,1,5)', linspace(-1,1,6)', randn(5,6), K=[3 4]);

            testCase.verifyEqual(spline1D.S, 3)
            testCase.verifyEqual(spline2D.S, [2 3])
        end

        function tensorSplineFevalMatchesDirectEvaluation(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 .* Y.^3 + 2*X.*Y - 5;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);

            testCase.assertThat(feval(spline, X, Y), IsEqualTo(spline(X, Y), 'Within', AbsoluteTolerance(1e-10)))
            testCase.assertThat(feval(spline, X, Y, [1 0]), IsEqualTo(spline(X, Y, [1 0]), 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplineDomainReturnsNumericLimits(testCase)
            spline1D = InterpolatingSpline((0:4)', (0:4)', K=2);
            spline2D = InterpolatingSpline((0:4)', (-2:2)', randn(5,5), K=[2 3]);

            testCase.verifyEqual(spline1D.domain, [0 4])
            testCase.verifyEqual(spline2D.domain, [0 4; -2 2])
        end

        function tensorSplineRootsStayWithinSplineDomain(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) mod(x,2) - 0.5;
            t = linspace(0,10,11)';
            spline = InterpolatingSpline(t, f(t), K=2);

            expected = (0:9)' + 0.5;
            actual = roots(spline);

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(2*eps)))
        end

        function tensorSplineRootsRejectHigherDimensions(testCase)
            x = linspace(0,1,5)';
            y = linspace(0,1,6)';
            [X,Y] = ndgrid(x,y);
            F = X - Y;
            spline = InterpolatingSpline(x, y, F, K=[2 2]);

            testCase.verifyError(@() roots(spline), 'TensorSpline:roots:UnsupportedDimension')
        end

        function tensorSplinePointsOfSupportMatchBasisSize(testCase)
            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            spline = InterpolatingSpline(x, y, x .* y', K=[4 4]);

            [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(spline.tKnot, spline.K);

            testCase.verifySize(supportPoints, [prod(spline.basisSize), spline.numDimensions])
            testCase.verifyEqual(cellfun(@numel, supportVectors), spline.basisSize)
        end

        function tensorSplinePowerMatchesSquaredValuesOnSupport(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 + Y + 2;
            spline = InterpolatingSpline(x, y, F, K=[4 4]);
            squaredSpline = spline.^2;
            supportPoints = TensorSpline.pointsOfSupport(spline.tKnot, spline.K);

            testCase.assertThat(squaredSpline(supportPoints), ...
                IsEqualTo(spline(supportPoints).^2, 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplineSqrtMatchesSquareRootValuesOnSupport(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(0,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = (X + 1).^2 + (Y + 2).^2;
            spline = InterpolatingSpline(x, y, F, K=[4 4]);
            rootedSpline = sqrt(spline);
            supportPoints = TensorSpline.pointsOfSupport(spline.tKnot, spline.K);

            testCase.assertThat(rootedSpline(supportPoints), ...
                IsEqualTo(sqrt(spline(supportPoints)), 'Within', AbsoluteTolerance(1e-10)))
        end
    end
end
