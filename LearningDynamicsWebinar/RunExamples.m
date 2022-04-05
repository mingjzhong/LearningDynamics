% 
% Run the Examples from several different scenarios
%

% (c) M. Zhong

% check to see if necessary paths are needed
if ispc
% Windows is not case-sensitive
  onPath = contains(lower(path), lower(pwd));
else
  onPath = contains(path, pwd);
end
% run startup with pwd
if ~onPath
  startup;
end

% set up the scenarios to run on
scenarios  = {'Run the examples for the PNAS paper', ...
              'Run the examples for Physica D paper', ...
              'Run the examples for Dynamics on Manifold', ...              
              'Run the examples for 2nd Order Learning paper', ...
              'Run the examples for all dynamics (no learning)'};
% pick a scenario           
for idx = 1 : length(scenarios)
  fprintf('\n [%2d] %s', idx, scenarios{idx});
end
fprintf('\n\n');    
ScenarioIdx = input('Pick an scenario to run:           ');
switch ScenarioIdx
  case 1
    RunExamples_PNAS;
  case 2
    choice = 'PhysicaD';
    RunExamples_main;   
  case 3
    choice = 'LDoM';
    RunExamples_main;    
  case 4
    choice = '2ndMC';
    RunExamples_main;       
  case 5
    RunExamples_dynamics;  
  otherwise
    error('RunExamples:exception', 'Invalid user input: 1 <= input <= %2d.', length(scenarios));
end
return