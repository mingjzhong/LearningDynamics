function gravity_terms = generateGravityMat(learningOutput, method)
% function gravity_terms = generateGravityMat(learningOutput, method)

% (c) M. Zhong (JHU)

if method == 1 || method == 2
% sun on planet interactions first
  sunEstimators               = learningOutput{1}.Estimator.phiEhat(2 : end, 1);
  rhoLTemps.hist              = learningOutput{1}.rhoLTemp.rhoLTE.hist(2 : end, 1);
  rhoLTemps.histedges         = learningOutput{1}.rhoLTemp.rhoLTE.histedges(2 : end, 1); 
  rhoLTemps.supp              = learningOutput{1}.rhoLTemp.rhoLTE.supp(2 : end, 1);  
% prepare the r_p vector and initalize the storage
  num_planets                 = length(sunEstimators);                                              % = N - 1;
  refine_level                = num_planets;
  num_pts                     = 4^(refine_level + 2) - 1;
  knots                       = zeros(1, num_planets * num_pts);  
  for ind = 1 : num_planets
    ind1                      = (ind - 1) * num_pts + 1;
    ind2                      = ind       * num_pts;
    knots(ind1 : ind2)        = linspace(rhoLTemps.supp{ind}(1), rhoLTemps.supp{ind}(2), num_pts);
  end  
  rp                          = unique(knots);
  P                           = length(rp);
% initalize the storage
  sunPhiMat                   = zeros(num_planets, P);
  sunRhoMat                   = zeros(num_planets, P);
% find out the values  
  for ind = 1 : num_planets
    sunPhiMat(ind, :)         = sunEstimators{ind}(rp);
    sunRhoMat(ind, :)         = evaluate_rhoLT(rhoLTemps.hist{ind}, rhoLTemps.histedges{ind}, rhoLTemps.supp{ind}, rp);
  end      
  gravity_terms.Phii1Mat      = sunPhiMat;
  gravity_terms.Rhoi1Mat      = sunRhoMat;
  gravity_terms.rp            = rp;
% planet on sun interaction next
  planetEstimators            = learningOutput{1}.Estimator.phiEhat(1, 2 : end);
  rhoLTemps.hist              = learningOutput{1}.rhoLTemp.rhoLTE.hist(1, 2 : end);
  rhoLTemps.histedges         = learningOutput{1}.rhoLTemp.rhoLTE.histedges(1, 2 : end); 
  rhoLTemps.supp              = learningOutput{1}.rhoLTemp.rhoLTE.supp(1, 2 : end);
% initialize storage
  planetPhiMat                = zeros(num_planets, P);
  planetRhoMat                = zeros(num_planets, P);
  for ind = 1 : num_planets
    planetPhiMat(ind, :)      = planetEstimators{ind}(rp);
    planetRhoMat(ind, :)      = evaluate_rhoLT(rhoLTemps.hist{ind}, rhoLTemps.histedges{ind}, rhoLTemps.supp{ind}, rp);
  end
  gravity_terms.Phi1iMat      = planetPhiMat;
  gravity_terms.Rho1iMat      = planetRhoMat;
elseif method == 3
  N                           = size(learningOutput{1}.Estimator.phiEhat, 1);
% prepare the r_p vector and initalize the storage
  num_pts                     = 2^N - 1;
  knots                       = zeros(1, (N^2 - N)/2 * num_pts);
  N_sums                      = cumsum([0, N - 1 : -1 : 2]);
  for i_ind = 1 : N
    for j_ind = i_ind + 1 : N
      supp                    = learningOutput{1}.rhoLTemp.rhoLTE.supp{i_ind, j_ind};
      ind                     = N_sums(i_ind) + (j_ind - i_ind);
      ind1                   = (ind - 1) * num_pts + 1;
      ind2                    = ind       * num_pts;
      knots(ind1 : ind2)      = linspace(supp(1), supp(2), num_pts);      
    end
  end
  rp                          = unique(knots);
  P                           = length(rp);
  PhiMat                      = zeros(N, N, P);
  RhoMat                      = zeros(N, N, P);
  for i_ind = 1 : N
    for j_ind = i_ind + 1 : N
      PhiMat(i_ind, j_ind, :) = learningOutput{1}.Estimator.phiEhat{i_ind, j_ind}(rp);
      PhiMat(j_ind, i_ind, :) = learningOutput{1}.Estimator.phiEhat{j_ind, i_ind}(rp);
      hist                    = learningOutput{1}.rhoLTemp.rhoLTE.hist{i_ind, j_ind};
      histedges               = learningOutput{1}.rhoLTemp.rhoLTE.histedges{i_ind, j_ind};
      supp                    = learningOutput{1}.rhoLTemp.rhoLTE.supp{i_ind, j_ind};
      RhoMat(i_ind, j_ind, :) = evaluate_rhoLT(hist, histedges, supp, rp);
      RhoMat(j_ind, i_ind, :) = RhoMat(i_ind, j_ind, :);
    end
  end
  gravity_terms.PhiMat        = PhiMat;
  gravity_terms.RhoMat        = RhoMat;
  gravity_terms.rp            = rp;
else
  error('SOD_Learn:generateGravityMat:exception', 'It only calculate gravity terms for 3 different methods!!');
end
end