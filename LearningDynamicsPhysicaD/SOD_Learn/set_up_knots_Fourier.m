function knots = set_up_knots_Fourier(period)
% function knots = set_up_knots_Fourier(period)

% (C) M. Zhong

validateattributes(period, {'numeric'}, {'scalar', 'positive'}, 'set_up_knots_Fourier', 'period', 1);
knots = [-period/2, period/2];
end