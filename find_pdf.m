function hist_prob = find_pdf(hist_count)
% function hist_prob = find_pdf(hist_count)

% (c), M. Zhong, JHU

K         = size(hist_count, 1);
hist_prob = zeros(size(hist_count));

for k1 = 1 : K
  for k2 = 1 : K
    total_count_Ck1_Ck2  = norm(squeeze(hist_count(k1, k2, :)), 1);
    hist_prob(k1, k2, :) = hist_count(k1, k2, :)/total_count_Ck1_Ck2;    
  end
end
end