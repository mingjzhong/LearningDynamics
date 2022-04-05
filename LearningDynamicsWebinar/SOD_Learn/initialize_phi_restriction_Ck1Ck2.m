function phi_rest = initialize_phi_restriction_Ck1Ck2(k1, Nk1, k2, Nk2, L, phi_rest)
% function phi_rest = initialize_phi_restriction_Ck1Ck2(k1, Nk1, k2, Nk2, L, phi_rest)

% (C) M. Zhong

if ~isempty(phi_rest)
  num_rest                  = length(phi_rest);
  for ind = 1 : num_rest
    if ~isempty(phi_rest{ind})
      phi_rest{ind}{k1, k2} = zeros(L * Nk1, Nk2);
    end
  end
end
end