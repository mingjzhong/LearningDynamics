close all;

data_index=log10(2.^[3 4 7 10 13]);
m=size(data_index,2);
Mean_Errors = zeros(6*m,2);
Std_Errorss = zeros(6*m,2);
Errtotal=zeros(m,10);
sysname='PS';
for j=1:m
    
    filename1 = strcat(sysname,'ErrorsM',num2str(10^data_index(j)),'_NODerivative.mat');
    load(filename1);
    Mean_Errors(6*(j-1)+1:6*j,:)=Mean_traj_errors;
    Std_Errors(6*(j-1)+1:6*j,:)=Std_traj_errors;
     for i=1:size(Err,2)
     Err_smooth=Err(i).EErrSmooth;
      c=(Err_smooth.Abs(1,1)/Err_smooth.Rel(1,1))^2+(Err_smooth.Abs(1,2)/Err_smooth.Rel(1,2))^2+(Err_smooth.Abs(2,1)/Err_smooth.Rel(2,1))^2+(Err_smooth.Abs(2,2)/Err_smooth.Rel(2,2)^2);
     Errtotal(j,i)=sqrt(Err_smooth.Abs(1,1).^2+Err_smooth.Abs(1,2).^2+Err_smooth.Abs(2,1).^2+Err_smooth.Abs(2,2))./sqrt(c);
     %Errtotal(j,i)=Err_smooth.Rel;

     end
     
end
  





 %% mean traj errors over [0,1]
%figure(1);
subplot(1,2,1);

plot(data_index,log10(Mean_Errors(1:6:6*m,1)),'-bd','Linewidth',4,'markersize',20); hold on;
coefs1 = polyfit(data_index,log10(Mean_Errors(1:6:6*m,1)'), 1);

plot(data_index,log10(Mean_Errors(3:6:6*m,1)),'-.rs','Linewidth',4,'markersize',20); hold on;
coefs2 = polyfit(data_index,log10(Mean_Errors(3:6:6*m,1)'), 1);


plot(data_index,log10(Mean_Errors(5:6:6*m,1)),'--ko','Linewidth',4,'markersize',20); hold on;
coefs3 = polyfit(data_index,log10(Mean_Errors(5:6:6*m,1)'), 1);

hold off;
h1=gca;
h1.FontSize=45;
legend(strcat('Traning ICs, Slope=' ,num2str(round(coefs1(1),2)))...
    ,strcat('Random ICs, Slope=' ,num2str(round(coefs2(1),2)))...
    ,strcat('Large N, Slope=',num2str(round(coefs3(1),2))),'Location','southwest');
set(gcf, 'Position',  [1,1, 1920, 1080])
xlabel('log_{10}M'); ylabel('log_{10}(Traj Err)');

xlim([data_index(1) data_index(end)])
title('Mean Traj Errs over training time [0, 0.01]')

axes('Position',[.65 .65 .25 .25])
box on
plot(data_index,log10(mean(Errtotal,2)),'-b+','Linewidth',4,'markersize',20); 
xlim([data_index(1) data_index(end)])
xlabel('log_{10}M');
ylabel('log_{10}(Rel Err)');

% X_aug=[ones(size(data_index,2),1) data_index'];
% Y=log10(mean(Errtotal,2));
%B=X_aug\Y;
B=polyfit(data_index,log10(mean(Errtotal,2))', 1);
Y_reg=B(2)+B(1).*data_index';
lgd = legend(strcat('Slope =',num2str(round(B(1),2))));
h2=gca;
h2.FontSize=39;

set(gcf, 'Position',  [1,1, 1920, 1080])

%title(lgd,'L2 Rel Err')



%% mean traj errors over [1,20]
%figure(2);
subplot(1,2,2);

plot(data_index,log10(Mean_Errors(2:6:6*m,1)),'-bd','Linewidth',4,'markersize',20); hold on;
coefs1 = polyfit(data_index,log10(Mean_Errors(2:6:6*m,1)'), 1);

plot(data_index,log10(Mean_Errors(4:6:6*m,1)),'-.rs','Linewidth',4,'markersize',20); hold on;
coefs2 = polyfit(data_index,log10(Mean_Errors(4:6:6*m,1)'), 1);


plot(data_index,log10(Mean_Errors(6:6:6*m,1)),'--ko','Linewidth',4,'markersize',20); hold on;
coefs3 = polyfit(data_index,log10(Mean_Errors(6:6:6*m,1)'), 1);

hold off;
h3=gca;
h3.FontSize=45;
legend(strcat('Traning ICs, Slope=' ,num2str(round(coefs1(1),2)))...
    ,strcat('Random ICs, Slope=' ,num2str(round(coefs2(1),2)))...
    ,strcat('Large N, Slope=',num2str(round(coefs3(1),2))),'Location','southwest');
set(gcf, 'Position',  [1,1, 1920, 1080])
xlabel('log_{10}M'); ylabel('log_{10}(Traj Err)');

xlim([data_index(1) data_index(end)])
title('Mean Traj Errs over future time [0.01,2]')


% axes('Position',[.7 .7 .2 .2])
% set(gcf, 'Position',  [1,1, 1920, 1080])
% box on
% % plot(data_index,log2(mean(Errtotal,2)),'-b+','Linewidth',4,'markersize',10); 
% xlabel('log_{10}M');
% ylabel('log_{10}(Rel Err)');
% h4=gca;
% h4.FontSize=30;


