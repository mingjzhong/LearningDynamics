function basis = construct_basis_Ck1Ck2_tensor_grid(range, knots, basis_info)
% function basis = construct_basis_Ck1Ck2_tensor_grid(range, knots, basis_info)

% (C) M. Zhong
       
basis.degree                        = basis_info.degree;
basis.supp                          = range;
basis.dim                           = size(range, 1);
basis.type                          = basis_info.type;
basis.sub_type                      = basis_info.sub_type;
basis.period                        = basis_info.period;
basis1Ds                            = cell(size(knots));
basis.n                             = zeros(1, basis.dim);
for idx = 1 : basis.dim
  basis1Ds{idx}                     = construct_basis_Ck1Ck2_1D(idx, knots{idx}, basis_info);
  basis.n(idx)                      = basis1Ds{idx}.n;
end
switch basis.dim
  case 1
    basis.f                         = basis1Ds{1}.f;
    basis.df                        = basis1Ds{1}.df;
    basis.d2f                       = basis1Ds{1}.d2f;
    basis.knots                     = basis1Ds{1}.knots;
    basis.supp_knots_idx            = basis1Ds{1}.supp_knots_idx;
    basis.supp_type                 = basis1Ds{1}.supp_type;
  case {2, 3}
    basis.f                         = cell(1, prod(basis.n));
    basis.knots                     = cell(1, basis.dim);
    basis.supp_knots_idx            = cell(1, basis.dim);
    basis.supp_type                 = cell(1, basis.dim);
    if basis.dim == 2
      for eta1 = 1 : basis1Ds{1}.n
        for eta2 = 1 : basis1Ds{2}.n
          eta                       = (eta1 - 1) * basis1Ds{2}.n + eta2;
          basis.f{eta}              = @(r, s) basis1Ds{1}.f{eta1}(r) .* basis1Ds{2}.f{eta2}(s);
        end
      end
    elseif basis.dim == 3
      for eta1 = 1 : basis1Ds{1}.n
        for eta2 = 1 : basis1Ds{2}.n
          for eta3 = 1 : basis1Ds{3}.n
            eta                     = (eta1 - 1) * basis1Ds{2}.n * basis1Ds{3}.n ...
                                      + (eta2 - 1) * basis1Ds{3}.n + eta3;
            basis.f{eta}            = @(r, s, z) basis1Ds{1}.f{eta1}(r) .* basis1Ds{2}.f{eta2}(s) ...
                                      .* basis1Ds{3}.f{eta3}(z);
          end
        end
      end    
    end
    for idx = 1 : basis.dim
      basis.knots{idx}              = basis1Ds{idx}.knots;
      basis.supp_knots_idx{idx}     = basis1Ds{idx}.supp_knots_idx;
      basis.supp_type{idx}          = basis1Ds{idx}.supp_type;
    end
  otherwise
    error('');
end
end