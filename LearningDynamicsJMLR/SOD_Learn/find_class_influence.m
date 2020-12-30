function class_influence = find_class_influence( psis, pdist_data, regulation, pdiff_data, d, num_agents, kappa, ISSPARSE)
% function class_influence = find_class_influence( psis, pdist_data, regulation, pdiff_data, d, num_agents, kappa)

% (c) M. Maggioni, Ming Zhong

if nargin<8, ISSPARSE   = false; end

DEBUG                   = false;                                                                    % to check that fast code gives same result as previous code
FLAG                    = 1;

n                       = length(psis.f);                                                           % find out the number of basis functions
num_rows                = size(pdist_data, 1);
num_cols                = size(pdist_data, 2);
maxidx                  = [];

if FLAG == 1 || DEBUG
    if DEBUG, Timings.Code1 = tic; end
    
    [pdist_data_sorted,pdist_data_sorted_idxs]  = sort(pdist_data(:));                               % Bin the distance data based on the supports of the basis functions
    pdist_counts                                = histcounts(pdist_data_sorted, psis.knots);
    populatedBins                               = find(pdist_counts > 0);
    pdist_counts_cumsum                         = cumsum(pdist_counts)';
    sz_class_influence                          = [size(pdiff_data, 1), n];
    if ISSPARSE
        i                                       = zeros(prod(sz_class_influence),1);
        j                                       = zeros(prod(sz_class_influence),1);
        s                                       = zeros(prod(sz_class_influence),1);
        i_cur                                   = 1;
    else
        class_influence2                        = zeros(sz_class_influence);                         % allocate storage for class_influence, vs and vprimes
    end
    
    for p = d:-1:1
        pdiff_data_d_tmp                         = pdiff_data(p:d:end,:);
        pdiff_data_d{p}                          = reshape(pdiff_data_d_tmp(pdist_data_sorted_idxs), size(pdiff_data_d_tmp));
    end
    
    for k = 1:length(populatedBins)                                                                   % go through bins in distance space
        if k==1
            idxs                                   = 1:pdist_counts_cumsum(populatedBins(k));             % distances in the current bin
            idxs                                   = idxs';
        else
            idxs                                   = pdist_counts_cumsum(populatedBins(k-1)):pdist_counts_cumsum(populatedBins(k));% distances in the current bin
        end
        f_idxs                                   = find( psis.knotIdxs == populatedBins(k) );           % functions supported in the current bin
        for kp = 1:length(f_idxs)
            psi_of_r_idxs                          = psis.f{f_idxs(kp)}(pdist_data_sorted(idxs));
            psi_of_r_idxs                          = psi_of_r_idxs * (kappa/num_agents);                  % scale the influence from basis function properly
            if ~isempty(regulation), psi_of_r_idxs = psi_of_r_idxs .* regulation;   end                   % add regulation factor
            
            [idxsI,idxsJ]                          = ind2sub([num_rows, num_cols],pdist_data_sorted_idxs(idxs));
            
            for p = 1:d                                                                                   % multiply basis function by difference vectors
                infl_tmp                             = psi_of_r_idxs.*reshape(pdiff_data_d{p}(idxs),size(psi_of_r_idxs));
                infl_tmp_mat                         = sparse(idxsI,idxsJ,infl_tmp,num_rows,num_cols);
                if ISSPARSE
                    itmp                            = p:d:sz_class_influence(1);
                    i(i_cur:i_cur+length(itmp)-1)   = itmp;
                    j(i_cur:i_cur+length(itmp)-1)   = f_idxs(kp);
                    s(i_cur:i_cur+length(itmp)-1)   = sum(infl_tmp_mat, 2);
                    i_cur                           = i_cur+length(itmp);
                else
                    class_influence2(p:d:end,f_idxs(kp)) = sum(infl_tmp_mat, 2);                                % sum over the class C_{k_2} for all i' in C_{k_2} and scaled by the modifier
                end
            end
        end
        maxidx = max(maxidx,max(f_idxs));
    end
    if ISSPARSE
        i(i_cur:end) = [];  j(i_cur:end) = [];  s(i_cur:end) = [];
        class_influence2 = sparse(i,j,s,sz_class_influence(1),sz_class_influence(2));
    end
    
    if FLAG == 1,   class_influence = class_influence2; end
end


if FLAG == 0 || DEBUG
    Timings.Code0               = tic;
    class_influence             = zeros(size(pdiff_data, 1), n);                                    % allocate storage for class_influence, vs and vprimes
    psi_pdist                   = cell(1, n);
    dpsi_pdist                  = cell(1, n);
    
    for k = 1:n                                                                                     % now we can go through each basis functions; only do it for the number of agents in this class is greater than 1
        [psi_of_r, dpsi_of_r]   = psis.f{k}(pdist_data);                                            % calculate \psi_{\l}(|x_{i'}(t_l) - x_i(t_l)|) and its derivative
        psi_pdist{k}            = psi_of_r;                                                         % save the basis functiona and derivative values for adaptive learning
        dpsi_pdist{k}           = dpsi_of_r;
        psi_of_r                = psi_of_r * (kappa/num_agents);                                    % scale the influence from basis function properly
        if ~isempty(regulation), psi_of_r   = psi_of_r .* regulation;   end                         % now time to regulate the interaction
        psi_influence           = kron(psi_of_r,ones(d,1)).*pdiff_data;                             % To save memory: for k = 1:d, psi_influence(k:d:end,:) = psi_of_r.*pdiff_data(k:d:end,:);end
        class_influence(:, k)   = sum(psi_influence, 2);                                            % sum over the class C_{k_2} for all i' in C_{k_2} and scaled by the modifier
    end
    Timings.Code0 = toc(Timings.Code0);
    
    if DEBUG
        Timings.Code1 = toc(Timings.Code1);
        fprintf('\n\t find_class_influence: Diff. =%f, speedup= %f',max(max(abs(class_influence-class_influence2))), Timings.Code0/Timings.Code1);
    end
end

return




