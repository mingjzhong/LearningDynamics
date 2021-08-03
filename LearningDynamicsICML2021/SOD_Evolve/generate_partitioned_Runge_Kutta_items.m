function [A_tilde, c_vec, b_tilde_vec, b_vec]  = generate_partitioned_Runge_Kutta_items(order)
% function [A_tilde, c_vec, b_tilde_vec, b_vec]  = generate_partitioned_Runge_Kutta_items(order)

% the formula of the items are given by the paper: GniCodes - Matlab Programs for Geometric Numerical
% Integration, E. Hairer, M. Hairer, from Example 2.2
% c_i's are roots of the s_th shifted Legendre polynomial:
% d^s/dx^s(x^s(x - 1)^s)
% a_ij are computed from the linear system
% \sum_{j = 1}^s a_ij c_j^{k - 1} = c_i^k/k, for i, k = 1, \ldots, s
% \hat{b}_i = b_i, \hat{a}_ij = a_ij, \tilde{b}^T = b^T\hat{A} = b^TA, \tilde{A} = A\hat{A} = A^2
% b_i and a_ij (due to symmetric, of equation (2.21), we have
% a_{s + 1 - i, s + 1 - j} + a_{i, j} = b_j, for all i, j
% we take i = 1, and obtain: a_{s, s + 1 - j} + a_{1, j} = b_j for j = 1, \ldots, s
% it has order 2s (which is maximal among all s-stage Runge-Kutta method)
% the roots of the shifted Legendre polynomial uses the following formula:
% syms x
% roots = vpasolve(legendreP(#stages, x) == 0)
% then c_i's = (roots + 1)/2
% they are pre-calculated

% (C) M. Zhong

switch order
  case 2
    roots   = 0;    
  case 4
    roots   = [-0.57735026918962576450914878050196; 
                0.57735026918962576450914878050196];
  case 6
    roots   = [-0.77459666924148337703585307995648; 
                                                 0; 
                0.77459666924148337703585307995648];                                   
  otherwise
% theoretically it can go up to infinite order, however, #stages also increase, hence, we stop at 
% the number of stages = 3 for now
    error('');
end
c_vec       = (roots + 1)/2;
num_stages  = length(c_vec);
C1          = fliplr(vander(c_vec));
ks          = (1 : num_stages)';
C2          = spdiags(c_vec, 0, num_stages, num_stages) * C1 * spdiags(1./ks, 0, num_stages, ...
              num_stages);
A           = C2 / C1;
A_tilde     = A^2;
b_vec       = (A(1, 1 : num_stages) + A(num_stages, num_stages : -1 : 1))';
b_tilde_vec = (b_vec' * A)';
end