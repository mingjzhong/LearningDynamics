function make_traj_multiD_animation(traj_fig, trajs, dtrajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)
% function make_traj_multiD_animation(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)

% (C) M. Zhong

% routine check
if sys_info.d == 1, error('SOD_Utils:make_traj_multiD_animation:exception', 'This routine is for 2D/3D animation!!'); end
% split the trajectories
X_coords                       = cell(length(trajs), sys_info.d); 
dX_coords                      = cell(length(trajs), sys_info.d);
the_mins                       = zeros(length(trajs), sys_info.d); 
the_maxs                       = zeros(length(trajs), sys_info.d); 
the_spans                      = zeros(1, sys_info.d);
if isfield(plot_info, 'phases') && ~isempty(plot_info.phases)
  phase_maxs                   = zeros(1, length(trajs));
  phase_mins                   = zeros(1, length(trajs)); 
  phases                       = cell(1, length(trajs));
end
for ind = 1 : length(trajs)
  traj                         = trajs{ind}; 
  dtraj                        = dtrajs{ind}; 
  for d_ind = 1 : sys_info.d
    X_cd                       = traj(d_ind : sys_info.d : end - (sys_info.d - d_ind), :);
    dX_cd                      = dtraj(d_ind : sys_info.d : end - (sys_info.d - d_ind), :);
    the_mins(ind, d_ind)       = min(X_cd(:));
    the_maxs(ind, d_ind)       = max(X_cd(:));
    X_coords{ind, d_ind}       = X_cd;
    dX_coords{ind, d_ind}      = dX_cd;
  end
  if isfield(plot_info, 'phases') && ~isempty(plot_info.phases)
    phase                      = plot_info.phases{ind};
    phase_mins(ind)            = min(phase(:));
    phase_maxs(ind)            = max(phase(:));
    phases{ind}                = phase;
  end  
end
x_min                          = min(the_mins(:, 1));
x_max                          = max(the_maxs(:, 1));
the_spans(1)                   = x_max - x_min;
y_min                          = min(the_mins(:, 2));
y_max                          = max(the_maxs(:, 2));
the_spans(2)                   = y_max - y_min;
if isfield(plot_info, 'phases') && ~isempty(plot_info.phases)
  cmap                         = colormap('parula');
  phase_min                    = min(phase_mins);
  phase_max                    = max(phase_maxs);
end
if sys_info.d == 3, z_min = min(the_mins(:, 3)); z_max = max(the_maxs(:, 3)); the_spans(3) = z_max - z_min; end
if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold) && sys_info.on_manifold
  [manifold_min, manifold_max] = get_component_range_from_manifold(sys_info);
  if ~isempty(manifold_min)
    x_min                      = min([x_min, manifold_min(1)]);
    x_max                      = max([x_max, manifold_max(1)]);
    y_min                      = min([y_min, manifold_min(2)]);
    y_max                      = max([y_max, manifold_max(2)]);
    if sys_info.d == 3
      z_min                    = min([z_min, manifold_min(3)]);
      z_max                    = max([z_max, manifold_max(3)]);
    end
  end
end
[x_min, x_max]                 = get_adjusted_traj_range(x_min, x_max);
[y_min, y_max]                 = get_adjusted_traj_range(y_min, y_max);
if sys_info.d == 3
  [z_min, z_max]               = get_adjusted_traj_range(z_min, z_max);
end
if length(trajs) == 1, handleAxes = gobjects(1); else, handleAxes = gobjects(length(trajs)/2, 2); end
T_loc                          = find(time_vec == obs_info.T);
sp_handles                     = gobjects(1, length(trajs));
lg_handles                     = gobjects(length(trajs), sys_info.K);
lg_names                       = cell(length(trajs), sys_info.K);
arrow_lens                     = cell(size(trajs));
type_names                     = get_type_names(sys_info);
for ind = 1 : length(trajs)
  for d_ind = 1 : sys_info.d
    if d_ind == 1, actual_len = (dX_coords{ind, d_ind}/the_spans(d_ind)).^2;
    else, actual_len = actual_len + (dX_coords{ind, d_ind}/the_spans(d_ind)).^2; end
  end
  arrow_lens{ind}              = plot_info.arrow_scale ./ sqrt(actual_len);                         % arrow length relative to fig. window size
  if length(trajs) == 1, sp_handles(ind) = subplot(1, 1, ind); else, sp_handles(ind) = subplot(length(trajs)/2, 2, ind); end 
  if mod(ind, 2) == 1, name = 'True '; else, name = 'Learned '; end
  for k = 1 : sys_info.K
    if length(trajs) == 1, lg_names{ind, k} = type_names{k}; else, lg_names{ind, k} = [name type_names{k}]; end
  end
  row_ind                      = floor((ind - 1)/2) + 1;
  col_ind                      = mod(ind - 1, 2) + 1;  
  handleAxes(row_ind, col_ind) = sp_handles(ind);
