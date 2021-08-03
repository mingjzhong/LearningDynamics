function ALM_new = add_Psim_to_ALM(m, M, L, ALM, Psi, learn_info, type)
% function ALM_new = add_Psim_to_ALM(m, M, L, ALM, Psi, learn_info, type)

% (C) M. Zhong

file_name       = sprintf(learn_info.pd_file_form, learn_info.temp_dir, learn_info.sys_info.name, ...
                  learn_info.time_stamp, m);
if learn_info.is_parallel
  switch type
    case 'EA'
      load(file_name, 'Psi', 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{1}; else, Gs = []; end
    case 'xi'
      load(file_name, 'PsiXi', 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{2}; else, Gs = []; end
      Psi        = PsiXi;
    otherwise
  end
else
  switch type
    case 'EA'
      load(file_name, 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{1}; else, Gs = []; end
    case 'xi'
      load(file_name, 'G_LNkd');
      if ~isempty(G_LNkd), Gs = G_LNkd{2}; else, Gs = []; end
    otherwise
  end  
end
ALM_new          = cell(size(Psi));
if isempty(ALM)
  for k = 1 : length(Psi)
    if ~isempty(Gs)
      ALM_new{k} = transpose(Psi{k}) * Gs{k} * Psi{k}/(M * L);
    else
      ALM_new{k} = transpose(Psi{k}) * Psi{k}/(M * L);
    end
  end
else
  for k = 1 : length(Psi)
    if ~isempty(Gs)
      ALM_new{k} = ALM{k} + transpose(Psi{k}) * Gs{k} * Psi{k}/(M * L);
    else
      ALM_new{k} = ALM{k} + transpose(Psi{k}) * Psi{k}/(M * L);
    end
  end 
end
end