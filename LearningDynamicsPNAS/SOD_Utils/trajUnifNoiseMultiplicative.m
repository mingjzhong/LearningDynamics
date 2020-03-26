function trajData = trajUnifNoiseMultiplicative( trajData, sigma )

% Adds multiplicative uniform noise of relative amplitude sigma to trajectories
trajData = trajData.*(1+sigma*(rand(size(trajData))-0.5));

return