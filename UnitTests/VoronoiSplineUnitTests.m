classdef VoronoiSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function oneDimensionalVoronoiSplineMatchesBSpline(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            t = linspace(0, 3, 13)';
            K = 4;
            sites = VoronoiSpline.sitesForDataPoints(t, K=K);
            xi = sin(1.7 * sites);

            voronoiSpline = VoronoiSpline(K, sites, xi);
            bspline = BSpline(K, voronoiSpline.support.tKnot, xi);

            tq = linspace(t(1), t(end), 101)';
            testCase.assertThat(voronoiSpline(tq), ...
                IsEqualTo(bspline(tq), 'Within', AbsoluteTolerance(1e-10)))
            testCase.assertThat(voronoiSpline(tq, 1), ...
                IsEqualTo(bspline(tq, 1), 'Within', AbsoluteTolerance(1e-10)))
        end

        function oneDimensionalDiffMatchesBSplineDerivative(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            sites = linspace(0, 2, 9)';
            K = 4;
            xi = cos(0.8 * sites);

            voronoiSpline = VoronoiSpline(K, sites, xi);
            bspline = BSpline(K, voronoiSpline.support.tKnot, xi);

            dVoronoi = diff(voronoiSpline);
            dBSpline = diff(bspline);
            tq = linspace(0, 2, 121)';

            testCase.assertThat(dVoronoi(tq), ...
                IsEqualTo(dBSpline(tq), 'Within', AbsoluteTolerance(1e-10)))
        end

        function hexLatticeOrderOneInterpolatesAtSupportSites(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            lattice = VoronoiSpline.hexLattice([-1.5 1.5; -1.5 1.5], spacing=0.6, padding=1);
            B = VoronoiSpline.matrix(lattice.sites, lattice, 1);

            testCase.assertThat(B, IsEqualTo(eye(size(B)), 'Within', AbsoluteTolerance(1e-12)))
        end

        function twoDimensionalVoronoiSplineMatchesMatrixEvaluation(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            lattice = VoronoiSpline.hexLattice([-1 1; -1 1], spacing=0.65, padding=2);
            xi = sin(1.3 * lattice.sites(:,1)) + cos(0.7 * lattice.sites(:,2));
            spline = VoronoiSpline(2, lattice, xi, xMean=3, xStd=2);

            queryPoints = [-0.4 -0.2; -0.1 0.3; 0.0 0.0; 0.2 -0.1; 0.35 0.4];
            B = VoronoiSpline.matrix(queryPoints, lattice, 2);
            expected = 2 * (B * xi) + 3;
            actual = spline(queryPoints(:,1), queryPoints(:,2));

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(1e-10)))
        end

        function twoDimensionalVoronoiSplineRejectsDerivatives(testCase)
            lattice = VoronoiSpline.hexLattice([-1 1; -1 1], spacing=0.75, padding=1);
            spline = VoronoiSpline(2, lattice, randn(size(lattice.sites,1), 1));
            [X, Y] = ndgrid(linspace(-0.3, 0.3, 3), linspace(-0.3, 0.3, 3));

            testCase.verifyError(@() spline(X, Y, [1 0]), 'VoronoiSpline:UnsupportedDerivative')
        end
    end
end
