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
  obs_data_as_input              = false;
  learn_out.Timings.generateData = tic;
  if learn_info.VERBOSE >= 1
    fprintf('\n--------------------------------------------------------------------------------');
  end  
  fprintf('\nGenerating %d trajectories with %d observations each...', obs_info.M, obs_info.L);  
  solver_info.time_span(2)       = obs_info.T;
  obs_data                       = generateObservations(learn_info.sys_info, solver_info, ...
                                   obs_info, obs_info.M, obs_data);
  learn_out.Timings.generateData = toc(learn_out.Timings.generateData);
  if learn_info.VERBOSE >= 1, fprintf('done (%6.2f sec).', learn_out.Timings.generateData); end
else
  obs_data_as_input              = true;
end

%% learn the interactions
learn_out.Timings.learn          = tic;
% Use only the (y, dy) pair from obs_data, and break them into smaller L's if needed
[y, dy]                          = split_observation_in_L(obs_data.y, obs_data.dy, ...
                                   obs_info.time_vec, learn_info);
if learn_info.VERBOSE >= 1
  fprintf('\n--------------------------------------------------------------------------------');
  fprintf('\nLearn the interaction laws with L = %d and M = %d...', size(y, 2), size(y, 3));
end
learn_info.pd_file_form          = obs_info.pd_file_form;
learn_out.Estimator              = learn_from_dynamics(y, dy, learn_info);
learn_out.Timings.learn          = toc(learn_out.Timings.learn);                                     
if learn_info.VERBOSE >= 1
  fprintf('done (%6.2f sec).', learn_out.Timings.learn);
  if learn_info.sys_info.ode_order == 1
    state                        = 'x ';
  elseif learn_info.sys_info.ode_order == 2
    state                        = 'v ';
  end
  fprintf(['\n\tThe empirical error from learning phis on ', state, ' is: %10.4e.'], ...
    max(learn_out.Estimator.emp_err));
  if ~isempty(learn_out.Estimator.emp_err_xi)
    fprintf('\n\tThe empirical error from learning phis on xi is: %10.4e.', ...
      max(learn_out.Estimator.emp_err_xi)); 
  end
end

%% Package outputs for different system info
learn_out                        = set_sys_info_for_learn_out(learn_info, learn_out);
if ~obs_data_as_input
  learn_out.obs_data             = obs_data;
end
end