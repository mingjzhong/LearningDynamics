% function test_PI_frep()
%

% (C) M. Zhong

% Load example definitions and let user select one example to run
prep_time          = tic;
selection_idx      = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                    
total_num_years    = 400;                                                                
num_years          = 400;                                                            
data_kind          = 3;                                                                  
use_v              = true;                                                               
[Exam, obs_data]   = Gravitation_JPL_def(selection_idx, num_years, total_num_years, use_v, data_kind);
sys_info           = Exam.sys_info;
block              = obs_data.N * obs_data.d;
traj               = obs_data.y;
clear obs_data Exam
total_years        = 1600 : 1999;
time_type          = get_JPL_time_type(data_kind);
freqs              = [60, 30, 15];
test_years         = [100, 200, 300, 400];
PI                 = cell(length(freqs), length(test_years));
fprintf('\nIt takes %6.2f secs to prepare.', toc(prep_time));
for idx1 = 1 : length(freqs)
  sys_info.freq    = freqs(idx1);
  for idx2 = 1 : length(test_years)
    fprintf('\nTesting with freq = %2d secs and %3d years', sys_info.freq, test_years(idx2));
    years          = total_years(1 : test_years(idx2));
    days           = get_num_days_from_years(years);
    time_vec       = get_time_vec_from_days(days, time_type);  
    traj_ind       = 1 : length(time_vec);
    thePI          = get_JPL_planet_information_over_time(traj(1 : block, traj_ind), ...
                     time_vec, sys_info);
    PI{idx1, idx2} = thePI;
    print_JPL_PI_err(sys_info.AO_names, sys_info.PI, thePI, test_years(idx2));
  end
end
return