function output = regularize_phihat(phi, phihat, phiknots, degree, rhoLTemp, sys_info)
%
%

% (c) M. Zhong (JHU)

basis_info.phiknots              = phiknots;
for k_1 = sys_info.K : -1 : 1
  for k_2 = sys_info.K : -1 : 1
    basis_info.supp{k_1, k_2}     = getFcnSupp( phihat{k_1,k_2}, phiknots{k_1,k_2} );
    basis_info.interval{k_1, k_2} = intersectInterval( basis_info.supp{k_1,k_2}, rhoLTemp.supp{k_1,k_2} );
    if basis_info.interval{k_1, k_2}(2) - basis_info.interval{k_1,k_2}(1) > 0
      phihatsmooth{k_1, k_2}      = simplifyfcn( phihat{k_1,k_2}, phiknots{k_1,k_2}, basis_info.interval{k_1,k_2}, degree(k_1,k_2) );
    else
      phihatsmooth{k_1, k_2}      = phihat{k_1,k_2};
    end
    phihat_diff{k_1, k_2}         = @(r) (phi{k_1,k_2}(r)) - (phihat{k_1,k_2}(r));
    phihatsmooth_diff{k_1, k_2}   = @(r) (phi{k_1,k_2}(r)) - (phihatsmooth{k_1,k_2}(r));
  end
end

output.basis_info                = basis_info;
output.phihatsmooth              = phihatsmooth;
output.phihat_diff               = phihat_diff;
output.phihatsmooth_diff         = phihatsmooth_diff;
end