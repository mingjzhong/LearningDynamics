function [path, total_years, time_type] = get_path_for_NASA_data(kind)
%

%

if kind == 1
  path            = [];
  total_years     = 2010 : 2019;  
  time_type       = 'daily';
else
  if kind == 2 || kind == 3 
    total_years   = 1600 : 1999;
  elseif kind == 4
    total_years   = 1600 : 1999;
  end
  switch kind
    case 2
      folder_type = '_daily';
      time_type   = 'daily';
    case 3
      folder_type = '_hourly';
      time_type   = 'hourly';
    case 4
      folder_type = '_minutely';
      time_type   = 'minutely';
    otherwise
      error('');
  end
  data_folder     = ['1600_to_1999' folder_type]; 
% please place the planet data inside the DataAnalyses folder  
  if ispc
    if strcmp(getenv('computername'), 'DESKTOP-LJKQMKC')
      path        = ['D:\planet_data\', data_folder, '\'];
    else
      path        = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\planet_data\' data_folder '\']; 
    end
  else % includes ismac and isunix
    path          = [getenv('HOME'), '/DataAnalyses/LearningDynamics/planet_data/' data_folder '/']; 
  end
  if ~isfolder(path), error('SOD_data:load_planet_traj:exception', 'Source Data path is not valid!!'); end    
end
end