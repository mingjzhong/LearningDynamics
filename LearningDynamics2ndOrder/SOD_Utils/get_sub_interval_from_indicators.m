function [subInt, idx_J] = get_sub_interval_from_indicators(idx_J, knots, indicators)
% function [subInt, idx_J] = get_sub_interval_from_indicators(idx_J, knots, indicators)

% (C) M. Zhong

J                      = length(knots);
j                      = J;
idx_j                  = idx_J;
max_diff_jm1           = get_maximum_level_difference_in_J(idx_J, J);
done                   = false;
while ~done
  indicator_j          = indicators{j};
  max_diff_j           = min([get_maximum_level_difference_in_J(idx_j, j), max_diff_jm1]);
  idx1                 = idx_j;
  if idx_j > length(indicator_j)/2
    idx2               = idx_j + 2^(max_diff_j - 1) - 1;
  else
    idx2               = idx_j + 2^max_diff_j - 1;
  end
  if idx2 > length(indicator_j), fprintf('idx_j = %d, j = %d, idx1 = %d, and idx2 = %d', idx_j, ...
      j, idx1, idx2); end
  idx_of_1             = find(indicator_j(idx1 : idx2) == 1, 1);
  if isempty(idx_of_1)
    num_0s             = idx2 - idx1 + 1;
  else
    num_0s             = idx_of_1 - 1;
  end
  max_diff_j           = floor(log2(num_0s));
  if max_diff_j == 0
    subInt             = knots{j}(idx_j : idx_j + 1);
    idx_J              = idx_J + 2^(J - j);
    done               = true;
  else
    if j > 1
      idx_jm1          = (idx_j - 1)/2 + 1;
      jm1              = j - 1;
      if mod(idx_jm1, 2) > 0 
        if indicators{jm1}(idx_jm1) == 0
          j            = jm1;
          idx_j        = idx_jm1;
          max_diff_jm1 = max_diff_j;
        else
          subInt       = knots{j}(idx_j : idx_j + 1);  
          idx_J        = idx_J + 2^(J - j);
          done         = true;
        end
      else
        if indicators{jm1}(idx_jm1) == 0
          subInt       = knots{jm1}(idx_jm1 : idx_jm1 + 1);
          idx_J        = idx_J + 2;
          done         = true;
        else
          subInt       = knots{j}(idx_j : idx_j + 1);
          idx_J        = idx_J + 2^(J - j);
          done         = true;          
        end
      end      
    else
      subInt           = knots{j};
      idx_J            = idx_J + 2^J;
      done             = true;
    end
  end
end
end