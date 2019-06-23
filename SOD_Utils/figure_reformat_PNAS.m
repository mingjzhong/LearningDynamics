% stript to re-format the figures for PNAS submission

% (C) M. Zhong

% load the saved dynamics data into Workspace

% changing plot_info
plot_info.scrsz                 = [1, 1, 1920, 1080];                                        
plot_info.legend_font_size      = 33;
plot_info.legend_font_name      = 'Helvetica';
plot_info.colorbar_font_size    = 33;
plot_info.title_font_size       = 44;
plot_info.title_font_name       = 'Helvetica';
plot_info.axis_font_size        = 44;
plot_info.axis_font_name        = 'Helvetica';
plot_info.tick_font_size        = 39;
plot_info.tick_font_name        = 'Helvetica';
plot_info.traj_line_width       = 1.0;
plot_info.phi_line_width        = 1.5;
plot_info.phihat_line_width     = 1.5;
plot_info.rhotscalingdownfactor = 1;
plot_info.showplottitles        = false;
plot_info.display_phihat        = false;
plot_info.display_interpolant   = true;
plot_info.T_L_marker_size       = 40;
plot_info.solver_info           = solver_info;
plot_info.line_styles           = {'-', '-.', '--', ':'};                                        % traj. line styles
plot_info.type_colors           = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
plot_info.marker_style          = {'s', 'd', 'p', 'h', 'x', '+', 'v', '^', '<', '>'};            
plot_info.marker_size           = plot_info.T_L_marker_size;                                                   
plot_info.marker_edge_color     = {'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k'};
plot_info.marker_face_color     = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; else, SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end 
plot_info.SAVE_DIR              = SAVE_DIR;
time_stamp                      = '123';
plot_info.plot_name             = sprintf('%s/%s_learningOutput_%s',SAVE_DIR, sys_info.name, time_stamp);
if contains(sys_info.name, 'ModelSelection')
  displayMSLearningResults(learningOutput, sys_info, plot_info);
else
  plot_info.save_file              = sprintf('%s/%s_learningOutput%s.mat', SAVE_DIR, sys_info.name, time_stamp);
  displayLearningResults_for_PNAS(learningOutput, sys_info, chosen_dynamics, obs_info, learn_info, plot_info);
end