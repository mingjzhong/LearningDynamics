function output = generateGravityMat_by_kp(kp, learningOutput)
% function output = generateGravityMat_by_kp(kp, learningOutput)

% (c) M. Zhong (JHU)

N                     = size(learningOutput.Estimator.phiEhat, 1);
if kp > N, error(''); end                                                                           % 1 <= kp <= N
rhoLTE                = learningOutput.Estimator.rhoLTM{1};
rqs                   = cell(N - 1, 1);
ks_ind                = setdiff(1 : N, kp);
for idx = 1 : N - 1
  k                   = ks_ind(idx);
  knots               = learningOutput.Estimator.Ebasis{k, kp}.knots;
  rqs{idx}            = (knots(2 : end) + knots(1 : end - 1))/2;
end
rq                    = unique([rqs{:}]);
Q                     = length(rq);
phiEhatkkp            = zeros(N - kp, Q);
rhoEhatkkp            = zeros(N - kp, Q);
phiEhatkkpdrho        = zeros(N - kp, 1);
phiEhatkpk            = zeros(N - kp, Q);
rhoEhatkpk            = zeros(N - kp, Q);
phiEhatkpkdrho        = zeros(N - kp, 1);
for idx = 1 : N - 1
  k                   = ks_ind(idx);
  phiEhatkkp(idx, :)  = learningOutput.Estimator.phiEhat{k, kp}(rq);
  rhoEhatkkp(idx, :)  = rhoLTE{k, kp}.dense(rq);
  phiEhatkkpdrho(idx) = sum(phiEhatkkp(idx, :).^2 .* rhoEhatkkp(idx, :));
  phiEhatkpk(idx, :)  = learningOutput.Estimator.phiEhat{kp, k}(rq);
  rhoEhatkpk(idx, :)  = rhoLTE{kp, k}.dense(rq);
  phiEhatkpkdrho(idx) = sum(phiEhatkpk(idx, :).^2 .* rhoEhatkpk(idx, :));
end
output.rq             = rq;
output.phiEhatkkp     = phiEhatkkp;
output.rhoEhatkkp     = rhoEhatkkp;
output.phiEhatkkpdrho = phiEhatkkpdrho;
output.phiEhatkpk     = phiEhatkpk;
output.rhoEhatkpk     = rhoEhatkpk;
output.phiEhatkpkdrho = phiEhatkpkdrho;
end