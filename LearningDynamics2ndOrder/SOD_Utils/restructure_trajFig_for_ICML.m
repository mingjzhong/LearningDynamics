function fig2 = restructure_trajFig_for_ICML(fig1)
% function restructure_trajFig_for_ICML(fig1)

% (C) M. Zhong

% find all the objects needed for replacements
% or use findall(...)
CBs                      = findobj(fig1, 'type', 'ColorBar');
AXs                      = findobj(fig1, 'type', 'Axes');
LHs                      = findobj(fig1, 'type', 'Legend');
CMap                     = get(AXs(1), 'ColorMap');
AXs                      = AXs(4 : -1 : 1);
LHs                      = LHs(4 : -1 : 1);
fig_pos                  = fig1.Position;
fig_pos(1)               = fig_pos(1) + 50;
fig2                     = figure('name', [fig1.Name ' UT'], 'NumberTitle', 'off', 'Position', fig_pos);
set(groot, 'Currentfigure', fig2);
AHs                      = gobjects(2);
for idx = 1 : 4
  AX                     = subplot(2, 2, idx);
  AXcp                   = copyobj(AXs(idx), fig2);
  set(AXcp, 'Position', get(AX, 'Position'));
  delete(AX);
  if mod(idx, 2) == 0
    colormap(CMap);
    colorbar('Location', 'East');
  end
  hold on;
  l_handle                = plot(NaN, NaN, '-k');                                                   % dummy lines for legend
  hold off;
  LH                      = legend(l_handle, LHs(idx).String, 'Location', LHs(idx).Location);
  set(LH, 'Interpreter', 'latex', 'FontName', LHs(idx).FontName, 'FontSize', LHs(idx).FontSize);
  rIdx                    = floor((idx - 1)/2) + 1;
  cIdx                    = mod(idx - 1, 2) + 1;
  AHs(rIdx, cIdx)         = gca;
end
tightFigaroundAxes(AHs);
CBs_new                   = findobj(fig2, 'type', 'ColorBar');
for idx = 1 : 2
  CBs_new(idx).Limits     = CBs(1).Limits;
  CBs_new(idx).Ticks      = CBs(1).Ticks;
  CBs_new(idx).TickLabels = CBs(1).TickLabels;
  CBs_new(idx).FontSize   = CBs(1).FontSize;
  CBs_new(idx).FontName   = CBs(1).FontName;
end
close(fig1);
end