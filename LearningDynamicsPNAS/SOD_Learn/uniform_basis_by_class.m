function basis = uniform_basis_by_class(Rs, K, basis_info)

%
% [all_basis, knot_vecs] = uniform_basis_by_class(Rs, num_classes, basis_info)
%

% (c) Ming Zhong, Mauro Maggioni, JHU

if size(Rs,1)<K,    Rs = Rs*ones(K,K);  end

if ~isempty(basis_info)
    basis                   = cell(K);                                                               % the basis for each class
    for k_1 = 1 : K                                                                                  % construct the basis
        for k_2 = 1 : K
            b                     = Rs(k_1, k_2);                                                   % the right end point of the learning interval
            p                     = basis_info.degree(k_1, k_2);                                    % the degree of the basis functions
            num_basis_funs        = basis_info.n(k_1, k_2);                                         % find out the number of basis functions for this class-class interaction
            basis{k_1,k_2}        = uniform_basis(b, p, num_basis_funs, basis_info);                % construct a basis for this class_{s_1} to class_{s_2} interaction
            basis{k_1,k_2}.degree = p;
            basis{k_1,k_2}.Rmax   = Rs(k_1,k_2);                                                    % TBD
        end
    end
else
    basis                   = [];
end

return