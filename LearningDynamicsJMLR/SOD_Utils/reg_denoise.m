function data_denoised = reg_denoise(data, time_vec, lambda, max_iters, ...
           epsilon, type)
% data_denoised = reg_denoise(data, time_vec, lambda, max_iters, ...
%   epsilon, type)
% de-nosie a vector data, f, using either the TV-regularization:
% \min\{\lambda * \int_0^T |du/dt|   dt + 1/2 * \int_0^T |u - f|^2 dt\}
% or the H^1-regularization
% \min\{\lambda * \int_0^T |du/dt|^2 dt + 1/2 * \int_0^T |u - f|^2 dt\}

% Ming Zhong
% Postdoc Research at JHU

% find out the length of the data
N                 = length(data);
% construct the backward differencing matrix based on the time instances
D                 = backward_differencing_matrix(time_vec);
% the tranpose (Hermitian conjugate) of D
D_trans           = D';
% Default initialization is the data iself
u_0               = data;
% the starting u
u                 = u_0;
% Main loop
for iter = 1 : max_iters
% pick a L matrix based on the type
  if strcmp(type, 'TV-denoise')
% Diagonal matrix of weights, for linearizing E-L equation: 
% 1/(|u'| + \epsilon), u = u^n
    Q             = spdiags(1./sqrt((D * u).^2 +  epsilon), 0, N, N);
% Linearized diffusion matrix, also approximation of Hessian.
% L * u = d/dt (u'/(|(u^n)'| + \epsilon)
    L             = D_trans * Q * D;
  elseif strcmp(type, 'H1-denoise')
% then L * u = d/dt (2 * u')    
    L             = D_trans * 2 * D;
  end
% Gradient of functional
  g               = lambda * L * u + u - data;
% Build preconditioner, as the sum of \lambda * L + I (the identity)
  B               = lambda * L + spdiags(ones(N, 1), 0, N, N);
% do a incomplete Cholesky factorization on B for preconditioning
  opts.type       = 'ict';
  opts.droptol    = 1.0e-2;
  R               = ichol(B, opts);
% Prepare to solve linear equation using pcg
  tol             = 1.0e-2;
  max_it          = 100;
% find the descent direction
  update_dir      = pcg(@(x) (lambda * L * x + x), -g, tol, max_it, R', R);
% Update current solution
  u               = u + update_dir;
end 
% output the de-noised u
data_denoised     = u;