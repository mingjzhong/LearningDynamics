function cell2 = construct_the_same_cell(cell1)
% function cell2 = construct_the_same_cell(cell1)
 
% (C) M. Zhong

cell2  = cell(size(cell1));
for k1 = 1 : size(cell1, 1)
  for k2 = 1 : size(cell1, 2)
    if ~isempty(cell1{k1, k2}), cell2{k1, k2} = zeros(size(cell1{k1, k2})); else, cell2{k1, k2} = []; end
  end
end
end