%% With derivative
close all
datasize=10:15; % M=2^datasize;
Errtotal=zeros(size(datasize,2),size(Err,2));
sysname='Truncated_MultiLennardJones1stOrder';

%sysname='Truncated_MultiLennardJones1stOrder';

% compute the vector esitmation norm from the data
for j=1:max(size(datasize))
     load(strcat(sysname,'RelErrors',num2str(datasize(j)),'.mat'),'Err');
   for i=1:size(Err,1)
     EErr=Err(i).EErr;
     c=(EErr.Abs(1,1)/EErr.Rel(1,1))^2+(EErr.Abs(1,2)/EErr.Rel(1,2))^2+(EErr.Abs(2,1)/EErr.Rel(2,1))^2;
     Errtotal(j,i)=sqrt((EErr.Abs(1,1).^2+EErr.Abs(1,2).^2+EErr.Abs(2,1).^2)/c);
  end
end

%plot the convergence rate 
figure(1);
set(gcf, 'Position',  [1,1, 1920, 1080])

X=log2(2.^datasize'); % log(M/log(M))
X_aug=[ones(size(X,1),1) X]; % for the least square fitting of data points 
Y=log2(mean(Errtotal,2)); % log(errors)
B=X_aug\Y; % coeffs of least square curve
Y_reg=B(1)+B(2).*X;
Y_opt=Y(1)-0.4.*datasize'+0.4*datasize(1); % optimal decay curve

plot(X,Y,'ro',X,Y_reg,'b','Linewidth',4,'markersize',10,'MarkerFaceColor','r');
hold on;
plot(X,Y_opt,'k--','Linewidth',2);
hold off

legend('Rel Err',strcat('Slope=-0.35'),'Optimal decay');
xlabel('log_{2}(M)');
ylabel('log_{2}(Rel Err)');
xlim([X(1) X(end)]);
xticks(10:16)
%xticklabels({'7.5','8','9','10','11','12','12.5'})
h1=gca;
h1.FontSize=39;

%% Coercivity constant 
dimensions=[25,50,100,150,200];
min_eig1=zeros(1,5); % for type 1
min_eig2=zeros(1,5); % for type 2
for j=1:5
filename=strcat('PS','Coercivity',num2str(dimensions(j)),'.mat');
load(filename);
min_eig1(j)=min(eig(A1));
min_eig2(j)=min(eig(A2));
end

%% the coercivity for type I agents
figure(2)
plot(dimensions,min_eig1,'b','marker','o', 'Linewidth',4','markersize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on;
plot(dimensions,min_eig2,'k','marker','o', 'Linewidth',4','markersize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');

xticks(dimensions)
%ylim([0.01,0.1])
set(gcf, 'Position',  [1,1, 1920, 1080])
xlabel('Partitions of intervals','Interpreter','latex');
ylabel('Minimal eigenvalue');
legend('Type I block','Type II block')
h2=gca;
h2.YRuler.Exponent = -2;
h2.FontSize=39;

%ylim([0.019,0.021]);

%% the coercivity for type II agents
%figure(3)
%plot(dimensions,min_eig2,'b','marker','o', 'Linewidth',4','markersize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
% set(gcf, 'Position',  [1,1, 1920, 1080])
% xticks(dimensions)
% xlabel('Dimension');
% ylabel('Coercivity constant');
% %yticks([6.8*1e-3, 6.9*1e-3,7*1e-3]);
% h3=gca;
% h3.FontSize=39;
% xlabel('dim($$\mathcal{H}_{n}$$)','Interpreter','latex');
% 
% ylabel('Coercivity constant');
% ylim([6.5*1e-3,7.21e-3])