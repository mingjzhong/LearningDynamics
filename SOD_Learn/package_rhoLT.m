function rhoLT = package_rhoLT(histedgesR, histcountR, histbinwidthR, histedgesDR, histcountDR, histbinwidthDR, histedgesXi, histcountXi, histbinwidthXi, ...
         histcountA, jhistcountXi, M, sys_info, obs_info, max_rs, min_rs, max_dotrs, min_dotrs, max_xis, min_xis)
% function rhoLT = package_rhoLT(histedgesR, histcountR, histedgesDR, histcountDR, histedgesXi, histcountXi, histcountA, jhistcountXi, M, sys_info, obs_info, max_rs, min_rs, max_dotrs, min_dotrs, max_xis, min_xis)

% (c) M. Zhong

% prepare some indicators
if sys_info.ode_order == 1
    has_energy                  = 1;
    has_align                   = 0;
    has_xi                      = 0;
elseif sys_info.ode_order == 2
    if ~isempty(sys_info.phiE)
        has_energy              = 1;
    else
        has_energy              = 0;
    end
    if ~isempty(sys_info.phiA)
        has_align               = 1;
    else
        has_align               = 0;
    end
    has_xi                      = sys_info.has_xi;
end
output                          = restructure_histcount(histcountR, histcountDR, histcountA, histcountXi, jhistcountXi, M, sys_info.K, sys_info.type_info, obs_info.hist_num_bins);

histcountR                      = output.histcountR;
if has_align
    histcountA                    = output.histcountA;
    histcountDR                   = output.histcountDR;
end
if has_xi
    jhistcountXi                  = output.jhistcountXi;
    histcountXi                   = output.histcountXi;
end

% post-processing the data
histcount                       = cell(sys_info.K);
hist                            = cell(sys_info.K);
supp                            = cell(sys_info.K);
histedges                       = cell(sys_info.K);
max_rs                          = max(max_rs, [], 3);
min_rs                          = min(min_rs, [], 3);
histcountR                      = sum(histcountR, 4);
histcount_R                     = cell(sys_info.K);
hist_R                          = cell(sys_info.K);
supp_R                          = cell(sys_info.K);
for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
        supp_R{k1, k2}              = [min_rs(k1, k2), max_rs(k1, k2)];
        histcount_R{k1, k2}         = squeeze(histcountR(k1, k2, :));
        hist_R{k1, k2}              = histcount_R{k1, k2}/(sum(histcount_R{k1, k2}) * histbinwidthR(k1, k2));
    end
end
if has_energy
    for k1 = 1 : sys_info.K
        for k2 = 1 : sys_info.K
            supp{k1, k2}              = supp_R{k1, k2};
            histcount{k1, k2}         = histcount_R{k1, k2};
            hist{k1, k2}              = hist_R{k1, k2};
        end
    end
    rhoLTE.histcount               = histcount;
    rhoLTE.hist                    = hist;
    rhoLTE.supp                    = supp;
    rhoLTE.histedges               = histedgesR;
else
    rhoLTE                         = [];
