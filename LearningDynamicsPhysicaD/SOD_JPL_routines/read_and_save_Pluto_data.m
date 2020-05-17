function read_and_save_Pluto_data()
%

%

path        = 'D:\planet_data\1600_to_1999_source\';
days        = get_num_days_from_years(1600 : 1999);
time_vec    = get_time_vec_from_days(days, 'daily');
dt_min      = 1/(24 * 60);
dt_hour     = 1/24;
d           = 3;
L           = length(time_vec);
file        = [path, 'Pluto.txt'];
AO_data     = dlmread(file, ',', 0, 2);
x           = AO_data(1 : L, 1 : d)';
v           = AO_data(1 : L, (d + 1) : 2 * d)';
file        = [path, 'Pluto_m1min.txt'];
AO_data     = dlmread(file, ',', 0, 2);
x_m1m       = AO_data(1 : L, 1 : d)';
v_m1m       = AO_data(1 : L, (d + 1) : 2 * d)';
file        = [path, 'Pluto_p1min.txt'];
AO_data     = dlmread(file, ',', 0, 2);
x_p1m       = AO_data(1 : L, 1 : d)';
v_p1m       = AO_data(1 : L, (d + 1) : 2 * d)';
a_minutely  = (v_p1m - v_m1m)/(2 * dt_min);
ax_minutely = (x_p1m - 2 * x + x_m1m)/(dt_min^2);
file        = [path, 'Pluto_m1hour.txt'];
AO_data     = dlmread(file, ',', 0, 2);
v_m1h       = AO_data(1 : L, (d + 1) : 2 * d)';
file        = [path, 'Pluto_p1hour.txt'];
AO_data     = dlmread(file, ',', 0, 2);
v_p1h = AO_data(1 : L, (d + 1) : 2 * d)';
a_hourly    = (v_p1h - v_m1h)/(2 * dt_hour);
a_daily     = approximate_derivative(v, time_vec, 1);
path        = 'D:\planet_data\1600_to_1999_daily\'; 
matFile     = [path, 'Pluto.mat'];
save(matFile, '-v7.3', 'x', 'v', 'a_daily', 'a_hourly', 'a_minutely', 'ax_minutely');