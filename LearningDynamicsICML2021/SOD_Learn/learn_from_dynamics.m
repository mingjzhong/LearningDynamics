function Estimator = learn_from_dynamics(y, dy, learn_info)
% function Estimator = learn_from_dynamics(y, dy, learn_info)

% (c) M. Zhong, M. Maggioni, JHU

% Run it in parallel or not, based on user input and corrected by (M, #cores)
M                            = size(y, 3);
L                            = size(y, 2);
if ~isfield(learn_info, 'VERBOSE'), learn_info.VERBOSE = 2; end
if ~isfield(learn_info, 'is_parallel') || isempty(learn_info.is_parallel)  
  learn_info.is_parallel     = true;       % by default, run in parallel  
end
if M < feature('numcores'), learn_info.is_parallel= false; end

% Process the data, so that pairwise distances, differences, rhs vectors are obtained and saved
if ispc, learn_info.temp_dir = [learn_info.SAVE_DIR, '\tempOut']; 
else, learn_info.temp_dir = [learn_info.SAVE_DIR, '/tempOut']; end
if ~exist(learn_info.temp_dir, 'dir'), mkdir(learn_info.temp_dir); end
learn_info.is_rhoLT          = false;
agent_info                   = getAgentInfo(learn_info.sys_info);
[phi_range, rho_range]       = process_the_data(y, dy, learn_info, agent_info);

% Compute rhoTLM
% prepare the bins for hist count
[hist_binwidths, hist_edges] = prepare_hist_items(learn_info.hist_num_bins, rho_range);
% assemble rhoLTM for local error estiamtes
hist_counts                  = assemble_histcounts(M, hist_edges, learn_info);
Estimator.rhoLTM             = package_rhoLT(hist_edges, hist_binwidths, hist_counts, ...
                               learn_info.sys_info, rho_range);    
                               
% Construct the basis
if isfield(learn_info, 'use_kernel') && ~isempty(learn_info.use_kernel) && learn_info.use_kernel
  [basis, basis_plan]        = construct_kernel_basis(phi_range, learn_info);
else
  if isfield(learn_info, 'use_rho') && ~isempty(learn_info.use_rho) && learn_info.use_rho
    learn_info.M             = M;
    learn_info.L             = L;
    basis_plan               = get_basis_construction_plan(phi_range, Estimator.rhoLTM, learn_info);
  else
    basis_plan               = get_basis_construction_plan(phi_range, [], learn_info);
  end
  basis                      = construct_basis(phi_range, learn_info, basis_plan);
end

% Assemble ALM and bLM
[Estimator.ALM, Estimator.bLM, Estimator.rhs_l2sq , Estimator.ALMXi, Estimator.bLMXi, ...
  Estimator.rhsXi_l2sq]      = assemble_A_and_b(M, L, basis, learn_info);
Estimator                    = set_basis_in_Estimator(basis, basis_plan, learn_info.sys_info, ...
                               Estimator);
learn_info                   = update_basis_info(Estimator, learn_info);

% Solve for alphas
% find out the minimizer and optimal value
[Estimator.Ealpha, Estimator.Aalpha, Estimator.Xialpha, opt_val, opt_val_xi, Estimator.ALM_Info, ...
  Estimator.ALMXi_Info]      = solve_the_learning_problem(Estimator, learn_info);                   
% the empirical error: opt_val + \sum_{m = 1}^M <(d_vec - F_vec)^(m), (d_vec - F_vec)^(m)>
Estimator.emp_err            = add_two_vectors(opt_val, Estimator.rhs_l2sq);
Estimator.emp_err_xi         = [];
if ~isempty(Estimator.ALMXi), Estimator.emp_err_xi = add_two_vectors(opt_val_xi, Estimator.rhsXi_l2sq); end

% Assemble phihats
Estimator                    = assemble_phihats(Estimator, learn_info.sys_info);

% Regularize phihats
Estimator                    = regularizePhihats(Estimator, learn_info);

% Smooth out some of the oscillation in the phihats
Estimator                    = simplifyPhihats(Estimator);

% Learn parametric form
% Only for gravity system (w/ 1D phihat_{i, i'}'s), learn the parameterized form
if contains(learn_info.sys_info.name, 'Gravitation') && ...
    (~isfield(learn_info.sys_info, 'V_map') || isempty(learn_info.sys_info.V_map)) && ...
    learn_info.sys_info.K > 1  % no extra V map, and K > 1 (no for semi-parametric learning)                                                        
  Estimator.gravity          = learn_gravitation(learn_info.sys_info, Estimator);
  [Estimator.phiEhatclean, Estimator.Ebasisclean] ...
                             = assemble_clean_phiEhat(learn_info.sys_info, Estimator);
  Estimator.massErr          = computeMassErr(learn_info.sys_info, Estimator.gravity); 
end

% delete the files
parfor m = 1 : M
  delete_the_file(m, learn_info);
end
end