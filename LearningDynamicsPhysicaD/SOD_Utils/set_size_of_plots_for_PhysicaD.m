function set_size_of_plots_for_PhysicaD()
% function set_size_of_plots_for_PhysicaD()

% (C) M. Zhong

fig                = get(groot,'CurrentFigure');
if ~isempty(fig)
  AH               = findobj(fig, 'type', 'axes');
  switch length(AH)
    case 1
      tightFigaroundAxes(AH);
    case 2
      ano_AH       = gobjects(1, 2);
      ano_AH(1)    = AH(2);
      ano_AH(2)    = AH(1);
      tightFigaroundAxes(ano_AH);
    case 4
      ano_AH       = gobjects(2, 2);
      ano_AH(1, 1) = AH(4);
      ano_AH(1, 2) = AH(3);
      ano_AH(2, 1) = AH(2);
      ano_AH(2, 2) = AH(1);
      tightFigaroundAxes(ano_AH);     
    otherwise
  end
end
end