function plot_info = get_plot_info(is_JPL)
% function plot_info = get_plot_info(is_JPL)

% (C) M. Zhong

if nargin < 1, is_JPL = false; end
plot_info.scrsz                 = [1, 1, 1920, 1080];                                               % change the 3rd and 4th parameters for bigger size (width x height)
if ~is_JPL
  plot_info.legend_font_size    = 26;
else
  plot_info.legend_font_size    = 16;
end
plot_info.legend_font_name      = 'Helvetica';
plot_info.colorbar_font_size    = 16;
if ~is_JPL
  plot_info.title_font_size     = 30;
else
  plot_info.title_font_size     = 16;
end
plot_info.title_font_name       = 'Helvetica';
if ~is_JPL
  plot_info.axis_font_size      = 30;
else
  plot_info.axis_font_size      = 16;
end
plot_info.axis_font_name        = 'Helvetica';
if ~is_JPL
  plot_info.tick_font_size      = 26;
else
  plot_info.tick_font_size      = 16;
end
plot_info.tick_font_name        = 'Helvetica';
plot_info.traj_line_width       = 1.5;
plot_info.phi_line_width        = 1.5;
plot_info.phihat_line_width     = 1.5;
plot_info.phi_rho_resolution    = 20;
% plot_info.display_phihat           = true; % retired
plot_info.make_movie            = false;
plot_info.arrow_thickness       = 1.5;                                                              % thickness of the arrow body
plot_info.arrow_head_size       = 0.8;                                                              % size of the arrow head
plot_info.arrow_scale           = 0.05;                                                             % arrow length relative to fig. window size
plot_info.line_styles           = {'-', '-.', '--', ':'};                                           % traj. line styles
plot_info.type_colors           = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
plot_info.marker_style          = {'s', 'd', 'p', 'h', 'x', '+', 'v', '^', '<', '>'};            
plot_info.marker_size           = 10;                                                   
plot_info.marker_edge_color     = {'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k'};
plot_info.marker_face_color     = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
plot_info.rhotscalingdownfactor = 1;
plot_info.showplottitles        = false;
if ~is_JPL
  plot_info.showlabels          = true;
  plot_info.showplotlegends     = true;
else
  plot_info.showlabels          = false;  
  plot_info.showplotlegends     = false;
end
plot_info.T_L_marker_size       = plot_info.traj_line_width;
plot_info.rho_color             = [0.85, 0.325, 0.098];
plot_info.color_gray            = 0.2 * [7/255, 17/255, 17/255]; % color gray
plot_info.bg_trans              = 0.1;
plot_info.bg_colors             = [plot_info.color_gray; 
                                   0,      0.4470, 0.7410; % taken from MATLAB's pre-defined colors
                                   0.850,  0.325,  0.098; 
                                   0.929,  0.694,  0.125;
                                   0.494,  0.184,  0.556;
                                   0.466,  0.674,  0.188;
                                   0.301,  0.745,  0.933;
                                   0.635,  0.078,  0.184;];
end