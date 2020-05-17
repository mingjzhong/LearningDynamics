function A_cols = get_total_number_of_basis_functions(basis)
% function A_cols = get_total_number_of_basis_functions(basis)

% (C) M. Zhong

A_cols.E     = 0; 
A_cols.A     = 0; 
A_cols.Xi    = 0;
if ~isempty(basis{1}), A_cols.E  = sum(sum(cellfun(@(x) length(x.f), basis{1}))); end               % the number of energy based basis functions for Estimator.Phi        
if length(basis) > 2
  if ~isempty(basis{2}), A_cols.A  = sum(sum(cellfun(@(x) length(x.f), basis{2}))); end             % the number of alignment based basis functions for Estimator.Phi
  if ~isempty(basis{3}), A_cols.Xi = sum(sum(cellfun(@(x) length(x.f), basis{3}))); end             % the number of xi based basis functions for Estimator.Phi
else
  if ~isempty(basis{2}), A_cols.Xi = sum(sum(cellfun(@(x) length(x.f), basis{2}))); end 
end
A_cols.total = A_cols.E + A_cols.A;                                                                 % find out the total number fo columns for the Estimator.ALM matrix
end