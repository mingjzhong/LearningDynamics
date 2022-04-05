function theBool = char2bool(theChar)
% function theBool = char2bool(theChar)

% (C) M. Zhong

switch theChar
  case 'Y'
    theBool = true;
  case 'y'
    theBool = true;
  case 'N'
    theBool = false;
  case 'n'
    theBool = false;
  otherwise
    error('SOD_Utils:char2bool:exception', 'Only accept Inputs of Y, y, N, n!!');
end
end