classdef ConstrainedSpline < BSpline
    % Constrained spline fit through data values.
    %
    % Local constraints are specified with a struct containing fields
    % `t` and `D`, so that f^(D)(t) = 0 at the supplied locations.
    %
    % ConstrainedSpline supports both Gaussian least-squares fitting and
    % iteratively reweighted fitting for other distributions, together with
    % local derivative constraints and optional global shape constraints.
    %
    % - Topic: Initialization
    % - Topic: Operations
    % - Topic: Utility
    % - Topic: Methodology (Static methods)
    % - Declaration: classdef ConstrainedSpline < BSpline

    properties (Access = public)
        % Error model used while fitting the constrained spline.
        %
        % - Topic: Primary attributes
        distribution
        % Observation locations used to fit the spline.
        %
        % - Topic: Primary attributes
        t
        % Observation values used to fit the spline.
        %
        % - Topic: Primary attributes
        x
        
        % Inverse coefficient covariance or normal-equation system matrix.
        %
        % - Topic: Primary attributes
        % - Developer: true
        CmInv
        % Design matrix for the observation locations.
        %
        % - Topic: Primary attributes
        % - Developer: true
        X
        % Weight matrix or weights used by the fit.
        %
        % - Topic: Primary attributes
        % - Developer: true
        W
    end
    
    methods
        function self = ConstrainedSpline(t,x,K,tKnot,distribution,constraints)
            % Create a constrained spline through samples x observed at t.
            %
            % - Topic: Initialization
            % - Declaration: self = ConstrainedSpline(t,x,K,tKnot,distribution,constraints)
            % - Parameter t: sample locations
            % - Parameter x: sample values
            % - Parameter K: spline order
            % - Parameter tKnot: knot sequence
            % - Parameter distribution: error model object for the fit
            % - Parameter constraints: struct describing local or global constraints
            % - Returns self: ConstrainedSpline instance
            arguments
                t {mustBeNumeric,mustBeReal,mustBeFinite}
                x {mustBeNumeric,mustBeReal,mustBeFinite}
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                tKnot (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
                distribution = []
                constraints = []
            end

            t = reshape(t,[],1);
            x = reshape(x,[],1);

            if numel(x) ~= numel(t)
                error('ConstrainedSpline:SizeMismatch', 'x and t must have the same length.');
            end

            if isempty(distribution)
                distribution = NormalDistribution(1);
            end
            constraints = ConstrainedSpline.normalizeConstraints(constraints);

            % terminate the splines at the boundaries
            tKnot = ConstrainedSpline.terminatedKnotPoints(tKnot, K);

            if isa(distribution,'NormalDistribution')
                [coefficients,CmInv,cachedVars] = ConstrainedSpline.ConstrainedSolution(t,x,K,tKnot,distribution,[],constraints,[]);
            else
                [coefficients,CmInv,cachedVars] = ConstrainedSpline.IteratedLeastSquaresTensionSolution(t,x,tKnot,K,distribution,constraints,[]);
            end

            self@BSpline(K,tKnot,coefficients);
            self.distribution = distribution;
            self.t = t;
            self.x = x;
            self.CmInv = CmInv;
            self.X = cachedVars.X;
            self.W = cachedVars.W;
        end

        function S = smoothingMatrix(self)
            % Return the smoothing matrix that maps observations to fitted values.
            %
            % - Topic: Operations
            % - Declaration: S = smoothingMatrix(self)
            % - Parameter self: ConstrainedSpline instance
            % - Returns S: smoothing matrix
            if size(self.W,1) == length(self.t) && size(self.W,2) == 1
                S = (self.X*(self.CmInv\(self.X.'))).*(self.W.');
            else
                S = (self.X*(self.CmInv\(self.X.')))*self.W;
            end
        end
    end
    
    
    methods (Static)
        function tc = MinimumConstraintPoints(tKnot,K,T)
            % Return a minimal set of locations for universal derivative constraints.
            %
            % For a terminated spline of order K, this chooses the smallest
            % set of points needed to constrain all segments at polynomial
            % degree T.
            %
            % - Topic: Methodology (Static methods)
            % - Declaration: tc = MinimumConstraintPoints(tKnot,K,T)
            % - Parameter tKnot: knot sequence
            % - Parameter K: spline order
            % - Parameter T: constrained polynomial degree
            % - Returns tc: constraint locations

            t = unique(tKnot);
            D = K-1-T; % 0 if we're constraining at the same order
            if mod(D,2) == 0
                ts = t(1) + (t(2)-t(1))/(D/2 + 2)*(1:(D/2+1)).';
                te = t(end-1) + (t(end)-t(end-1))/(D/2 + 2)*(1:(D/2+1)).';
                ti = t(2:end-2) + diff(t(2:end-1))/2;
                tc = cat(1,ts,ti,te);
            else
                ts = t(1) + (t(2)-t(1))/((D-1)/2+1)*(0:((D-1)/2)).';
                te = t(end) - (t(end)-t(end-1))/((D-1)/2 + 1)*(0:((D-1)/2)).';
                ti = t(2:end-1);
                tc = cat(1,ts,ti,te);
            end
        end

        function cachedVars = PrecomputeSolutionMatrices(t,x,K,tKnot,distribution,W,constraints,cachedVars)
            % Precompute reusable matrices for constrained spline fitting.
            %
            % - Topic: Methodology (Static methods)
            % - Developer: true
            % - Declaration: cachedVars = PrecomputeSolutionMatrices(t,x,K,tKnot,distribution,W,constraints,cachedVars)
            % - Parameter t: sample locations
            % - Parameter x: sample values
            % - Parameter K: spline order
            % - Parameter tKnot: knot sequence
            % - Parameter distribution: error model object
            % - Parameter W: optional weights or weight matrix
            % - Parameter constraints: local/global constraint specification
            % - Parameter cachedVars: optional previously cached matrices
            % - Returns cachedVars: struct of precomputed matrices
            arguments
                t (:,1) double
                x (:,1) double
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                tKnot (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
                distribution
                W = []
                constraints = []
                cachedVars = []
            end
            constraints = ConstrainedSpline.normalizeConstraints(constraints);
            cachedVars = ConstrainedSpline.normalizeCachedVars(cachedVars);

            if isempty(fieldnames(cachedVars))
                cachedVars = struct('t',t,'x',x,'tKnot',tKnot,'K',K,'distribution',distribution);
            end

            if ~isfield(cachedVars,'X') || isempty(cachedVars.X)
                % These are the splines at the points of observation
                cachedVars.X = BSpline.matrix(t, tKnot, K); % NxM
            end

            if ~isfield(cachedVars,'XT') || isempty(cachedVars.XT)
                cachedVars.XT = cachedVars.X';
            end

            if ~isfield(cachedVars,'F') || isempty(cachedVars.F)
                % Deal with *local* constraints
                if ~isfield(constraints,'t') || ~isfield(constraints,'D')
                    F=[];
                else
                    M = size(cachedVars.X,2); % number of splines
                    NC = length(constraints.t); % number of constraints
                    if length(constraints.D) ~= NC
                        error('t and D must have the same length in the constraints structure.');
                    end
                    F = zeros(NC,M);
                    Xc = BSpline.matrix(constraints.t, tKnot, K, D=K-1);
                    for i=1:NC
                        F(i,:) = squeeze(Xc(i,:,constraints.D(i)+1));
                    end
                end
                cachedVars.F = F;
            end

            if ~isempty(distribution.rho) && (~isfield(cachedVars,'rho_t') || isempty(cachedVars.rho_t))
                cachedVars.rho_t = distribution.rho(t - t.');
            end

            if ~isfield(cachedVars,'W') || isempty(cachedVars.W)
                % The (W)eight matrix.
                %
                % For a normal distribution the weight matrix is the
                % covariance matrix.
                %
                % For anything other than a normal distribution, it is
                % *not* the covariance matrix. During IRLS this matrix will
                % be changing as points are reweighted.
                if isempty(W)
                    if isempty(distribution.rho)
                        W = 1/(distribution.sigma0)^2;
                    else
                        rho_t = cachedVars.rho_t;
                        sigma = ones(size(x))*distribution.sigma0;
                        Sigma2 = (sigma * sigma.') .* rho_t;
                        W = inv(Sigma2);
                    end
                end
                cachedVars.W = W;
            end

            X = cachedVars.X;
            XT = cachedVars.XT;
            N = length(x);
            if ~isfield(cachedVars,'XWX') || isempty(cachedVars.XWX)
                if size(W,1) == N && size(W,2) == N
                    XWX = XT*W*X;
                elseif length(W) == 1
                    if ~isfield(cachedVars,'XX') || isempty(cachedVars.XX)
                        cachedVars.XX = XT*X;
                    end
                    XWX = cachedVars.XX*W;
                elseif length(W) == N
                    XWX = XT*(W.*X); % (MxN * NxN * Nx1) = Mx1
                else
                    error('W must have the same length as x and t.');
                end
                cachedVars.XWX = XWX;
            end
            
            if ~isfield(cachedVars,'XWx') || isempty(cachedVars.XWx)
                if size(W,1) == N && size(W,2) == N
                    XWx = XT*W*x;
                elseif length(W) == 1
                    XWx = XT*W*x;
                elseif length(W) == N
                    XWx = XT*(W.*x); % (MxN * NxN * Nx1) = Mx1
                else
                    error('W must have the same length as x and t.');
                end
                cachedVars.XWx = XWx;
            end

            if ~isfield(cachedVars,'SC') || isempty(cachedVars.SC)
                % Deal with *global* constraints (S)hape (C)onstraints
                if ~isfield(constraints,'global')
                    SC = [];
                else
                    M = size(cachedVars.X,2); % number of splines
                    switch constraints.global
                        case ShapeConstraint.none
                            SC = [];
                        case ShapeConstraint.positive
                            SC =eye(M);
                        case ShapeConstraint.monotonicIncreasing
                            SC = tril(ones(M)); % positive lower triangle
                        case ShapeConstraint.monotonicDecreasing
                            SC = -tril(ones(M)); % negative lower triangle
                            SC(:,1)=1; % except the first point
                        otherwise
                            error('Invalid global constraint.');
                    end
                end
                cachedVars.SC = SC;
            end
            S = cachedVars.SC;

            if ~isempty(S)
                if ~isfield(cachedVars,'XS') || isempty(cachedVars.XS)
                    cachedVars.XS = cachedVars.X*S;
                end
                if ~isfield(cachedVars,'XST') || isempty(cachedVars.XST)
                    cachedVars.XST = cachedVars.XS';
                end
                XS = cachedVars.XS;
                XST = cachedVars.XST;
                
                if ~isfield(cachedVars,'FS') || isempty(cachedVars.FS)
                    if ~isempty(cachedVars.F)
                        cachedVars.FS = cachedVars.F*S; % NxM
                    else
                        cachedVars.FS = [];
                    end
                end
                
                if ~isfield(cachedVars,'SXWXS') || isempty(cachedVars.SXWXS)
                    if size(W,1) == N && size(W,2) == N
                        SXWXS = XST*W*XS;
                    elseif length(W) == 1
                        SXWXS = XST*W*XS;
                    elseif length(W) == N
                        SXWXS = XST*(W.*XS); % (MxN * NxN * Nx1) = Mx1
                    else
                        error('W must have the same length as x and t.');
                    end
                    cachedVars.SXWXS = SXWXS;
                end
                
                if ~isfield(cachedVars,'SXWx') || isempty(cachedVars.SXWx)
                    if size(W,1) == N && size(W,2) == N
                        SXWx = XST*W*x;
                    elseif length(W) == 1
                        SXWx = XST*W*x;
                    elseif length(W) == N
                        SXWx = XST'*(W.*x); % (MxN * NxN * Nx1) = Mx1
                    else
                        error('W must have the same length as x and t.');
                    end
                    cachedVars.SXWx = SXWx;
                end
            end

        end

        function [coefficients,CmInv,cachedVars] = ConstrainedSolution(t,x,K,tKnot,distribution,W,constraints,cachedVars)
            % Solve the constrained weighted least-squares spline system.
            %
            % Supports local equality constraints and optional global shape
            % constraints enforced through quadratic programming when needed.
            %
            % - Topic: Methodology (Static methods)
            % - Developer: true
            % - Declaration: [coefficients,CmInv,cachedVars] = ConstrainedSolution(t,x,K,tKnot,distribution,W,constraints,cachedVars)
            % - Parameter t: sample locations
            % - Parameter x: sample values
            % - Parameter K: spline order
            % - Parameter tKnot: knot sequence
            % - Parameter distribution: error model object
            % - Parameter W: optional weights or weight matrix
            % - Parameter constraints: local/global constraint specification
            % - Parameter cachedVars: optional previously cached matrices
            % - Returns coefficients: fitted spline coefficients
            % - Returns CmInv: inverse coefficient covariance or system matrix
            % - Returns cachedVars: updated cache of precomputed matrices

            cachedVars = ConstrainedSpline.PrecomputeSolutionMatrices(t,x,K,tKnot,distribution,W,constraints,cachedVars);
            
            F = cachedVars.F;
            XWX = cachedVars.XWX;
            XWx = cachedVars.XWx;
     
            % set up inverse matrices
            E_x = XWX; % MxM
            F_x = XWx;
            
            % First solve without global constraints
            NC = size(F,1);
            M = size(cachedVars.X,2);
            if NC > 0
                E_x = cat(1,E_x,F); % (M+NC)xM
                E_x = cat(2,E_x,cat(1,F',zeros(NC)));
                F_x = cat(1,F_x,zeros(NC,1));
                solution = E_x\F_x;
                coefficients = solution(1:M);
            else
                coefficients = E_x\F_x;
            end

            % Now solve *with* global constraints, if necessary
            S = cachedVars.SC;
            if ~isempty(S)
                coefficients0 = coefficients;
                xi0 = S\coefficients0;
                if any(xi0<0)
                    E_x = cachedVars.SXWXS; % MxM
                    F_x = cachedVars.SXWx;
                    
                    M = size(XWX,2); % number of splines
                    lb = zeros(M,1); lb(1) = -inf;
                    ub = inf*ones(M,1);
                    
                    % These are the local constraints, exactly as above
                    Aeq = cachedVars.FS;
                    if isempty(Aeq)
                        beq = [];
                    else
                        beq = zeros(NC,1);
                    end
                    
                    % E_x should be symmetric, although sometimes it's not
                    % exactly.
                    H = (E_x+E_x')*0.5;
                    
                    if 0 %if NC == 0
                        options = optimoptions('quadprog','Display','off','Algorithm','trust-region-reflective');
                        x = quadprog(2*H,-2*F_x,[],[],Aeq,beq,lb,ub,xi0,options);
                    else
                        options = optimoptions('quadprog','Display','off','Algorithm','interior-point-convex');
                        x = quadprog(2*H,-2*F_x,[],[],Aeq,beq,lb,ub,[],options);
                    end
                    coefficients = S*x;
                end
            end
            CmInv = E_x;
            
            % Here's the other way to solve the constraint problem
            %                 xi = optimvar('xi',M,'LowerBound',0,'UpperBound',Inf);
            %                 xi(1).LowerBound = -Inf;
            %                 xi(1).UpperBound = Inf;
            %                 B = X*S;
            %
            %                 f = sum(x.^2) - 2*sum(x.*(B*xi)) + sum((B*xi).^2);
            %
            %                 qprob = optimproblem('Objective',f);
            %                 opts = optimoptions('quadprog','Algorithm','trust-region-reflective','Display','off');
            %                 [sol,qfval,qexitflag,qoutput] = solve(qprob,struct('xi',xi0),'options',opts);
            %
            %                 coefficients = S*sol.xi;
        end

        function [coefficients,CmInv,cachedVars] = IteratedLeastSquaresTensionSolution(t,x,tKnot,K,distribution,constraints,cachedVars)
            % Solve a constrained spline fit with iteratively reweighted least squares.
            %
            % The first iteration computes an initial constrained fit, then
            % updates weights using the supplied distribution until the
            % effective variance model converges.
            %
            % - Topic: Methodology (Static methods)
            % - Developer: true
            % - Declaration: [coefficients,CmInv,cachedVars] = IteratedLeastSquaresTensionSolution(t,x,tKnot,K,distribution,constraints,cachedVars)
            % - Parameter t: sample locations
            % - Parameter x: sample values
            % - Parameter tKnot: knot sequence
            % - Parameter K: spline order
            % - Parameter distribution: error model object
            % - Parameter constraints: local/global constraint specification
            % - Parameter cachedVars: optional previously cached matrices
            % - Returns coefficients: fitted spline coefficients
            % - Returns CmInv: inverse coefficient covariance or system matrix
            % - Returns cachedVars: updated cache of precomputed matrices
            arguments
                t (:,1) double
                x (:,1) double
                tKnot (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                distribution
                constraints = []
                cachedVars = []
            end
            constraints = ConstrainedSpline.normalizeConstraints(constraints);
            cachedVars = ConstrainedSpline.normalizeCachedVars(cachedVars);

            cachedVars.W = []; cachedVars.XWX = []; cachedVars.XWx = []; cachedVars.SXWXS = []; cachedVars.SXWx = [];
            [coefficients,CmInv,cachedVars] = ConstrainedSpline.ConstrainedSolution(t,x,K,tKnot,distribution,[],constraints,cachedVars);
            
            X = cachedVars.X;
            sigma2_previous = (distribution.sigma0)^2;
            rel_error = 1.0;
            repeats = 1;
            while (rel_error > 0.01)
                sigma_w2 = distribution.w(X*coefficients - x);

                if isfield(cachedVars,'rho_t') && ~isempty(cachedVars.rho_t)
                    Sigma2 = (sqrt(sigma_w2) * sqrt(sigma_w2).') .* cachedVars.rho_t;
                    W = inv(Sigma2);
                else
                    W = 1./sigma_w2;
                end
                
                % hose any cached variable associated with W...
                cachedVars.W = []; cachedVars.XWX = []; cachedVars.XWx = [];
                % ...and recompute the solution with this new weighting
                [coefficients,CmInv,cachedVars] = ConstrainedSpline.ConstrainedSolution(t,x,K,tKnot,distribution,W,constraints,cachedVars);
                
                rel_error = max( abs((sigma_w2-sigma2_previous)./sigma_w2) );
                sigma2_previous=sigma_w2;
                repeats = repeats+1;
                
                if (repeats == 250)
                    disp('Failed to converge after 250 iterations.');
                    break;
                end
            end
            
        end

        function tKnot = terminatedKnotPoints(tKnot, K)
            % Ensure the knot vector has K repeated knots at each boundary.
            %
            % - Topic: Utility
            % - Declaration: tKnot = terminatedKnotPoints(tKnot,K)
            % - Parameter tKnot: knot sequence
            % - Parameter K: spline order
            % - Returns tKnot: terminated knot sequence
            arguments
                tKnot (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
            end

            nLeft = find(tKnot <= tKnot(1),1,'last');
            nRight = numel(tKnot) - find(tKnot == tKnot(end),1,'first') + 1;
            tKnot = [repmat(tKnot(1),K-nLeft,1); tKnot; repmat(tKnot(end),K-nRight,1)];
        end

        function constraints = normalizeConstraints(constraints)
            % Normalize an optional constraint specification struct.
            %
            % - Topic: Utility
            % - Developer: true
            % - Declaration: constraints = normalizeConstraints(constraints)
            % - Parameter constraints: empty or struct with constraint fields
            % - Returns constraints: normalized struct with fields t and D
            if isempty(constraints)
                constraints = struct('t',[],'D',[]);
                return;
            end

            if ~isstruct(constraints)
                error('ConstrainedSpline:InvalidConstraints', 'constraints must be empty or a struct.');
            end

            if ~isfield(constraints,'t')
                constraints.t = [];
            end

            if ~isfield(constraints,'D')
                constraints.D = [];
            end
        end

        function cachedVars = normalizeCachedVars(cachedVars)
            % Normalize an optional cached-variable struct.
            %
            % - Topic: Utility
            % - Developer: true
            % - Declaration: cachedVars = normalizeCachedVars(cachedVars)
            % - Parameter cachedVars: empty or struct of cached matrices
            % - Returns cachedVars: normalized cache struct
            if isempty(cachedVars)
                cachedVars = struct();
                return;
            end

            if ~isstruct(cachedVars)
                error('ConstrainedSpline:InvalidCachedVars', 'cachedVars must be empty or a struct.');
            end
        end
    end
end
