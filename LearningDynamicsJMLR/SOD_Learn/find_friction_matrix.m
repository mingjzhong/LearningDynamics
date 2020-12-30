function F_mat = find_friction_matrix(v, sys_info, learning_info)
% F_mat = find_friction_matrix(v, learning_info)
 
% Ming Zhong
% Postdoc Research at JHU

% find out the number of agents
N                                              = sys_info.N;
% find out the size of the state vector
d                                              = sys_info.d;
% find out the number of classes
num_classes                                    = sys_info.K;
% find out the class function which maps agent index to its class index
class_info                                     = sys_info.class_info;
% find out which kind of friction with which we are dealing
friction_kind                                  = sys_info.friction_kind;
% find out the number of time instances when observations are made
L                                              = size(v, 2);
% allocate memory
switch friction_kind
  case 1
    F_mat                                      = zeros(L * N * d, num_classes);
  case 2
    F_mat                                      = zeros(L * N * d, num_classes * 2);
  otherwise
    error('SOD_Learn:find_friction_matrix:invalidInput', ...
    'The code only supports friction of the kind of either -\nu_k * v_i or (\alpha_k - \beta_k * ||v_i||^2)v_i!!');
end
class_indic                                    = zeros(num_classes, N);
% calculate the block size
block                                          = N * d;
% go through tiem
for l = 1 : L
% find out the velocity information at time t, reshape it to size [d, N]
  v_at_t                                       = reshape(v(:, l), [d, N]);
% for the second kind of friction, we also need the squared of the norm of v_i and make it of size [d, N]
  if friction_kind == 2
    norm2_v_at_t                               = kron(sum(v_at_t.^2), ones(d, 1));
  end
% calculate the row indices to put the dat in
  row_1                                        = (l - 1) * block + 1;
  row_2                                        = (l - 1) * block + block;
% go through each class
  for k = 1 : num_classes
% clean out the memory in F_at_t
    F_at_t                                     = zeros(d, N);    
% find out the agents in this class
    if l == 1
% initial time, use find, and use logical indexing      
      agents_Ck                                = class_info == k;
% save it
      class_indic(k, :)                        = agents_Ck;
    else 
% any other time, just retrieve it, use logcial indexing
      agents_Ck                                = class_indic(k, :);
    end
% constructe the matrix
    switch friction_kind
      case 1
% first kind, -\nu_k * v_i for i \in C_k
         F_at_t(:, agents_Ck)    = -v_at_t(:, agents_Ck);
% reshape it to a vector and put it back in F_mat
         F_mat(row_1 : row_2, k)               = F_at_t(:);
      case 2
% second kind: (\alpha_k - \beta_k * ||v_i||^2) * v_i for i \in C_k, first for v_i
         F_at_t(:, agents_Ck)                  = v_at_t(:, agents_Ck);
% reshape it to a vector and put it back in F_mat
         F_mat(row_1 : row_2, k)               = F_at_t(:);
% next for -||v_i||^2 * v_i
         F_at_t(:, agents_Ck)                  = -norm2_v_at_t(:, agents_Ck) .* v_at_t(:, agents_Ck);
% reshape it to a vector and put it back in F_mat
         F_mat(row_1 : row_2, k + num_classes) = F_at_t(:);
      otherwise
    end
  end
end
end