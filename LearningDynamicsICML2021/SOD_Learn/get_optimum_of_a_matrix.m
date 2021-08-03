function optimum = get_optimum_of_a_matrix(mat, kind)
% function optimum = get_optimum_of_a_matrix(mat, kind)

% (C) M. Zhong

switch kind
  case 'min'
    if isvector(mat)
      optimum = min(mat);
    else
      optimum = min(mat, [], 2);
    end
  case 'max'
    if isvector(mat)
      optimum = max(mat);
    else
      optimum = max(mat, [], 2);
    end    
  otherwise
end
end