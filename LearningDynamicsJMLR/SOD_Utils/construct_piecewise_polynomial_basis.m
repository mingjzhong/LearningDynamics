function basis = construct_piecewise_polynomial_basis(polynomial_info)
%
%

%
%

degree                    = polynomial_info.degree;
switch polynomial_info.how_to_create
    case 'num_basis_first'
        a                     = polynomial_info.left_end_pt;
        b                     = polynomial_info.right_end_pt;
        n                     = polynomial_info.num_basis;
        if mod(n, degree + 1) ~= 0
            error('SOD_Learn:construct_piecewise_polynomial_basis:invalidInput', ...
                'The total number of basis functions has to be a multiple of degree + 1.');
        end
        num_sub_inter           = n/(degree + 1);
        num_knots               = num_sub_inter + 1;
        basis.knots             = linspace(a, b, num_knots);
        basis.f                 = cell(1, n);
        basis.knotIdxs          = zeros(1,n,'uint32');
        for ind = 1 : n
            ell                   = ind - 1;
            n                     = mod(ell,  degree+ 1);
            k                     = (ell - n)/(degree + 1) + 1;
            basis.knotIdxs(ind)   = k;
            xspan                 = [basis.knots(k), basis.knots(k + 1)];
            switch polynomial_info.type
                case 'Legendre'
                    basis.f{ind} = @(r) Legendre_basis_L2(n, r, xspan);
                case 'standard'
                    basis.f{ind} = @(r) standard_basis(n, r, xspan);
                otherwise
                    error('SOD_Learn:construct_piecewise_polynomial_basis:invalidInput', ...
                        'Only Legendre and standad polynomials are supported for now.');
            end
        end
    case 'basis.knots_first'
        basis.knots             = standard_info.basis.knots;
        num_knots               = length(basis.knots);
        num_sub_inter           = num_knots - 1;
        n                       = num_sub_inter * (degree + 1);
        basis.f                 = cell(1, n);
        basis.knotIdxs          = zeros(1,n,'uint32');
        for ind = 1 : n
            ell                   = ind - 1;
            n                     = mod(ell, degree + 1);
            k                     = (ell - n)/(degree + 1) + 1;
            basis.knotIdxs(ind)   = k;
            xspan                 = [basis.knots(k), basis.knots(k + 1)];
            switch polynomial_info.type
                case 'Legendre'
                    basis.f{ind} = @(r) Legendre_basis_L2(n, r, xspan);
                case 'standard'
                    basis.f{ind} = @(r) standard_basis(n, r, xspan);
                otherwise
                    error('');
            end
        end
    otherwise
end

return