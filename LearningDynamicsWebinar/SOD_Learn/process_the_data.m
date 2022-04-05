function [phi_range, rho_range] = process_the_data(y, dy, learn_info, agent_info)
% function [phi_range, rho_range] = process_the_data(y, dy, learn_info, agent_info)

% (c) M. Zhong (JHU)

% Initialize some values 
M                                  = size(y, 3);
phi_range                          = [];
rho_range                          = [];
if learn_info.is_parallel
  if ~learn_info.is_rhoLT
    phi_ranges                     = cell(1, M);
  end
  rho_ranges                       = cell(1, M);  
  parfor m = 1 : M
    [phi_ranges{m}, rho_ranges{m}] = process_the_data_at_m(m, squeeze(y(:, :, m)), ...
                                     squeeze(dy(:, :, m)), learn_info, agent_info);
  end
  for m = 1 : M
    if ~learn_info.is_rhoLT
      phi_range                    = get_the_range(phi_ranges{m}, phi_range);
    end
    rho_range                      = get_the_range(rho_ranges{m}, rho_range);
  end
else
  for m = 1 : M 
    [phi_range_m, rho_range_m]     = process_the_data_at_m(m, squeeze(y(:, :, m)), ...
                                     squeeze(dy(:, :, m)), learn_info, agent_info);
    if ~learn_info.is_rhoLT
      phi_range                    = get_the_range(phi_range_m, phi_range);
    end
    rho_range                      = get_the_range(rho_range_m, rho_range);
  end
end

end