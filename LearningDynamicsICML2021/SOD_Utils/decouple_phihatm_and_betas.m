function [betas, phihatm_vec, rq, Info] = decouple_phihatm_and_betas(N, kp, method, options, ...
                                          type, gravity_items, Estimator)
% function [betas, phihatm_vec, rq, Info] = decouple_phihatm_and_betas(N, kp, method, options, ...
%                                           type, gravity_items, Estimator)

% (C) M. Zhong

% start the timer
% Optimization Approach to de-couple beta_{kp} and phihat_m(rq) from phihat_{k, kp}(rq)
if kp > 1
  phihatm                   = gravity_items.phihatm;
  gravity_items             = generateGravityMat_by_kp(kp, Estimator);
end
rq                          = gravity_items.rq;
gravity_items.kp            = kp;
Q                           = length(rq);
obj_func                    = @(x) total_loss_function_on_phihats(x, gravity_items, type);   
switch type
  case 'first'
    if kp == 1
      x0                    = ones(N + Q, 1)/(N + Q);
    else
      x0                    = zeros(N + Q, 1);
      x0(1 : N)             = ones(N, 1)/N;
      x0(N + 1 : N + Q)     = phihatm(rq);
    end
    [A, B, LB]              = get_fmincon_constrains(N, Q, method);    
  case 'second'
    x0                      = ones(N, 1)/N;
    [A, B, LB]              = get_fmincon_constrains(N, 0, method);      
  otherwise
end
% [x, fval, exitflag, output, lambda, grad, hessian] => lambda, grad and hessian are not needed
[x, fval, exitflag, output] = fmincon(obj_func, x0, A, B, [], [], LB, [], [], options);  
betas                       = x(1 : (N - kp + 1));
if strcmp(type, 'first')
  phihatm_vec               = x((N - kp + 2) : (N - kp + 1 + Q));
else
  phihatm_vec               = [];
end
Info.fval                   = fval;
Info.exitflag               = exitflag;
Info.output                 = output;                                 
end