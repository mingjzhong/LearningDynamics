function state_norm = state_norm_old(state_vec, system, agents_each_class, num_agents_each_class)

% function the_norm = state_norm(state_vec, system, agents_each_class, num_agents_each_class)

% (c) Ming Zhong, Mauro Maggioni, JHU

x               = state_vec(1 : system.N * system.d, 1);                                            % partition the state vector, find out the component for x
v               = [];
xi              = [];

if system.ode_order == 2
    v           = state_vec((system.N * system.d + 1) : (2 * system.N * system.d), 1);              % second order, there is always v
    if system.has_xi                                                                                % might not have xi
        xi        = state_vec((2 * system.N * system.d + 1) : (2 * system.N * system.d + system.N), 1); % find out the information on xi
    end
end

% Compute the norm of the state, based on the order of the ODE
if system.ode_order == 1    
    x           = reshape(x, [system.d, system.N]);                                                 % we only need to work on x, reshape x    
    the_sum     = sum(x.^2,1);                                                                        % square component wise and sum over the rows    
    x_norm      = 0;                                                                                % initialize the x_norm    
    for k = 1 : system.K                                                                            % go through each class        
        x_norm    = x_norm + sum(the_sum(logical(agents_each_class(k,:))))/num_agents_each_class(k);% find out the ||x_i||_2^2 for i \in C_k, and sum them up and scale it by their numbers
    end    
    x_norm      = sqrt(x_norm);    
    v_norm      = 0;
    xi_norm     = 0;
elseif system.ode_order == 2    
    x_norm      = 0;                                                                                % for second order, no contribution from x    
    v           = reshape(v, [system.d, system.N]);                                                 % compute norm for v    
    the_sum     = sum(v.^2,1);                                                                        % square component wise and sum over the rows    
    v_norm      = 0;                            
    for k = 1 : system.K                                                                            % go through each class        
        v_norm    = v_norm + sum(the_sum(logical(agents_each_class(k,:))))/num_agents_each_class(k);% find out the ||x_i||_2^2 for i \in C_k, and sum them up and scale it by their numbers
    end    
    v_norm      = sqrt(v_norm);
    
    if system.has_xi
        xi        = transpose(xi);
        the_sum   = sum(xi.^2,1);
        xi_norm   = 0;
        for k = 1 : system.K                                                                        % go through each class            
            xi_norm = xi_norm + sum(the_sum(logical(agents_each_class(k,:))))/num_agents_each_class(k); % find out the ||x_i||_2^2 for i \in C_k, and sum them up and scale it by their numbers
        end        
        xi_norm   = sqrt(xi_norm);
    else        
        xi_norm   = 0;
    end
else
    error('\nODE of order >2 not implemented');
end

% take the maximum over all
state_norm  = max([x_norm, v_norm, xi_norm]);                                                                                   

return