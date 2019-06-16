function new_pair_dist = resize_cell(pair_dist, num_classes)
%
%

% (c) Ming Zhong, Mauro Maggioni, JHU

num_MCs                               = length(pair_dist);                                          % number of Monte Carlo (MC) realizations
new_pair_dist                         = cell(num_classes);                                          % prepare the storage for the new pair_dist, in terms of number of classes
for MC_ind = 1 : num_MCs                                                                            % go through each MC realization
    all_pair_dist                       = pair_dist{MC_ind};                                        % find out the pair_dist for all classes
    for k_1 = 1 : num_classes                                                                       % re-distribute them in the new_pair_dist, go through each (C_k1, C_k2) pair
        for k_2 = 1 : num_classes
            if MC_ind == 1                                                                          % when it is the first time, initialize the storage
                new_pair_dist{k_1, k_2}       = cell(1, num_MCs);
            end
            new_pair_dist{k_1, k_2}(MC_ind) = all_pair_dist(k_1, k_2);                              % save it
        end
    end
end

return