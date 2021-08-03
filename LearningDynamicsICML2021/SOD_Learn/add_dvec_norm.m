function dvec_normsq_new = add_dvec_norm(m, M, L, dvec_normsq, dvec, learn_info, type)
% function dvec_normsq_new = add_dvec_norm(m, M, L, dvec_normsq, dvec, learn_info, type)

% (C) M. Zhong

file_name                = sprintf(learn_info.pd_file_form, learn_info.temp_dir, ...
                           learn_info.sys_info.name, learn_info.time_stamp, m);
if learn_info.is_parallel
  switch type
    case 'EA'
      load(file_name, 'dvec', 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{1}; else, Gs = []; end
    case 'xi'
      load(file_name, 'dvecXi', 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{2}; else, Gs = []; end
      dvec               = dvecXi;
    otherwise
      error('');
  end
else
  load(file_name, 'G_LNkd');  
  switch type
    case 'EA'
      if ~isempty(G_LNkd), Gs = G_LNkd{1}; else, Gs = []; end
    case 'xi'
      if ~isempty(G_LNkd), Gs = G_LNkd{2}; else, Gs = []; end
    otherwise
      error('');
  end  
end
dvec_normsq_new          = zeros(length(dvec), 1);
if isempty(dvec_normsq)
  for k = 1 : length(dvec)
    if ~isempty(Gs)
      dvec_normsq_new(k) = dvec{k}' * Gs{k} * dvec{k}/(M * L);
    else
      dvec_normsq_new(k) = norm(dvec{k})^2/(M * L);
    end
  end
else
  for k = 1 : length(dvec)
    if ~isempty(Gs)
      dvec_normsq_new(k) = dvec_normsq(k) + dvec{k}' * Gs{k} * dvec{k}/(M * L);                   
    else
      dvec_normsq_new(k) = dvec_normsq(k) + norm(dvec{k})^2/(M * L);
    end
  end  
end
end