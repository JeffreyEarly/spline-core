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

        function equalityConstraintCanBeBuiltFromOneDimensionalMask(testCase)
            t = (0:4)';
            mask = [true; false; true; false; true];

            constraint = PointConstraint.equalOnMask(t, mask, D=1, Value=0);

            testCase.verifyEqual(constraint.Points, t(mask))
            testCase.verifyEqual(constraint.D, ones(nnz(mask),1))
            testCase.verifyEqual(constraint.Value, zeros(nnz(mask),1))
            testCase.verifyEqual(constraint.Relation, "==")
        end

        function equalityConstraintCanBeBuiltFromGridVectorMask(testCase)
            x = [0; 1];
            y = [10; 20; 30];
            [X,Y] = ndgrid(x,y);
            mask = [true false true; false true false];

            constraint = PointConstraint.equalOnMask({x,y}, mask, D=[0 1], Value=0);

            testCase.verifyEqual(constraint.Points, [X(mask), Y(mask)])
            testCase.verifyEqual(constraint.D, repmat([0 1], nnz(mask), 1))
        end

        function lowerBoundConstraintCanBeBuiltFromGridArrayMask(testCase)
            x = [0; 1];
            y = [10; 20; 30];
            [X,Y] = ndgrid(x,y);
            mask = [false true false; true false true];

            constraint = PointConstraint.lowerBoundOnMask({X,Y}, mask, D=[1 0], Value=5);

            testCase.verifyEqual(constraint.Points, [X(mask), Y(mask)])
            testCase.verifyEqual(constraint.D, repmat([1 0], nnz(mask), 1))
            testCase.verifyEqual(constraint.Value, 5*ones(nnz(mask),1))
            testCase.verifyEqual(constraint.Relation, ">=")
        end

        function maskSizeMustMatchGrid(testCase)
            x = [0; 1];
            y = [10; 20; 30];
            mask = true(3,3);

            testCase.verifyError(@() PointConstraint.equalOnMask({x,y}, mask, D=[0 0], Value=0), ...
                'PointConstraint:InvalidMaskSize')
        end

        function pointAndGlobalConstraintsCanFormMixedArray(testCase)
            constraints = [
                PointConstraint.equal((0:2)', D=1, Value=0)
                GlobalConstraint.positive()
            ];

            testCase.verifyClass(constraints, 'SplineConstraint')
            testCase.verifyEqual(numel(constraints), 2)
            testCase.verifyTrue(isa(constraints(1), 'PointConstraint'))
            testCase.verifyTrue(isa(constraints(2), 'GlobalConstraint'))
        end
    end
end
