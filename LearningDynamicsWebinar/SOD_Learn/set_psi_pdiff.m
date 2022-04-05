function psi_pdiff = set_psi_pdiff(k1, k2, agent_info, sys_info, row_in_NkL_mat, row_in_NkdL_mat, psi_pdiff_l, psi_pdiff)
% function psi_pdiff = set_psi_pdiff(k1, k2, agent_info, sys_info, row_in_NkL_mat, row_in_NkdL_mat, psi_pdiff_l, psi_pdiff)

% (C) M. Zhong

if ~isempty(psi_pdiff_l)
  for ind = 1 : length(psi_pdiff_l)
    if ~isempty(psi_pdiff_l{ind})
      if sys_info.d > 1 && size(psi_pdiff_l{ind}, 1) == sys_info.N * sys_info.d
        psi_pdiff{ind}{k1, k2}(row_in_NkdL_mat, :) = psi_pdiff_l{ind}(agent_info.idxs_in_Nd{k1}, ...
          agent_info.idxs{k2});
      elseif size(psi_pdiff_l{ind}, 1) == sys_info.N
        psi_pdiff{ind}{k1, k2}(row_in_NkL_mat, :)  = psi_pdiff_l{ind}(agent_info.idxs{k1}, ...
          agent_info.idxs{k2});        
      end
    end
  end
end
end