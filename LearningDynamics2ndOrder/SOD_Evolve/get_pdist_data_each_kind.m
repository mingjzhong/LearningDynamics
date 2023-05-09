function pdist_data = get_pdist_data_each_kind(r_plus_V, sys_info, kind)
% function pdist_data = get_pdist_data_each_kind(r_plus_V, sys_info, kind)

% (C) M. Zhong

pdist_data            = cell(sys_info.K);
proj                  = [];
switch kind 
  case 'energy'
    if isfield(sys_info, 'projE') && ~isempty(sys_info.projE)
      proj            = sys_info.projE;
    end
  case 'alignment'
    if isfield(sys_info, 'projA') && ~isempty(sys_info.projA)
      proj            = sys_info.projA;
    end
  case 'xi'
    if isfield(sys_info, 'projXi') && ~isempty(sys_info.projXi)
      proj            = sys_info.projXi;
    end
  otherwise
    error('SOD_Evolve:get_phi_of_states_each_var:exception', ...
      'Only energy, alignment or xi type is supported!!');
end
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if ~isempty(proj) && ~isempty(proj{k1, k2})
% projection of the whole r_plus_V map instead      
      inds             = [1, proj{k1, k2} + 1];
    else
% by default, it only takes the pairwise distance      
      inds             = 1;
    end
    pdist_data{k1, k2} = r_plus_V{k1, k2}(inds);
  end
end

end