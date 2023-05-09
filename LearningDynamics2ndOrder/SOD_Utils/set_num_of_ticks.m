function set_num_of_ticks(AH, d)
% function set_num_of_ticks(AH, d)

% (C) M. Zhong

variable         = {'X', 'Y'};
for idx = 1 : d - 1
  tick_marks     = get(AH, [variable{idx}, 'TickLabel']);
  inds           = 1 : length(tick_marks);
  inds           = inds(cellfun(@(x) ~isempty(x), tick_marks));
  tick_marks     = tick_marks(inds);
  num_ticks      = length(tick_marks);
  if num_ticks > 3
    mid_tick_idx = floor((1 + num_ticks)/2);
    tick_marks   = tick_marks([1, mid_tick_idx, num_ticks]);
    the_ticks    = cellfun(@(x) str2double(x), tick_marks);
    set(AH, [variable{idx}, 'Tick'], the_ticks);
    set(AH, [variable{idx}, 'TickLabel'], tick_marks);
  end
end
end