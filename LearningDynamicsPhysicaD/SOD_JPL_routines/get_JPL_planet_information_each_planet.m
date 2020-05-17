function PI = get_JPL_planet_information_each_planet(CenttoP_pos, time_vec, PI_info)
% function PI = get_JPL_planet_information_each_planet(CenttoP_pos, time_vec, PI_info)

% (C) M. Zhong

% initialize 
PI                          = zeros(4, 2);
% use a pchip to interpolate CenttoP_pos, hence needs ppval     
CenttoP_t                  = pchip(time_vec, CenttoP_pos);                                          
num_minutes                = (floor(time_vec(end)) + 1) * 24 * 60;                                  % total number of minutes from [T_0, T]
freq_in_sec                = 60/PI_info.freq;                                                       % sampled at every 60, 30, etc, divisible by 60
num_samples                = num_minutes * freq_in_sec;                                             % total number of samples
t_l                        = (0 : (num_samples - 1))/(24 * 60 * freq_in_sec);
ind                        = t_l > time_vec(end);                                                   % do not extrapolate
t_l(ind)                   = [];                         
r_l                        = sum(ppval(CenttoP_t, t_l).^2).^(0.5);
if strcmp(PI_info.type, 'Neptune'), is_Neptune = true; else, is_Neptune = false; end
[PI(1 : 3, :), apsis_locs] = get_JPL_PI_from_findpeaks(t_l, r_l, is_Neptune);
ts                         = t_l(apsis_locs);
thetas                     = get_JPL_precession_advance(ppval(CenttoP_t, ts));
if ~isempty(ts)
  [ts, thetas]             = set_JPL_thetas_postprocessing(ts, thetas, PI_info.type);
  PI(4, :)                 = get_JPL_precession_rate(ts, thetas, PI_info);
end
end