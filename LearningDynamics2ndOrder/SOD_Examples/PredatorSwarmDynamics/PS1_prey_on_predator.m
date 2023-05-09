function phi = PS1_prey_on_predator(r, r_cut, IR)
% function phi = PS1_prey_on_predator(r, r_cut, IR)

% (C)

ind        = r < 0;
r(ind)     = 0;
phi        = zeros(size(r));
f          = @(r) 3.5 * r.^(-3);
df         = @(r) -10.5 * r.^(-4);
ind        = r < r_cut;
phi(ind)   = df(r_cut) * (r(ind) - r_cut) + f(r_cut);
if IR ~= Inf
  if 0.99 * IR < r_cut, error(''); end
  ind      = r_cut <= r & r < 0.99 * IR;
  phi(ind) = f(r(ind));
  ind      = 0.99 * IR <= r & r < IR;
  phi(ind) = ppval(spline([0.99 * IR, IR], [df(0.99 * IR), f(0.99 * IR), 0, 0]), r(ind));
else
  ind      = r >= r_cut;
  phi(ind) = f(r(ind));
end
end