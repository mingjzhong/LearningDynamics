function phi = gravity_phiE(r, m, G)
% function phi = gravity_phiE(r, m, G)
% simplified gravity force: F = mGN/r^3, different from 1/r^2, 
% since it is multiplied by (x_i' - x_i)

% (C) M. Maggioni, M. Zhong (JHU)

phi = m * G * r.^(-3);                                                                         
end