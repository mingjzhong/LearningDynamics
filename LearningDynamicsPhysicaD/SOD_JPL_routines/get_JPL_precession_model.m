function [theBeta, theBetaCI, cost] = get_JPL_precession_model(ts, thetas, PI_info)
% function [theBeta, theBetaCI, cost] = get_JPL_precession_model(ts, thetas, PI_info)

% (C) M. Zhong

max_iter_num              = 10000;
tol                       = 1e-10;
switch PI_info.the_model
  case 'linear'
    model_func            = @(beta, t) beta(1) + beta(2) * t;
    beta0                 = ones(2, 1);       
  case 'quadratic'
    model_func            = @(beta, t) beta(1) + beta(2) * t + beta(3) * t.^2;
    beta0                 = ones(3, 1);    
  case 'cubic'
    model_func            = @(beta, t) beta(1) + beta(2) * t + beta(3) * t.^2 + beta(4) * t.^3;
    beta0                 = ones(4, 1);        
  otherwise
    if isfield(PI_info, 'num_terms') && ~isempty(PI_info.num_terms)
      num_terms           = PI_info.num_terms;
    else
      num_terms           = 2;
    end
    num_peri_terms        = floor((length(thetas) - num_terms)/3);
    if num_peri_terms > 14, num_peri_terms = 14; end
    model_func            = @(beta, t) JPL_periodic_precession_model(beta, t, num_terms, ...
                            num_peri_terms);
    beta0                 = ones(num_terms + num_peri_terms * 3, 1);
end
if ~isfield(PI_info, 'solver_type') || isempty(PI_info.solver_type) || ...
     ~strcmp(PI_info.solver_type, 'fminsearch')
% nlinfit and fminsearch (given in the next block) uses the same least-sqaure cost function   
% fitnlm uses nlinfit
  if ~iscolumn(ts), ts = ts'; end
  if ~iscolumn(thetas), thetas = thetas'; end
  options                 = statset('MaxIter', max_iter_num, 'TolFun', tol, 'TolX', tol, ...
                               'Display', 'off');
  [theBeta, R, J, ~, MSE] = nlinfit(ts, thetas, model_func, beta0, options);                       
  cost                    = MSE;
  theBetaCI               = nlparci(theBeta, R, 'jacobian', J);
else
  if ~iscolumn(ts), ts = ts'; end
  if ~iscolumn(thetas), thetas = thetas'; end  
  fcost                   = @(beta) sum((model_func(beta, ts) - thetas).^2);
  options                 = optimset('TolFun', tol, 'TolX', tol, 'MaxFunEvals', max_iter_num, ...
                               'MaxIter', max_iter_num, 'Display', 'off');
  theBeta                 = fminsearch(@(beta) fcost(beta), beta0, options);    
  cost                    = fcost(theBeta)/length(ts);
  theBetaCI               = [];
% how to calculate confidence interval from regression, when fminsearch is used? 
end
end