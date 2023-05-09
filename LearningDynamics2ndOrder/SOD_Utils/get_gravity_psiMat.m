function psiMat = get_gravity_psiMat(psis, rq)
% function psiMat = get_gravity_psiMat(psis, rq)

% (C) M. Zhong
          
n                = length(psis);
Q                = length(rq);
if ~iscolumn(rq), rq = rq'; end
psiMat           = zeros(Q, n);
for eta = 1 : n
  psiMat(:, eta) = psis{eta}(rq);
end
end