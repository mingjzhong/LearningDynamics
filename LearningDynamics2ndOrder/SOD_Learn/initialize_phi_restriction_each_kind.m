function phi_rest = initialize_phi_restriction_each_kind(kind, sys_info)
% function phi_rest = initialize_phi_restriction_each_kind(kind, sys_info)

% (C) M. Zhong

phi_rest       = [];
switch kind
  case 'energy'
    if isfield(sys_info, 'RE') && ~isempty(sys_info.RE)
      phi_rest = cell(sys_info.K);
    end    
  case 'alignment'
    if isfield(sys_info, 'RA') && ~isempty(sys_info.RA)
      phi_rest = cell(sys_info.K);
    end      
  case 'xi'
    if isfield(sys_info, 'Rxi') && ~isempty(sys_info.Rxi)
      phi_rest = cell(sys_info.K);
    end      
  otherwise
end
end