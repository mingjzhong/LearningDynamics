function [energy_bar, energy_var] = calculate_energy_statistics(total_energy)
% function [energy_bar, energy_var] = calculate_energy_statistics(total_energy)

% (C) M. Zhong

energy_bar  = mean(total_energy);
energy_var  = var(total_energy, [], 2);
end