function displayPatternIndicators(learningOutput, solver_info)
% function displayPatternIndicators(learningOutput, solver_info)

% (C) M. Zhong (JHU)

fprintf('\n------------------- Predication Performance for training IC''s (T_f = %10.4e):', solver_info.time_span(2));
level = size(learningOutput{1}.patternIndicatorScores.training.scores, 1);
fprintf('\n------------------- Confusion Matrix:');
fprintf('\n\tTN = %10.4e%c%10.4e, FP = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(1, 1), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(1, 1), learningOutput)), ...
  mean(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(1, 2), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(1, 2), learningOutput)));
fprintf('\n\tFN = %10.4e%c%10.4e, TP = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(2, 1), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(2, 1), learningOutput)), ...
  mean(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(2, 2), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.cMatrix(2, 2), learningOutput)));
fprintf('\n\tClassification Accuracy = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.accuracy, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.accuracy, learningOutput)));
fprintf('\n\tMisclassification Rate  = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.MR, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.MR, learningOutput)));
fprintf('\n\tPrecision               = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.precision, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.precision, learningOutput)));
fprintf('\n\tRecall                  = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.recall, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.recall, learningOutput)));
fprintf('\n\tF Score                 = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.training.F_score, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.training.F_score, learningOutput)));                            
fprintf('\n------------------- Pattern Indicator Scores:');
for level_ind = 1 : level
  fprintf('\n\tAt level = %2d, mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e', level_ind, ...
    mean(cellfun(@(x) mean(x.patternIndicatorScores.training.scores(level_ind, :)), learningOutput)), 177, std(cellfun(@(x) mean(x.patternIndicatorScores.training.scores(level_ind, :)), learningOutput)), ...
    mean(cellfun(@(x) std(x.patternIndicatorScores.training.scores(level_ind, :)),  learningOutput)), 177, std(cellfun(@(x) std(x.patternIndicatorScores.training.scores(level_ind, :)),  learningOutput)))
end

fprintf('\n------------------- Predication Performance for new IC''s (T_f = %10.4e):', solver_info.time_span(2));
fprintf('\n------------------- Confusion Matrix:');
fprintf('\n\tTN = %10.4e%c%10.4e, FP = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(1, 1), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(1, 1), learningOutput)), ...
  mean(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(1, 2), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(1, 2), learningOutput)));
fprintf('\n\tFN = %10.4e%c%10.4e, TP = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(2, 1), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(2, 1), learningOutput)), ...
  mean(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(2, 2), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.cMatrix(2, 2), learningOutput)));
fprintf('\n\tClassification Accuracy = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.accuracy, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.accuracy, learningOutput)));
fprintf('\n\tMisclassification Rate  = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.MR, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.MR, learningOutput)));
fprintf('\n\tPrecision               = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.precision, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.precision, learningOutput)));
fprintf('\n\tRecall                  = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.recall, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.recall, learningOutput)));
fprintf('\n\tF Score                 = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.new.F_score, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.new.F_score, learningOutput)));  
fprintf('\n------------------- Pattern Indicator Scores:');
for level_ind = 1 : level
  fprintf('\n\tAt level = %2d, mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e', level_ind,...
    mean(cellfun(@(x) mean(x.patternIndicatorScores.new.scores(level_ind, :)), learningOutput)), 177, std(cellfun(@(x) mean(x.patternIndicatorScores.new.scores(level_ind, :)), learningOutput)), ...
    mean(cellfun(@(x) std(x.patternIndicatorScores.new.scores(level_ind, :)),  learningOutput)), 177, std(cellfun(@(x) std(x.patternIndicatorScores.new.scores(level_ind, :)),  learningOutput)))
end 

if isfield(learningOutput{1}, 'trajErr_Ntransfer') && ~isempty(learningOutput{1}.trajErr_Ntransfer)
  fprintf('\n------------------- Predication Performance for Larger N (T_f = %10.4e):', solver_info.time_span(2));
  fprintf('\n------------------- Confusion Matrix:');
  fprintf('\n\tTN = %10.4e%c%10.4e, FP = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(1, 1), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(1, 1), learningOutput)), ...
    mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(1, 2), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(1, 2), learningOutput)));
  fprintf('\n\tFN = %10.4e%c%10.4e, TP = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(2, 1), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(2, 1), learningOutput)), ...
    mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(2, 2), learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.cMatrix(2, 2), learningOutput)));
  fprintf('\n\tClassification Accuracy = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.accuracy, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.accuracy, learningOutput)));
  fprintf('\n\tMisclassification Rate  = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.MR, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.MR, learningOutput)));
  fprintf('\n\tPrecision               = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.precision, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.precision, learningOutput)));
  fprintf('\n\tRecall                  = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.recall, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.recall, learningOutput)));
  fprintf('\n\tF Score                 = %10.4e%c%10.4e', mean(cellfun(@(x) x.patternIndicatorScores.Ntransfer.F_score, learningOutput)), 177, std(cellfun(@(x) x.patternIndicatorScores.Ntransfer.F_score, learningOutput)));  
  fprintf('\n------------------- Pattern Indicator Scores:');  
  for level_ind = 1 : level
    fprintf('\n\tAt level = %2d, mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e', level_ind,...
      mean(cellfun(@(x) mean(x.patternIndicatorScores.Ntransfer.scores(level_ind, :)), learningOutput)), 177, std(cellfun(@(x) mean(x.patternIndicatorScores.Ntransfer.scores(level_ind, :)), learningOutput)), ...
      mean(cellfun(@(x) std(x.patternIndicatorScores.Ntransfer.scores(level_ind, :)),  learningOutput)), 177, std(cellfun(@(x) std(x.patternIndicatorScores.Ntransfer.scores(level_ind, :)),  learningOutput)))
  end 
end
end