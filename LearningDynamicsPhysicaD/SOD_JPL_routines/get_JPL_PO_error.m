function thetas = get_JPL_PO_error(xNs, dot_vNs, xNp1, phihats)
% function thetas = get_JPL_PO_error(xNs, dot_vNs, xNp1, phihats)

% (C) M. Zhong

fNs_diff = get_JPL_model_error(xNs, dot_vNs, phihats);
thetas   = get_JPL_difference_in_angle(xNs, xNp1, fNs_diff);
end