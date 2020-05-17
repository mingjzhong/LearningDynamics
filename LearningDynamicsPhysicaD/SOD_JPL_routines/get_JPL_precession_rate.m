function PR = get_JPL_precession_rate(ts, thetas, PI_info)
% function PR = get_JPL_precession_rate(ts, thetas, PI_info)

% (C) M. Zhong

if nargin < 2, PI_info.model = 'periodic'; end
warning('off', 'all');                                                                              % disable warnings from nlinfit
PR                    = zeros(1, 2);
switch length(thetas)
  case 1
    beta              = [thetas, 0];                                                                % default choice
    beta_std          = 0;
  case 2
    m                 = (thetas(2) - thetas(1))/(ts(2) - ts(1));                                    % slope
    beta              = [thetas(1) - ts(1) * m, m];
    beta_std          = 0;
  case 3
    m1                = (thetas(1) - thetas(2))/(ts(1) - ts(2));
    m2                = (thetas(2) - thetas(3))/(ts(2) - ts(3));
    beta              = zeros(3, 1);
    beta(3)           = (m1 - m2)/(ts(1) - ts(3));
    beta(2)           = m1 - beta(3) * (ts(1) + ts(2));
    beta(1)           = thetas(1) - beta(3) * ts(1)^2 - beta(2) * ts(1);
    beta_std          = 0;
  otherwise
    PI_info.the_model = 'periodic';
    [beta, betaCI]    = get_JPL_precession_model(ts, thetas, PI_info);  
    beta_std          = (betaCI(2, 2) - betaCI(2, 1))/2;
end    
warning('on', 'all');                                                                               % disable warnings from nlinfit
if isfield(PI_info, 'num_days_a_year') && ~isempty(PI_info.num_days_a_year)
  num_days_a_year     = PI_info.num_days_a_year;
else
  num_days_a_year     = 365.25636;                                                                  % how many days in one year  
end
PR(1)                 = beta(2) * num_days_a_year * 100;                                            % change from 1 Earth-day to 100 Earth-year
PR(2)                 = beta_std;
end