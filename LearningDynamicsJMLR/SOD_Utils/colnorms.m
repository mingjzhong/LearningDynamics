function norms = colnorms( X )

norms = sqrt(sum(X.^2,1));

return