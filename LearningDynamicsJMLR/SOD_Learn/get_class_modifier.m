function class_mod = get_class_modifier(L, N, d, num_classes, class_info)
% class_mod = get_class_modifier(L, N, d, num_classes, class_info)

% Ming Zhong
% Postdoc Research at JHU

% find out the number of agents in each class for each agent
class_mod        = zeros(N, 1);
% prepare the number of agents in each class vector
for k = 1 : num_classes
% use logical indexing  
  ind            = class_info == k;
% take sqrt due to the fact that this sits out of the norm, || \cdot ||^2  
  class_mod(ind) = sqrt(nnz(ind)); 
end  
% to make it to have size [N * d, 1]
class_mod        = kron(class_mod, ones(d, 1));
% repeat it to have size [L * N * d, 1];
class_mod        = repmat(class_mod, [L, 1]);