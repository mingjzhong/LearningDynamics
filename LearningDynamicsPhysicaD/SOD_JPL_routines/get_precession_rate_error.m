function PRerr = get_precession_rate_error(PI, PIhat)
% function PRerr = get_precession_rate_error(PI, PIhat)

% (C) M. Zhong

PRerr = abs(PI(:, 4) - squeeze(PIhat(:, 4, 1)))./abs(PI(:, 4));
end