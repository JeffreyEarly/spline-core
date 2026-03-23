function values = evaluatePoints(self, points, options)
% Evaluate the tensor spline at explicit point locations.
%
% Use this for scattered query points represented as one point
% per row.
%
% ```matlab
% values = spline.evaluatePoints([xq(:), yq(:)]);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: values = evaluatePoints(self,points,options)
% - Parameter self: TensorSpline instance
% - Parameter points: query points as a vector in 1-D or an N-by-D matrix in higher dimensions
% - Parameter options.D: derivative order per dimension
% - Returns values: one value per query point, preserving input shape in 1-D
arguments
    self (1,1) TensorSpline
    points {mustBeNumeric,mustBeReal}
    options.D = 0
end

[pointMatrix, outputSize] = TensorSpline.normalizePointMatrixInput(points, self.numDimensions);
derivativeOrders = TensorSpline.normalizeDerivativeOrders(options.D, self.numDimensions);

if any(derivativeOrders > self.K - 1)
    values = zeros(outputSize, 'like', pointMatrix);
    return;
end

basisMatrix = TensorSpline.matrix(pointMatrix, self.tKnot_, self.K, D=derivativeOrders);
values = basisMatrix * self.xi(:);

if ~isempty(self.xStd)
    values = self.xStd * values;
end

if ~isempty(self.xMean) && all(derivativeOrders == 0)
    values = values + self.xMean;
end

values = reshape(values, outputSize);
