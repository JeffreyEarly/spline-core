classdef ConstrainedTensorSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function constrainedTensorSplineFitsPlanarField(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = [0; 1];
            y = [0; 2];
            [X,Y] = ndgrid(x,y);
            F = 2*X + 3*Y + 1;

            K = [2 2];
            tKnot = {
                [x(1); x(1); x(end); x(end)]
                [y(1); y(1); y(end); y(end)]
            };

            spline = ConstrainedTensorSpline({X,Y}, F, K=K, tKnot=tKnot, distribution=NormalDistribution(1));

            testCase.assertThat(spline(X, Y), IsEqualTo(F, 'Within', AbsoluteTolerance(10*eps)))
        end

        function constrainedTensorSplineSupportsRobustDistribution(testCase)
            x = linspace(-1,1,5)';
            y = linspace(0,2,6)';
            [X,Y] = ndgrid(x,y);
            F = sin(pi*X) + cos(0.5*pi*Y);

            K = [4 4];
            tKnot = {
                BSpline.knotPointsForDataPoints(x, K=K(1))
                BSpline.knotPointsForDataPoints(y, K=K(2))
            };

            spline = ConstrainedTensorSpline({X,Y}, F, K=K, tKnot=tKnot, distribution=StudentTDistribution(sigma=1,nu=3));

            testCase.verifySize(spline(X, Y), size(F))
        end

        function smoothingMatrixHasExpectedSize(testCase)
            x = [0; 1];
            y = [0; 2];
            [X,Y] = ndgrid(x,y);
            F = 2*X + 3*Y + 1;

            K = [2 2];
            tKnot = {
                [x(1); x(1); x(end); x(end)]
                [y(1); y(1); y(end); y(end)]
            };

            spline = ConstrainedTensorSpline([X(:), Y(:)], F(:), K=K, tKnot=tKnot, distribution=NormalDistribution(1));

            testCase.verifySize(spline.smoothingMatrix(), [numel(F) numel(F)])
        end

        function constrainedTensorSplineProvidesModernDefaults(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = [0; 1];
            y = [0; 2];
            [X,Y] = ndgrid(x,y);
            F = 2*X + 3*Y + 1;

            spline = ConstrainedTensorSpline({X,Y}, F);

            testCase.verifyEqual(spline.K, [4 4])
            testCase.verifyClass(spline.distribution, 'NormalDistribution')
            testCase.verifyEqual(cellfun(@numel, spline.tKnot), [8 8])
            testCase.assertThat(spline(X, Y), IsEqualTo(F, 'Within', AbsoluteTolerance(10*eps)))
        end

        function oneDimensionalAutomaticKnotsMatchPolyfit(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(-2,2,11)';
            x = 1 - 0.5*t + 0.25*t.^2 - 0.1*t.^3 + 0.05*sin(2*t);
            tq = linspace(min(t), max(t), 41)';

            spline = ConstrainedTensorSpline(t, x);

            p = polyfit(t, x, 3);
            xFit = polyval(p, tq);

            testCase.assertThat(spline(tq), IsEqualTo(xFit, 'Within', AbsoluteTolerance(1e-10)))
        end

        function twoDimensionalAutomaticKnotsMatchPolynomialSurface(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = linspace(-1,1,6)';
            y = linspace(-2,2,7)';
            [X,Y] = ndgrid(x,y);
            F = 1 + 2*X - Y + 0.5*X.^2.*Y - 0.25*X.*Y.^3;

            xq = linspace(min(x), max(x), 19)';
            yq = linspace(min(y), max(y), 21)';
            [Xq,Yq] = ndgrid(xq,yq);
            Fq = 1 + 2*Xq - Yq + 0.5*Xq.^2.*Yq - 0.25*Xq.*Yq.^3;

            spline = ConstrainedTensorSpline({X,Y}, F);

            testCase.assertThat(spline(Xq, Yq), IsEqualTo(Fq, 'Within', AbsoluteTolerance(1e-10)))
        end
    end
end
