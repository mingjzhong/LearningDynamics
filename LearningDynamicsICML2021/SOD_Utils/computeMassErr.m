function massErr = computeMassErr(sys_info, gravity)
% function massErr = computeMassErr(sys_info, gravity)

% (C) M. Zhong (JHU)

if ~iscolumn(gravity.mass_hat), gravity.mass_hat = gravity.mass_hat'; end
if ~iscolumn(sys_info.known_mass), sys_info.known_mass = sys_info.known_mass'; end
massErr = abs(gravity.mass_hat - sys_info.known_mass)./(sys_info.known_mass);
end