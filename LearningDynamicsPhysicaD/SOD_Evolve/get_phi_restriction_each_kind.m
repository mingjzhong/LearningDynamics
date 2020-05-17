function phi_rest = get_phi_restriction_each_kind(x, v, xi, sys_info, type)
% function phi_rest = get_phi_restriction_each_kind(x, v, xi, sys_info, type)
%   modifies the phis_of_pdist with regulation based on the system information
% IN:
%   x             : x_i's, state of agents (position, opinions, etc.)
%   v             : \dot{x}_i's, derivative of the state
%   xi            : \xi_i's, interaction with the environment or emotion (fear, etc.)
%   sys_info      : struct which contains necessary information of the system
%   type          : type of the regulation (energy, alignment or xi based)
% OUT:
%   phi_res :

% (c) M. Zhong, JHU

% find out the regulation to constrain the dynamics based on type
switch type                                                                                         
  case 'energy'
    if isfield(sys_info, 'RE') && ~isempty(sys_info.RE)
      phi_rest = sys_info.RE(x, sys_info);                                                           % energy based regulation depends only on x
    else
      phi_rest = [];
    end
  case 'alignment'
    if isfield(sys_info, 'RA') && ~isempty(sys_info.RA)
      phi_rest = sys_info.RA(x, v, sys_info);                                                        % alignment based regulation depends on x and v
    else
      phi_rest = [];
    end
  case 'xi'
    if isfield(sys_info, 'Rxi') && ~isempty(sys_info.Rxi)
      phi_rest = sys_info.Rxi(x, xi, sys_info);                                                      % xi based regulation depends on x and xi
    else
      phi_rest = [];
    end
  otherwise
end
end