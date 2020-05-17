function cond_num = get_conditional_number_from_svd(sing_vals)
% function cond_num = get_conditional_number_from_svd(sing_vals)

% (C) M. Zhong

ind      = find(sing_vals > 0);
cond_num = sing_vals(ind(1))/sing_vals(ind(end));
end