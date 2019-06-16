% 
% Run the Examples from several different scenarios
%

% (c) M. Zhong

% set up the scenarios to run on
scenarios = {'Run the main examples', ...
             'Run the Model Selection examples', ...
             'Run the M vs. L convergence test for the main examples'};
% pick a scenario           
for idx = 1 : length(scenarios)
  fprintf('\n [%2d] %s', idx, scenarios{idx});
end
fprintf('\n\n');    
ScenarioIdx = input('Pick an scenario to run:           ');
switch ScenarioIdx
  case 1
    RunExamples_main;
  case 2
    RunExamples_modelSelection;
  case 3
    RunExamples_MLTest;
  otherwise
    error('RunExamples:exception', 'Invalid user input (1 <= input <= %2d)', length(scenarios));
end
return