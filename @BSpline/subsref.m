function varargout = subsref(self, index)
% Evaluate the spline with function-call syntax or defer to built-in indexing.
%
% Parentheses indexing `spline(t)` is redirected to
% `valueAtPoints`, while dot indexing behaves like the default
% MATLAB handle-class implementation.
%
% Use `spline(t)` for values and `spline(t,n)` for derivatives.
%
% ```matlab
% x = spline(tQuery);
% dxdt = spline(tQuery, 1);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: varargout = subsref(self,index)
% - Parameter self: BSpline instance
% - Parameter index: MATLAB subscript structure
% - Returns varargout: indexed property access or spline values
idx = index(1).subs;
switch index(1).type
    case '()'
        if length(idx) >= 1
            t = idx{1};
        end

        if length(idx) >= 2
            NumDerivatives = idx{2};
        else
            NumDerivatives = 0;
        end

        varargout{1} = self.valueAtPoints(t, NumDerivatives);
    case '.'
        [varargout{1:nargout}] = builtin('subsref',self,index);
    case '{}'
        error('The BSpline class does not know what to do with {}.');
    otherwise
        error('Unexpected syntax');
end
