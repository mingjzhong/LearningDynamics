function r_sum = general_riemann_sum(integrand, time_vec, kind)
%
%

%
%

% find out the number of elements in time_vec
num_elms   = length(time_vec);
% find out the number of sub-intervals 
num_subin  = num_elms - 1; 
% integrand should have the same length as time_vec
if length(integrand) ~= num_elms
  error('');
end
% find out the time step sizes
time_steps = time_vec(2 : num_elms) - time_vec(1 : num_subin);
% find out the Riemann sum based on kind
switch kind
  case 1
% the left Riemann sum  
    r_sum  = sum(integrand(1 : num_subin) .* time_steps);
  case 2
% the right Riemann sum
    r_sum  = sum(integrand(2 : num_elms) .* time_steps);
  case 3
% the Trapezoidal rule (kind of like a midpoint rule)
    r_sum  = sum((integrand(2 : num_elms) + integrand(1 : num_subin)) ...
    .* time_steps)/2;
  otherwise
    error('SOD_Learn:general_riemann_sum:invalidInput', ...
    'The function can only do three different approximations!!');
end
end