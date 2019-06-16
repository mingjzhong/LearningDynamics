function [sup_pert, sup_pert_fut, failtrajpert] = generatePerturbedTrajectories(sys_info, ...
         solver_info, y_init,   obs_info, traj, obs_info_fut, traj_fut, SIGMA, N_PERTURBATIONS)
% function [sup_pert, Haus_pert, sup_pert_fut, Haus_pert_fut, failtrajpert] = generatePerturbedTrajectories( ...
%          sys_info, solver_info, y_init,   obs_info, traj, obs_info_fut, traj_fut, SIGMA, N_PERTURBATIONS)

% (c) M. Zhong, M. Maggioni (JHU)

failtrajpert        = zeros(N_PERTURBATIONS,1,'logical');

flag_fut            = (nargin>5) & ~isempty(obs_info_fut) & ~isempty(traj_fut);

y_init_pert         = bsxfun(@plus,y_init,SIGMA*colnorms(y_init)/sqrt(sys_info.d)* ...              % generate perturbed initial conditions
                                                        randn(size(y_init,1),N_PERTURBATIONS));
for k = 1:N_PERTURBATIONS                                                                        % Generate trajectories from perturbed initial conditions
    dynamics                    = self_organized_dynamics( y_init_pert(:,k), sys_info, solver_info);
    failtrajpert(k)             = dynamics.flag;
    if failtrajpert(k),         continue; end
    trajpert                    = observe_dynamics( dynamics, obs_info );
    supdist(k)                  = traj_norm( traj, trajpert, 'Time-Maxed', sys_info );              % Compute trajectory accuracy
%     Hausdist(k)                 = 0;%traj_norm( traj, trajpert, 'Hausdorff', sys_info );
    if flag_fut
        trajpert                = observe_dynamics( dynamics, obs_info_fut );
        supdist_fut(k)          = traj_norm( traj_fut, trajpert, 'Time-Maxed', sys_info );          % Compute trajectory accuracy
%         Hausdist_fut(k)         = 0;%traj_norm( traj_fut, trajpert, 'Hausdorff', sys_info );
    end
end

sup_pert            = mean(supdist(~failtrajpert));                                                 % Return means of accuracies
% Haus_pert           = mean(Hausdist(~failtrajpert));

if flag_fut
    sup_pert_fut    = mean(supdist_fut(~failtrajpert));
%     Haus_pert_fut   = mean(Hausdist_fut(~failtrajpert));
else
    sup_pert_fut    = []; % Haus_pert_fut = [];
end
return