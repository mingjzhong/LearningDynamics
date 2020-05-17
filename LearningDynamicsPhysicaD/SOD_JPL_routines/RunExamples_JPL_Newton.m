%
% Run the Example of Using Newton's Gravity on JPL's Development Ephemeris
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                                                  
time_stamp                     = datestr(now, 30);
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
selection_idx                  = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                   % index from each AO in the solar system, from 1 = Sun to 9 = Neptune
total_num_years                = 400;                                                               % total number of years of data, integer value
num_years                      = 400;                                                               % number of years of data for learning
data_kind                      = 2;                                                                 % use either daily or houly data
use_v                          = true;                                                              % use true velocity or not
load_data_time                 = tic;
[Example, obs_data]            = Gravitation_JPL_def(selection_idx, num_years, total_num_years, ...
                                 use_v, data_kind);
obs_data.y                     = [];
obs_data.time_vec              = [];
fprintf('\nIt takes %6.2f secs to load the data', toc(load_data_time));

%% Get example parameters
sys_info                       = Example.sys_info;
solver_info                    = Example.solver_info;                                                         

%% Perform learning on trajectory data
overall_time                   = tic;
fprintf('\n================================================================================');
syshat_info                    = sys_info;
for k1 = 1 : syshat_info.K
  for k2 = 1 : syshat_info.K
    if k1 == k2
      syshat_info.phiE{k1, k2} = @(r) zeros(size(r));
    else
      syshat_info.phiE{k1, k2} = @(r) syshat_info.G * syshat_info.known_mass(k2) * r.^(-3);         % Newton's Gravity 
    end
  end
end

%% trajectory errors, precession rates, and errors in estimating masses
fprintf('\nCalculating Traj. Err......');
err_time                       = tic;
learn_out.syshat_info          = syshat_info;
dynamics_type                  = 'Newton''s Gravity';
[~, ~, trajErr, dynhat]        = get_JPL_trajErr(obs_data, sys_info, solver_info, syshat_info, ...
                                 num_years, total_num_years, dynamics_type);
learn_out.trajErr              = trajErr;
learn_out.dynamicshat          = dynhat;
fprintf('\n------------------- Time for traj. err.: %6.2f sec.', toc(err_time));
  
%% save the output
save_file                      = sprintf('%s/%s_%s_Newton.mat', SAVE_DIR, sys_info.name, time_stamp);
save(save_file, '-v7.3', 'sys_info', 'solver_info', 'obs_data', 'SAVE_DIR', 'syshat_info', ...
  'num_years', 'total_num_years', 'learn_out');
%% Done
fprintf('\nDone.\n');
return
