function names = get_type_names(sys_info)
% function names = get_type_names(sys_info)

% (C) M. Zhong

if contains(sys_info.name, 'Anticipation') || contains(sys_info.name, 'CuckerDong') || ...
    contains(sys_info.name, 'CuckerSmale') || contains(sys_info.name, 'Viscek') || ...
    contains(sys_info.name, 'Flocking')
  names      = {'Bird'};
elseif contains(sys_info.name, 'FishSchool')
  names      = {'Fish'};
elseif contains(sys_info.name, 'Gravitation')
  names      = sys_info.AO_names;
elseif contains(sys_info.name, 'Opinion')
  names      = {'Opinion'};
elseif contains(sys_info.name, 'LennardJones')
  names      = {'Molecule'};
elseif contains(sys_info.name, 'Phototaxis')
  names      = {'Bacteria'}; 
elseif contains(sys_info.name, 'PredatorPrey')
  names      = {'Prey', 'Predator'};
elseif contains(sys_info.name, 'SynchronizedOscillator')
  names      = {'Swarmalator'};
else   
  names      = cell(1, sys_info.K);
  for k = 1 : sys_info.K
    names{k} = sprintf('Type %d', k);
  end
end
end