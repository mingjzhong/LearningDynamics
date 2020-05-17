function PIerr = get_JPL_PI_errors(PItrue, PIest)
% function PIerr = get_JPL_PI_errors(PItrue, PIest)

% (C) M. Zhong
 
abs_err       = abs(PIest - PItrue);
ind           = abs_err ~= 0;
rel_err       = abs_err;
rel_err(ind)  = rel_err(ind)./abs(PItrue(ind));
PIerr.rel_err = rel_err;
PIerr.abs_err = abs_err;
end