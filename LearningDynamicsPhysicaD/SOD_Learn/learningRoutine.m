function learn_out = learningRoutine(solver_info, obs_info, learn_info, obs_data)
% function learn_out = learningRoutine(solver_info, obs_info, learn_info, obs_data)
%

% IN: structures of parameters for the system, observations and learning.
%   [obs_data]  : use the given observations
%
% OUT: structure with learned system
% 

% (c) M. Maggioni, M. Zhong (JHU)

if nargin < 4, obs_data = [];  end

if ~isfield(learn_info,'VERBOSE'),        learn_info.VERBOSE       = 2;    end
if ~isfield(learn_info,'keep_obs_data') , learn_info.keep_obs_data = true; end

%% Generate dynamics and observations
if isempty(obs_data) || isempty(obs_data.y)
  if learn_info.VERBOSE >= 1
    fprintf('\n--------------------------------------------------------------------------------');
  end  
  fprintf('\nGenerating %d trajectories with %d observations each...', obs_info.M, obs_info.L);  
  solver_info.time_span(2)                 = obs_info.T;
  obs_data                                 = generateObservations(learn_info.sys_info, solver_info, ...
                                             obs_info, obs_info.M, obs_data);
  if learn_info.VERBOSE >= 1, fprintf('done (%6.2f sec).',obs_data.Timings.total); end
end

%% learn the interactions
if learn_info.VERBOSE >= 1
  fprintf('\n--------------------------------------------------------------------------------');
  fprintf('\nLearn the interaction laws...');
end
learn_out                                  = learn_from_dynamics(learn_info.sys_info, obs_info, ...
                                             learn_info, obs_data);
if learn_info.VERBOSE >= 1
  fprintf('done (%6.2f sec).',learn_out.Timings.total);
  if learn_info.sys_info.ode_order == 1
    state                                  = 'x ';
  elseif learn_info.sys_info.ode_order == 2
    state                                  = 'v ';
  end
  fprintf(['\n\tThe empirical error from learning phis on ' state ' is: %10.4e.'], learn_out.Estimator.emp_err);
  if ~isempty(learn_out.Estimator.emp_err_xi)
    fprintf('\n\tThe empirical error from learning phis on xi is: %10.4e.', learn_out.Estimator.emp_err_xi); 
  end
end

%% Regularize interaction(s)
if isfield(learn_info, 'use_reg') && ~isempty(learn_info.use_reg) && learn_info.use_reg
  learn_out.Timings.regEstim               = tic;
  if learn_info.VERBOSE >= 1
    fprintf('\n--------------------------------------------------------------------------------');
    fprintf('\nRegularizing the learned Estimators:');
  end
  learn_out.Estimator                      = regularize_Estimator(learn_out.Estimator, learn_info);
  syshatreg_info                           = learn_info.sys_info;
  syshatreg_info.phiE                      = learn_out.Estimator.phiEhatReg;
  syshatreg_info.phiA                      = learn_out.Estimator.phiAhatReg;
  syshatreg_info.phiXi                     = learn_out.Estimator.phiXihatReg;
  learn_out.Timings.regEstim               = toc(learn_out.Timings.regEstim);
  if learn_info.VERBOSE >= 1
    fprintf('\nTime for regularizing phihats: %6.2f sec', learn_out.Timings.regEstim);
  end
else
  learn_out.Estimator.phiEhatReg           = [];
  learn_out.Estimator.phiAhatReg           = [];
  learn_out.Estimator.phiXihatReg          = [];
  syshatreg_info                           = [];
end

%% For gravity (or other parametrized functions), learn the parameterized form
if contains(learn_info.sys_info.name, 'Gravitation')
  fprintf('\n--------------------------------------------------------------------------------');
  fprintf('\nLearning parametric form:');  
  learn_out.Timings.estimateParametricForm = tic;
  learn_out.gravity                        = learn_gravitation(learn_info.sys_info, learn_out);
  [learn_out.Estimator.phiEhatclean, learn_out.Estimator.Ebasisclean] ...
                                           = assemble_clean_phiEhat(learn_info.sys_info, learn_out);
  learn_out.massErr                        = computeMassErr(learn_info.sys_info, learn_out.gravity);
  learn_out.Timings.estimateParametricForm = toc(learn_out.Timings.estimateParametricForm);
  fprintf('\nTime for learning parametric form: %6.2f sec', learn_out.Timings.estimateParametricForm); 
else
  learn_out.Estimator.phiEhatclean         = [];
end

%% Package outputs
learn_out.syshatreg_info                   = syshatreg_info;
syshat_info                                = learn_info.sys_info;
syshat_info.phiE                           = learn_out.Estimator.phiEhat;
syshat_info.phiA                           = learn_out.Estimator.phiAhat;
syshat_info.phiXi                          = learn_out.Estimator.phiXihat;
learn_out.syshat_info                      = syshat_info;
syshatsmooth_info                          = learn_info.sys_info;
syshatsmooth_info.phiE                     = learn_out.Estimator.phiEhatsmooth;
syshatsmooth_info.phiA                     = learn_out.Estimator.phiAhatsmooth;
syshatsmooth_info.phiXi                    = learn_out.Estimator.phiXihatsmooth;
learn_out.syshatsmooth_info                = syshatsmooth_info;
if learn_info.keep_obs_data
  learn_out.obs_data                       = obs_data;
end
end