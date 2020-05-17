function patternIndicatorScores = computePatternIndicatorScores(learningOutput, sys_info, ...
         sys_info_Ntransfer)
% function patternIndicatorScores = computePatternIndicatorScores(learningOutput, sys_info, ...
%          sys_info_Ntransfer, solver_info)

% (C) M. Zhong (JHU)

% pattern indicator scores on training ICs data
if ~isempty(learningOutput.trajErr)
  patternIndicatorScores.training = computePatternIndicatorforEachTrajType(learningOutput.trajErr, ...
                                    sys_info);
else
  patternIndicatorScores.training = [];
end
% pattern indicator scores on new ICs data
if ~isempty(learningOutput.trajErr_new)
  patternIndicatorScores.new      = computePatternIndicatorforEachTrajType(learningOutput.trajErr_new, ...
                                    sys_info);
else
  patternIndicatorScores.new      = [];
end
% pattern indicator scores on new ICs data
if ~isempty(learningOutput.trajErr_Ntransfer)
  patternIndicatorScores.Ntransfer = computePatternIndicatorforEachTrajType(learningOutput.trajErr_Ntransfer, ...
                                     sys_info_Ntransfer);
else
  patternIndicatorScores.Ntransfer = [];
end
end