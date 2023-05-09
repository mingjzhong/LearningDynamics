function [alphas, basis] = get_alphas_and_basis_from_Estimator(type, Estimator)
% function [alphas, basis] = get_alphas_and_basis_from_Estimator(type, Estimator)

% (C) M. Zhong

switch type
  case 'energy'
    n                  = cellfun(@(x) length(x.f), Estimator.Ebasis);
    K                  = size(Estimator.Ebasis, 1);
    alphas             = cell(K);
    n_prev             = 0;
    for k1 = 1 : K
      for k2 = 1 : K
        idx1           = n_prev + 1;
        idx2           = n_prev + n(k1, k2);
        alphas{k1, k2} = Estimator.alpha(idx1 : idx2);
        n_prev         = n_prev + n(k1, k2);
      end
    end
    basis              = Estimator.Ebasis;
  case 'alignment'
    K                  = size(Estimator.Abasis, 1);
    alphas             = cell(K);
    if ~isempty(Estimator.Ebasis)
      n_E              = cellfun(@(x) length(x.f), Estimator.Ebasis);
      n_E              = sum(n_E(:));      
    else
      n_E              = 0;
    end
    n                  = cellfun(@(x) length(x.f), Estimator.Abasis);
    n_prev             = n_E;
    for k1 = 1 : K
      for k2 = 1 : K
        idx1           = n_prev + 1;
        idx2           = n_prev + n(k1, k2);
        alphas{k1, k2} = Estimator.alpha(idx1 : idx2);
        n_prev         = n_prev + n(k1, k2);
      end
    end
    basis              = Estimator.Abasis;
  case 'xi'
    K                  = size(Estimator.Xibasis, 1);
    n                  = cellfun(@(x) length(x.f), Estimator.Xibasis);
    n_prev             = 0;
    alphas             = cell(K);
    for k1 = 1 : K
      for k2 = 1 : K
        idx1           = n_prev + 1;
        idx2           = n_prev + n(k1, k2);
        alphas{k1, k2} = Estimator.alpha_xi(idx1 : idx2);
        n_prev         = n_prev + n(k1, k2);
      end
    end
    basis              = Estimator.Xibasis;
  otherwise
    error('');
end
end