end
set(traj_fig, 'visible', 'on');
movie_file                     = VideoWriter([plot_info.plot_name '_mov'], 'MPEG-4');
open(movie_file);
for time_ind = 1 : length(time_vec)
  for ind = 1 : length(trajs)
    sp_handle = sp_handles(ind);
    if 1 <= ind && ind <= 4, the_sys_info = sys_info; else, the_sys_info = sys_info_Ntransfer; end
    if isfield(plot_info, 'phases') && ~isempty(plot_info.phases)
      phases_at_t              = phases{ind}(:, time_ind);
      scaled_phase             = (phases_at_t - phase_min)/(phase_max - phase_min);
      color_ind                = round((size(cmap, 1) - 1) * scaled_phase) + 1;
      plot_info.color_on_phase = cmap(color_ind, :);
    end
    lg_handles(ind, :)         = plot_one_point_multiD(traj_fig, sp_handle, X_coords(ind, :), ...
                                 dX_coords(ind, :), time_ind, arrow_lens{ind}(:, time_ind), ...
                                 T_loc == time_ind, the_sys_info, plot_info);
    plot_one_line_multiD(traj_fig, sp_handle, X_coords(ind, :), time_ind, the_sys_info, plot_info); 
    if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold) && sys_info.on_manifold
      if strcmp(sys_info.manifold_type, 'H2')
        plot_info.y_range      = [y_min, y_max];
        plot_info.z_range      = [z_min, z_max];
      end
      plot_manifold(traj_fig, sp_handle, sys_info, plot_info);
    end
    hold off;
    if ind == 1
      xticks                   = get(sp_handle, 'XTick');
      if isfield(plot_info, 'phases') && ~isempty(plot_info.phases)
        delta                  = xticks(2) - xticks(1);
      else
        delta                  = 0;
      end
    end
    if sys_info.d == 2, axis([x_min, x_max + delta, y_min, y_max]); 
    else, axis([x_min, x_max + delta, y_min, y_max, z_min, z_max]); end
    sp_handle.FontSize         = plot_info.tick_font_size;
    sp_handle.FontName         = plot_info.tick_font_name;    
    if mod(ind, 2) == 1
      zlabel('Coord. $3$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
        'FontName', plot_info.axis_font_name); 
    end
    ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
      'FontName', plot_info.axis_font_name);
    if ind == length(trajs) - 1 || ind == length(trajs)
      xlabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
      'FontName', plot_info.axis_font_name); 
    end
    if isfield(plot_info, 'traj_titles') && ~isempty(plot_info.traj_titles)
      title(plot_info.traj_titles{ind}, 'FontSize', plot_info.axis_font_size, 'Interpreter', ...
        'latex', 'FontName', plot_info.axis_font_name);
    end   
    if (length(trajs) == 1 || mod(ind, 2) == 0) && isfield(plot_info, 'phases') && ...
        ~isempty(plot_info.phases)
      tickLabel                = {sprintf('%.1f', phase_min), ...
                                  sprintf('%.1f', (phase_min + phase_max)/2), sprintf('%.1f', phase_max)};
      cbh                      = colorbar('YTickLabel', tickLabel, 'YTick', [0, 0.5, 1], ...
                                 'Location', 'East');
      set(cbh, 'FontSize', plot_info.colorbar_font_size);
    end    
%     if time_ind < ceil(length(time_vec)/10) || time_ind == T_loc || ...
%         time_ind > ceil(length(time_vec) * 9/10)
%       leg_handle               = legend(lg_handles(ind, :), lg_names(ind, :));
%       if plot_info.legend_font_size > 16
%         legend_font_size       = 16;
%       else
%         legend_font_size       = plot_info.legend_font_size;
%       end
%       set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', legend_font_size);
%     end
  end
  tightFigaroundAxes(handleAxes);
  writeVideo(movie_file, getframe(gcf));
  if time_ind == 1, pause(0.01); end
end
close(movie_file);
end