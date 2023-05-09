function gravity = solve_for_mass_and_phim(sys_info, Estimator)
% function gravity = solve_for_mass_and_phim(sys_info, Estimator)

% M. Zhong (JHU)

if isfield(Estimator, 'gravity_method') && ~isempty(Estimator.gravity_method)
  method                  = Estimator.gravity_method;                                               % use 'trust-region-reflective';
else
  method                  = 'interior-point';
end
% find out the necessary phi's and rho's
gravity_items             = generateGravityMat(Estimator);
% prepare the optimization option, use interior point, and constrained optimization, since we only 
% require part of x to be positive
max_power                 = 6;
max_iters                 = 10^max_power;
max_funEva                = 10^max_power;
tol                       = 1e-12;
options                   = optimoptions(@fmincon, 'Algorithm', method, 'SpecifyObjectiveGradient', ...
                            true, 'MaxIterations', max_iters, 'MaxFunctionEvaluations', max_funEva, ...
                            'ConstraintTolerance', tol, 'OptimalityTolerance', tol, 'StepTolerance', ...
                            tol, 'Display', 'off');
% Step 1a: learn beta_1 and phihatm at various r_qs
fprintf('\n------------------- Learn phihat_m(r_q)''s');
[beta1, phim_vec, rq, out] = decouple_phim_and_betas(sys_info.N, method, options, 'first', ...
                             gravity_items);
gravity.opt_out            = cell(1, 2);
gravity.opt_out{1}         = out;
% Step 1b: learn beta_ks (k = 2, \cdots, N) at various r_qs
gravity_items.phim_vec     = phim_vec;
fprintf('\n------------------- Learn betas (roughly = C * m_i) from phihat_m(r_q)''s');
[betas, ~, ~, out]         = decouple_phim_and_betas(sys_info.N, method, options, 'second', ...
                             gravity_items);
gravity.opt_out{2}         = out;
% Step 2a: check to see if phihat_m(rp) \approx C/rp^{-3}
[pred_phim, C, P]          = check_phihatm_vec(phim_vec, rq);
% Step 2b: extend phihat_m(rp) to a continuous function using regularized-L2 fit, Clamped B-splines
fprintf('\n------------------- Extend phihat_m(r_q)''s to a continuous phihat_m');
opt.h                      = 0.05;
opt.derivative_type        = 2;
opt.use_weight             = true;
[phihatm, alphas, basis]   = extend_phihatm_vec(phim_vec, rq, gravity_items.supp, opt);
% Step 3: learn the betas with known phihatm_vec

gravity.betas              = [beta1; betas];
gravity.C                  = C;
gravity.basis              = basis;
gravity.phihatm            = phihatm;
gravity.alphas             = alphas;
gravity.P                  = P;
gravity.phim_vec           = phim_vec;
gravity.pred_phim          = pred_phim;
gravity.rq                 = rq;
end