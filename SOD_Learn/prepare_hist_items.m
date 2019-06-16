function [histedgesR, histbinwidthR, histedgesDR, histbinwidthDR, histedgesXi, histbinwidthXi, histcountR, ...
         histcountA, histcountDR, jhistcountXi, histcountXi] = prepare_hist_items(K, hist_num_bins, M, max_rs, max_dotrs, max_xis)
% 

% (c) M. Zhong (JHU)

histedgesR                      = cell(K);
histbinwidthR                   = zeros(K);
histedgesDR = []; histbinwidthDR = []; histedgesXi = []; histbinwidthXi = [];
if ~isempty(max_dotrs), histedgesDR = cell(K); histbinwidthDR = zeros(K); end
if ~isempty(max_xis), histedgesXi = cell(K); histbinwidthXi = zeros(K); end

for k1 = 1 : K
  for k2 = 1 : K
    histedgesR{k1, k2}          = linspace(0, max_rs(k1, k2), hist_num_bins + 1);
    histbinwidthR(k1, k2)       = max_rs(k1, k2)/hist_num_bins;
    if ~isempty(max_dotrs)
      histedgesDR{k1, k2}       = linspace(0, max_dotrs(k1, k2), hist_num_bins + 1);
      histbinwidthDR(k1, k2)    = max_dotrs(k1, k2)/hist_num_bins;
    end
    if ~isempty(max_xis)
      histedgesXi{k1, k2}       = linspace(0, max_xis(k1, k2), hist_num_bins + 1);
      histbinwidthXi(k1, k2)    = max_xis(k1, k2)/hist_num_bins;
    end
  end
end
% prepare the hist counts for rhoLTE, rhoLTA and rhoLTXi
histcountR                        = cell(1, M);
histcountA = []; histcountDR = []; jhistcountXi = []; histcountXi = [];
if ~isempty(max_dotrs), histcountA = cell(1, M); histcountDR = cell(1, M); end
if ~isempty(max_xis), jhistcountXi = cell(1, M); histcountXi = cell(1, M); end
end