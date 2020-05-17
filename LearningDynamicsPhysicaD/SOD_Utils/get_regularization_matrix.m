function regMat = get_regularization_matrix(basis, rho, learn_info)
% function regMat = get_regularization_matrix(basis, rho, learn_info)

% (C) M. Zhong

if ~isempty(basis)
  K                                          = learn_info.sys_info.K;
  if isfield(learn_info, 'reg_h') && ~isempty(learn_info.reg_h)
    h                                        = learn_info.reg_h;
  else
    h                                        = 0.01;
  end
  num_pts                                    = zeros(K);
  agent_info                                 = getAgentInfo(learn_info.sys_info);
  for k1 = 1 : K
    for k2 = 1 : K
      if k1 == k2 && agent_info.num_agents(k2) == 1
        num_pts(k1, k2)                      = 1;
      else
        num_pts(k1, k2)                      = ceil((basis{k1, k2}.supp(2) - basis{k1, k2}.supp(1))/h);
      end
    end
  end
  num_rows                                   = sum(sum(num_pts));
  num_cols                                   = sum(sum(cellfun(@(x) length(x.df), basis)));
  regMat                                     = zeros(num_rows, num_cols);
  num_prev_rows                              = 0;
  num_prev_cols                              = 0;
  for k1 = 1 : K
    for k2 = 1 : K
      if k1 ~= k2 || agent_info.num_agents(k2) == 1
        rs                                   = linspace(basis{k1, k2}.supp(1), basis{k1, k2}.supp(2), ...
          ceil(abs(basis{k1, k2}.supp(2) - basis{k1, k2}.supp(1))/h) + 1);
        if ~iscolumn(rs), rs = rs'; end  
        step_size                              = rs(2) - rs(1);
        row_ind1                               = num_prev_rows + 1;
        row_ind2                               = num_prev_rows + length(rs) - 1;  
        for eta = 1 : length(basis{k1, k2}.df)
          psi                                  = basis{k1, k2}.df{eta};
          col_ind                              = num_prev_cols + eta;
          regMat(row_ind1 : row_ind2, col_ind) = sqrt(step_size) * psi(rs(1 : end - 1)) .* rs(1 : end - 1) .* rho{k1, k2}.dense(rs(1 : end - 1));
%          regMat(row_ind1 : row_ind2, col_ind) = sqrt(step_size) * psi(rs(1 : end - 1));
        end
        num_prev_rows                          = num_prev_rows + length(rs) - 1;
        num_prev_cols                          = num_prev_cols + length(basis{k1, k2}.df);
      else
        num_prev_rows                          = num_prev_rows + 1;
        num_prev_cols                          = num_prev_cols + length(basis{k1, k2}.df);
      end
    end
  end
else
  regMat                                       = [];
end