function learn_info = set_n_in_learn_info_JPL(M, time_type, base_num, learn_info)
% function learn_info = set_n_in_learn_info_JPL(M, time_type, base_num, learn_info)

% (C) M. Zhong

switch time_type
  case 'daily'
    L                      = 1;
  case 'hourly'
    L                      = 24;
  case 'minutely'
    L                      = 24 * 60;
  otherwise
    error('');
end
basis_info                 = learn_info.Ebasis_info;
K                          = size(basis_info, 1);
M                          = 2^(floor(log(M)/log(base_num)));
max_n                      = ceil((M * L/log(M * L))^(1/3));
for k1 = 1 : K
  for k2 = 1 : K
    if k1 ~= k2
      basis_info{k1, k2}.n = set_n_in_basis_info(max_n, basis_info{k1, k2}.degree, ....
                             basis_info{k1, k2}.type, basis_info{k1, k2}.sub_type);
    end
  end
end
learn_info.Ebasis_info     = basis_info;
end