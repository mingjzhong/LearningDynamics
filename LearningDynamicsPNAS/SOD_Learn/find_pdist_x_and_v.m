function [pdist_x, pdist_v, Rs] = find_pdist_x_and_v(x, v, sys_info, learning_info, agents_info)

%
% [pdist_x, pdist_v, Rs, num_agents_each_class] = find_pdist_x_and_v(x, v, learning_info)

% (c) Ming Zhong, Mauro Maggioni, JHU

% the number of time instances
L                                   = size(x, 2);

% find out if we need to store pdist_v
if sys_info.ode_order == 2,     has_align  = ~isempty(learning_info.Abasis_info);
elseif sys_info.ode_order == 1, has_align  = false;                                             end

% prepare storage
pdist_x                             = cell(sys_info.K,sys_info.K);
if has_align,   pdist_v             = cell(sys_info.K,sys_info.K);
else,           pdist_v             = [];                                                       end
Rs                                  = zeros(sys_info.K, sys_info.K, L);

% Memory allocation
for k_1 = 1 : sys_info.K
  for k_2 = 1 : sys_info.K                                                                        % Some duplication here, but useful for future extensions
    if k_1 == k_2            
      if agents_info.num_agents(k_1) > 1                
        pdist_x{k_1, k_2}       = zeros( nchoosek(agents_info.num_agents(k_1),2),L );       % allocate pairwise distances
        if has_align
            pdist_v{k_1, k_2}   = zeros( nchoosek(agents_info.num_agents(k_1),2),L );
        end
      else                                                                                    % no distances                
          pdist_x{k_1, k_2}                   = [];
          if has_align,   pdist_v{k_1, k_2}   = [];                                       end
      end
    else                                                                                        % agents in different classes
      pdist_x{k_1, k_2}           = zeros(agents_info.num_agents(k_1) * agents_info.num_agents(k_2), L);
      if has_align
          pdist_v{k_1, k_2}       = zeros(agents_info.num_agents(k_1) * agents_info.num_agents(k_2), L);
      end
    end
  end
end

pair_dist_x                 = zeros(sys_info.N,sys_info.N,L);
for l = 1:L                                                                                         % go through observations through time and compute pairwise distances
    x_at_t                  = reshape(x(:, l), [sys_info.d, sys_info.N]);
    pair_dist_x(:,:,l)      = squareform(pdist(transpose(x_at_t)), 'tomatrix');
end
if has_align
    pair_dist_v             = zeros(sys_info.N,sys_info.N,L);
    for l = 1:L                                                                                     % go through observations through time and compute pairwise distances
        v_at_t              = reshape(v(:, l), [sys_info.d, sys_info.N]);
        pair_dist_v(:,:,l)  = squareform(pdist(transpose(v_at_t)), 'tomatrix');
    end
end

for l = 1:L                                                                                         % re-format pairwise distances
    for k_1 = 1 : sys_info.K
        for k_2 = 1 : sys_info.K
            pair_dist_x_Ck1_Ck2     = pair_dist_x(agents_info.idxs{k_1}, agents_info.idxs{k_2});
            if has_align
                pair_dist_v_Ck1_Ck2 = pair_dist_v(agents_info.idxs{k_1}, agents_info.idxs{k_2});
            end            
            if k_1 == k_2
                if agents_info.num_agents(k_1) > 1
                    pdist_x{k_1, k_2}(:, l)     = squareform(pair_dist_x_Ck1_Ck2, 'tovector');
                    if has_align
                        pdist_v{k_1, k_2}(:, l) = squareform(pair_dist_v_Ck1_Ck2, 'tovector');
                    end
                end
            else                
                pdist_x{k_1, k_2}(:, l)                 = pair_dist_x_Ck1_Ck2(:);                   % for agents in different classes, simply resize
                if has_align, pdist_v{k_1, k_2}(:, l)   = pair_dist_v_Ck1_Ck2(:);               end
            end            
            Rs(k_1, k_2,l)            = max(max(pair_dist_x_Ck1_Ck2));                         % save the maximum radius
        end
    end
end

Rs = max(Rs, [], 3); Rs(Rs == 0) = 1;

return