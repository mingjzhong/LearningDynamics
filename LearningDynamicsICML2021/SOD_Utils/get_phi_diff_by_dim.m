function phidiff = get_phi_diff_by_dim(phi, phihat, dim)
% function phidiff = get_phi_diff_by_dim(phi, phihat, dim)

% (C) M. Zhong

switch dim
  case 1
    phidiff = @(r)       phi(r)       - phihat(r);   
  case 2
    phidiff = @(r, s)    phi(r, s)    - phihat(r, s);   
  case 3
    phidiff = @(r, s, z) phi(r, s, z) - phihat(r, s, z);   
  otherwise
    error('');
end
end