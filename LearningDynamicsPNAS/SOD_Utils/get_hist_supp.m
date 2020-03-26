function hist_supp = get_hist_supp(min_pt, max_pt, histedges)
% function hist_supp = get_hist_supp(min_pt, max_pt, histedges)
%   
%

% (c), M. Zhong, JHU

K                        = size(min_pt, 1);
hist_supp                = zeros(K, K, 2);

for k1 = 1 : K
  for k2 = 1 : K
    hist_supp(k1, k2, 2) = max_pt(k1, k2);
    histedges_Ck1_Ck2    = histedges{k1, k2};
    hist_supp(k1, k2, 1) = histedges_Ck1_Ck2(find(histedges_Ck1_Ck2 > min_pt(k1, k2), 1, 'last'));
  end
end
end