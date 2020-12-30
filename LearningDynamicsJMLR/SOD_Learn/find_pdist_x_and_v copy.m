function [pdist_x, pdist_v, Rs, num_agents_each_class] = find_pdist_x_and_v(x, v, sys_info, learning_info, agent_info)
% [pdist_x, pdist_v, Rs, num_agents_each_class] = find_pdist_x_and_v(x, v, learning_info)

% (c) Ming Zhong, Mauro Maggioni, JHU

% the number of agents
N                                   = sys_info.N;
% the size of the state
d                                   = sys_info.d;
% the number of classes
num_classes                         = sys_info.K;
% the class index function
class_info                          = sys_info.class_info;
% the number of time instances
L                                   = size(x, 2);
% find out if we need to store pdist_v
if sys_info.ode_order == 2
    has_align                       = ~isempty(learning_info.align_basis_info);
elseif sys_info.ode_order == 1
    has_align                       = false;
end
% prepare storage
pdist_x                             = cell(num_classes,num_classes);
if has_align
    pdist_v                         = cell(num_classes,num_classes);
else
    pdist_v                         = [];
end
Rs                                  = zeros(num_classes);
Rs_at_t                             = zeros(num_classes, num_classes, L);
num_agents_each_class               = zeros(1, num_classes);
class_indicator                     = cell(1, num_classes);

agents_info = getAgentInfo( sys_info );




% go through time
for l = 1 : L
    % find out the copy of x and v at this time, and reshape
    x_at_t                          = reshape(x(:, l), [d, N]);
    if has_align
        v_at_t                      = reshape(v(:, l), [d, N]);
    end
    % calculate the pairwise distances on them
    pair_dist_x                     = squareform(pdist(transpose(x_at_t)), 'tomatrix');
    if has_align
        pair_dist_v                 = squareform(pdist(transpose(v_at_t)), 'tomatrix');
    end
    % go through each (C_k1, C_k2) pair
    for k_1 = 1 : num_classes
        for k_2 = 1 : num_classes
            % find out the agents in C_k2
            if l == 1
                % for agents in the same class, be careful
                if k_1 == k_2
                    % we need to know the number of agents in C_k1
                    if agents_info.num_agents(k_1) > 1
                        % then we only need the non-repeated ones
                        pdist_x{k_1, k_2}         = zeros(agents_info.num_agents(k_1) * (agents_info.num_agents(k_1) - 1)/2, L);
                        if has_align
                            pdist_v{k_1, k_2}       = zeros(agents_info.num_agents(k_1) * (agents_info.num_agents(k_1) - 1)/2, L);
                        end
                    else
                        % no distances
                        pdist_x{k_1, k_2}         = [];
                        if has_align
                            pdist_v{k_1, k_2}       = [];
                        end
                    end
                else
                    % if the agents are in different classes, then
                    pdist_x{k_1, k_2}           = zeros(agents_info.num_agents(k_1) * agents_info.num_agents(k_2), L);
                    if has_align
                        pdist_v{k_1, k_2}         = zeros(agents_info.num_agents(k_1) * agents_info.num_agents(k_2), L);
                    end
                end
            end
            % do the partition
            pair_dist_x_Ck1_Ck2             = pair_dist_x(agents_info.idxs{k_1}, agents_info.idxs{k_2});
            if has_align
                pair_dist_v_Ck1_Ck2           = pair_dist_v(agents_info.idxs{k_1}, agents_info.idxs{k_2});
            end
            % save them accordingly
            if k_1 == k_2
                % same class, take out the repeated ones using squareform
                if agents_info.num_agents(k_1) > 1
                    % only do it when there are more than 1 agent, for 1 agent-class, do nothing
                    pdist_x{k_1, k_2}(:, l)     = squareform(pair_dist_x_Ck1_Ck2, 'tovector');
                    if has_align
                        pdist_v{k_1, k_2}(:, l)   = squareform(pair_dist_v_Ck1_Ck2, 'tovector');
                    end
                end
            else
                % for agents in different class, simply resize
                pdist_x{k_1, k_2}(:, l)       = pair_dist_x_Ck1_Ck2(:);
                if has_align
                    pdist_v{k_1, k_2}(:, l)     = pair_dist_v_Ck1_Ck2(:);
                end
            end
            % save the maximum radius
            Rs_at_t(k_1, k_2, l)            = max(max(pair_dist_x_Ck1_Ck2));
        end
    end
end

% now find the maximum interaction radii
for k_1 = 1 : num_classes
    for k_2 = 1 : num_classes
        Rs(k_1, k_2)                      = max(squeeze(Rs_at_t(k_1, k_2, :)));
        if Rs(k_1, k_2) == 0, Rs(k_1, k_2)  = 1; end                                                % in case there is no interaction radius (1-agent class)
    end
end

return