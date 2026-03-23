classdef GlobalConstraintUnitTests < matlab.unittest.TestCase

    methods (Test)
        function positiveConstraintHasNoAssociatedDimension(testCase)
            constraint = GlobalConstraint.positive();

            testCase.verifyEqual(constraint.Shape, "positive")
            testCase.verifyEmpty(constraint.Dimension)
        end

        function monotonicIncreasingDefaultsToFirstDimension(testCase)
            constraint = GlobalConstraint.monotonicIncreasing();

            testCase.verifyEqual(constraint.Shape, "monotonicIncreasing")
            testCase.verifyEqual(constraint.Dimension, 1)
        end

        function monotonicDecreasingStoresRequestedDimension(testCase)
            constraint = GlobalConstraint.monotonicDecreasing(Dimension=2);

            testCase.verifyEqual(constraint.Shape, "monotonicDecreasing")
            testCase.verifyEqual(constraint.Dimension, 2)
        end

        function positiveConstraintRejectsUnexpectedDimension(testCase)
            testCase.verifyError(@() GlobalConstraint("positive", Dimension=1), ...
                'GlobalConstraint:UnexpectedDimension')
        end
    end
end
