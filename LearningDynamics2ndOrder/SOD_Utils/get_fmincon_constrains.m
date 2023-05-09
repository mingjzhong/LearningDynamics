function [A, B, LB] = get_fmincon_constrains(N, P, method)
% function [A, B, LB] = get_fmincon_constrains(N, P, method)

% (C) M. Zhong

switch method
  case 'trust-region-reflective'
    A      = [];
    B      = [];
    LB     = zeros(N + P, 1);    
  case 'interior-point'
    A      = sparse(zeros(N, N + P));
    ind    = logical(eye(N));
    A(ind) = -1;
    B      = sparse(zeros(N, 1));  
    LB     = [];
  otherwise
    error('');
end
end