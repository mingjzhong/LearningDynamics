function the_max = get_max_psi_pdist(k1, Nk1, k2, Nk2, psi_pdist)
% function the_max = get_max_psi_pdist(k1, Nk1, k2, Nk2, psi_pdist)

% (C) M. Zhong

if k1 == k2
  if Nk1 > 1 || Nk2 > 1
    the_max = max(get_rid_of_diagonal(psi_pdist));
  else
    the_max = 1;
  end
else
  the_max   = max(psi_pdist(:));
end
end