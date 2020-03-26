function the_diff = check_rhoLT_independence(sys_info, rhoLT)
% function the_diff = check_rhoLT_independence(sys_info, rhoLT)

% (c) M. Zhong

if sys_info.ode_order ~= 2
  error('SOD_Utils:check_rhoLT_independence:exception', 'System ODE has to be second order!!');
else
  if isempty(sys_info.phiA)
    error('SOD_Utils:check_rhoLT_independence:exception', 'System has to have alignment based interactions!!');
  end
end

the_diff.rhoLTA_diff = zeros(sys_info.K);
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    bin_width1                   = rhoLT.rhoLTA.rhoLTR.histedges{k1, k2}(2) - rhoLT.rhoLTA.rhoLTR.histedges{k1, k2}(1);
    bin_width2                   = rhoLT.rhoLTA.rhoLTDR.histedges{k1, k2}(2) - rhoLT.rhoLTA.rhoLTR.histedges{k1, k2}(1);
    the_diff.rhoLTA_diff(k1, k2) = calculate_independence(rhoLT.rhoLTA.hist{k1, k2}, rhoLT.rhoLTA.rhoLTR.hist{k1, k2}, ...
    rhoLT.rhoLTA.rhoLTDR.hist{k1, k2}, bin_width1, bin_width2);
  end
end
if sys_info.has_xi
  the_diff.rhoLTXi_diff = zeros(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      bin_width1                   = rhoLT.rhoLTXi.rhoLTR.histedges{k1, k2}(2) - rhoLT.rhoLTA.rhoLTR.histedges{k1, k2}(1);
      bin_width2                   = rhoLT.rhoLTXi.mrhoLTXi.histedges{k1, k2}(2) - rhoLT.rhoLTA.rhoLTR.histedges{k1, k2}(1);      
      the_diff.rhoLTXi_diff(k1, k2) = calculate_independence(rhoLT.rhoLTXi.hist{k1, k2}, rhoLT.rhoLTXi.rhoLTR.hist{k1, k2}, ...
      rhoLT.rhoLTXi.mrhoLTXi.hist{k1, k2}, bin_width1, bin_width2);  
    end
  end
end
end