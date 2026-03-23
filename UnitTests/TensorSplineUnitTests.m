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

        function tensorSplineRejectsPointMatrixEvaluationSyntax(testCase)
            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 + Y;

            spline = InterpolatingSpline(x, y, F, K=[4 4]);

            testCase.verifyError(@() spline([X(:), Y(:)]), 'TensorSpline:InvalidEvaluationInput')
        end

        function tensorInterpolatingSplineRejectsNdgridConstructorInputs(testCase)
            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = sin(pi*X) .* cos(0.5*pi*Y);

            caught = [];
            try
                InterpolatingSpline(X, Y, F, K=[4 4]);
            catch exception
                caught = exception;
            end

            testCase.verifyNotEmpty(caught)
        end

        function tensorSplinePlusAddsScalarOffset(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 + 3*Y - 1;
            spline = InterpolatingSpline(x, y, F, K=[4 4]);

            shifted = spline + 1;

            testCase.assertThat(shifted(X, Y), IsEqualTo(F + 1, 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplineMtimesScalesSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X.^2 + 3*Y - 1;
            spline = InterpolatingSpline(x, y, F, K=[4 4]);

            scaled = -2 * spline;

            testCase.assertThat(scaled(X, Y), IsEqualTo(-2*F, 'Within', AbsoluteTolerance(1e-10)))
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

        function tensorSplineCumsumMatchesIntegralAlongSpecifiedDimension(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(0,2,7)';
            [X,Y] = ndgrid(x,y);
            F = X + 2*Y;
            integralAlongY = X.*Y + Y.^2;

            spline = InterpolatingSpline(x, y, F, K=[2 2]);
            intspline = cumsum(spline, 2);

            testCase.assertThat(intspline(X, Y),  IsEqualTo(integralAlongY - integralAlongY(:,1), 'Within', AbsoluteTolerance(1e-10)))
        end

        function tensorSplineExposesDegreeVector(testCase)
            spline2D = InterpolatingSpline(linspace(0,1,5)', linspace(-1,1,6)', randn(5,6), K=[3 4]);

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

        function tensorSplineCoefficientsCanBeReassigned(testCase)
            tKnot = {
                [0; 0; 1; 1]
                [0; 0; 1; 1]
            };
            spline = TensorSpline([2 2], tKnot, 1:4);

            spline.xi = 11:14;

            testCase.verifyEqual(spline.xi, reshape(11:14, [2 2]))
        end

        function tensorSplineRejectsInvalidCoefficientCountAssignment(testCase)
            tKnot = {
                [0; 0; 1; 1]
                [0; 0; 1; 1]
            };
            spline = TensorSpline([2 2], tKnot, 1:4);

            caught = [];
            try
                spline.xi = 1:3;
            catch exception
                caught = exception;
            end

            testCase.verifyNotEmpty(caught)
            testCase.verifyEqual(caught.identifier, 'TensorSpline:InvalidCoefficientCount')
        end

        function tensorSplineOutputAffineTermsAreReadOnly(testCase)
            spline = TensorSpline(2, {[0; 0; 1; 1]}, [1; 2], xMean=3, xStd=4);

            xMeanException = [];
            try
                spline.xMean = 7;
            catch exception
                xMeanException = exception;
            end

            xStdException = [];
            try
                spline.xStd = 8;
            catch exception
                xStdException = exception;
            end

            testCase.verifyNotEmpty(xMeanException)
            testCase.verifyNotEmpty(xStdException)
            testCase.verifyEqual(spline.xMean, 3)
            testCase.verifyEqual(spline.xStd, 4)
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
            [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(spline.tKnot, spline.K);
            [Xsup, Ysup] = ndgrid(supportVectors{:});
            expected = reshape(TensorSpline.matrix(supportPoints, spline.tKnot, spline.K) * spline.xi(:), cellfun(@numel, supportVectors));
            expected = spline.xStd * expected + spline.xMean;

            testCase.assertThat(squaredSpline(Xsup, Ysup),  IsEqualTo(expected.^2, 'Within', AbsoluteTolerance(1e-10)))
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
            [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(spline.tKnot, spline.K);
            [Xsup, Ysup] = ndgrid(supportVectors{:});
            expected = reshape(TensorSpline.matrix(supportPoints, spline.tKnot, spline.K) * spline.xi(:), cellfun(@numel, supportVectors));
            expected = spline.xStd * expected + spline.xMean;

            testCase.assertThat(rootedSpline(Xsup, Ysup),  IsEqualTo(sqrt(expected), 'Within', AbsoluteTolerance(1e-10)))
        end
    end
end
