function D_mat = pdist2_states( states_1, states_2, sys_info )

the_dfunc  = @(ZI, ZJ) distfun(ZI, ZJ, sys_info, agents_each_class, num_agents_each_class);         % prepare the distance function
D_mat      = pdist2(states_1', states_2', @(ZI, ZJ) the_dfunc(ZI', ZJ'));                           % use the MATLAB built-in pdist2

return
%% The distance function
function D2 = distfun(ZI, ZJ, sys_info, agents_each_class, num_agents_each_class)

D2             = zeros(size(ZJ,2), 1);
for row_ind = 1 : size(ZJ, 2)
    D2(row_ind)  = state_norm(ZI - ZJ(:,row_ind), sys_info, agents_each_class, num_agents_each_class);
end

return
