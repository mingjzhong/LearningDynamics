function [aphelion, perihelion, period, ts] = get_JPL_orbit_information_sineFit(t_l, r_l, ZP_type)
% function [aphelion, perihelion, period, ts] = get_JPL_orbit_information_sineFit(t_l, r_l, ZP_type)

% (C) M. Zhong

beta       = get_JPL_sine_fit_to_dist(t_l, r_l, ZP_type);                                           % use a Sine fit
aphelion   = beta(1) + beta(2);                                                                     % aphelion                                       
perihelion = beta(1) - beta(2);                                                                     % perihelion
period     = 1/beta(3);                                                                             % orbital period
T_0        = t_l(1);                                                                                % initial time                                                
T          = t_l(end);                                                                              % end time
K1         = ceil((2  * pi * beta(3) * T_0 + beta(4) - pi/2)/(2 * pi));                             % times when the aphelion is reached 
K2         = floor((2 * pi * beta(3) * T   + beta(4) - pi/2)/(2 * pi));                             % at \pi/2 \pm 2k\pi 
ts1        = (2 * pi * (K1 : K2) + pi/2 - beta(4))/(2 * pi * beta(3));
K1         = ceil((2  * pi * beta(3) * T_0 + beta(4) + pi/2)/(2 * pi));                             % times when the perihelion is reached 
K2         = floor((2 * pi * beta(3) * T   + beta(4) + pi/2)/(2 * pi));                             % at -\pi/2 \pm 2k\pi 
ts2        = (2 * pi * (K1 : K2) - pi/2 - beta(4))/(2 * pi * beta(3));       
if length(ts1) >= length(ts2)
  ts       = ts1;                                                                                   % choose the one with more samples
else
  ts       = ts2;
end
end