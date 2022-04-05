function [phiEhatclean, Ebasisclean] = assemble_clean_phiEhat(sys_info, Estimator)
%

% (C) M. Zhong

phiEhatclean               = cell(sys_info.K);
Ebasisclean                = cell(sys_info.K);
betas                      = Estimator.gravity.betas;
phihatm                    = Estimator.gravity.phihatm;
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    Ebasisclean{k1, k2}    = Estimator.Ebasis{k1, k2};
    if k1 == k2
      phiEhatclean{k1, k2} = @(r) zeros(size(r));
    else
      phihatclean          = @(r) betas(k2) * phihatm(r);
      phiEhatclean{k1, k2} = simplifyfcn(phihatclean, Ebasisclean{k1, k2}.knots, ...
                             Ebasisclean{k1, k2}.degree);
    end
  end
end
end