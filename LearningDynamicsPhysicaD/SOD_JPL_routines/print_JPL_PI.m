function print_JPL_PI(print_msg, AO_names, PI) 
% function print_JPL_PI(print_msg, AO_names, PI)

% (C) M. Zhong

num_planets = size(PI, 1);
fprintf('\n----------------------------------------------------');
fprintf('\n%s.', print_msg);
fprintf('\nAO Name|Aphelion|Perihelion| Period|Precession Rate|');
for idx = 1 : num_planets
  switch AO_names{idx}
    case 'Moon'
      fprintf('\n%7s|%8.3f|%10.3f|%7.1f|%15.0f|', AO_names{idx}, PI(idx, 1), PI(idx, 2), ...
        PI(idx, 3), PI(idx, 4));
    otherwise
      fprintf('\n%7s|%8.1f|%10.1f|%7.1f|%15.0f|', AO_names{idx}, PI(idx, 1), PI(idx, 2), ...
        PI(idx, 3), PI(idx, 4));     
  end  
end
