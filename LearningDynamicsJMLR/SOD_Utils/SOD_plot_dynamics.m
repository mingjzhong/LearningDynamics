function SOD_plot_dynamics(dynamics, system_info, plot_info)
% SOD_plot_dynamics(trajectories, time_vec, system_info, plot_info)

% Ming Zhong
% Postdoc Research

% find out the information about the self-organized dynamical system
% find out the number of agents
N                        = system_info.N;
% find out the size of the state vector for each agent
d                        = system_info.d;
% find out the number of classes in the system
num_classes              = system_info.K;
% find out the class information function
class_info               = system_info.class_info;
% find out the trajectory to plot
traj                     = dynamics.y;
% find out the time vector at which the discrete trajectory is obtained
time_vec                 = dynamics.x;
% find out the number of the time steps taken by the numerical integrator
L                        = length(time_vec);
% prepare different colors according to classes
colors                   = {'b', 'r', 'g', 'c', 'm', 'y', 'k', 'w'};
% prepare different markers for different classes
marker_styles            = {'o', 's', 'd', 'p', 'h', '.', 'x', 'v', '^', '<', '>'};
% prepare different marker sizes for different classes
marker_sizes             = 10 : 10 : 40;
% only visualize the data when the state vector is of size 3 and lower
if d <= 3
% plot the trajectories over time
  win_title              = sprintf('Self-Organized Dynamics - %d-D', d);
  traj_fig = figure('Name', win_title, 'NumberTitle', 'off', 'units', 'normalized', 'position', [0.2, 0.2, 0.55, 0.55]);
% do the plot according to different size of the state vectors, for now   
  switch d
% for 1D state, only the position of the agents will be shown (no velocity)
    case 1
      hold on;
      for agent_ind = 1 : N
        one_traj         = traj(agent_ind, :);
        plot(time_vec, one_traj, 'color', colors{class_info(agent_ind)});
      end
      hold off;
      xlabel('time(t)');
      ylabel('State x_i(t)');
      title(plot_info.traj_title);
      y_min              = min(min(min(traj))) - 0.1;
      y_max              = max(max(max(traj))) + 0.1;
      x_min              = time_vec(1);
      x_max              = time_vec(end);
      axis([x_min, x_max, y_min, y_max]);
      if plot_info.save_traj
        print(traj_fig, plot_info.traj_file, '-depsc2');
      end
    case 2
% find out the position of each agent
      U_of_t             = traj(1 : 2 * N, :);
% find out the velocity information      
      if system_info.ode_order == 1
% when velocity information is provided
        if plot_info.has_velocity
          V_of_t         = plot_info.velocity;
          has_V          = true;
        else
          has_V          = false;
        end
      elseif system_info.ode_order == 2
% find out the velocity from the system
        V_of_t         = traj(2 * N + 1 : 4 * N, :);
        has_V          = true;
      end
% get the x-component of U, squeeze out the singleton dimensions
      Ux_of_t          = U_of_t(1 : 2 : 2 * N - 1, :);
% get the y-component of U, squeeze out the singleton dimensions
      Uy_of_t          = U_of_t(2 : 2 : 2 * N, :);
      if has_V
% get the x-component of V, squeeze out the singleton dimensions
        Vx_of_t          = V_of_t(1 : 2 : 2 * N - 1, :);
% get the y-component of V, squeeze out the singleton dimensions
        Vy_of_t          = V_of_t(2 : 2 : 2 * N, :);   
      end
% find out the size for the axis, fix a box to plot the points
      x_min            = min(min(Ux_of_t)) - 0.1;
      x_max            = max(max(Ux_of_t)) + 0.1;
      y_min            = min(min(Uy_of_t)) - 0.1;
      y_max            = max(max(Uy_of_t)) + 0.1;
% start an avi object, when the movie_flag is turned on
      if plot_info.movie_flag
% use compressed motion JPEG 2000          
        aviobj         = VideoWriter(plot_info.movie_name, 'Motion JPEG AVI');
        open(aviobj)
      end
% advance in time        
      for t_ind = 1 : L
% make sure we are on the right window          
        set(0, 'Currentfigure', traj_fig);
% clear the previous plot          
        set(traj_fig, 'nextplot', 'replacechildren');
% do the plot by class types
        for k = 1 : num_classes
% find out the class of agents            
          a_class      = find(class_info == k);
% plot them using scatter            
          scatter(Ux_of_t(a_class, t_ind), Uy_of_t(a_class, t_ind), marker_sizes(k), colors{k}, marker_styles{k});
% if this is the first time we do scatter, we put up a hold            
          if k == 1
            hold on;
          end
% for 2nd order system, put down the velocity with arrows           
          if has_V
            quiver(Ux_of_t(a_class, t_ind), Uy_of_t(a_class, t_ind), Vx_of_t(a_class, t_ind), Vy_of_t(a_class, t_ind), ...
            0.5, 'k');
          end
        end
        xlabel('x comp. of the state vector');
        ylabel('y comp. of the state vector');
        title(sprintf('Agents at time = %9.3E', time_vec(t_ind)));
        axis([x_min, x_max, y_min, y_max]);
        if plot_info.movie_flag == 1
          traj_frame = getframe(traj_fig);
          writeVideo(aviobj, traj_frame);
        end
        if t_ind == 1
          pause;
        else
          pause(0.01);
        end
% after the plot is drawn and saved into avi, clear the figure
        if t_ind < length(time_vec)
          clf;
        end
      end
 % cloase the avi object
      if plot_info.movie_flag == 1
        close(aviobj);
      end
    case 3
      error('');
    otherwise
  end
else
  fprintf('Visualization for state vectors of size more then 3 is not possible!!\n');
end
end