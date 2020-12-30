function [xi_knots, xi_basis, pdist_xi, Phi, rhs_vec, extra] = parallel_assemble_xi(Rs, x_d, xi_d, dot_xi_d, ...
         time_vec, learning_info)
% [xi_knots, xi_basis, pdist_xi, Phi, rhs_vec, extra] = parallel_assemble_xi(Rs, x_d, xi_d, dot_xi_d, ...
% time_vec_d, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% on the client side, do nothing for now
fprintf('Starting from the client side.\n');
fprintf('Initializing data for workers.\n');
% define the tags for data communication later (shared by all workers)
xi_basis_tag                                           = 5;
num_Phi_col_tag                                        = 6;
% find out some basic information (shared by all workers)
% the number of classes in the system
num_classes                                            = learning_info.K;
% find out if we have derivative
has_derivative                                         = ~isempty(dot_xi_d);
%
fprintf('Initialization is done.\n');
% time to run in parallel
fprintf('All workers get to work!!.\n');
fprintf('I will know how many workers there are after I run in parallel.\n');
spmd
% time to work
  fprintf('Lab = %d: Time to work.\n', labindex);
% Lab(01) is in charge of communicating, so it has to know the number of workers in the system
  if labindex == 1
    num_cores_l                                        = numlabs;
  else
    num_cores_l                                        = [];
  end
% get a local copy of x_d and see if I need to work, since x is only used on worker side, not '_l'
  x                                                    = getLocalPart(x_d);
% based on the local copy of x (on this worker), it decide to work or stay idle
  if ~isempty(x)
% get a local copy of xi, dot_xi and time_vec
    xi                                                 = getLocalPart(xi_d);
% get a local copy of dot_xi
    if has_derivative  
      dot_xi                                           = getLocalPart(dot_xi_d);
    else
      dot_xi                                           = [];
    end
% find out number of Monte Carlo realizations this worker is assigned to
    has_3D                                             = length(size(x)) ==  3;
    if has_3D
      M                                                = size(x, 3);
    else
      M                                                = 1;
    end
% start working
    if ~has_3D
      fprintf('Lab = %d: My copy of x has size [%d, %d].\n',     labindex, size(x, 1), size(x, 2));
    else
      fprintf('Lab = %d: My copy of x has size [%d, %d, %d].\n', labindex, size(x, 1), size(x, 2), M);
    end
% for other variables    
    fprintf('Lab = %d: initializing variables.\n', labindex);
% allocate storage for MC ealizations: energy based terms, pdist_x_l will be assembled later on
    pdist_xi_l                                         = cell(1, M);
% now it is time to build the basis, only build it on the Lab(01)
    if labindex == 1
% build it and then send it out
      fprintf('Lab = %d: Building basis.\n', labindex);
% build the basis
      [xi_basis_l, xi_knots_l]                         = uniform_basis_on_xi(Rs, learning_info);
% calculate the number of basis functions
      num_Phi_cols                                     = 0;
      for k_1 = 1 : num_classes
        for k_2 = 1 : num_classes
          num_Phi_cols                                 = num_Phi_cols + length(xi_basis_l{k_1, k_2});
        end
      end
      fprintf('Lab = %d: The data tags for the difference kinds of data are:\n', labindex);
      fprintf('  Xi_basis_l:   tag = %d.\n', xi_basis_tag);
      fprintf('  Num_Phi_cols: tag = %d.\n', num_Phi_col_tag);
% send these 6 pieces of data to other workers
      for lab_ind = 2 : num_cores_l
        fprintf('Lab = %d: I am sending 2 pieces of data over, with 2 different tags, to Lab (%d).\n', labindex, lab_ind);
        labSend(xi_basis_l,   lab_ind, xi_basis_tag);
        labSend(num_Phi_cols, lab_ind, num_Phi_col_tag);
      end        
    else
% if you are not Lab(01), you dont need to know xi_knots_l
      xi_knots_l                                       = [];
% receiving xi_basis_l and num_Phi_cols_l from Lab(01)
% for other workers, just receive the basis information from Lab(01)
      fprintf('Lab = %d: I am receiving data, and identify them using tags, from Lab(%d).\n', labindex, 1);
      xi_basis_l                                       = labReceive(1, xi_basis_tag);
      num_Phi_cols                                     = labReceive(1, num_Phi_col_tag);
    end
% now that everbody knows num_Phi_cols_l, allocate memory for Phi_l and rhs_vec_l
    Phi_l                                              = zeros(num_Phi_cols);
    rhs_vec_l                                          = zeros(num_Phi_cols, 1);
% we also need the square of the l_2 norm of the rhs_vec for every m
    rhs_in_l2_norm_sq_l                                = 0;
% the local Monte Carlo loop
    for m = 1 : M
% find the portion of x
      one_x                                            = squeeze(x(:, :, m));
% find the portion of xi when it's present
      one_xi                                           = squeeze(xi(:, :, m));
% find out the portion of dot_xi
      if has_derivative
        one_dot_xi                                     = squeeze(dot_xi(:, :, m));
      else
        one_dot_xi                                     = [];
      end
% find out: pairwise distances on xi (not needed for uniform learn), its non-repeated copy, Phi matrix (with xi as the pairwise
% differences), F (external influence) vector, d (approxiamted derivative of xi) vector
      [~, one_pdist_xi, one_Phi, one_F_vec, one_d_vec] = one_step_assemble_on_xi(one_x, one_xi, one_dot_xi, ...
      time_vec, xi_basis_l, learning_info);
% calculate the right handside
      one_rhs_vec                                      = one_d_vec - one_F_vec;
% find out the square of its l_2 norm
      rhs_in_l2_norm_sq_l                              = rhs_in_l2_norm_sq_l + norm(one_rhs_vec)^2;
% calculate (Phi^{(m)})^T * Phi^{(m)} and add it to Phi
      Phi_l                                            = Phi_l + transpose(one_Phi) * one_Phi;
% calculate (Phi^{(m)})^T * (d_vec^{(m)} - F_vec^{(m)}), and add it to rhs_vec
      rhs_vec_l                                        = rhs_vec_l + transpose(one_Phi) * one_rhs_vec;
% save the pdist_xi data when we need it
      pdist_xi_l{m}                                    = one_pdist_xi;
    end
  else
% if the worker has nothing do to, initialize the following to empty
    num_cores_l                                        = [];
    Phi_l                                              = [];
    rhs_vec_l                                          = [];
    pdist_xi_l                                         = [];
    xi_basis_l                                         = [];
    xi_knots_l                                         = [];
    rhs_in_l2_norm_sq_l                                = [];
  end  
end
% now back to the client side and assemble pdist_xi, Phi, rhs_vec, xi_knots, xi_basis, and rhs_in_l2_norm_sq
fprintf('Back to client side.\n');
fprintf('Assembling data.\n');
% we also need the sum of all square of the l_2 norm of d_vec - F_vec over all m's
rhs_in_l2_norm_sq                                      = sum([rhs_in_l2_norm_sq_l{:}]);
extra.rhs_in_l2_norm_sq                                = rhs_in_l2_norm_sq;
% now assemble the data: find out the number of works
num_cores                                              = num_cores_l{1};
% assemble the Phi matrices, F_vec and d_vec
for lab_ind = 1 : num_cores
  if lab_ind == 1
    Phi                                                = Phi_l{lab_ind};
    rhs_vec                                            = rhs_vec_l{lab_ind};
  else
    Phi_lab                                            = Phi_l{lab_ind};
    if ~isempty(Phi_lab)
      Phi                                              = Phi + Phi_lab;
      rhs_vec                                          = rhs_vec + rhs_vec_l{lab_ind};
    end
  end
end
% find out xi_basis, xi_knots, just need the copy from Lab(01)
xi_basis                                               = xi_basis_l{1};
xi_knots                                               = xi_knots_l{1};
% assemble pdist_x and pdist_v, just simply change the composite variable back into one
pdist_xi                                               = [pdist_xi_l{:}];
fprintf('Finished!!\n');
end