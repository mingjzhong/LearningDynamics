function Examples = LoadExampleDefinitions(kind)
% function Examples = LoadExampleDefinitions(is_MS)

% (c) M. Zhong

% turn on/off the indicator for picking up Model Selection cases
if nargin < 1
  kind                             = 'Main';
end
% Common parameters
% for solver_info (ODE integrator)
solver                             = '15s';                                                         % use ode15s as the integrator
rel_tol                            = 1.0e-5;                                                        % the relative tolerance for adaptive integration
abs_tol                            = 1.0e-6;                                                        % the absolute tolerance for adaptive integration

% visualization
plot_info.scrsz                    = [1, 1, 1920, 1080];                                            % find the 3rd and 4th parameters for bigger size (width x height)
plot_info.legend_font_size         = 20;
plot_info.legend_font_name         = 'Helvetica';
plot_info.colorbar_font_size       = 20;
plot_info.title_font_size          = 26;
plot_info.title_font_name          = 'Helvetica';
plot_info.axis_font_size           = 26;
plot_info.axis_font_name           = 'Helvetica';
plot_info.tick_font_size           = 20;
plot_info.tick_font_name           = 'Helvetica';
plot_info.traj_line_width          = 2.0;
plot_info.phi_line_width           = 1.5;
plot_info.phihat_line_width        = 1.5;
plot_info.rhotscalingdownfactor    = 1;
plot_info.showplottitles           = false;
plot_info.display_phihat           = false;
plot_info.display_interpolant      = true;
plot_info.for_PNAS                 = false;
plot_info.line_styles              = {'-', '-.', '--', ':'};                                        % traj. line styles
plot_info.T_L_marker_size          = plot_info.traj_line_width;

% for learn_info
solver_type                        = 'pinv';                                                        % use the MATLAB built-in LS solver, for single class case, Phi is never singular (?), so mldivide can do the job
is_parallel                        = false;                                                         % turn off paralell assemble
is_adaptive                        = false;                                                         % adaptive learning (basis) indicator                                                                
keep_obs_data                      = true;                                                          % indicator to keep the observation data
Riemann_sum                        = 2;
N_ratio                            = 4;                                                             % predict the dynamics with 4 times the original # of agents

% find all the files
def_files                          = dir('./SOD_Examples/*_def.m');
switch kind
  case 'Main'
    MS_match                       = cellfun(@(name) contains(name, 'ModelSelection'), {def_files.name});
    main_match                     = ~MS_match;
    def_files                      = def_files(main_match);
%   def_files(MS_match)              = [];    
  case 'ModelSelection'
    MS_match                       = cellfun(@(name) contains(name, 'ModelSelection'), {def_files.name});
    def_files                      = def_files(MS_match);    
  otherwise
    error('SOD_Utils:LoadExampleDefinitions:exception', 'Only 2 different loads are supported!!');
end

total_num_defs                     = length(def_files);
Examples                           = cell(1, total_num_defs);
for idx = 1 : total_num_defs
  eval(sprintf('Example = %s();', erase(def_files(idx).name, '.m')));
  Example.plot_info                = plot_info;
  Example.solver_info.solver       = solver;
  if ~isfield(Example.solver_info, 'rel_tol')
    Example.solver_info.rel_tol    = rel_tol;
  end
  if ~isfield(Example.solver_info, 'abs_tol')
    Example.solver_info.abs_tol    = abs_tol;
  end
  Example.learn_info.solver_type   = solver_type;
  Example.learn_info.is_parallel   = is_parallel;
  Example.learn_info.is_adaptive   = is_adaptive;
  Example.learn_info.keep_obs_data = keep_obs_data;
  Example.learn_info.Riemann_sum   = Riemann_sum;
  Example.learn_info.N_ratio       = N_ratio;
  Examples{idx}                    = Example;
end
end