classdef ConstrainedSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function constrainedSplineFitsPlanarField(testCase)
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

            spline = ConstrainedSpline({X,Y}, F, K=K, tKnot=tKnot, distribution=NormalDistribution(1));

            testCase.assertThat(spline(X, Y), IsEqualTo(F, 'Within', AbsoluteTolerance(10*eps)))
        end

        function constrainedSplineSupportsRobustDistribution(testCase)
            x = linspace(-1,1,5)';
            y = linspace(0,2,6)';
            [X,Y] = ndgrid(x,y);
            F = sin(pi*X) + cos(0.5*pi*Y);

            K = [4 4];
            tKnot = {
                BSpline.knotPointsForDataPoints(x, K=K(1))
                BSpline.knotPointsForDataPoints(y, K=K(2))
            };

            spline = ConstrainedSpline({X,Y}, F, K=K, tKnot=tKnot, distribution=StudentTDistribution(sigma=1,nu=3));

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

            spline = ConstrainedSpline([X(:), Y(:)], F(:), K=K, tKnot=tKnot, distribution=NormalDistribution(1));

            testCase.verifySize(spline.smoothingMatrix(), [numel(F) numel(F)])
        end

        function constrainedSplineProvidesModernDefaults(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            x = [0; 1];
            y = [0; 2];
            [X,Y] = ndgrid(x,y);
            F = 2*X + 3*Y + 1;

            spline = ConstrainedSpline({X,Y}, F);

            testCase.verifyEqual(spline.K, [4 4])
            testCase.verifyClass(spline.distribution, 'NormalDistribution')
            testCase.verifyEqual(cellfun(@numel, spline.tKnot), [8 8])
            testCase.assertThat(spline(X, Y), IsEqualTo(F, 'Within', AbsoluteTolerance(10*eps)))
        end

        function oneDimensionalMinimalKnotFitMatchesPolyfit(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(-2,2,11)';
            x = 1 - 0.5*t + 0.25*t.^2 - 0.1*t.^3 + 0.05*sin(2*t);
            tq = linspace(min(t), max(t), 41)';
            tKnot = [repmat(t(1), 4, 1); repmat(t(end), 4, 1)];

            spline = ConstrainedSpline(t, x, K=4, tKnot=tKnot);

            p = polyfit(t, x, 3);
            xFit = polyval(p, tq);

            testCase.assertThat(spline(tq), IsEqualTo(xFit, 'Within', AbsoluteTolerance(1e-10)))
        end

        function oneDimensionalAutomaticKnotsUseBSplineHelperWhenPossible(testCase)
            t = linspace(-2,2,11)';
            x = sin(t);

            spline = ConstrainedSpline(t, x, K=4);
            expectedTKnot = BSpline.knotPointsForDataPoints(t, K=4);

            testCase.verifyEqual(spline.tKnot, expectedTKnot)
        end

        function oneDimensionalConstructorAcceptsNumericTKnot(testCase)
            t = linspace(-1,1,13)';
            x = exp(t);
            tKnot = BSpline.knotPointsForDataPoints(t, K=4, dataDOF=2);

            spline = ConstrainedSpline(t, x, K=4, tKnot=tKnot);

            testCase.verifyEqual(spline.tKnot, tKnot)
        end

        function dataDOFControlsAutomaticKnotSelection(testCase)
            t = linspace(-2,2,21)';
            x = sin(2*t);

            spline = ConstrainedSpline(t, x, K=4, dataDOF=3);
            expectedTKnot = BSpline.knotPointsForDataPoints(t, K=4, dataDOF=3);

            testCase.verifyEqual(spline.tKnot, expectedTKnot)
        end

        function splineDOFControlsAutomaticKnotSelection(testCase)
            t = linspace(-2,2,21)';
            x = cos(2*t);

            spline = ConstrainedSpline(t, x, K=4, splineDOF=6);
            expectedTKnot = BSpline.knotPointsForDataPoints(t, K=4, splineDOF=6);

            testCase.verifyEqual(spline.tKnot, expectedTKnot)
        end

        function terminatedKnotPointsTerminatesNumericInput(testCase)
            tKnot = [0; 0; 0.4; 1; 1];
            terminated = ConstrainedSpline.terminatedKnotPoints(tKnot, 4);

            testCase.verifyEqual(terminated, [0; 0; 0; 0; 0.4; 1; 1; 1; 1])
        end

        function minimumConstraintPointsMatchesExpectedOneDimensionalLocations(testCase)
            tKnot = [0; 0; 0; 0; 1; 2; 3; 3; 3; 3];
            tc = ConstrainedSpline.minimumConstraintPoints(tKnot, 4, 0);

            testCase.verifyEqual(tc, [0; 0.5; 1; 2; 3; 2.5])
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

            spline = ConstrainedSpline({X,Y}, F);

            testCase.assertThat(spline(Xq, Yq), IsEqualTo(Fq, 'Within', AbsoluteTolerance(1e-10)))
        end

        function pointConstraintsEnforceDerivativeInOneDimension(testCase)
            t = linspace(-1,1,9)';
            x = t;

            spline = ConstrainedSpline(t, x, ...
                distribution=NormalDistribution(1), ...
                constraints=PointConstraint.equal(0, D=1, Value=0));

            testCase.verifyLessThan(abs(spline(0, 1)), 1e-10)
        end

        function mixedConstraintArrayIsAccepted(testCase)
            t = linspace(-1,1,21)';
            x = t.^2 - 0.2;
            constraints = [
                PointConstraint.equal(0, D=1, Value=0)
                GlobalConstraint.positive()
            ];

            spline = ConstrainedSpline(t, x, constraints=constraints);

            testCase.verifyLessThan(abs(spline(0,1)), 1e-10)
            testCase.verifyGreaterThanOrEqual(min(spline(linspace(-1,1,101)')), -1e-10)
        end

        function pointConstraintsEnforceValuesAtManyTensorPoints(testCase)
            x = linspace(-1,1,6)';
            y = linspace(-1,1,7)';
            [X,Y] = ndgrid(x,y);
            F = sin(pi*X) + 0.5*cos(pi*Y) + X.*Y;

            tKnot = {
                BSpline.knotPointsForDataPoints(x, K=4)
                BSpline.knotPointsForDataPoints(y, K=4)
            };

            mask = abs(X) <= 0.25 & abs(Y) <= 0.35;
            points = [X(mask), Y(mask)];
            constraint = PointConstraint.equal(points, D=[0 0], Value=0);

            spline = ConstrainedSpline({X,Y}, F, ...
                K=[4 4], ...
                tKnot=tKnot, ...
                distribution=NormalDistribution(1), ...
                constraints=constraint);

            testCase.verifyLessThan(max(abs(spline(points(:,1), points(:,2)))), 1e-10)
        end

        function maskPointConstraintsCanFlattenARegion(testCase)
            x = linspace(-1,1,9)';
            y = linspace(-1,1,11)';
            [X,Y] = ndgrid(x,y);
            F = exp(-2*(X.^2 + Y.^2));
            mask = (X.^2 + Y.^2) <= 0.2^2;

            spline = ConstrainedSpline({X,Y}, F, ...
                distribution=NormalDistribution(1), ...
                constraints=PointConstraint.equalOnMask({x,y}, mask, D=[0 0], Value=0));

            maskedPoints = [X(mask), Y(mask)];
            testCase.verifyLessThan(max(abs(spline(maskedPoints(:,1), maskedPoints(:,2)))), 1e-8)
        end

        function positiveGlobalConstraintKeepsFitNonnegative(testCase)
            t = linspace(-1,1,21)';
            x = t.^2 - 0.35;
            tq = linspace(min(t), max(t), 101)';

            spline = ConstrainedSpline(t, x, ...
                distribution=NormalDistribution(1), ...
                constraints=GlobalConstraint.positive());

            testCase.verifyGreaterThanOrEqual(min(spline(tq)), -1e-10)
        end

        function monotonicGlobalConstraintActsAlongSelectedDimension(testCase)
            x = linspace(-1,1,6)';
            y = linspace(0,1,7)';
            [X,Y] = ndgrid(x,y);
            F = cos(pi*Y) + 0.1*X;

            tKnot = {
                BSpline.knotPointsForDataPoints(x, K=4)
                BSpline.knotPointsForDataPoints(y, K=4)
            };

            spline = ConstrainedSpline({X,Y}, F, ...
                K=[4 4], ...
                tKnot=tKnot, ...
                distribution=NormalDistribution(1), ...
                constraints=GlobalConstraint.monotonicIncreasing(Dimension=2));

            xq = linspace(min(x), max(x), 13)';
            yq = linspace(min(y), max(y), 19)';
            [Xq,Yq] = ndgrid(xq,yq);
            Fq = spline(Xq, Yq);

            testCase.verifyGreaterThanOrEqual(min(diff(Fq, 1, 2), [], 'all'), -1e-10)
        end

        function monotonicGlobalConstraintWorksInOneDimension(testCase)
            t = linspace(0,1,31)';
            x = 0.2 + 0.8*(1 - exp(-4*t)) + 0.03*sin(8*pi*t);
            tq = linspace(min(t), max(t), 151)';

            spline = ConstrainedSpline(t, x, ...
                distribution=NormalDistribution(1), ...
                constraints=GlobalConstraint.monotonicIncreasing());

            testCase.verifyGreaterThanOrEqual(min(diff(spline(tq))), -1e-10)
        end

        function smoothingMatrixRejectsConstrainedFits(testCase)
            t = linspace(-1,1,9)';
            x = t.^2 - 0.2;

            spline = ConstrainedSpline(t, x, ...
                distribution=NormalDistribution(1), ...
                constraints=GlobalConstraint.positive());

            testCase.verifyError(@() spline.smoothingMatrix(), ...
                'ConstrainedSpline:UnavailableSmoothingMatrix')
        end
    end
end
