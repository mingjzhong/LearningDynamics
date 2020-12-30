function trajErr = computeTrajectoryAccuracy( sys_info, syshat_info, solver_info, obs_info, y_init )

% function trajErr = computeTrajectoryAccuracy( sys_info, syshat_info, solver_info, obs_info, y_init )
%
% IN: the usual structure containing the system, estimated system and observations, plus a
%       sys_info.d*sys_info.N by M set of initial conditions in y_init
% OUT:
%   trajErr     : structure with the following fields:
%       sup     : sup distance on [0,obs_info.T_L]
%       supFut  : sup distance on [obs_info.T_L,solver_info.time_span(2)]
%      ( Haus    : Haus distance on [0,obs_info.T_L] )
%      ( HausFut : Haus distance on [obs_info.T_L,solver_info.time_span(2)] )

% (c) M. Zhong, M. Maggioni (JHU)

VERBOSE                     = obs_info.VERBOSE;

%% Trajectories from initial conditions y_init
M                           = size(y_init,2);

% Generate true trajectories
sys_var_len                 = calculate_sys_var_len(sys_info);
traj                        = zeros(sys_var_len, obs_info.L_test, M);
trajfut                     = zeros(sys_var_len, obs_info.L_test, M);
failtraj                    = zeros(1,M,'logical');
obs_info_Ltest              = obs_info;
obs_info_Ltest.L            = obs_info.L_test;
obs_info_Ltest.time_vec     = linspace(0,obs_info.T_L,obs_info_Ltest.L);
obs_info_Ltest_fut          = obs_info_Ltest;
obs_info_Ltest_fut.time_vec = linspace(obs_info.T_L,solver_info.time_span(2),obs_info_Ltest.L);

if VERBOSE>1,   fprintf('\nGenerating %d true trajectories for testing...',M);  end
trajErr.Timings.TrueKernelTrainICs  = tic;
parfor m = 1:M    
  dynamics                  = self_organized_dynamics( y_init(:,m), sys_info, solver_info);         % run the simulation from m-th initial condition used in training
  failtraj(m)               = dynamics.flag;
  if dynamics.flag,       continue;   end
  traj(:, :, m)             = observe_dynamics( dynamics, obs_info_Ltest     );                     % observe the trajectories L equispaced times up to T_L
  trajfut(:,:,m)            = observe_dynamics( dynamics, obs_info_Ltest_fut );                     % observe the trajectories L equispaced times from to T_L to T_f
end
trajErr.Timings.TrueKernelTrainICs  = toc(trajErr.Timings.TrueKernelTrainICs);
if VERBOSE > 1, fprintf('done (%.2f secs)',trajErr.Timings.TrueKernelTrainICs); end


%% Generate estimated trajectories
trajhat                     = zeros(sys_var_len, obs_info.L_test, M);
trajfuthat                  = zeros(sys_var_len, obs_info.L_test, M);
failtrajest                 = zeros(1,M,'logical');
if VERBOSE>1,   fprintf('\nGenerating %d estimated trajectories for testing...',M); end
trajErr.Timings.EstKernelTrainICs = tic;
parfor m = 1:M
  dynamics                  = self_organized_dynamics(y_init(:,m), syshat_info, solver_info);       % run the simulation from m-th initial condition used in training
  failtrajest(m)            = dynamics.flag;
  if failtrajest(m),        continue; end
  trajhat(:, :, m)          = observe_dynamics( dynamics, obs_info_Ltest     );                           % observe the trajectories L equispaced times up to T_L
  trajfuthat(:,:,m)         = observe_dynamics( dynamics, obs_info_Ltest_fut );                           % observe the trajectories L equispaced times from to T_L to T_f
end
trajErr.Timings.EstKernelTrainICs = toc(trajErr.Timings.EstKernelTrainICs);
if VERBOSE > 1, fprintf('done (%.2f sec.)',trajErr.Timings.EstKernelTrainICs);  end
%bigFig;for k = 1:10;plot(obstraj(2*k-1,:,1),obstraj(2*k,:,1),'k');hold on;plot(obstrajhat(2*k-1,:,1),obstrajhat(2*k,:,1),'r');end;

fail_idxs                   = (failtraj | failtrajest);
if sum(fail_idxs) > 0
  fprintf('\n\t Failed simulations with original system: %d/%d', sum(failtraj),   M);
  fprintf('\n\t Failed simulations with estimated system: %d/%d',sum(failtrajest),M);
  fprintf('\n\t Common failures = %d / Total failures = %d',     sum(failtraj & failtrajest),sum(fail_idxs));
end
% erase the failed trajectories
traj(:, :,       fail_idxs) = [];
trajhat(:, :,    fail_idxs) = [];
trajfut(:, :,    fail_idxs) = [];
trajfuthat(:, :, fail_idxs) = [];

