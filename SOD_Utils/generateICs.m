function y_inits = generateICs( M, sys_info )
% function y_inits = generateICs( M, sys_info )
%   generates M different initial conditions for the specific dynamics to run
% IN:
%   M        : # of different Monte Carlor realizations
%   sys_info : struct variable which contains information for the whole dynamics
% OUT:
%   y_inits  : different initial conditions for the dynamics to run

% (c) M. Maggioni, M. Zhong, JHU

% initialize storage
y_inits         = zeros(calculate_sys_var_len(sys_info), M);

% run in parallel to generate the initial conditions
parfor m = 1 : M
  y_init        = sys_info.mu0();                                                                 % draw a different initial condition
  y_inits(:, m) = y_init(:);
end
end