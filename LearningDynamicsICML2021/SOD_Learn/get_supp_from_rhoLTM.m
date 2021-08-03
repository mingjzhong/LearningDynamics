function supp = get_supp_from_rhoLTM(knots, first_dim, rhoLTM)
% function supp = get_supp_from_rhoLTM(knots, first_dim, rhoLTM)

% (C) M. Zhong

resolution  = 200;
rs_HC       = rhoLTM.histcounts;
r_edges     = rhoLTM.histedges{1};
s_edges     = rhoLTM.histedges{2};
r_ctrs      = (r_edges(2 : end) + r_edges(1 : end - 1))/2;
s_ctrs      = (s_edges(2 : end) + s_edges(1 : end - 1))/2;
[R, S]      = ndgrid(r_ctrs, s_ctrs);
ind         = rs_HC > 0;
r           = R(ind);
s           = S(ind);
if first_dim == 1
  x         = r;
  x_ctrs    = r_ctrs;
  y         = s;
else
  x         = s;
  x_ctrs    = s_ctrs;
  y         = r;
end
y_of_x      = get_y_as_a_function_of_x(x, y, x_ctrs);
max_diff    = 5 * max(abs(y_of_x(x) - y));
knots       = knots{first_dim};
supp        = cell(1, length(knots) - 1);
for idx = 1 : length(supp)
  subInt    = linspace(knots(idx), knots(idx + 1), resolution + 1);
  y_pts     = y_of_x(subInt);
  supp{idx} = [min(y_pts) - max_diff, max(y_pts) + max_diff];
end
end