%% Compute trajectory accuracy
sup_err                     = zeros(M,1);
sup_err_fut                 = zeros(M,1);
% Haus_err            = zeros(M,1);
% Haus_err_fut        = zeros(M,1);
if VERBOSE>1,   fprintf('\n\tComputing trajectory accuracies...');  end
trajErr.Timings.TrajNorm    = tic;
parfor m = 1:size(traj,3)
  sup_err(m)                = traj_norm(traj(:,:,m),    trajhat(:,:,m),    'Time-Maxed', sys_info);
  sup_err_fut(m)            = traj_norm(trajfut(:,:,m), trajfuthat(:,:,m), 'Time-Maxed', sys_info);
%     Haus_err(m)     = 0; %traj_norm(traj(:,:,m),    trajhat(:,:,m),     'Hausdorff',    sys_info);
%     Haus_err_fut(m) = 0; %traj_norm(trajfut(:,:,m), trajfuthat(:,:,m),  'Hausdorff',    sys_info);
end
trajErr.Timings.TrajNorm    = toc( trajErr.Timings.TrajNorm );
if VERBOSE>1,   fprintf('done (%.2f sec.)', trajErr.Timings.TrajNorm); end

%% Compute accuracy of trajectories with perturbed initial conditions
% if obs_info.compute_pICs
%   SIGMA               = [1e-4, 1e-2, 1];
%   N_ICsTOPERTURB      = 10;
%   N_PERTURBATIONS     = 10;
% 
%   sup_pert            = zeros(M,length(SIGMA));
%   % Haus_pert           = zeros(M,length(SIGMA));
%   sup_pert_fut        = zeros(M,length(SIGMA));
%   % Haus_pert_fut       = zeros(M,length(SIGMA));
% 
%   trajErr.Timings.PerturbedICs    = tic;
%   for k = 1:length(SIGMA)
%       if VERBOSE>1,   fprintf('\n\tComputing trajectory accuracies with perturbed IC''s (sigma=%f)...',SIGMA(k)); end
%       trajErr.Timings.ICPerturbs(k)=tic;
%       parfor m = 1:min(M,N_ICsTOPERTURB)
%   %         [sup_pert(m,k), Haus_pert(m,k),sup_pert_fut(m,k), Haus_pert_fut(m,k)] = ...
%   %                 generatePerturbedTrajectories( sys_info, solver_info, y_init(:,m), ...
%   %                                                 obs_info, traj(:,:,m), obs_info_fut, trajfut(:,:,m), ...
%   %                                                 SIGMA(k), N_PERTURBATIONS );
%         [sup_pert(m,k), sup_pert_fut(m,k)] = generatePerturbedTrajectories( sys_info, solver_info, y_init(:,m), ...
%         obs_info, traj(:,:,m), obs_info_fut, trajfut(:,:,m), SIGMA(k), N_PERTURBATIONS );
%       end
%       trajErr.Timings.ICPerturbs(k) = toc(trajErr.Timings.ICPerturbs(k));
%       if VERBOSE>1,   fprintf('done (%.2f)',trajErr.Timings.ICPerturbs(k));   end
%   end
%   trajErr.Timings.PerturbedICs = toc( trajErr.Timings.PerturbedICs );
% 
%   %% Compute relative error between the accuracy of trajectories with estimated interaction kernels
%   %   and that of trajectories with perturbed IC's
%   sup_pert_rel                 = zeros(M,length(SIGMA));
%   % Haus_pert_rel                = zeros(M,length(SIGMA));
%   sup_pert_rel_fut             = zeros(M,length(SIGMA));
%   % Haus_pert_rel_fut            = zeros(M,length(SIGMA));
%   for m = 1:min(M,N_ICsTOPERTURB)
%       sup_pert_rel(m,:)        = sup_err(m)./sup_pert(m,:);
%   %     Haus_pert_rel(m,:)       = Haus_err(m)./Haus_pert(m,:);
%       sup_pert_rel_fut(m,:)    = sup_err_fut(m)./sup_pert_fut(m,:);
%   %     Haus_pert_rel_fut(m,:)   = Haus_err(m)./Haus_pert_fut(m,:);    
%   end
% else
%   SIGMA                        = [];
%   sup_pert                     = [];
%   sup_pert_fut                 = [];
%   sup_pert_rel                 = [];
%   sup_pert_rel_fut             = [];
% end

%% Repackage outputs
obs_true.observation        = traj;
obs_true.observationfuture  = trajfut;
obs_hat.observation         = trajhat;
obs_hat.observationfuture   = trajfuthat;

trajErr.sup                 = sup_err;
trajErr.sup_fut             = sup_err_fut;
% trajErr.Haus                = Haus_err;
% trajErr.Haus_fut            = Haus_err_fut;
% trajErr.sup_pert            = sup_pert;
% trajErr.sup_pert_fut        = sup_pert_fut;
% trajErr.Haus_pert           = Haus_pert;
% trajErr.Haus_pert_fut       = Haus_pert_fut;
% trajErr.sup_pert_rel        = sup_pert_rel;
% trajErr.Haus_pert_rel       = Haus_pert_rel;
% trajErr.sup_pert_rel_fut    = sup_pert_rel_fut;
% trajErr.Haus_pert_rel_fut   = Haus_pert_rel_fut;
% trajErr.SIGMA               = SIGMA;

trajErr.obs_true         = obs_true;
trajErr.obs_hat          = obs_hat;

return