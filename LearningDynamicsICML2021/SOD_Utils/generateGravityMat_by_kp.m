function output = generateGravityMat_by_kp(kp, Estimator)
% function output = generateGravityMat_by_kp(kp, Estimator)

% (c) M. Zhong (JHU)

N                     = size(Estimator.phiEhat, 1);
if kp > N, error(''); end                                                                           % 1 <= kp <= N
rhoLTE                = Estimator.rhoLTM{1};
rqs                   = cell(N - 1, 1);
ks_ind                = setdiff(1 : N, kp);
for idx = 1 : length(ks_ind)
  k                   = ks_ind(idx); 
  num_SI              = 16;   % 21 points for each interval might be enough
  knots               = linspace(Estimator.Ebasis{k, kp}.supp(1), Estimator.Ebasis{k, kp}.supp(2), ...
                        num_SI + 1); 
  rqs{idx}            = (knots(2 : end) + knots(1 : end - 1))/2;
end
rq                    = unique([rqs{:}]);
Q                     = length(rq);
phiEhatkkp            = zeros(length(ks_ind), Q);
rhoEhatkkp            = zeros(length(ks_ind), Q);
phiEhatkkpdrho        = zeros(length(ks_ind), 1);
phiEhatkpk            = zeros(length(ks_ind), Q);
rhoEhatkpk            = zeros(length(ks_ind), Q);
phiEhatkpkdrho        = zeros(length(ks_ind), 1);
for idx = 1 : length(ks_ind)
  k                   = ks_ind(idx);
  phiEhatkkp(idx, :)  = Estimator.phiEhat{k, kp}(rq);
  rhoEhatkkp(idx, :)  = rhoLTE{k, kp}.dense(rq);
  phiEhatkkpdrho(idx) = sum(phiEhatkkp(idx, :).^2 .* rhoEhatkkp(idx, :)); % L^2(rho) norm
  phiEhatkpk(idx, :)  = Estimator.phiEhat{kp, k}(rq);
  rhoEhatkpk(idx, :)  = rhoLTE{kp, k}.dense(rq);
  phiEhatkpkdrho(idx) = sum(phiEhatkpk(idx, :).^2 .* rhoEhatkpk(idx, :)); % L^2(rho) norm
end
output.rq             = rq;
output.phiEhatkkp     = phiEhatkkp;
output.rhoEhatkkp     = rhoEhatkkp;
output.phiEhatkkpdrho = phiEhatkkpdrho;
output.phiEhatkpk     = phiEhatkpk;
output.rhoEhatkpk     = rhoEhatkpk;
output.phiEhatkpkdrho = phiEhatkpkdrho;
end