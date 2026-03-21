classdef PointConstraintUnitTests < matlab.unittest.TestCase

    methods (Test)
        function equalityConstraintNormalizesOneDimensionalInputs(testCase)
            constraint = PointConstraint.equal((0:2)', D=2, Value=0);

            testCase.verifyEqual(constraint.Points, (0:2)')
            testCase.verifyEqual(constraint.D, 2*ones(3,1))
            testCase.verifyEqual(constraint.Value, zeros(3,1))
            testCase.verifyEqual(constraint.Relation, "==")
            testCase.verifyEqual(constraint.numDimensions, 1)
            testCase.verifyEqual(constraint.numConstraints, 3)
        end

        function equalityConstraintReplicatesDerivativeVectorAcrossPoints(testCase)
            points = [0 0; 1 1; 2 2];
            constraint = PointConstraint.equal(points, D=[1 0], Value=5);

            testCase.verifyEqual(constraint.D, repmat([1 0], 3, 1))
            testCase.verifyEqual(constraint.Value, 5*ones(3,1))
        end

        function lowerBoundConstraintAcceptsPerPointTargets(testCase)
            points = [0 0; 1 1; 2 2];
            values = [0; 1; 2];
            constraint = PointConstraint.lowerBound(points, D=zeros(3,2), Value=values);

            testCase.verifyEqual(constraint.Relation, ">=")
            testCase.verifyEqual(constraint.Value, values)
            testCase.verifyEqual(constraint.D, zeros(3,2))
        end

        function upperBoundConstraintStoresRelation(testCase)
            constraint = PointConstraint.upperBound((0:2)', D=0, Value=1);

            testCase.verifyEqual(constraint.Relation, "<=")
            testCase.verifyEqual(constraint.Value, ones(3,1))
        end

        function multidimensionalScalarDerivativeOrderIsRejected(testCase)
            points = [0 0; 1 1];

            testCase.verifyError(@() PointConstraint.equal(points, D=1, Value=0), ...
                'PointConstraint:AmbiguousDerivativeOrders')
        end
    end
end
