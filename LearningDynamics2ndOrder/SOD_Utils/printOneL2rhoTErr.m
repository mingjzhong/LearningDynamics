function printOneL2rhoTErr(K, Err, ErrSmooth, ErrClean, basis, kind)
% function printIntKerErr_kind(sys_info.K, Err, ErrSmooth, ErrClean, basis, kind)

% (c) M. Zhong
fprintf('\n------------------- %8s Based Interaction L2(rho_T) Errors:', kind);
fprintf('\n\tBasis Information:')
if ~isempty(basis)
  for k1 = 1 : K
    for k2 = 1 : K
      fprintf('\n\t\tFor (%d, %d)-interaction:', k1, k2);
      [type, degree, n, supp]   = get_output_from_basis_info(basis{k1, k2});
      fprintf('\n\t\tn = %s, degree = %s.', n, degree);
      fprintf('\n\t\ttype = %s.', type);
      fprintf('\n\t\tsupp = %s.', supp);
    end
  end
end
fprintf('\n\tRelative L_2(rho_T) errors:');
for k1 = 1 : K
  for k2 = 1 : K
    fprintf('\n\t\tFor original \\hat\\phi_{%d, %d}, Err = %10.4e%c%10.4e.', k1, k2, ...
      mean(cellfun(@(x) x.Rel(k1, k2), Err)), 177, std(cellfun(@(x) x.Rel(k1, k2), Err)));
    if ~isempty(ErrSmooth)
      fprintf('\n\t\tFor smooth   \\hat\\phi_{%d, %d}, Err = %10.4e%c%10.4e.', k1, k2, ...
        mean(cellfun(@(x) x.Rel(k1, k2), ErrSmooth)), 177, std(cellfun(@(x) x.Rel(k1, k2), ErrSmooth)));
    end
    if ~isempty(ErrClean)
     fprintf('\n\t\tFor clean    \\hat\\phi_{%d, %d}, Err = %10.4e%c%10.4e.', k1, k2, ...
       mean(cellfun(@(x) x.Rel(k1, k2), ErrClean)), 177, std(cellfun(@(x) x.Rel(k1, k2), ErrClean)));       
    end
  end
end
fprintf('\n\tAbsolute L_2(rho_T) errors:')
for k1 = 1 : K
  for k2 = 1 : K
    fprintf('\n\t\tFor original \\hat\\phi_{%d, %d}, Err = %10.4e%c%10.4e.', k1, k2, ...
      mean(cellfun(@(x) x.Abs(k1, k2), Err)), 177, std(cellfun(@(x) x.Abs(k1, k2), Err)));
    if ~isempty(ErrSmooth)
      fprintf('\n\t\tFor smooth   \\hat\\phi_{%d, %d}, Err = %10.4e%c%10.4e.', k1, k2, ...
        mean(cellfun(@(x) x.Abs(k1, k2), ErrSmooth)), 177, std(cellfun(@(x) x.Abs(k1, k2), ErrSmooth)));
    end
    if ~isempty(ErrClean)
     fprintf('\n\t\tFor clean    \\hat\\phi_{%d, %d}, Err = %10.4e%c%10.4e.', k1, k2, ...
       mean(cellfun(@(x) x.Abs(k1, k2), ErrClean)), 177, std(cellfun(@(x) x.Abs(k1, k2), ErrClean)));       
    end
  end
end
end