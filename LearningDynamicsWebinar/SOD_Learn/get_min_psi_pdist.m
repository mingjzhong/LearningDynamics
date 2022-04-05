function the_min = get_min_psi_pdist(k1, Nk1, k2, Nk2, psi_pdist)
% function the_min = get_min_psi_pdist(k1, Nk1, k2, Nk2, psi_pdist)

% (C) M. Zhong

if k1 == k2
  if Nk1 > 1 || Nk2 > 1
    the_min = min(get_rid_of_diagonal(psi_pdist));
  else
    the_min = 0;
  end
else
  the_min   = min(psi_pdist(:));
end
end