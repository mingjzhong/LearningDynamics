function estsupp = getHistSupp( bindistrib, histedges,quantthres )

if nargin<3, quantthres = 0.0;   end

cumdistrib = cumsum(bindistrib);

minsuppdistr            = histedges(find(cumdistrib>quantthres,1,'first'));
if ~isempty(minsuppdistr)
    estsupp(1) = minsuppdistr;
else
    estsupp(1) = 0;
end
maxsuppdistr            = histedges(find(cumdistrib<(1-quantthres)*cumdistrib(end),1,'last'));
if ~isempty(maxsuppdistr)
    estsupp(2) = maxsuppdistr;
else
    estsupp(2) = 0;
end


return