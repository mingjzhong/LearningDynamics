function y_init = LJ_init_config(L_x, d, N, kind)
%
% function y_init = LJD_init_config(L_x, d, N, kind)
%

% (c) M. Zhong, M. Maggioni

% generate the initial configuration based on kind
switch kind
    case 1
        y_init = uniform_dist(d, N, 'rectangle', [-L_x, L_x]);
        y_init = y_init(:);
    case 2
        y_init = randn(d,N);
        y_init = y_init(:);
    otherwise
end

return
