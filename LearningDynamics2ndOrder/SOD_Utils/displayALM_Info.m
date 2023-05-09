function displayALM_Info(learningOutput)
% function displayALM_Info(learningOutput)

% (C) M. Zhong

K = length(learningOutput{1}.Estimator.ALM_Info);
fprintf('\n------------------- Info. about the learning matrix A_{L, M}:');
for k = 1 : K
  fprintf('\nFor A_%d:', k);
  fprintf('\n\tCond. Num. = %10.4e%c%10.4e.', ...
    mean(cellfun(@(x) x.Estimator.ALM_Info{k}.condNum, learningOutput)), 177, ...
    std(cellfun(@(x) x.Estimator.ALM_Info{k}.condNum, learningOutput)));
  fprintf('\n\tSmal. Eig. = %10.4e%c%10.4e.', ...
    mean(cellfun(@(x) x.Estimator.ALM_Info{k}.smallest_eig, learningOutput)), 177, ...
    std(cellfun(@(x) x.Estimator.ALM_Info{k}.smallest_eig, learningOutput)));
end
if ~isempty(learningOutput{1}.Estimator.ALMXi_Info)
  fprintf('\n------------------- Info. about the learning matrix A_{L, M}^{xi}:');
  for k = 1 : K
    fprintf('\nFor A^{xi}_%d:', k);
    fprintf('\n\tCond. Num. = %10.4e%c%10.4e.', ...
      mean(cellfun(@(x) x.Estimator.ALMXi_Info{k}.condNum, learningOutput)), 177, ...
      std(cellfun(@(x) x.Estimator.ALMXi_Info{k}.condNum, learningOutput)));
    fprintf('\n\tSmal. Eig. = %10.4e%c%10.4e.', ...
      mean(cellfun(@(x) x.Estimator.ALMXi_Info{k}.smallest_eig, learningOutput)), 177, ...
      std(cellfun(@(x) x.Estimator.ALMXi_Info{k}.smallest_eig, learningOutput)));
  end  
end