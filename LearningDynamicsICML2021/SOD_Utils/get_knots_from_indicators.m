function the_knots = get_knots_from_indicators(knots, indicators)
% function knots = get_knots_from_indicators(knots, indicators)

% (C) M. Zhong

J                              = length(knots);  
if iscell(knots{1})
  dim                          = length(knots{1});
  if dim > 1, error(''); end
  for j = 1 : J
    knots{j}                   = knots{j}{1};
  end
end
the_knots                      = cell(1, length(indicators{J}));
int_idx                        = 1;
knots_idx                      = 0;
done                           = false;
while ~done
  if indicators{J}(int_idx) == 0 && mod(int_idx, 2) > 0
    [subInt, int_idx]          = get_sub_interval_from_indicators(int_idx, knots, indicators);
  else
    subInt                     = knots{J}(int_idx : int_idx + 1);
    int_idx                    = int_idx + 1;
  end    
  knots_idx                    = knots_idx + 1;
  the_knots{knots_idx}         = subInt;
  if int_idx > length(indicators{J}), done = true; end
end
the_knots(knots_idx + 1 : end) = [];
the_knots                      = unique(horzcat(the_knots{:}));
end