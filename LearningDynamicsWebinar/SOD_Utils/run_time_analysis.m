function run_time_analysis()
% function run_time_analysis()

% (C) M. Zhong

if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end   
files                    = {'OD_on_S2', 'OD_on_PD', 'LJD_on_S2', 'LJD_on_PD', 'PS1_on_S2', ...
                            'PS1_on_PD'};
n_trials                 = 10;
learn_time               = zeros(1, n_trials);
traj_time                = zeros(1, n_trials);
for idx = 1 : length(files)
  file_name              = [SAVE_DIR, '/', files{idx}, '.txt'];
  fid                    = fopen(file_name);
  done                   = false;
  lt_idx                 = 0;
  tt_idx                 = 0;
  while ~done
    fline                = fgetl(fid);
    if contains(fline, 'Generating rhoT')
      content            = strsplit(fline);
      content            = content{3};
      content(1)         = [];
      rho_time           = str2double(content);
    elseif contains(fline, 'Time for learning:')
      content            = strsplit(fline);
      lt_idx             = lt_idx + 1;
      learn_time(lt_idx) = str2double(content{5});
    elseif contains(fline, 'Time for Trajectory Error:')
      content           = strsplit(fline);
      tt_idx            = tt_idx + 1;
      traj_time(tt_idx) = str2double(content{6});    
    elseif contains(fline, 'Overall Learning Time is:')
      content           = strsplit(fline);
      total_time        = str2double(content{6});      
      done              = true;
    else
      error('');
    end
  end
  fclose(fid);
  fprintf('\nFor %s', files{idx});
  fprintf('\nIt takes %10.4e secs to generate rhoLT', rho_time);
  fprintf('\nIt takes %10.4e secs to run 10 trials', total_time);
  fprintf('\n\tFor learning, it takes %10.4e secs', sum(learn_time));
  fprintf('\n\tOn average, it takes %10.4e (pm) %10.4e secs', mean(learn_time), std(learn_time));
  fprintf('\n\tFor Traject., it takes %10.4e secs', sum(traj_time));
  fprintf('\n\tOn average, it takes %10.4e (pm) %10.4e secs', mean(traj_time), std(traj_time));
end
end