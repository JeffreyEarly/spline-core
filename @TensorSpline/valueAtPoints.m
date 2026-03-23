function values = valueAtPoints(self, varargin)
% Evaluate the tensor spline or a mixed partial derivative.
%
% Evaluate with one query input per tensor dimension.
%
% ```matlab
% values = spline(xq, yq);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: values = valueAtPoints(self,X1,...,Xn,derivativeOrders)
% - Parameter self: TensorSpline instance
% - Parameter X1,...,Xn: query locations as one array per dimension
% - Parameter derivativeOrders: derivative order per dimension
% - Returns values: spline values reshaped to match the query input
if isempty(varargin)
    error('TensorSpline:NotEnoughInputs', 'Specify one query input per spline dimension.');
end

if numel(varargin) == self.numDimensions
    queryInputs = varargin;
    derivativeOrders = zeros(1, self.numDimensions);
elseif numel(varargin) == self.numDimensions + 1
    queryInputs = varargin(1:end-1);
    derivativeOrders = TensorSpline.normalizeDerivativeOrders(varargin{end}, self.numDimensions);
else
    error('TensorSpline:InvalidEvaluationInput', 'Use spline(X1,...,Xn) or spline(X1,...,Xn,D).');
end

[pointMatrix, outputSize] = TensorSpline.normalizeQueryInputs(queryInputs, self.numDimensions);

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
