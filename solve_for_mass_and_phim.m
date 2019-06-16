function [y, rp] = solve_for_mass_and_phim(sys_info, learningOutput, method, solver)
% function [y, rp] = solve_for_mass_and_phim(sys_info, learningOutput, method)

% M. Zhong (JHU)

if nargin < 4, solver = 1; end
% prepare the optimization option, use interior point, and constrained optimization, since we only
% require part of x to be positive
switch solver
  case 1
    options                 = optimoptions(@fmincon, 'Algorithm', 'interior-point',          ...
    'SpecifyObjectiveGradient', true, 'MaxIterations', 50000, 'MaxFunctionEvaluations', 50000, 'OptimalityTolerance', 1e-8);
  case 2
    options                 = optimoptions(@fmincon, 'Algorithm', 'trust-region-reflective', ...
    'SpecifyObjectiveGradient', true, 'MaxIterations', 50000, 'MaxFunctionEvaluations', 50000, 'OptimalityTolerance', 1e-8);
  otherwise
end
% Optimization Approach to discovering the mass
gravity_terms               = generateGravityMat(learningOutput, method);
rp                          = gravity_terms.rp;
P                           = length(rp);
% initialize storage
y                           = zeros(sys_info.N + P, 1); 
switch method 
  case 1
% find (\beta_1, \vec{\phi}_m) first
    params.Phi              = gravity_terms.Phii1Mat;
    params.Rho              = gravity_terms.Rhoi1Mat; 
    obj_func                = @(x) total_gravity_energy(x, params, 1);
    x0                      = ones(P + 1, 1);
%    x0                      = ones(P + 1, 1)/(P + 1);
%    x0                      = rand(P + 1, 1);
    switch solver
      case 1
        A                   = zeros(1, P + 1);
        A(1, 1)             = -1;
        B                   = 0;
        LB                  = [];
      case 2
        A                   = [];
        B                   = [];
        LB                  = zeros(size(x0));
      otherwise
    end
    x                       = fmincon(obj_func, x0, A, B, [], [], LB, [], [], options);
% unpack the data in x, and put it back in y, the first N entries of Y are for beta, and the remaining 
% P entries are for phi_vec
    y(1)                    = x(1);
    phi_vec                 = x(2 : end);
    y(sys_info.N + 1 : end) = phi_vec;
% find (\beta_2, \cdots, \beta_N) next    
    params.Phi              = gravity_terms.Phi1iMat;
    params.Rho              = gravity_terms.Rho1iMat;
    params.phi_vec          = phi_vec;
    obj_func                = @(x) total_gravity_energy(x, params, 2);
%    x0                      = ones(sys_info.N - 1, 1);
%    x0                      = zeros(sys_info.N - 1, 1);
%    x0                      = rand(sys_info.N - 1, 1);
    switch solver
      case 1
        A                   = -ones(1, sys_info.N - 1);
        B                   = 0;
        LB                  = [];
      case 2
        A                   = [];
        B                   = [];
        LB                  = zeros(size(x0));
      otherwise
    end    
    x                       = fmincon(obj_func, x0, A, B, [], [], LB, [], [], options);
    y(2 : sys_info.N)       = x;
  case 2
% find \beta's and phi_vec together
    params.Phii1            = gravity_terms.Phii1Mat;
    params.Rhoi1            = gravity_terms.Rhoi1Mat;
    params.Phi1i            = gravity_terms.Phi1iMat;
    params.Rho1i            = gravity_terms.Rho1iMat;
    obj_func                = @(x) total_gravity_energy(x, params, 3);
    x0                      = ones(sys_info.N + P, 1)/(sys_info.N + P);
%    x0                      = zeros(sys_info.N + P, 1);
%    x0                      = rand(sys_info.N + P, 1);
    switch solver
      case 1
        A                   = zeros(sys_info.N, sys_info.N + P);
        ind                 = logical(eye(size(A)));
        A(ind)              = -1;
        B                   = zeros(sys_info.N, 1);       
        LB                  = [];
      case 2
        A                   = [];
        B                   = [];
        LB                  = zeros(size(x0));
      otherwise
    end
    y                       = fmincon(obj_func, x0, A, B, [], [], LB, [], [], options);
  case 3
% find (\beta_1, \cdots, \beta_N) and phi_vec all together from all phi's and rho's
    params.PhiMat           = gravity_terms.PhiMat;
    params.RhoMat           = gravity_terms.RhoMat;
    obj_func                = @(x) total_gravity_energy(x, params, 4);
    x0                      = ones(sys_info.N + P, 1)/(sys_info.N + P);
    switch solver
      case 1
        A                   = zeros(sys_info.N, sys_info.N + P);
        ind                 = logical(eye(size(A)));
        A(ind)              = -1;
        B                   = zeros(sys_info.N, 1);       
        LB                  = [];
      case 2
        A                   = [];
        B                   = [];
        LB                  = zeros(size(x0));
      otherwise
    end
    y                       = fmincon(obj_func, x0, A, B, [], [], LB, [], [], options);    
  otherwise
end
end