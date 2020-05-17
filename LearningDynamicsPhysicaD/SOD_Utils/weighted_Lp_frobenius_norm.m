function fro_norm = weighted_Lp_frobenius_norm(A, W, p)
% function fro_norm = weighted_Lp_frobenius_norm(A, W, p)

% (C) M. Zhong

fro_norm = sum(sum(abs(A).^p .* W))^(1/p);
end