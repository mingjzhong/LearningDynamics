%
% Run the various examples of learning using the NASA JPL's Development Ephemeris
%
% (c) M. Zhong

%% set up the cases to run on
cases                    = {'Run the main examples', ...
                            'Run the examples of model selection'};
% pick a case           
for idx = 1 : length(cases)
  fprintf('\n [%2d] %s', idx, cases{idx});
end
fprintf('\n\n');    
caseInd                  = input('Pick a case to run:           ');
switch caseInd
  case 1
    choice = 'PNAS';
    RunExamples_main;
  case 2
    RunExamples_modelSelection;
  otherwise
    error('RunExamples:exception', 'Invalid user input: 1 <= input <= %2d.', length(cases));
end
return