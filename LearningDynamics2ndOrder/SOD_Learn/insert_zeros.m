function alpha_new = insert_zeros(k, alpha, learn_info, type)
% function alpha_new = insert_zeros(k, alpha, learn_info, type)

% (C) M. Zhong

switch type
  case 'EA'
    if isfield(learn_info, 'Ebasis_info') && ~isempty(learn_info.Ebasis_info)
      num_Ebasis      = cellfun(@(x) prod(x.n), learn_info.Ebasis_info(k, :));
    else
      num_Ebasis      = [];
    end
    total_num_Ebasis  = sum(num_Ebasis);
    if isfield(learn_info, 'Abasis_info') && ~isempty(learn_info.Abasis_info)
      num_Abasis      = cellfun(@(x) prod(x.n), learn_info.Abasis_info(k, :));
    else
      num_Abasis      = [];
    end    
    total_num_Abasis  = sum(num_Abasis);
    total_num_basis   = total_num_Ebasis + total_num_Abasis;
    if total_num_basis == length(alpha)
      alpha_new       = alpha;
    else
      alpha_new       = zeros(total_num_basis, 1);
      E_idxs          = get_logical_index_for_zeros(k, total_num_Ebasis, num_Ebasis);
      A_idxs          = get_logical_index_for_zeros(k, total_num_Abasis, num_Abasis);
% one of E_idxs or A_idxs being empty will force [E_idxs; A_idxs] to become non-logical      
      idxs            = logical([E_idxs; A_idxs]);
      alpha_new(idxs) = alpha;
    end
  case 'xi'
    if isfield(learn_info, 'Xibasis_info') && ~isempty(learn_info.Xibasis_info)
      num_basis       = cellfun(@(x) prod(x.n), learn_info.Xibasis_info(k, :));
    else
      num_basis       = [];
    end
    total_num_basis   = sum(num_basis);
    if total_num_basis == length(alpha)
      alpha_new       = alpha;
    else
      alpha_new       = zeros(total_num_basis, 1);
      idxs            = get_logical_index_for_zeros(k, total_num_basis, num_basis);
      alpha_new(idxs) = alpha;
    end 
  otherwise
    error('');
end
end