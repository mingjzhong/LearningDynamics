function counts = histcounts3(x, y, z, xedges, yedges, zedges)
% function counts = histcounts3(x, y, z, xedges, yedges, zedges)
% a simple extension of MATLAB's built-in routines, histcounts and histcounts2, into 3D
% ATTENTOIN: it uses three for loops, a more efficient way has to be developed!!

% (C) M. Zhong (JHU)

if isempty(x) || isempty(y) || isempty(z)
  counts = zeros(length(xedges), length(ydeges), length(zdeges));
else
% 
  validateattributes(x,      {'numeric', 'logical'}, {'real'},                  mfilename, 'x',      1);
  validateattributes(y,      {'numeric', 'logical'}, {'real', 'size', size(x)}, mfilename, 'y',      2);
  validateattributes(z,      {'numeric', 'logical'}, {'real', 'size', size(x)}, mfilename, 'z',      3);
  validateattributes(xedges, {'numeric'}, {'real', 'increasing'},               mfilename, 'xedges', 4);
  validateattributes(yedges, {'numeric'}, {'real', 'increasing'},               mfilename, 'yedges', 5);
  validateattributes(zedges, {'numeric'}, {'real', 'increasing'},               mfilename, 'zedges', 6);
%
  nbins_x = length(xedges) - 1; nbins_y = length(yedges) - 1; nbins_z = length(zedges) - 1;
  counts  = zeros(nbins_x, nbins_y, nbins_z);
%
  for idx_x = 1 : nbins_x
    if idx_x < nbins_x
      ind_x = xedges(idx_x) <= x & x < xedges(idx_x + 1);
    else
      ind_x = xedges(idx_x) <= x & x <= xedges(idx_x + 1);
    end
    for idx_y = 1 : nbins_y
      if idx_y < nbins_y
        ind_y = yedges(idx_y) <= y & y < yedges(idx_y + 1);
      else
        ind_y = yedges(idx_y) <= y & y <= yedges(idx_y + 1);
      end    
      for idx_z = 1 : nbins_z
        if idx_z < nbins_z
          ind_z = yedges(idx_z) <= z & z < yedges(idx_z + 1);
        else
          ind_z = yedges(idx_z) <= z & z <= yedges(idx_z + 1);
        end       
        counts(idx_x, idx_y, idx_z) = nnz(ind_x & ind_y & ind_z);
      end
    end
  end
end
end