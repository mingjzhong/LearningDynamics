function data_deriv = reg_diff(data, time_vec, lambda, max_diff_iters, ...
           epsilon, type)
%
%
%

% Ming Zhong
% Postdoc Research at JHU

% find out the size of data
n                 = length(data);
% Construct antidifferentiation operator: A * u = \int_0^x u(t) dt
A                 = @(x) cumsum(x);
% the adjoint of A: A^* * u = \int_x^L u(t) dt = \int_0^L u(t) dt - A * u
A_adj             = @(x) (sum(x) * ones(length(x), 1) - [0; cumsum(x(1 : end - 1))]);
% Construct backward differentiation matrix
D                 = backward_differencing_matrix(time_vec);
% the tranpose (Hermitian conjugate) of D
D_trans           = D';
% Since Au(0) = \int_0^0 u(d) dt = 0, we need to adjust.
data              = data - data( 1 );
% Default initialization is naive derivative.
u_0               = D * data;
% 
u                 = u_0;
% precompute A^*(u)
A_adj_of_data     = A_adj(data);
% Main loop
for iter = 1 : max_diff_iters
% pick a L matrix based on the type
  if strcmp(type, 'TV-diff')
% Diagonal matrix of weights, for linearizing E-L equation: 
% 1/(|u'| + \epsilon)
    Q             = spdiags(1./sqrt((D * u).^2 +  epsilon), 0, n, n );
% Linearized diffusion matrix, also approximation of Hessian.
    L             = D_trans * Q * D;
  elseif strcmp(type, 'H1-diff')
% then d/dx (2 * u')    
    L             = D_trans * 2 * D;
  end
% Gradient of functional.
  g               = A_adj(A(u)) - A_adj_of_data + lambda * L * u;
% Build preconditioner, as the sum of \lambda * L + a diagonal matrix,
% whose diagonal entries are the row sums of A^* * A, which is,
% analytically:
% the first  entry: 1 + 2 + ... + n - 2 + n - 1 + n
% the second entry: 1 + 2 + ... + n - 2 + n - 1
% the third  entry: 1 + 2 + ... + n - 2
% the last   entry: 1
  c               = cumsum(n : -1 : 1).';
  B               = lambda * L + spdiags(c(end : -1 : 1), 0, n, n);
% do a incomplete Cholesky factorization on B for preconditioning
  opts.type       = 'ict';
  opts.droptol    = 1.0e-2;
  R               = ichol(B, opts);
% Prepare to solve linear equation using pcg
  tol             = 1.0e-2;
  maxit           = 100;
% find the descent direction
  s               = pcg(@(x) (lambda * L * x + A_adj(A(x))), -g, tol, ...
    maxit, R', R);
% Update current solution
  u               = u + s;
end 
% save u
data_deriv        = u;