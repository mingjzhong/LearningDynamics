function the_rhoLT = get_the_rhoLT(rhoLT, sys_info, type)
% function the_rhoLT = get_the_rhoLT(rhoLT, sys_info, type)

% (C) M. Zhong

if ~isempty(rhoLT)
  if sys_info.ode_order == 1
    switch type
      case 'energy'
        the_rhoLT   = rhoLT{1};
      case 'xi'
        the_rhoLT   = rhoLT{2};
      otherwise
        error('SOD_Learn:find_the_rhoLT:exception', 'only 2 specific kinds of rhoLT are supported!!');
    end
  elseif sys_info.ode_order == 2
    switch type
      case 'energy'
        the_rhoLT   = rhoLT{1};
      case 'alignment'
        if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
          the_rhoLT = rhoLT{2};
        else
          the_rhoLT = rhoLT{1};
        end
      case 'xi'
        the_rhoLT   = rhoLT{end};
      otherwise
        error('SOD_Learn:find_the_rhoLT:exception', 'only 3 specific kinds of rhoLT are supported!!');
    end
  end
else
  the_rhoLT = [];
end
end