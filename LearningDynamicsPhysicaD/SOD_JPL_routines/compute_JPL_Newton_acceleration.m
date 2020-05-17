function a_Newton = compute_JPL_Newton_acceleration(x, sys_info)
% function a_Newton = compute_JPL_Newton_acceleration(x, sys_info)

% (C) M. Zhong

L                = size(x, 2);
a_Newton         = zeros(size(x));
d                = sys_info.d;
N                = sys_info.N;
ind              = logical(eye(N));
mass_vec         = sys_info.known_mass;
if ~isrow(mass_vec), mass_vec = mass_vec'; end
G                = sys_info.G;
parfor l = 1 : L
  x_l            = reshape(x(:, l), [d, N]);
  rij            = sqrt(abs(sqdist_mod(x_l)));                                                      % rij = ||x_i - v_j||_2
  xij            = get_pair_diff(x_l);                                                              % x_j - x_i
  rijinv         = rij.^(-1);                                                                       % 1/r_ij
  rijinv(ind)    = 0;                                                                               % take care of the diagonal terms
  F_Newton       = smatrix_times_vmatrix(G * rijinv.^(3) .* repmat(mass_vec, [N, 1]), xij, d);      % F_ij = Gm_j/r_ij^3 * (x_j - x_i)
  a_Newton(:, l) = sum(F_Newton, 2);                                                                % \sum_{j = 1, j ~= i}^N F_ij
end
end