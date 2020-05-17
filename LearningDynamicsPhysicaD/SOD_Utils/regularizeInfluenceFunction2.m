function phiReg = regularizeInfluenceFunction2(phi, basis, learn_info)
% function phiReg = regularizeInfluenceFunction2(phi, basis, learn_info)

% (C) M. Zhong

K                  = size(phi, 1);
phiReg             = cell(size(phi));
for k1 = 1 : K
  for k2 = 1 : K
    phiReg{k1, k2} = regularizeInfluenceFunction_each_kind(phi{k1, k2}, basis{k1, k2}, learn_info);
  end
end
end