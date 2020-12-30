function [the_F, d_vec, energy_Phi, align_Phi] = scale_the_quantities(the_F, d_vec, energy_Phi, align_Phi, N, num_classes, ...
         class_info, time_vec, Riemann)
% [the_F, d_vec, energy_Phi, align_Phi] = scale_the_matrices(the_F, d_vec, energy_Phi, align_Phi, N, num_classes, ...
% class_info, time_vec, Riemann)

% Ming Zhong
% Postdoc Research at JHU

% find out the number of times when observations are made
L            = length(time_vec);
% find out the size of the state vector
d            = size(d_vec, 1)/(L * N);
% find out the modifer from numer of agents in each class
class_mod    = get_class_modifier(L, N, d, num_classes, class_info);
% find out the modifier from time (and different Riemann sum)
if L == 1
% if there is only one observation, there is no factor from time
  time_mod   = ones(N * d, 1);
% construct a sparse diagonal matrix
  D_mod      = spdiags(time_mod ./ class_mod, 0, N * d, N * d);  
else
% for more than 1 observation  
  time_mod   = get_Riemann_based_time_modifier(N, d, time_vec, Riemann);
% construct a sparse diagonal matrix
  D_mod      = spdiags(time_mod ./ class_mod, 0, L * N * d, L * N * d);  
end
% modify the non-collective influence terms
the_F        = D_mod * the_F;
% modify the derivative terms
d_vec        = D_mod * d_vec;
% modify the energy terms
if ~isempty(energy_Phi)
  energy_Phi = D_mod * energy_Phi;
end
% modify the alignment terms
if ~isempty(align_Phi)
  align_Phi  = D_mod * align_Phi;
end
end