function m = sqdist_mod(p, q, A)
% SQDIST          Squared Euclidean or Mahalanobis distance.
% SQDIST(p, q)    returns m(i,j) = (p(:,i) - q(:,j))'*(p(:,i) - q(:,j)).
% SQDIST(p, q, A) returns m(i,j) = (p(:,i) - q(:,j))'*A*(p(:,i) - q(:,j)).

% Written by Tom Minka, small modifications by Mauro Maggioni, further
% modification by Ming Zhong


[~, pn]               = size(p);
if nargin==1
  qn                  = pn;
else
  [~, qn]             = size(q);
end

if pn == 0 || qn == 0
  m                   = zeros(pn,qn);
  return
end

if nargin == 1
%  pmag                = col_sum(p .* p);
  pmag                = sum(p .* p, 1);
  qmag                = pmag;
  m                   = abs(repmat(qmag, pn, 1) + repmat(pmag', 1, qn) - 2*(p')*p); 
  m(1 : qn + 1 : end) = 0;
elseif nargin == 2    
%   pmag                = col_sum(p .* p);
%   qmag                = col_sum(q .* q);
  pmag                = sum(p .* p, 1);
  qmag                = sum(q .* q, 1);  
  m                   = abs(repmat(qmag, pn, 1) + repmat(pmag', 1, qn) - 2*p'*q);
%   m                   = ones(pn,1)*qmag + pmag'*ones(1,qn) - 2*p'*q;    
else    
%   Ap                  = A*p;
%   Aq                  = A*q;
%   pmag                = col_sum(p .* Ap);
%   qmag                = col_sum(q .* Aq);
  pmag                = sum(p .* A * p, 1);
  qmag                = sum(q .* A * q, 1);
  m                   = abs(repmat(qmag, pn, 1) + repmat(pmag', 1, qn) - 2*p'*Aq);   
end
end