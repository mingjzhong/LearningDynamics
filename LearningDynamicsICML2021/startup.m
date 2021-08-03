function startup(home_path)
% startup()
%   Adds necessary paths to the simulator

% (c) M. Zhong, JHU

if nargin < 1, home_path = pwd; end
%% prepare all needed folders to run the learning simulator
fprintf('\nSetting up paths for Learning Dynamics...');                                                                         
fprintf('\n\tAdding necessary folders to %s', home_path);
addpath([home_path, filesep, 'SOD_Evolve', filesep]);                                               % code to run the dynamics for obtaining observation 
addpath([home_path, filesep, 'SOD_Learn', filesep]);                                                % code to run the learning routines
addpath([home_path, filesep, 'SOD_Utils', filesep]);                                                % Utility routines (plotting etc.)                                                                         
addpath([home_path, filesep, 'SOD_External', filesep]);                                             % External routines
addpath([home_path, filesep, 'SOD_Manifold', filesep]);                                             % Dynamics on Manifold 
addpath(genpath([home_path, filesep, 'SOD_Examples', filesep]));                                    % code to generate the examples for specific dynamics
fprintf('\ndone.\n');
end
