function [d_histcount, d_histedges] = downsampleHistCounts( hist, histedges, factor )

nBins            = length(histedges);
idxs             = unique(floor(linspace(1,nBins,nBins/factor)));
d_histedges      = histedges( idxs );
d_histcount      = zeros(length(idxs)-1,1);
bin_wid_old      = histedges(2) - histedges(1);
bin_wid_new      = d_histedges(2) - d_histedges(1);
for k = 1:length(idxs)-1
  d_histcount(k) = sum(hist(idxs(k):idxs(k+1)-1));
end
d_histcount      = d_histcount * bin_wid_old/bin_wid_new;

return