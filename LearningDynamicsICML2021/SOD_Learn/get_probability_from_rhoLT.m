function prob = get_probability_from_rhoLT(rhoLT, subInts)
% function prob = get_probability_from_rhoLT(rhoLT, subInts)

% (C) M. Zhong

prob        = zeros(size(subInts));
for idx = 1 : length(subInts)
  prob(idx) = get_probability_from_rhoLT_on_subInt(rhoLT, subInts{idx});
end
end