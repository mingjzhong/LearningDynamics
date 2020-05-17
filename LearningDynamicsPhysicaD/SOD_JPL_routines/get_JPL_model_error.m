function fNs_diff = get_JPL_model_error(xNs, dot_vNs, phihats)
% function fNs_diff = get_JPL_model_error(xjs, xN, dot_vN, phihatiNjs)

% (C) M. Zhong

d                = 3;
N                = size(phihats, 1);
fNs_diff         = cell(1, N);
for idx1 = 1 : N
  fi_model       = zeros(d, size(xNs, 2));
  xi             = xNs((idx1 - 1) * d + 1 : idx1 * d, :);
  for idx2 = 1 : N
    if idx2 ~= idx1
      ind        = (idx2 - 1) * d + 1 : idx2 * d;
      xjmxi      = xNs(ind, :) - xi;
      fi_model   = fi_model + repmat(phihats{idx1, idx2}(sum(xjmxi.^2).^(0.5)), [d, 1]) .* xjmxi;
    end
  end
  fNs_diff{idx1} = dot_vNs((idx1 - 1) * d + 1 : idx1 * d, :) - fi_model;
end
end