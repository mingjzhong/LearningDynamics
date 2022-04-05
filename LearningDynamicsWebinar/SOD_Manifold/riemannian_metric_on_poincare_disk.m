function G = riemannian_metric_on_poincare_disk(x, d)
% function G = riemannian_metric_on_poincare_disk(x, d)

% (C) M. Zhong

% the Riemannian metric on Poincare Disk is:
% gij = 4\delta_ij/(1 - x_1^2 - \cdots - x_n^2)^2
N     = size(x, 2);
I_mat = eye(d);
G     = repmat(I_mat(:)', [1, N]) .* kron(4./(1 - sum(x.^2)).^2, ones(1, d^2)); 
end