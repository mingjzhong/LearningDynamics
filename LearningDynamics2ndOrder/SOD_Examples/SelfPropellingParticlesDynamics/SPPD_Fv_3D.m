function Fv = SPPD_Fv_3D(x, v, d, N, alpha, beta, G, lambda, gamma)
% function Fv = SPPD_Fv_3D(x, v, d, N, alpha, beta, G, lambda, gamma)

% (c) M. Zhong

% initalization
v     = reshape(v, [d, N]);
x     = reshape(x, [d, N]);
u     = get_lab_frame_fluid_velocity(x, v, d, N, G);
v_rel = v - u;                                                                                      % relative  velocity (to the fluid)
v_per = v - lambda * u;                                                                             % perceived velocity (given by lambda)
RHF   = SPPD_Rayleigh_Dissipation(v_per(:), d, N, alpha, beta);                                      % Rayleigh-Helmholtz friction based on swimmer's referenced velocity   
Fv    =  -gamma * v_rel(:) + RHF;                                                                   % drag force + the Rayleigh-Helmholtz friction
end