function learn_info = turn_on_adaptive_learning(learn_info)
% function learn_info = turn_on_adaptive_learning(learn_info)

% (C) M. Zhong

learn_info.use_rhoLTM        = true;
learn_info.is_adaptive       = true;
learn_info.max_num_subs      = 128;
learn_info.adaptive_method   = 'wrt_rho_and_psi';
learn_info.adaptive_err_tol  = 1.e-12;
learn_info.adaptive_err_type = 'f';
learn_info.sample_tol        = 1/200;
end