function [Ebasis, Abasis] = uniform_basis_on_x_and_v(Rs, sys_info, learn_info)

% function [Ebasis, Abasis] = uniform_basis_on_x_and_v(Rs, sys_info, learn_info)

% (c) Ming Zhong, Mauro Maggioni, JHU


Ebasis     = [];
Abasis     = [];

% Construct energy-based interaction basis
if ~isempty( learn_info.Ebasis_info )
    Ebasis   = uniform_basis_by_class(Rs, sys_info.K, learn_info.Ebasis_info);
end

% Construct alignment-based interaction basis
if sys_info.ode_order == 2
    if ~isempty( learn_info.Abasis_info )
        Abasis = uniform_basis_by_class(Rs, sys_info.K, learn_info.Abasis_info);
    end
end

return