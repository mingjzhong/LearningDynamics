function [obs_data, obs_data_new] = get_training_data_from_rhoLT(rhoLT_data, M)
% function [obs_data, obs_data_new] = get_training_data_from_rhoLT(rhoLT_data, M)

% (C) M. Zhong

M_rho             = size(rhoLT_data.y, 3);
ind_total         = 1 : M_rho;
ind_train         = sort(randperm(M_rho, M));
ind_left          = setdiff(ind_total, ind_train);
ind_new           = sort(ind_left(randperm(M_rho - M, M)));
obs_data.y        = rhoLT_data.y(:, :, ind_train);
obs_data.ICs      = squeeze(obs_data.y(:, 1, :));
obs_data_new.y    = rhoLT_data.y(:, :, ind_new);
obs_data_new.ICs  = squeeze(obs_data_new.y(:, 1, :));
if isfield(rhoLT_data, 'dy') && ~isempty(rhoLT_data.dy)
  obs_data.dy     = rhoLT_data.dy(:, :, ind_train);
% obs_data_new is only used for trajectory error computation, no need of dy  
else
  obs_data.dy     = [];
end
end