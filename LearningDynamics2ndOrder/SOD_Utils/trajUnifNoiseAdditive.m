function trajData = trajUnifNoiseAdditive(trajData, sigma)
% Adds multiplicative uniform noise of relative amplitude sigma to trajectories

trajData = trajData + sigma * (rand(size(trajData)) - 0.5);
return