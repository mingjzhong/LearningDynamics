function bLM_new = add_dvecm_to_bLM(m, M, L, bLM, Psi, dvec, learn_info, type)
% function bLM_new = add_dvecm_to_bLM(m, M, L, bLM, Psi, dvec, learn_info, type)

% (C) M. Zhong

file_name       = sprintf(learn_info.pd_file_form, learn_info.temp_dir, learn_info.sys_info.name, ...
                  learn_info.time_stamp, m);
if learn_info.is_parallel
  switch type
    case 'EA'
      load(file_name, 'Psi', 'dvec', 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{1}; else, Gs = []; end
    case 'xi'
      load(file_name, 'PsiXi', 'dvecXi', 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{2}; else, Gs = []; end
      Psi        = PsiXi;
      dvec       = dvecXi;
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
bLM_new          = cell(size(Psi));
if isempty(bLM)
  for k = 1 : length(Psi)
    if ~isempty(Gs)
      bLM_new{k} = transpose(Psi{k}) * Gs{k} * sparse(dvec{k})/(M * L); 
    else
      bLM_new{k} = transpose(Psi{k}) * sparse(dvec{k})/(M * L);      
    end
  end
else
  for k = 1 : length(Psi)
    if ~isempty(Gs)
      bLM_new{k} = bLM{k} + transpose(Psi{k}) * Gs{k} * sparse(dvec{k})/(M * L); 
    else
      bLM_new{k} = bLM{k} + transpose(Psi{k}) * sparse(dvec{k})/(M * L);      
    end    
  end  
end
end