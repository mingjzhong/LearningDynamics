function [err_mean, err_std] = getTrajErrStat_each_kind(ind, trajErrs)
% function [err_mean, err_std] = getTrajErrStat_each_kind(ind, trajErrs)

% (C) M. Zhong

if isempty(trajErrs{1}.sup_fut)
  err_mean       = zeros(1, length(trajErrs));
  err_std        = zeros(1, length(trajErrs));
else
  err_mean       = zeros(3, length(trajErrs));
  err_std        = zeros(3, length(trajErrs));    
end
err_mean(1, :)   = cellfun(@(x) mean(x.sup(ind, :)),     trajErrs);
if ~isempty(trajErrs{1}.sup_fut)
  err_mean(2, :) = cellfun(@(x) mean(x.sup_mid(ind, :)), trajErrs);
  err_mean(3, :) = cellfun(@(x) mean(x.sup_fut(ind, :)), trajErrs);
end
err_std(1, :)    = cellfun(@(x)  std(x.sup(ind, :)),     trajErrs);
if ~isempty(trajErrs{1}.sup_fut)
  err_std(2, :)  = cellfun(@(x)  std(x.sup_mid(ind, :)), trajErrs);
  err_std(3, :)  = cellfun(@(x)  std(x.sup_fut(ind, :)), trajErrs);
end
end