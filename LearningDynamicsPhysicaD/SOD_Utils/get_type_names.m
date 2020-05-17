function names = get_type_names(sys_info)
% function names = get_type_names(sys_info)

% (C) M. Zhong

switch sys_info.name
  case 'FishSchoolDynamics2D'
    names      = {'Fish'};
  case 'FishSchoolDynamics3D'
    names      = {'Fish'};    
  case 'Gravitation'
    names      = sys_info.AO_names;
  case 'OpinionDynamicsCont'
    names      = {'Opinion'};
  case 'OpinionDynamicsDisc'
    names      = {'Opinion'};
  case 'LennardJonesDynamics'
    names      = {'Molecule'};
  case 'LennardJonesDynamicsTruncated'
    names      = {'Molecule'};
  case 'PhototaxisDynamics'
    names      = {'Bacteria'};    
  case 'PredatorPrey1stOrder'
    names      = {'Prey', 'Predator'};
  case 'PredatorPrey1stOrderSplines'
    names      = {'Prey', 'Predator'};
  case 'PredatorPrey2ndOrder'
    names      = {'Prey', 'Predator'};  
  case 'CuckerSmaleDynamics'
    names      = {'Bird'};
  case 'ViscekDynamics'
    names      = {'Bird'};
  case 'SynchronizedOscillatorDynamics'
    names      = {'Swarmalator'};
  case 'SynchronizedOscillatorDynamicsPeriodic'
    names      = {'Swarmalator'};    
  otherwise
    names      = cell(1, sys_info.K);
    for k = 1 : sys_info.K
      names{k} = sprintf('Type %d', k);
    end
end
end