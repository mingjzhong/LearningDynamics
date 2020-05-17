function learn_out = learn_from_dynamics(sys_info, obs_info, learn_info, obs_data)
% function learn_out = learn_from_dynamics(sys_info, obs_info, learn_info, obs_data)

% (c) M. Zhong, M. Maggioni, JHU

learn_out.Timings.total              = tic;
if ~isfield(learn_info, 'VERBOSE'), learn_info.VERBOSE = 2; end
if isempty(obs_data.y), fprintf('\n\t WARNING: empty observations!'); return;  end
% partition data
[x, v, xi, dot_xv, dot_xi]           = split_observation(obs_data, obs_info, sys_info, false);
[x, v, xi, dot_xv, dot_xi, time_vec] = split_observation_in_L(x, v, xi, dot_xv, dot_xi, ...
                                       obs_info.time_vec, learn_info);
if learn_info.VERBOSE > 1
  fprintf('\n===============================================');                                     % learn the interaction functions on x and v together
  fprintf('\nLearning interaction kernels.');
end
learn_out.Timings.learnInteractions  = tic;
Estimator                            = learn_interactions(x, v, xi, dot_xv, dot_xi, time_vec, ...
                                       sys_info, learn_info);
learn_out.Timings.learnInteractions  = toc(learn_out.Timings.learnInteractions);
learn_out.Estimator                  = Estimator;
learn_out.Timings.total              = toc(learn_out.Timings.total);
end