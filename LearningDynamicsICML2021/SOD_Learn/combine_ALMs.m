function ALMEA = combine_ALMs(ALME, ALMA)
% function ALMEA = combine_ALMs(ALME, ALMA)

% (C) M. Zhong

ALMEA = cell(size(ALME));
for k = 1 : length(ALME)
  ALMEA{k} = [ALME{k}, ALMA{k}];
end
end