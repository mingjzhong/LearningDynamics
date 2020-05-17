function gravity = learn_gravitation(sys_info, learningOutput)
% function learn_gravitation(sys_info, learningOutput)

% (c) M. Zhong

gravity          = solve_for_mass_and_phim(sys_info, learningOutput);
gravity.mass_hat = gravity.betas * gravity.C/sys_info.G;
end