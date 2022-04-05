function [betas, phim_vec, rq, Info] = decouple_phim_and_betas(N, method, options, type, gravity_items)
% function [betas, phim_vec, rq, Info] = decouple_phim_and_betas(N, method, options, type, gravity_items)

% (C) M. Zhong

% initialize items
rq                          = gravity_items.rq;
Q                           = length(rq);
obj_func                    = @(x) total_loss_function_on_beta_and_phim(x, gravity_items, type);   
switch type
  case 'first'
    x0                      = ones(1 + Q, 1)/(1 + Q);
    [A, B, LB]              = get_fmincon_constrains(1, Q, method);    
  case 'second'
    x0                      = ones(N - 1, 1)/(N - 1);
    [A, B, LB]              = get_fmincon_constrains(N - 1, 0, method);      
  otherwise
end
% [x, fval, exitflag, output, lambda, grad, hessian] => lambda, grad and hessian are not needed
[x, fval, exitflag, output] = fmincon(obj_func, x0, A, B, [], [], LB, [], [], options);  
if strcmp(type, 'first')
  betas                     = x(1);
  phim_vec                  = x(2 : end);
else
  betas                     = x;
  phim_vec                  = [];
end
Info.fval                   = fval;
Info.exitflag               = exitflag;
Info.output                 = output;                                 
end