function force = PT_external_force(v, xi, I_0, psi, xi_ci, v_term)

% function force = PT_external_force(v, xi, I_0, psi, xi_ci, v_term)
[d, N]    = size(v);
xi_effect = transpose(1 - psi(xi, xi_ci));                                                          % find out the effect from xi
xi_effect = kron(xi_effect, ones(d, 1));                                                            % enlarge the xi effect
v_term    = repmat(v_term, N, 1);                                                                   % enlarge the velocity to become a vector of length d * N
v_vec     = reshape(v, [d * N, 1]);                                                                 % reshape the v matrix into a vector
force     = I_0 * (v_term - v_vec) .* xi_effect;                                                    % the external force

return