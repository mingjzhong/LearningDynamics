function [name, J, K, S, T_f] = SOD_get_params(kind)
% function [name, J, K, S, T_f] = SOD_get_params(kind)

% (C) M. Zhong

switch kind
% case 1 - 3 in Fig. 2 on page 4 of ''oscilators that sync and swarm''
  case 1
    name = 'static sync';
    J    = 0.1;
    K    = 1;
    S    = -1;
    T_f  = 100; 
  case 2
    name = 'static async';
    J    = 0.1;
    K    = -1;
    S    = 0;
    T_f  = 100; 
  case 3
    name = 'static phase wave';
    J    = 1;
    K    = 0;
    S    = 1;
    T_f  = 100; 
% case 4 - 5 in Fig. 5 on page 6 of ''oscilators that sync and swarm''
  case 4
    name = 'splintered phase wave';
    J    = 1;
    K    = -0.1;
    S    = [];
    T_f  = 1000; 
  case 5
    name = 'active phase wave';
    J    = 1;
    K    = -0.75;
    S    = [];
    T_f  = 1000; 
  otherwise
    error('SOD_Examples:SOD_get_params:exception', 'Only 5 different states are considered!!');
end
end