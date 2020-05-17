% 
% Run the Examples from several different scenarios
%

% (c) M. Zhong

% set up the scenarios to run on
scenarios  = {'Run the examples for the PNAS paper', ...
              'Run the examples for Physica D paper', ...
              'Run only the dynamics';
% pick a scenario           
for idx = 1 : length(scenarios)
  fprintf('\n [%2d] %s', idx, scenarios{idx});
end
fprintf('\n\n');    
ScenarioIdx = input('Pick an scenario to run:           ');
switch ScenarioIdx
  case 1
    choice = 'PNAS';
    RunExamples_main;
  case 2
    choice = 'PhysicaD';
    RunExamples_main;   
  case 3
    RunExamples_dynamics;    
  otherwise
    error('RunExamples:exception', 'Invalid user input: 1 <= input <= %2d.', length(scenarios));
end
return