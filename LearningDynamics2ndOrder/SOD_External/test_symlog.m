function test_symlog(F_EIH)
% function test_symlog(F_EIH)

% % (C) M. Zhong
% x  = linspace(-50,50,1e4+1); 
% y1 = x; 
% %y2 = sin(x);
% figure;
% subplot(2, 2, 1);
% plot(x, y1);
% title('Original y = x');
% AX = subplot(2, 2, 2);
% plot(x, y1);
% yscale_symlog(AX);
% title('Trans. y = x');
% subplot(2, 2, 3);
% plot(x, y1);
% title('Original y = x');
% AX = subplot(2, 2, 4);
% plot(x, y1);
% symlog(AX, 'y', -2);
% title('Trans. y = x');

m1       = 1.9885e6;
G        = 8.64^2 * 6.67408e-6;  
c        = 2.99792458 * 24 * 360;
F_Newton = @(r) G * m1 * r.^(-3);
F_Newcor = @(r) 3 * G * m1/c^2 * r.^(-1);
r_pts    = F_EIH{1}.GridVectors{1};
F_max    = F_EIH{1}.Values;
F_min    = F_EIH{2}.Values;
F_diff1  = (F_max - F_Newton(r_pts))./F_Newton(r_pts);
scale1   = floor(min(log10(abs(F_diff1))));
F_diff2  = (F_min - F_Newton(r_pts))./F_Newton(r_pts);
F_diff3  = F_Newcor(r_pts);
scale2   = floor(min(log10(abs(F_diff3))));
figure;
plot(r_pts, F_diff1, 'bo');
hold on;
plot(r_pts, F_diff2, 'rd');
plot(r_pts, F_diff3, 'ks');
hold off;
% yscale_symlog(gca)
symlog(gca, 'y', min(scale1, scale2));
axis tight;
end