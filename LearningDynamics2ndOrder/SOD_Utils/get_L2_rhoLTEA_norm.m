function L2rhoTEA = get_L2_rhoLTEA_norm(phiE, Ebasis, phiA, Abasis, rhoLT)
% function L2rhoTEA = get_L2_rhoLTEA_norm(phiE, Ebasis, phiA, Abasis, rhoLT)

% (C) M. Zhong

switch size(rhoLT.supp, 1)
  case 2
    r_range        = intersectInterval(rhoLT.supp(1, :), Ebasis.supp(1, :));
    r_ctrs         = linspace(r_range(1), r_range(2), 500);
    dotr_range     = rhoLT.supp(2, :);
    dotr_ctrs      = linspace(dotr_range(1), dotr_range(2), 500);
    [R, dotR]      = ndgrid(r_ctrs, dotr_ctrs);
    drhos          = rhoLT.dense(R, dotR);
    L2rhoTEA       = sqrt(sum(sum((phiE(R) .* R + phiA(R) .* dotR).^2 .* drhos)));
  case 3
    if Ebasis.dim == 1 && Abasis.dim == 2
      r_range      = intersectInterval(rhoLT.supp(1, :), Ebasis.supp(1, :));
      r_ctrs       = linspace(r_range(1), r_range(2), 500);
      s_range      = intersectInterval(rhoLT.supp(2, :), Abasis.supp(2, :));
      s_ctrs       = linspace(s_range(1), s_range(2), 500);
      dotr_range   = rhoLT.supp(3, :);
      dotr_ctrs    = linspace(dotr_range(1), dotr_range(2), 500);      
      [R, S, dotR] = ndgrid(r_ctrs, s_ctrs, dotr_ctrs);
      drhos        = rhoLT.dense(R, S, dotR);
      L2rhoTEA     = sqrt(sum(sum(sum((phiE(R) .* R + phiA(R, S) .* dotR).^2 .* drhos))));
    elseif Ebasis.dim == 2 && Abasis.dim == 1
      r_range      = intersectInterval(rhoLT.supp(1, :), Ebasis.supp(1, :));
      r_ctrs       = linspace(r_range(1), r_range(2), 500);
      s_range      = intersectInterval(rhoLT.supp(2, :), Ebasis.supp(2, :));
      s_ctrs       = linspace(s_range(1), s_range(2), 500);
      dotr_range   = rhoLT.supp(3, :);
      dotr_ctrs    = linspace(dotr_range(1), dotr_range(2), 500);      
      [R, S, dotR] = ndgrid(r_ctrs, s_ctrs, dotr_ctrs);
      drhos        = rhoLT.dense(R, S, dotR);
      L2rhoTEA     = sqrt(sum(sum(sum((phiE(R, S) .* R + phiA(R) .* dotR).^2 .* drhos))));     
    else
      error('');
    end
  otherwise
    error('');
end
end