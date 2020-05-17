function test_planet_data(PD)
%

%
figure(1)
hold on;
% zlim([-5 5])
k = 2;
for l = 1 : 365 * 60
    scatter3(PD{k,3}.x(l), PD{k,3}.y(l), PD{k,3}.z(l), 1); %Plot the full histories
    view(30, 30);
    pause(0.1);
end
hold off;
% dists = zeros(1, 88);
% for day = 1 : 88
%   dists(day) = norm([PD{1, 3}.x(day), PD{1, 3}.y(day), PD{1, 3}.z(day)]);
% end
% 
% [~, ind] = max(dists);
% fprintf('ind = %d.\n', ind);
% x1 = PD{1, 3}.x(ind);
% y1 = PD{1, 3}.y(ind);
% z1 = PD{1, 3}.z(ind);
% [~, ind] = min(dists);
% fprintf('ind = %d.\n', ind);
% x2 = PD{1, 3}.x(ind);
% y2 = PD{1, 3}.y(ind);
% z2 = PD{1, 3}.z(ind);
% v1 = [x1, y1, z1] - [x2, y2, z2];
% 
% for day = 1 : 88
%   dists(day) = norm([PD{1, 3}.x(day+ 88), PD{1, 3}.y(day+ 88), PD{1, 3}.z(day+ 88)]);
% end
% 
% [~, ind] = max(dists);
% fprintf('ind = %d.\n', ind);
% x1 = PD{1, 3}.x(ind);
% y1 = PD{1, 3}.y(ind);
% z1 = PD{1, 3}.z(ind);
% [~, ind] = min(dists);
% fprintf('ind = %d.\n', ind);
% x2 = PD{1, 3}.x(ind);
% y2 = PD{1, 3}.y(ind);
% z2 = PD{1, 3}.z(ind);
% v2 = [x1, y1, z1] - [x2, y2, z2];
% 
% 
% theta = acos(dot(v1, v2)/(norm(v1) * norm(v2)));
% fprintf('angle is: %.8e\n', theta);