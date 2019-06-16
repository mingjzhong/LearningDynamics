function learn_out = learn_from_dynamics( sys_info, obs_info, learn_info, obs_data )
% function learn_out = learn_from_dynamics( sys_info, obs_info, learn_info, obs_data )
%

% (c) M. Zhong, M. Maggioni, JHU

learn_out.Timings.total = tic;

one_block               = sys_info.d * sys_info.N;

if ~isfield(learn_info,'VERBOSE'), learn_info.VERBOSE = 2; end
VERBOSE = learn_info.VERBOSE;

if isempty(obs_data.x), fprintf('\n\t WARNING: empty observations!'); return;  end
% partition data
x                       = obs_data.x(1:one_block, :, :);                                            % find out the position of the agents
if sys_info.ode_order == 1
    v = []; xi = []; Estimator_xi = []; extra_xi = [];
    sys_info.has_xi       = false;
    if obs_info.use_derivative
        dot_xv              = obs_data.xp(1 : one_block, :, :);
    else
        dot_xv              = [];
    end
elseif sys_info.ode_order == 2
    v                     = obs_data.x(one_block + 1 : 2 * one_block, :, :);
    if obs_info.use_derivative
        dot_xv              = obs_data.xp(one_block + 1 : 2 * one_block, :, :);
    else
        dot_xv              = [];
    end
    if sys_info.has_xi
        xi                  = obs_data.x(2 * one_block + 1 : 2 * one_block + sys_info.N, :, :);
        if obs_info.use_derivative
            dot_xi            = obs_data.xp(2 * one_block + 1 : 2 * one_block + sys_info.N, :, :);
        else
            dot_xi            = [];
        end
    else
        xi = []; dot_xi = []; Estimator_xi = []; extra_xi = [];
    end
end

if VERBOSE > 1
    fprintf('\n===============================================');                                   % learn the interaction functions on x and v together
    fprintf('\nLearning interaction kernel for x and v.');
end
learn_out.Timings.learnInteractions = tic;
[Estimator, extra_xv] = learn_interactions_on_x_and_v(x, v, xi, dot_xv, obs_info.time_vec, sys_info, learn_info);
learn_out.Timings.learnInteractions = toc(learn_out.Timings.learnInteractions);
learn_out.Timings.learn_interactions_on_x_and_v = Estimator.Timings;

if sys_info.has_xi                                                                                  % learn the interaction functions on xi, if there is a xi variable
    if VERBOSE>1
        fprintf('\n===============================================');
        fprintf('\nDone learning interaction kernel for x and v, starting learning on xi.');
    end
    Rs      = extra_xv.Rs;
    learn_out.Timings.learnInteractionsXi = tic;                                                    % find out the maximum interaction radii from previous learn (interactions on x and v)
    [Estimator_xi, extra_xi] = learn_interactions_on_xi(Rs, x, xi, dot_xi, obs_info.time_vec, sys_info, learn_info); % learn quantities on xi
    learn_out.Timings.learnInteractionsXi = toc(learn_out.Timings.learnInteractionsXi);
end

if ~learn_info.MEMORY_LEAN
    learn_out.Phi         = Estimator.Phi;
    learn_out.rhs         = Estimator.rhs;
    if ~isempty(Estimator_xi)
        learn_out.PhiXi     = Estimator_xi.PhiXi;
        learn_out.rhsXi     = Estimator_xi.rhsXi;
    end
end

learn_out.extra_xv       = extra_xv;
rhoLTemp                 = extra_xv.rhoLTemp;
if ~isempty(Estimator_xi)
    Estimator.phiXihat     = Estimator_xi.phiXihat;
    Estimator.Xibasis      = Estimator_xi.Xibasis;
    Estimator.emp_err_xi   = Estimator_xi.emp_err;
    learn_out.extra_xi     = extra_xi;
    rhoLTemp.rhoLTXi       = extra_xi.rhoLTXi;
else
    Estimator.phiXihat     = [];
    Estimator.Xibasis      = [];
    Estimator.emp_err_xi   = [];
    learn_out.extra_xi     = [];
    rhoLTemp.rhoLTXi       = [];
end
learn_out.rhoLTemp       = rhoLTemp;
learn_out.Timings.total  = toc(learn_out.Timings.total);
learn_out.Estimator      = Estimator;

return
