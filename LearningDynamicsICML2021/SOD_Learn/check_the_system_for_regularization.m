function to_reg = check_the_system_for_regularization(learn_info)
%

% (C) M. Zhong

is_multi_type = learn_info.sys_info.K > 1;
has_phiA      = isfield(learn_info.sys_info, 'phiA') && ~isempty(learn_info.sys_info.phiA);
has_phiXi     = isfield(learn_info.sys_info, 'phiXi') && ~isempty(learn_info.sys_info.phiXi);
to_reg        = ~is_multi_type && ~has_phiA && ~has_phiXi;
end