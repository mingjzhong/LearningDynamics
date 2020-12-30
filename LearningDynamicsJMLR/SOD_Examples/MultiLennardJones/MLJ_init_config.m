function y_init = MLJ_init_config(N, type_info, kind)
% y_init = PS_init_config(N, class_info, kind)

% (c) Sui Tang (UCSB)

if kind == 1
% only for d = 2
  d                    = 2;
% initialize the storage for the initial configuration
  y_init               = zeros(d, N);
% the 1st order case, generate an annulus, with radius: [0.5, 1.5]
  A_ind            = type_info == 1;
  num_A            = nnz(A_ind);
  %dist_type            = 'annulus';
  %domain               = [0.05, 0.15]*num_preys; 
  dist_type            = 'disk';
  domain               = 1;
  y_init(:, A_ind) = uniform_dist(d, num_A, dist_type, domain);
%   y_init(:, A_ind) = rand(d,num_A)+2;%uniform_dist(d, num_A, dist_type, domain);
%   
  % the predators are in the disk of radius = 0.1
  dist_type            = 'disk';
  domain               = 1;
  B_ind            = type_info == 2;
  num_B            = nnz(B_ind);
  y_init(:, B_ind) = uniform_dist(d, num_B, dist_type, domain);%randn(d,num_preds);;
  % reshape
  y_init   = randn(d,N);
  y_init               = y_init(:);
elseif kind == 2
% only for d = 2
  d                    = 2;
% initialize the storage for the initial configuration
  y_init               = zeros(d, N);  
% the 2nd order case, the preys are in the rectangle: [epsilon, 1]^2
  epsilon              = 0.1;
  domain               = [epsilon, 1];
  dist_type            = 'rectangle';
  preys_ind            = type_info == 1;
  num_preys            = nnz(preys_ind);
  y_init(:, preys_ind) = uniform_dist(d, num_preys, dist_type, domain);
  % the predators are in a smaller rectangle: [0, 0.8 * epsilon]^2
  domain               = [0, 0.8 * epsilon];
  preds_ind            = type_info == 2;
  num_preds            = nnz(preds_ind);
  y_init(:, preds_ind) = uniform_dist(d, num_preds, dist_type, domain);
% reshape
  y_init               = [y_init(:); zeros(d * N, 1)];
elseif kind == 3
% the 1st order case, generate on a spherical surface with radius = 0.15 * #(preys)
  d                    = 3;
  y_init               = zeros(d, N);
  preys_ind            = type_info == 1;
  num_preys            = nnz(preys_ind);
  dist_type            = 'sphere_surface';
  domain               = 0.15 * num_preys;    
  y_init(:, preys_ind) = uniform_dist(d, num_preys, dist_type, domain);
% the predators are inside a sphere with radius = 0.1
  dist_type            = 'sphere';
  domain               = 0.1;
  preds_ind            = type_info == 2;
  num_preds            = nnz(preds_ind);
  y_init(:, preds_ind) = uniform_dist(d, num_preds, dist_type, domain);
% reshape
  y_init               = y_init(:);  
end

return