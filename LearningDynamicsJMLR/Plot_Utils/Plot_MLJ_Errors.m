

data_index=[4 7 9 10];
m=size(data_index,2);
Mean_Errors = zeros(6*m,2);
Std_Errorss = zeros(6*m,2);

Err11=zeros(m,10);
Err12=zeros(m,10);
Err21=zeros(m,10);
Err22=zeros(m,10);
Errtotal=zeros(m,10);

for j=1:m
    
    filename1 = strcat('MLJErrorsM',num2str(2^data_index(j)),'_NODerivative.mat');
    load(filename1);
    Mean_Errors(6*(j-1)+1:6*j,:)=Mean_traj_errors;
    Std_Errors(6*(j-1)+1:6*j,:)=Std_traj_errors;
     for i=1:size(Err,2)
     Err_smooth=Err(i).EErrSmooth;
    c=(Err_smooth.Abs(1,1)/Err_smooth.Rel(1,1))^2+(Err_smooth.Abs(1,2)/Err_smooth.Rel(1,2))^2+(Err_smooth.Abs(2,1)/Err_smooth.Rel(2,1))^2;
    Errtotal(j,i)=sqrt((Err_smooth.Abs(1,1).^2+Err_smooth.Abs(1,2).^2+Err_smooth.Abs(2,1).^2)/c);
     end
     
end
  





close all;
 
figure(1);
%% with derivative 
% errorbar(Mean_Errors1([ 1 5 9 13],1),Mean_Errors1([1 5 9 13],2),'-.r*','Linewidth',2); hold on;
% errorbar(Mean_Errors1([ 3 7 11 15],1),Mean_Errors1([3 7 11 15],2),':bs','Linewidth',2); hold on;
%% without derivative

errorbar(Mean_Errors(1:6:6*m,1),Mean_Errors(1:6:6*m,2),'--go','Linewidth',2); hold on;
errorbar(Mean_Errors(3:6:6*m,1),Mean_Errors(3:6:6*m,2),'-.rs','Linewidth',2); hold on;
errorbar(Mean_Errors(5:6:6*m,1),Mean_Errors(5:6:6*m,2),'-kd','Linewidth',2); hold on;
hold off;
h1=gca;
h1.YScale='log';
h1.FontSize=32;
legend('Traning ICs','Random ICs','Large N')
set(gcf, 'Position',  [1,1, 1920, 1080])
xlabel('log_{2}M'); ylabel('log_{2}(Traj Err)');
title('Mean Traj Errs over time [0, 1]')
figure(2);
%% with derivative
% errorbar(Mean_Errors1([2 6 10 14],1),Mean_Errors1([2 6 10 14],2),'-.r*','Linewidth',2);hold on;
% errorbar(Mean_Errors1([4 8 12 16],1),Mean_Errors1([4 8 12 16],2),':bs','Linewidth',2); hold on;
%% without derivative
errorbar(Mean_Errors(2:6:6*m,1),Mean_Errors(2:6:6*m,2),'--go','Linewidth',2); hold on;
errorbar(Mean_Errors(4:6:6*m,1),Mean_Errors(4:6:6*m,2),'-.rs','Linewidth',2); hold on;
errorbar(Mean_Errors(6:6:6*m,1),Mean_Errors(6:6:6*m,2),'-kd','Linewidth',2); hold on;
hold off;


h2 =gca;
h2.YScale='log2';
h2.FontSize=32;
h2.XTick=1:4;
legend('Traning ICs','Random ICs','Large N')

set(gcf, 'Position',  [1,1, 1920, 1080])
xlabel('log_{2}M'); ylabel('log_{2}(Traj Err)');
title('Mean Traj Errs over time [1, 20]')


% figure(3); 
% h3=gca;
% %% with Derivatives
% errorbar(Std_Errors1([ 1 5 9 13],1),Std_Errors1([ 1 5 9 13],2),'-.r*','Linewidth',2); hold on;
% errorbar(Std_Errors1([ 3 7 11 15],1),Std_Errors1([ 3 7 11 15],2),':bs','Linewidth',2); hold on;
% 
% errorbar(Std_Errors2([ 1 5 9 13],1),Std_Errors2([ 1 5 9 13],2),'--go','Linewidth',2); hold on;
% errorbar(Std_Errors2([ 3 7 11 15],1),Std_Errors2([ 3 7 11 15],2),'-kd','Linewidth',2); hold on;
% h3.YScale='log';
% h3.FontSize=32;
% h3.XTick=1:4;
% legend('Traning ICs, true derivative','Random ICs, true derivative','Traning ICs','Random ICs')
% 
% set(gcf, 'Position',  [1,1, 1920, 1080])
% xlabel('log_{10}M'); ylabel('Traj Err');
% title('Std Traj Errs over time [0,0.1]')
% 
% figure(4);
% h4=gca;
% errorbar(Std_Errors1([2 6 10 14],1),Std_Errors1([2 6 10 14],2),'-.r*','Linewidth',2);hold on;
% errorbar(Std_Errors1([4 8 12 16],1),Std_Errors1([4 8 12 16],2),':bs','Linewidth',2); hold on;
% 
% errorbar(Std_Errors2([2 6 10 14],1),Std_Errors2([2 6 10 14],2),'--go','Linewidth',2);hold on;
% errorbar(Std_Errors2([4 8 12 16],1),Std_Errors2([4 8 12 16],2),'-kd','Linewidth',2); hold on;
% h4.YScale='log';
% h4.FontSize=32;
% h4.XTick=1:4;
% legend('Traning ICs, true derivative','Random ICs, true derivative','Traning ICs','Random ICs')
% 
% set(gcf, 'Position',  [1,1, 1920, 1080]);
% xlabel('log_{10}M'); ylabel('log_{10}(Traj Err)');
% title('Std Traj Errs over time [0.1,0.2]');
