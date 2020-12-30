function [d_histcount, d_histedges1, d_histedges2] = downsampleHist2D( hist, histedges1, factor1, histedges2, factor2 )

nBins1       = length(histedges1);
idxs1        = unique(floor(linspace(1,nBins1,nBins1/factor1)));
d_histedges1 = histedges1( idxs1 );
nBins2       = length(histedges2);
idxs2        = unique(floor(linspace(1,nBins2,nBins2/factor2)));
d_histedges2 = histedges2( idxs2 );
d_histcount  = zeros(length(idxs1) - 1, length(idxs2) - 1);
binWid1_old  = histedges1(2) - histedges1(1);
binWid2_old  = histedges2(2) - histedges2(1);
binWid1_new  = d_histedges1(2) - d_histedges1(1);
binWid2_new  = d_histedges2(2) - d_histedges2(1);
for k1 = 1:length(idxs1) - 1
  for k2 = 1 : length(idxs2) - 1
    d_histcount(k1, k2) = sum(sum(hist(idxs1(k1) : idxs1(k1 + 1) - 1, idxs2(k2) : idxs2(k2 + 1) - 1)));
  end
end
d_histcount             = d_histcount * binWid1_old * binWid2_old/(binWid1_new * binWid2_new);
end