function [alpha, opt_val, Info] = solve_for_alphas(A, b)
% function [alpha, opt_val, Info] = solve_for_alphas(A, b)

% (c) M. Zhong

% The matrix, A, uses sparse storage, altough A is symmetric, A might become semi-definite, hence we 
% use lsqminnorm, which is more efficient than pinv and gives the same solution as pinvi, to solve 
% for Ax = b, we will not use linsolve/mldivide, since they return different solutions based on the
% matrix being full or not (sparse).
alpha             = lsqminnorm(A, b);  % using the default tolerance based on QR of A
Info.method       = 'lsqminnorm';
Info.relres       = norm(A * alpha - b)/norm(b); 
% calculate <A * alpha_vec, alpha_vec> - 2 <alpha_vec, b>
opt_val           = (A * alpha)' * alpha - 2 * alpha' * b;
if issparse(A)
% condest is roughly the same as cond (it uses L1 norm instead), but the size of A is reasonable, we 
% will change it to be full matrix, otherwise, we will not change the sparse structure.
  if size(A, 1) < 200
    Info.condNum  = cond(full(A));
  else
    Info.condNum  = condest(A);
  end
else
  Info.condNum    = cond(A);
end
% A is real and symmetric (by construction), A is always diagonalizable, hence eig(A) will be used, 
% however eig does not work on sparse matrices, hence eigs will be used. SVD does not work on sparse
% matrices either.
Info.largest_eig  = eigs(A, 1);                    % eigs(A) returns the 6 largest
Info.smallest_eig = Info.largest_eig/Info.condNum; % it might be zero
end
% Old Code:
% The following is outdated:
% % Since A = \sum_{m = 1}^M A_m^T * A_m, A is symmetric, and A_m has no zero columns, 
% % so A is mostly positive definite, however, we will do it based on the condition number of A
% if issparse(A)
%   condNum       = cond(full(A)); % do not want to use condest on sparse A, force A to be full
% else
%   condNum       = cond(A);
% end
% cond_tol        = 1.e8;          % tolerance to consider a system is close to be singular
% % although A can be large, however A is unlikely to be sparse, iterative method is not that
% % efficient, we use either linsolve or lsqminnorm, both methods can handle singular systems,
% % however linsolve (mldivide) will provide sparse solutions instead for singular systems
% if condNum >= cond_tol
% % pinv uses truncated svd, similar accuracy to lsqminnorm, which uses Complete Orthogonal 
% % Decomposition, they both return the same minimizer of \{||Ax - b||_2 with the minimal ||x||_2\}
% % however lsqminnorm is generally considered more efficient than pinv  
%   alpha         = lsqminnorm(A, b);  % using the default tolerance based on QR of A
%   method        = 'lsqminnorm';
%   relres        = norm(A * alpha - b)/norm(b); 
% else
%   if ~issparse(A)
% % mldivide and linsolve return the same solution, mldivide is slower since it does checks on A first
% % however they return the same solution, we use all the known properties on A
%     opts.LT     = false; % Lower Triangular
%     opts.UT     = false; % Upper Triangular
%     opts.UHESS  = false; % Upper Hessenberg
%     opts.SYM    = true;  % Real Symmetric or Complex Hermitian
%     opts.POSDEF = true;  % Positive Definite
%     opts.RECT   = false; % General Rectangular
%     opts.TRANSA = false; % (Conjugate) Transpose of A
%     alpha       = linsolve(A, b, opts);
%     method      = 'linsolve';
%     relres      = norm(A * alpha - b)/norm(b);
%   else
% % linsolve does not work on sparse matrix    
%     method      = 'mldivide';
%     alpha       = mldivide(A, b);
%     relres      = norm(A * alpha - b)/norm(b);
%   end
% end
% % calculate <A * alpha_vec, alpha_vec> - 2 <alpha_vec, b>
% opt_val         = (A * alpha)' * alpha - 2 * alpha' * b;
% end