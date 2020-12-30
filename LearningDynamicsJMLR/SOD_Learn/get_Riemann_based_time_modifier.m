function time_mod = get_Riemann_based_time_modifier(N, d, time_vec, Riemann)
% time_mod = get_Riemann_based_time_modifier(N, d, time_vec, Riemann)

% Ming Zhong
% Postdoc Research

% find out the total number of time instances
L            = length(time_vec);
% find out the time steps
time_mod     = transpose(time_vec(2 : L) - time_vec(1 : (L - 1)));
% based in Riemman, change it accordingly
switch Riemann
  case 1
% left Riemann sum
    time_mod = [time_mod; 0];
  case 2
% right Riemann sum
    time_mod = [0; time_mod];
  case 3
% mid sum
    time_mod = ([time_mod; 0] + [0; time_mod])/2;
  otherwise
    error('');
end
% take a squareroot
time_mod     = sqrt(time_mod);
% make it of the size [L * N * d, 1]
time_mod     = kron(time_mod, ones(N * d, 1));