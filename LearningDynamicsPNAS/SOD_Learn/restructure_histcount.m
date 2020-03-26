function output = restructure_histcount(HCR, HCDR, HCA, HCXi, jHCXi, M, K, type_info, num_bins)
%

% (c) M. Zhong

% prepare indicators 
has_align                            = ~isempty(HCA);
has_xi                               = ~isempty(HCXi);
% prepare storage (for easier calculation of sum/max)
new_HCR                              = zeros(K, K, num_bins, M);
if has_align
  new_HCA                            = zeros(K, K, num_bins, num_bins, M);
  new_HCDR                           = zeros(K, K, num_bins, M);
end
if has_xi
  new_jHCXi                          = zeros(K, K, num_bins, num_bins, M);
  new_HCXi                           = zeros(K, K, num_bins, M);
end
% go through all Monte Carlo realizations
for m = 1 : M
  HCR_m                              = HCR{m};
  if has_align
    HCA_m                            = HCA{m};
    HCDR_m                           = HCDR{m};
  end
  if has_xi
    jHCXi_m                          = jHCXi{m};
    HCXi_m                           = HCXi{m};
  end
  for k1 = 1 : K
    num_Ck1                          = nnz(type_info == k1);
    for k2 = 1 : K
      if k1 == k2
        if num_Ck1 == 1
          to_update                  = false;
        else
          to_update                  = true;
        end
      else
        to_update                    = true;
      end
      if to_update
        new_HCR(k1, k2, :, m)        = HCR_m{k1, k2};
        if has_align
          new_HCA(k1, k2, :, :, m)   = HCA_m{k1, k2};
          new_HCDR(k1, k2, :, m)     = HCDR_m{k1, k2};
        end
        if has_xi
          new_jHCXi(k1, k2, :, :, m) = jHCXi_m{k1, k2};
          new_HCXi(k1, k2, :, m)     = HCXi_m{k1, k2};
        end
      end
    end
  end
end
% package the data
output.histcountR                    = new_HCR;
if has_align
  output.histcountA                  = new_HCA;
  output.histcountDR                 = new_HCDR;
end
if has_xi
  output.jhistcountXi                = new_jHCXi;
  output.histcountXi                 = new_HCXi;
end
end