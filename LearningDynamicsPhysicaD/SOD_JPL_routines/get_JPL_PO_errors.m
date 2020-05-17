function [Estimator, empiErr, L2rhoTErrs, trajErrs] = get_JPL_PO_errors(solver_info, sys_info, ...
          learn_info, x_l, v_l, dot_xv_l, ts_l, x_t, v_t, ts_t)
% function [Estimator, empiErr, L2rhoTErrs, trajErrs] = get_JPL_PO_errors(solver_info, sys_info, ...
%           learn_info, x_l, v_l, dot_xv_l, ts_l, x_t, v_t, ts_t)

% (C) M. Zhong

Estimator             = learn_interactions(x_l, v_l, [], dot_xv_l, [], ts_l, sys_info, learn_info);
empiErr               = Estimator.emp_err;
L2rhoTErrs            = get_JPL_L2rhoTErr(Estimator, sys_info);
syshat_info           = sys_info;
syshat_info.phiE      = Estimator.phiEhatsmooth;
solver_info.time_span = [ts_t(1), ts_t(end)];
trajErrs              = cell(1, 2);
trajErrs{1}           = get_JPL_trajErr_PO(x_l, v_l, syshat_info, solver_info, ts_t);
trajErrs{2}           = get_JPL_trajErr_PO(x_t, v_t, syshat_info, solver_info, ts_t);
end