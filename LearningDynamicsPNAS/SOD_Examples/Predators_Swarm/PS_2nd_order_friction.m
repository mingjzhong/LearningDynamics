function friction = PS_2nd_order_friction(v, nus, num_classes, class_info)
% friction = PS_2nd_order_friction(v, nus, num_classes, class_info)

% Ming Zhong
% Postdoc Research at JHU

%
[d, N]                    = size(v);
%
friction                  = zeros(d, N);
%
for k = 1 : num_classes
  agents_Ck1              = class_info == k;
  friction(:, agents_Ck1) = -nus(k) * v(:, agents_Ck1);
end
%
friction                  = friction(:);
end