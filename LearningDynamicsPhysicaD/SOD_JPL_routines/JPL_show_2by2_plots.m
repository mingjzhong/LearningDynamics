function JPL_show_2by2_plots(WH, title_names, xlabel_name, ylabel_name, x_vec, y_vecs, file_name)
%

% (C) M. Zhong
set(groot,'CurrentFigure', WH);                        
AHs                     = gobjects(2, 2);
% show the data
for idx = 1 : length(title_names)
  y_vec                 = y_vecs{idx};
  AH                    = subplot(2, 2, idx);
  plot(x_vec, y_vec);
  xlabel(xlabel_name);
  ylabel(ylabel_name);
  title(title_names{idx});
  row_ind               = floor((idx - 1)/2) + 1;
  col_ind               = mod(idx - 1, 2) + 1;
  AHs(row_ind, col_ind) = AH;  
  axis tight;
end
tightFigaroundAxes(AHs);  
print(WH, file_name, '-painters', '-dpng', '-r300');
end