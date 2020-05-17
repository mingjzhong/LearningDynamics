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
rel_tol                            = 1.0e-8;                                                        % the relative tolerance for adaptive integration
abs_tol                            = 1.0e-11;                                                        % the absolute tolerance for adaptive integration

% visualization
plot_info.scrsz                    = [1, 1, 1920, 1080];                                            % change the 3rd and 4th parameters for bigger size (width x height)
plot_info.legend_font_size         = 32;
plot_info.legend_font_name         = 'Helvetica';
plot_info.colorbar_font_size       = 26;
plot_info.title_font_size          = 32;
plot_info.title_font_name          = 'Helvetica';
plot_info.axis_font_size           = 32;
plot_info.axis_font_name           = 'Helvetica';
plot_info.tick_font_size           = 26;
plot_info.tick_font_name           = 'Helvetica';
plot_info.traj_line_width          = 1.5;
plot_info.phi_line_width           = 1.5;
plot_info.phihat_line_width        = 1.5;
plot_info.display_phihat           = false;
plot_info.display_interpolant      = true;
plot_info.make_movie               = false;
plot_info.arrow_thickness          = 1.5;                                                           % thickness of the arrow body
plot_info.arrow_head_size          = 0.8;                                                           % size of the arrow head
plot_info.arrow_scale              = 0.05;                                                          % arrow length relative to fig. window size
plot_info.line_styles              = {'-', '-.', '--', ':'};                                        % traj. line styles
plot_info.type_colors              = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
plot_info.marker_style             = {'s', 'd', 'p', 'h', 'x', '+', 'v', '^', '<', '>'};            
plot_info.marker_size              = 10;                                                   
plot_info.marker_edge_color        = {'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k'};
plot_info.marker_face_color        = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
plot_info.rhotscalingdownfactor    = 1;
plot_info.showplottitles           = false;
plot_info.showplotlegends          = true;                                                          % showing legend for phi comparison plots
plot_info.T_L_marker_size          = plot_info.traj_line_width;

% for learn_info
solver_type                        = 'pinv';                                                        % use the MATLAB built-in LS solver, for single class case, Phi is never singular (?), so mldivide can do the job
is_parallel                        = true;                                                          % turn on paralell assemble
is_adaptive                        = false;                                                         % adaptive learning (basis) indicator                                                                
keep_obs_data                      = true;                                                          % indicator to keep the observation data
N_ratio                            = 4;                                                             % predict the dynamics with 4 times the original # of agents
to_predict_LN                      = false;

% find all the files
def_files                          = dir('./SOD_Examples/*_def.m');
MS_match                           = cellfun(@(name) contains(name, 'ModelSelection'), {def_files.name});
LC_match                           = cellfun(@(name) contains(name, '_LC_def.m'), {def_files.name});
JPL_match                          = cellfun(@(name) contains(name, '_JPL_def.m'), {def_files.name}); 
switch kind
  case 'PNAS'
    main_match                     = ~(MS_match | LC_match | JPL_match);
    def_files                      = def_files(main_match); 
  case 'PhysicaD'
    def_files                      = def_files(LC_match);    
  case 'GravityLetter'
    def_files                      = def_files(JPL_match); 
  case 'ModelSelection'
    def_files                      = def_files(MS_match); 
  case 'Dynamics'
    main_match                     = ~(MS_match | JPL_match);
    def_files                      = def_files(main_match);     
  otherwise
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
  Example.learn_info.N_ratio       = N_ratio;
  Example.learn_info.to_predict_LN = to_predict_LN;
  Examples{idx}                    = Example;
end
end