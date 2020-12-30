%% MM: DEPRECATED

function learning_info = set_up_learning_info(system_info)
% learning_info = set_up_learning_info(system_info)
%

% Ming Zhong
% Postdoc Research at JHU

% MM: TBD: Clean up all the redundancies between variables!
% 
% % % the number of agents (system size)
% % learning_info.N        = system_info.N;
% % % the size of the state vector
% % learning_info.d         = system_info.d;
% % % the order of the ODE system
% % ode_order                        = system_info.ode_order;
% %learning_info.ode_order          = ode_order;
% % number of classes in the system
% % learning_info.K        = system_info.K;
% % % class index map which takes the agent index to its class index
% % learning_info.class_info         = system_info.class_info;
% % % the type of scaling factor
% % learning_info.scaling            = system_info.scaling;
% % % the indicator if the system has the auxiliary variable xi
% % has_xi                           = system_info.has_xi;
% %learning_info.has_xi             = has_xi;
% % indicator for stochastic noise
% % learning_info.has_noise          = system_info.has_noise;
% % use the Right Riemann sum
% learning_info.Riemann_sum        = 2;
% % use normal backward differencing to approximate derivative
% learning_info.how_to_diff        = 'normal';
% % do not de-noise the original data
% learning_info.how_to_denoise     = 'none';
% % the indicator if the basis is adaptive
% learning_info.is_adaptive        = false;
% % the parallel indicator
% learning_info.is_parallel        = false;
% % the indicator for finding the friction
% learning_info.need_friction      = false;
% % now the ode_order dependent variables
% % if ode_order == 1
% %     % the coupling strength term for x
% %     learning_info.energy_kappa     = system_info.energy_kappa;
% %     % regulation information on x
% %     learning_info.energy_regulator = system_info.energy_regulator;
% %     % external influence on x
% %     learning_info.x_external       = system_info.x_external;
% % elseif ode_order == 2
% %     % the mass of each agent
% %     learning_info.agent_mass       = system_info.agent_mass;
% %     % the coupling strength term for x
% %     learning_info.energy_kappa     = system_info.energy_kappa;
% %     % the coupling strength term for v
% %     learning_info.align_kappa      = system_info.align_kappa;
% %     % regulation information on x
% %     learning_info.energy_regulator = system_info.energy_regulator;
% %     % regulation information on v
% %     learning_info.align_regulator  = system_info.align_regulator;
% %     % external influence on v
% %     learning_info.v_external       = system_info.v_external;
% %     % check to see if we need to include information on xi
% %     if has_xi
% %         % the coupling strength term for xi
% %         learning_info.xi_kappa       = system_info.xi_kappa;
% %         % regulation information on xi
% %         learning_info.xi_regulator   = system_info.xi_regulator;
% %         % external influence on xi
% %         learning_info.xi_external    = system_info.xi_external;
% %     end
% % end