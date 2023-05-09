function Examples = LoadExampleDefinitions(kind)
% function Examples = LoadExampleDefinitions(kind)

% (c) M. Zhong

% turn on/off the indicator for picking up Model Selection cases
if nargin < 1
  kind                             = 'Main';
end
% Common parameters
% for solver_info (ODE integrator)
solver                             = '15s';                                                         % use ode15s as the integrator
rel_tol                            = 1.0e-8;                                                        % the relative tolerance for adaptive integration
abs_tol                            = 1.0e-11;                                                        % the absolute tolerance for adaptive integration

% visualization
plot_info                          = get_plot_info;

% for learn_info
is_parallel                        = true;                                                          % turn on paralell assemble                                                               
keep_obs_data                      = true;                                                          % indicator to keep the observation data
N_ratio                            = 4;                                                             % predict the dynamics with 4 times the original # of agents
to_predict_LN                      = false;
% obs_info
pd_file_form                       = '%s/%s_%s_m%d_PD.mat';
% find all the files
def_files                          = dir('./SOD_Examples/*_def.m');
MS_match                           = cellfun(@(name) contains(name, 'ModelSelection'), {def_files.name});
LC_match                           = cellfun(@(name) contains(name, '_LC_def.m'),      {def_files.name});
SMC_match                          = cellfun(@(name) contains(name, '_2ndMC_def.m'),   {def_files.name});
JPL_match                          = cellfun(@(name) contains(name, '_JPL_def.m'),     {def_files.name}); 
Manifold_match                     = cellfun(@(name) contains(name, '_LDoM_def.m'),    {def_files.name});
RKHS_match                         = cellfun(@(name) contains(name, '_RKHS_def.m'),    {def_files.name});
SSPL_match                         = cellfun(@(name) contains(name, '_SSPL_def.m'),    {def_files.name});
FML_match                          = cellfun(@(name) contains(name, '_FML_def.m'),    {def_files.name});
switch kind
  case 'PNAS'
    main_match                     = ~(MS_match | LC_match | JPL_match | SMC_match | ...
                                       Manifold_match | RKHS_match | SSPL_match | FML_match);
    def_files                      = def_files(main_match); 
  case 'ModelSelection'
    def_files                      = def_files(MS_match); 
  case 'MLtest'
    main_match                     = ~(MS_match | JPL_match | SMC_match);
    def_files                      = def_files(main_match);    
  case 'PhysicaD'
    def_files                      = def_files(LC_match);    
  case '2ndMC'
    def_files                      = def_files(SMC_match);
  case 'LDoM'
    def_files                      = def_files(Manifold_match);
  case 'GravityLetter'
    def_files                      = def_files(JPL_match); 
  case 'RKHS'
    def_files                      = def_files(RKHS_match);
  case 'SSPL'
    def_files                      = def_files(SSPL_match);
  case 'FML'
    def_files                      = def_files(FML_match);
  case 'Dynamics'
    main_match                     = ~(MS_match | JPL_match);
    def_files                      = def_files(main_match);  
  otherwise
    error('');
end

total_num_defs                     = length(def_files);
Examples                           = cell(1, total_num_defs);
for idx = 1 : total_num_defs
  eval(sprintf('Example = %s();', erase(def_files(idx).name, '.m')));
  Example.plot_info                = plot_info;
  if ~isfield(Example.solver_info, 'rel_tol')
    Example.solver_info.rel_tol    = rel_tol;
  end
  if ~isfield(Example.solver_info, 'abs_tol')
    Example.solver_info.abs_tol    = abs_tol;
  end
  if ~isfield(Example.solver_info, 'solver')
    Example.solver_info.solver     = solver;
  end
  Example.obs_info.pd_file_form    = pd_file_form;
  Example.learn_info.is_parallel   = is_parallel;
  Example.learn_info.keep_obs_data = keep_obs_data;
  Example.learn_info.N_ratio       = N_ratio;
  Example.learn_info.to_predict_LN = to_predict_LN;
  Examples{idx}                    = Example;
end
end