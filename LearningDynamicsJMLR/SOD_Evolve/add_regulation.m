function phis_of_pdist = add_regulation(x, v, xi, phis_of_pdist, sys_info, type)
% function phis_of_pdist = add_regulation(x, v, xi, phis_of_pdist, sys_info, type)
%   modifies the phis_of_pdist with regulation based on the system information
% IN:
%   x             : x_i's, state of agents (position, opinions, etc.)
%   v             : \dot{x}_i's, derivative of the state
%   xi            : \xi_i's, interaction with the environment or emotion (fear, etc.)
%   phis_of_pdist : \phi_{k1, k2}(|x_i - x_i'|)
%   sys_info      : struct which contains necessary information of the system
%   type          : type of the regulation (energy, alignment or xi based)
% OUT:
%   phis_of_pdist :

% (c) M. Zhong, JHU

% find out the regulation to constrain the dynamics based on type
switch type                                                                                         
  case 'energy'
    if ~isempty(sys_info.RE)
      regulation = sys_info.RE(x);                                                                  % energy based regulation depends only on x
    else
      regulation = [];
    end
  case 'alignment'
    if ~isempty(sys_info.RA)
      regulation = sys_info.RA(x, v);                                                               % alignment based regulation depends on x and v
    else
      regulation = [];
    end
  case 'xi'
    if ~isempty(sys_info.Rxi)
      regulation = sys_info.Rxi(x, xi);                                                             % xi based regulation depends on x and xi
    else
      regulation = [];
    end
  otherwise
end
% modify each phi_of_pdist if there is any regulation
if ~isempty(regulation), phis_of_pdist  = phis_of_pdist .* regulation; end
end