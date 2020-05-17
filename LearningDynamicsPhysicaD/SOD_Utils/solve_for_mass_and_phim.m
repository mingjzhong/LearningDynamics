function gravity = solve_for_mass_and_phim(sys_info, learningOutput)
% function gravity = solve_for_mass_and_phim(sys_info, learningOutput)

% M. Zhong (JHU)

if isfield(learningOutput, 'gravity_method') && ~isempty(learningOutput.gravity_method)
  method                  = learningOutput.gravity_method;                                          % use 'trust-region-reflective';
else
  method                  = 'interior-point';
end
% find out the necessary phi's and rho's
gravity_items             = generateGravityMat(learningOutput);
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
% Step 1a: learn betas and phihatm at various r_q
fprintf('\n------------------- Learn phihat_m(r_q)''s');
[~, phihatm_vec, rq]      = decouple_phihatm_and_betas(sys_info.N, 1, method, options, 'first', ...
                            gravity_items, learningOutput);
% Step 1b: check to see if phihat_m(rp) \approx C/rp^{-3}
src_pos                   = [10, 10, 500, 500];
[pred_phihatm, C, P]      = check_phihatm_vec(phihatm_vec, rq, src_pos);
% Step 2a: extend phihat_m(rp) to a continuous function using regularized-L2 fit, Clamped B-splines
src_pos                   = [20, 20, 500, 500];
fprintf('\n------------------- Extend phihat_m(r_q)''s to a continuous phihat_m');
opt.debug                 = false;
opt.h                     = 1;
opt.derivative_type       = 2;
if isfield(sys_info, 'gravity_with_weight') && ~isempty(sys_info.gravity_with_weight) && sys_info.gravity_with_weight
  opt.use_weight          = true;
end
[phihatm, alphas, basis]  = extend_phihatm_vec(phihatm_vec, rq, gravity_items.supp, pred_phihatm, ...
                            src_pos, opt);
% Step 3: learn the betas with known phihatm_vec
gravity_items.phihatm_vec = phihatm_vec;
fprintf('\n------------------- Learn betas (roughly = C * m_i) from phihat_m(r_q)''s');
gravity.betas             = decouple_phihatm_and_betas(sys_info.N, 1, method, options, 'second', ...
                            gravity_items, learningOutput);
gravity.C                 = C;
gravity.basis             = basis;
gravity.phihatm           = phihatm;
gravity.alphas            = alphas;
gravity.P                 = P;
gravity.phihatm_vec       = phihatm_vec;
gravity.rq                = rq;
end