function [Ealpha, Aalpha] = split_alpha(alpha, learn_info)
% function [Ealpha, Aalpha] = split_alpha(alpha, learn_info)

% (C) M. Zhong

has_Ebasis = isfield(learn_info, 'Ebasis_info') && ~isempty(learn_info.Ebasis_info);
has_Abasis = isfield(learn_info, 'Abasis_info') && ~isempty(learn_info.Abasis_info);

if has_Ebasis && has_Abasis
  nE     = cellfun(@(x) prod(x.n), learn_info.Ebasis_info);
  nE     = sum(nE(:));
  Ealpha = alpha(1 : nE);
  nA     = cellfun(@(x) prod(x.n), learn_info.Abasis_info);
  nA     = sum(nA(:));
  Aalpha = alpha(nE + 1 : nE + nA);
elseif has_Ebasis && ~has_Abasis
  Ealpha = alpha;
  Aalpha = [];
elseif ~has_Ebasis && has_Abasis
  Ealpha = [];
  Aalpha = alpha;
else
  Ealpha = [];
  Aalpha = [];
end
end