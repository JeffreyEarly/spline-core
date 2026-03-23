classdef BSplineUnitTests < matlab.unittest.TestCase

    methods (Test)
        function matrixAndPPFormsAgree(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) cos(2*pi*x/3);
            S = 3;
            t = linspace(0,3,13)';
            knotPoints = BSpline.knotPointsForDataPoints(t, S=S);

            X = BSpline.matrix(t, knotPoints, S);
            xi = X\f(t);
            [C,tpp] = BSpline.ppCoefficientsFromSplineCoefficients(xi, knotPoints, S);

            tq = linspace(t(1),t(end),301)';
            valuesFromMatrix = BSpline.matrix(tq, knotPoints, S) * xi;
            valuesFromPP = BSpline.evaluateFromPPCoefficients(tq,C,tpp);

            testCase.assertThat(valuesFromPP, IsEqualTo(valuesFromMatrix, 'Within', AbsoluteTolerance(1e-10)))
        end

        function splineDOFMatchesDocumentedDataDOFMapping(testCase)
            t = linspace(0,3,13)';
            S = 3;
            oldDataDOF = 3;
            splineDOF = max(S + 1, ceil(numel(t)/oldDataDOF));
            expected = legacyKnotPointsForDataPoints(t, S + 1, oldDataDOF);
            actual = BSpline.knotPointsForDataPoints(t, S=S, splineDOF=splineDOF);

            testCase.verifyEqual(actual, expected)
        end

        function ppEvaluationHandlesUnsortedInputs(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance

            f = @(x) sin(2*pi*x/3);
            S = 3;
            t = linspace(0,3,13)';
            knotPoints = BSpline.knotPointsForDataPoints(t, S=S);

            X = BSpline.matrix(t, knotPoints, S);
            xi = X\f(t);
            [C,tpp] = BSpline.ppCoefficientsFromSplineCoefficients(xi, knotPoints, S);

            tqSorted = linspace(t(1),t(end),31)';
            tqUnsorted = tqSorted([7 1 19 4 31 12 2 25 16 9 22 5 29 14 3 18 27 11 6 24 15 8 30 13 10 21 17 20 23 26 28]);

            expected = BSpline.matrix(tqUnsorted, knotPoints, S) * xi;
            actual = BSpline.evaluateFromPPCoefficients(tqUnsorted,C,tpp);

            testCase.assertThat(actual, IsEqualTo(expected, 'Within', AbsoluteTolerance(1e-10)))
        end

        function fevalDelegatesToValueAtPoints(testCase)
            t = linspace(0,1,9)';
            x = sin(2*pi*t);
            knotPoints = BSpline.knotPointsForDataPoints(t, S=3);
            spline = BSpline(S=3, knotPoints=knotPoints, xi=BSpline.matrix(t, knotPoints, 3)\x);
            tq = linspace(0,1,21)';

            testCase.verifyEqual(feval(spline, tq), spline.valueAtPoints(tq))
            testCase.verifyEqual(feval(spline, tq, D=1), spline.valueAtPoints(tq, D=1))
        end

        function clearingCoefficientsClearsCachedState(testCase)
            K = 3;
            S = K - 1;
            t = linspace(0,1,5)';
            knotPoints = [t(1)*ones(K,1); t(2:end-1); t(end)*ones(K,1)];
            spline = BSpline(S=S, knotPoints=knotPoints, xi=ones(length(knotPoints)-K,1));

            spline.xi = [];

            testCase.verifyEmpty(spline.C)
            testCase.verifyEmpty(spline.t_pp)
            testCase.verifyEmpty(spline.Xtpp)
        end

        function settingCoefficientsRebuildsCachedState(testCase)
            K = 3;
            S = K - 1;
            t = linspace(0,1,5)';
            knotPoints = [t(1)*ones(K,1); t(2:end-1); t(end)*ones(K,1)];
            spline = BSpline(S=S, knotPoints=knotPoints, xi=[]);

            spline.xi = ones(length(knotPoints)-K,1);

            testCase.verifyNotEmpty(spline.C)
            testCase.verifyNotEmpty(spline.t_pp)
            testCase.verifyNotEmpty(spline.Xtpp)
        end

        function knotSequenceIsReadOnly(testCase)
            K = 3;
            S = K - 1;
            t = linspace(0,1,5)';
            knotPoints = [t(1)*ones(K,1); t(2:end-1); t(end)*ones(K,1)];
            spline = BSpline(S=S, knotPoints=knotPoints, xi=ones(length(knotPoints)-K,1));

            caught = [];
            try
                spline.knotPoints = [0; 0; 0; 0.5; 1; 1; 1];
            catch exception
                caught = exception;
            end

            testCase.verifyNotEmpty(caught)
            testCase.verifyEqual(spline.knotPoints, knotPoints)
            testCase.verifyEqual(spline.xi, ones(length(knotPoints)-K,1))
        end

        function orderIsReadOnly(testCase)
            spline = BSpline(S=2, knotPoints=[0; 0; 0; 1; 1; 1], xi=[1; 2; 3]);

            caught = [];
            try
                spline.K = 4;
            catch exception
                caught = exception;
            end

            testCase.verifyNotEmpty(caught)
            testCase.verifyEqual(spline.S, 2)
            testCase.verifyEqual(spline.K, 3)
        end

        function outputAffineTermsAreReadOnly(testCase)
            spline = BSpline(S=2, knotPoints=[0; 0; 0; 1; 1; 1], xi=[1; 2; 3], xMean=4, xStd=5);

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
            testCase.verifyEqual(spline.xMean, 4)
            testCase.verifyEqual(spline.xStd, 5)
        end
    end

end

function tKnot = legacyKnotPointsForDataPoints(t, K, dataDOF)
tData = sort(t);
tData = [tData(1); tData(1+dataDOF:dataDOF:end-dataDOF); tData(end)];
mustBeGreaterThanOrEqual(numel(tData), K);

tPseudo = interp1((0:numel(tData)-1)', tData, linspace(0, numel(tData)-1, numel(tData)).');
if mod(K, 2) == 1
    dt = diff(tPseudo);
    tKnot = [tPseudo(1); tPseudo(1:end-1) + dt/2; tPseudo(end)];
    for i = 1:((K-1)/2)
        tKnot(2) = [];
        tKnot(end-1) = [];
    end
else
    tKnot = tPseudo;
    for i = 1:((K-2)/2)
        tKnot(2) = [];
        tKnot(end-1) = [];
    end
end

tKnot = [repmat(tKnot(1), K-1, 1); tKnot; repmat(tKnot(end), K-1, 1)];
end
