function is_Hamiltonian = check_Hamiltonian_system(sys_info)
% function is_Hamiltonian = check_Hamiltonian_system(sys_info)

% (C) M. Zhong

is_2nd_ordder  = sys_info.ode_order == 2;
has_energy     = isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE);
no_Fv          = ~isfield(sys_info, 'Fv') || isempty(sys_info.Fv);
no_alignment   = ~isfield(sys_info, 'phiA') || isempty(sys_info.phiA);
no_xi          = ~isfield(sys_info, 'phiXi') || isempty(sys_info.phiXi);
is_Hamiltonian = is_2nd_ordder && has_energy && no_Fv && no_alignment && no_xi ;
end