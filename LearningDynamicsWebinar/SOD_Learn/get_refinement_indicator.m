function to_refine = get_refinement_indicator(subProbs, sample_tol, L2errs, adaptive_err_tol)
% function to_refine = get_refinement_indicator(subProbs, sample_tol, L2errs, adaptive_err_tol)

% (C) M. Zhong

if nnz(subProbs >= sample_tol)     == length(subProbs) && ...
   nnz(L2errs >= adaptive_err_tol) == length(L2errs)
  to_refine = true;
else
  to_refine = false;
end
end