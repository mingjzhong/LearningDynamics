function L2rhoTnorm = L2_rhoT_norm(f, rhoT, basis)
% function L2rhoTnorm = L2_rhoT_norm(f, rhoT, basis)

% (C) M. Zhong

if size(f, 1) ~= size(f, 2), error(''); end
L2rhoTnorm               = zeros(size(f));
for k1 = 1 : size(f, 1)
  for k2 = 1 : size(f, 2)
    if ~isempty(rhoT{k1, k2})
      L2rhoTnorm(k1, k2) = L2_rhoTND(f{k1, k2}, rhoT{k1, k2}, basis{k1, k2}.supp);
    end
  end
end
end