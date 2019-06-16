function the_diff = calculate_independence(jhist, mhist1, mhist2, bwidth1, bwidth2)
% function the_diff = calculate_independence(jhist, mhist1, mhist2, bwidth1, bwidth2)

% (c) M. Zhong

if ~iscolumn(mhist1)
  mhist1 = mhist1';
end
if ~isrow(mhist2)
  mhist2 = mhist2';
end
the_diff = sum(sum(abs(jhist - mhist1 * mhist2))) * bwidth1 * bwidth2;
end