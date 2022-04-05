function y_t = single_bdf_step_dense(t_prevs, y_prevs, t)
% function y_t = single_bdf_step_dense(t_prevs, y_prevs, t)
% continuous extension for BD (Backward Differentiation) method, for t \in [t_n, t_{n -1}],
% use the interpolating polynomial of order k at the points (t_n, y_n), (t_{n - 1}, y_{n - 1}),
% \ldots, (t_{n - k}, y_{n - k}).
% refer to the paper, Dense Output, by L. F. Shampine and L. O. Jay, 
% link: http://homepage.divms.uiowa.edu/~ljay/publications.dir/EACM_Dense_Output.pdf
% on page: 340, section: linear multistep methods, backward differentiation method

% (C) M. Zhong

% let \vec{P}(t) = \sum_{j = 0}^{j = k} \vec{y}_{n - j} L_j(t), where L_j is a Lagrange polynomial
% interpolating the time points \vec{ts} = (t_n, t_{n - 1}, \ldots, t_{n - k}) to \vec{e}_j, where
% \vec{e}_0 = (1, 0, \ldots, 0), \vec{e}_1 = (0, 1, 0, \ldots, 0), and \vec{e}_k = (0, \ldots, 0, 1)
% and they are all of the same size (k + 1)-by-1.  How to find L_j(t)?  we use Vandermonde matrix
% each L_j(t) can be expressed as: L_j(t) = l^j_1 * t^k + l^j_2 * t^{k - 1} + \cdots + l^j_k * t +
% l^j_{k + 1}, and L_j maps \vec{ts} to \vec{e}_j, hence
% V(ts) * \vec{L}^j = \vec{e}_j for j = 0, \ldots, k.  Hence V(ts) * L_mat = I_{(k + 1) * (k + 1)}
% V(ts) is the Vandermonde matrix of (t_n, t_{n - 1}, \ldots, t_{n - k}), L_mat = [\vec{l}^0,
% \vec{l}^1, \ldots, \vec{l}^k], where \vec{l}^j = [l^j_l; l^j_2; \vdots, l^j_{k + 1}].
% Hence L_mat = V(ts)^{-1} (should have no trouble inverting it?? big condition number??)
% L_j(t) = [t^k, t^{k - 1}, \ldots, t, 1] * \vec{l}^j, so
% [L_0(t), L_1(t), \ldots, L_k(t)] = [t^k, t^{k - 1}, \ldots, t, 1] * L_mat
k       = length(t_prevs)  - 1;
V_t     = vander(t_prevs);
t_vec   = t.^(k : -1 : 0);
L_t_vec = (t_vec * pinv(V_t))';
L_t_mat = spdiags(L_t_vec, 0, k + 1, k + 1);
y_t     = sum(y_prevs * L_t_mat, 2);
end