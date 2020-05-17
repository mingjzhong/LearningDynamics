function the_rhoLT = get_the_rhoLT(rhoLT, type)
% function the_rhoLT = get_the_rhoLT(rhoLT, type)

% (C) M. Zhong

switch type
  case 'energy'
    the_rhoLT   = rhoLT{1};
  case 'alignment'
    the_rhoLT   = rhoLT{2};
  case 'xi'
    if length(rhoLT) > 2
      the_rhoLT = rhoLT{3};
    else
      the_rhoLT = rhoLT{2};
    end
  otherwise
    error('SOD_Learn:find_the_rhoLT:exception', 'only 3 specific kinds of rhoLT are supported!!');
end
end