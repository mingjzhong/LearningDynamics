function Fv = PT_Fv(v, xi, d, N, gamma, xi_critical, I_0, v_term)
% function Fv = PT_Fv(v, xi, d, N, gamma, xi_critical, I_0, v_term)

% (C) M. Zhong (JHU)

xi_effect = transpose(1 - gamma(xi, xi_critical));                                                  % find out the effect from xi
xi_effect = kron(xi_effect, ones(d, 1));                                                            % enlarge the xi effect
v_term    = repmat(v_term, N, 1);                                                                   % enlarge the velocity to become a vector of length d * N
v_vec     = reshape(v, [d * N, 1]);                                                                 % reshape the v matrix into a vector
Fv        = I_0 * (v_term - v_vec) .* xi_effect;                                                    % the external force
end