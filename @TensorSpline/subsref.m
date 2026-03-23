function varargout = subsref(self, index)
% Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
%
% Use `spline(X1,...,Xn)` for values and
% `spline(X1,...,Xn,D)` for mixed partial derivatives.
%
% ```matlab
% values = spline(xq, yq);
% dFdx = spline(xq, yq, [1 0]);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: varargout = subsref(self,index)
% - Parameter self: TensorSpline instance
% - Parameter index: MATLAB subscript structure
% - Returns varargout: indexed property access or spline values
idx = index(1).subs;
switch index(1).type
    case '()'
        varargout{1} = self.valueAtPoints(idx{:});
    case '.'
        [varargout{1:nargout}] = builtin('subsref',self,index);
    case '{}'
        error('The TensorSpline class does not know what to do with {}.');
    otherwise
        error('Unexpected syntax');
end