end
if has_align
    histcountA                    = sum(histcountA, 5);
    histcountDR                   = sum(histcountDR, 4);
    max_dotrs                     = max(max_dotrs, [], 3);
    min_dotrs                     = min(min_dotrs, [], 3);
    histcount_DR                  = cell(sys_info.K);
    hist_DR                       = cell(sys_info.K);
    supp_DR                       = cell(sys_info.K);
    for k1 = 1 : sys_info.K
        for k2 = 1 : sys_info.K
            supp{k1, k2}              = [min_rs(k1, k2), max_rs(k1, k2); min_dotrs(k1, k2), max_dotrs(k1, k2)];
            histcount{k1, k2}         = squeeze(histcountA(k1, k2, :, :));
            hist{k1, k2}              = histcount{k1, k2}/(sum(sum(histcount{k1, k2})) * histbinwidthR(k1, k2) * histbinwidthDR(k1, k2));
            histedges{k1, k2}         = [histedgesR{k1, k2}; histedgesDR{k1, k2}];
            supp_DR{k1, k2}           = [min_dotrs(k1, k2), max_dotrs(k1, k2)];
            histcount_DR{k1, k2}      = squeeze(histcountDR(k1, k2, :));
            hist_DR{k1, k2}           = histcount_DR{k1, k2}/(sum(histcount_DR{k1, k2}) * histbinwidthDR(k1, k2));
        end
    end
    % joint distribution of (r, \dot{r})
    rhoLTA.histcount               = histcount;
    rhoLTA.hist                    = hist;
    rhoLTA.supp                    = supp;
    rhoLTA.histedges               = histedges;
    % marginal in r
    rhoLTR.histcount               = histcount_R;
    rhoLTR.hist                    = hist_R;
    rhoLTR.supp                    = supp_R;
    rhoLTR.histedges               = histedgesR;
    % marginal in \dot{r}
    rhoLTDR.histcount              = histcount_DR;
    rhoLTDR.hist                   = hist_DR;
    rhoLTDR.supp                   = supp_DR;
    rhoLTDR.histedges              = histedgesDR;
    % package the data
    rhoLTA.rhoLTR                  = rhoLTR;
    rhoLTA.rhoLTDR                 = rhoLTDR;
else
    rhoLTA                         = [];
end
if has_xi
    jhistcountXi                  = sum(jhistcountXi, 5);
    histcountXi                   = sum(histcountXi, 4);
    max_xis                       = max(max_xis, [], 3);
    min_xis                       = min(min_xis, [], 3);
    histcount_Xi                  = cell(sys_info.K);
    hist_Xi                       = cell(sys_info.K);
    supp_Xi                       = cell(sys_info.K);
    for k1 = 1 : sys_info.K
        for k2 = 1 : sys_info.K
            supp{k1, k2}              = [min_rs(k1, k2), max_rs(k1, k2); min_xis(k1, k2), max_xis(k1, k2)];
            histcount{k1, k2}         = squeeze(jhistcountXi(k1, k2, :, :));
            hist{k1, k2}              = histcount{k1, k2}/(sum(sum(histcount{k1, k2})) * histbinwidthR(k1, k2) * histbinwidthXi(k1, k2));
            histedges{k1, k2}         = [histedgesR{k1, k2}; histedgesXi{k1, k2}];
            supp_Xi{k1, k2}           = [min_xis(k1, k2), max_xis(k1, k2)];
            histcount_Xi{k1, k2}      = squeeze(histcountXi(k1, k2, :));
            hist_Xi{k1, k2}           = histcount_Xi{k1, k2}/(sum(histcount_Xi{k1, k2}) * histbinwidthXi(k1, k2));
        end
    end
    % joint distribution of (r, \xi)
    rhoLTXi.histcount           = histcount;
    rhoLTXi.hist                = hist;
    rhoLTXi.supp                = supp;
    rhoLTXi.histedges           = histedges;
    % marginal in r
    rhoLTR.histcount            = histcount_R;
    rhoLTR.hist                 = hist_R;
    rhoLTR.supp                 = supp_R;
    rhoLTR.histedges            = histedgesR;
    % marginal in \dot{r}
    mrhoLTXi.histcount          = histcount_Xi;
    mrhoLTXi.hist               = hist_Xi;
    mrhoLTXi.supp               = supp_Xi;
    mrhoLTXi.histedges          = histedgesXi;
    % package the data
    rhoLTXi.rhoLTR              = rhoLTR;
    rhoLTXi.mrhoLTXi            = mrhoLTXi;
else
    rhoLTXi                     = [];
end
rhoLT.rhoLTE                    = rhoLTE;
rhoLT.rhoLTA                    = rhoLTA;
rhoLT.rhoLTXi                   = rhoLTXi;
end