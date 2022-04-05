function y_init = MS_init_config(d, N, type_info, kind)
% y_init = MS_init_config(d, N, kind)

% (c) M. Zhong (JHU)

switch kind
  case 1
    x_init = uniform_dist(d, N, 'annulus',   [0.5, 1]);
    v_init = uniform_dist(d, N, 'rectangle', [0, 10]);
    y_init = [x_init(:); v_init(:)];
  case 2
% the 1st order case, generate an annulus, with radius: [0.5, 1.5]
    dist_type            = 'annulus';
    domain               = [0.05, 0.15] * N;
    preys_ind            = type_info == 1;
    num_preys            = nnz(preys_ind);
    y_init(:, preys_ind) = uniform_dist(d, num_preys, dist_type, domain);
% the predators are in the disk of radius = 0.1
    dist_type            = 'disk';
    domain               = 0.1;
    preds_ind            = type_info == 2;
    num_preds            = nnz(preds_ind);
    y_init(:, preds_ind) = uniform_dist(d, num_preds, dist_type, domain);
% reshape
    y_init               = y_init(:);
  case 3
% the 2nd order case, the preys are in the rectangle: [epsilon, 1]^2
    epsilon              = 0.1;
    domain               = [epsilon, 1];
    dist_type            = 'rectangle';
    preys_ind            = type_info == 1;
    num_preys            = nnz(preys_ind);
    y_init(:, preys_ind) = uniform_dist(d, num_preys, dist_type, domain);
% the predators are in a smaller rectangle: [0, 0.8 * epsilon]^2
    domain               = [0, 0.7 * epsilon];
    preds_ind            = type_info == 2;
    num_preds            = nnz(preds_ind);
    y_init(:, preds_ind) = uniform_dist(d, num_preds, dist_type, domain);
% reshape
    y_init               = [y_init(:); zeros(d * N, 1)];    
  otherwise
end
end