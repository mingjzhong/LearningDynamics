function I = getFcnSupp( f, pts )

%pts     = sort(pts);
pts     = linspace(min(pts),max(pts),1000);
fvals   = f(pts);

idx     = find(abs(fvals)>10*eps,1,'first');
if ~isempty(idx)
    I(1) = pts(idx);
else
    I(1) = pts(1);
end

idx     = find(abs(fvals)>10*eps,1,'last');
if ~isempty(idx)
    I(2) = pts(idx);
else
    I(2) = pts(end);
end

return