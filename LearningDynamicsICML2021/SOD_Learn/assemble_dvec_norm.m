function dvec_norm = assemble_dvec_norm(dvec_norm_l, M, L, num_cores)
% function dvec_norm = assemble_dvec_norm(dvec_norm_l, M, L, num_cores)
 
% (C) M. Zhong

if isempty(dvec_norm_l{1})
  dvec_norm     = [];
else
  dvec_norm     = zeros(length(dvec_norm_l{1}), 1);
  for idx = 1 : num_cores
      dvec_norm = dvec_norm + dvec_norm_l{idx}/(M * L);
  end
end
end