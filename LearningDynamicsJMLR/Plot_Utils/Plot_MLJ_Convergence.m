Err11=zeros(6,1);
Err12=zeros(6,1);
Err21=zeros(6,1);
Err22=zeros(6,1);
Errtotal=zeros(6,1);

for j=1:6
    p=9+j;
    load(strcat('Truncated_MultiLennardJones1stOrderRelErrors',num2str(p),'.mat'));
    Err=Err.EErr;
    for i=1
    Err11(j,1)=Err(i).Abs(1,1)+Err11(j,1);
    Err12(j,1)=Err12(j,1)+Err(i).Abs(1,2);
    Err21(j,1)=Err21(j,1)+Err(i).Abs(2,1);
    Err22(j,1)=Err22(j,1)+Err(i).Abs(2,2);
    c=(Err(i).Abs(1,1)/Err(i).Rel(1,1))^2+(Err(i).Abs(1,2)/Err(i).Rel(1,2))^2+(Err(i).Abs(2,1)/Err(i).Rel(2,1))^2+(Err(i).Abs(2,2)/Err(i).Rel(2,2))^2;
    Errtotal(j,1)=Errtotal(j,1)+sqrt((Err(i).Abs(1,1).^2+Err(i).Abs(1,2).^2+Err(i).Abs(2,1).^2+Err(i).Abs(2,2).^2)/c);
    end
    %c=(Err.Abs(1,1)/Err.Rel(1,1))^2+(Err.Abs(1,2)/Err.Rel(1,2))^2+(Err.Abs(2,1)/Err.Rel(2,1))^2;%+(Err.Abs(2,2)/Err.Rel(2,2))^2;
    %Errtotal(j,1)=sqrt((Err.Abs(1,1).^2+Err.Abs(1,2).^2+Err.Abs(2,1).^2+Err.Abs(2,2).^2)/c);
end

% Errtotal=Errtotal./10;
% for j=5
%     load(strcat('MultiLennardJones1stOrderRelErrors',num2str(j),'.mat'));
%     for i=1
%     Err11(j,1)=Err(i).Abs(1,1)+Err11(j,1);
%     Err12(j,1)=Err12(j,1)+Err(i).Abs(1,2);
%     Err21(j,1)=Err21(j,1)+Err(i).Abs(2,1);
%     Err22(j,1)=Err22(j,1)+Err(i).Abs(2,2);
%     
%     %c=(Err(i).Abs(1,1)/Err(i).Rel(1,1))^2+(Err(i).Abs(1,2)/Err(i).Rel(1,2))^2+(Err(i).Abs(2,1)/Err(i).Rel(2,1))^2+(Err(i).Abs(2,2)/Err(i).Rel(2,2))^2;
%     c=1;
%     Errtotal(j,1)=Errtotal(j,1)+sqrt((Err(i).Abs(1,1).^2+Err(i).Abs(1,2).^2+Err(i).Abs(2,1).^2+Err(i).Abs(2,2).^2)/c);
%     end
%     %c=(Err.Abs(1,1)/Err.Rel(1,1))^2+(Err.Abs(1,2)/Err.Rel(1,2))^2+(Err.Abs(2,1)/Err.Rel(2,1))^2;%+(Err.Abs(2,2)/Err.Rel(2,2))^2;
%     %Errtotal(j,1)=sqrt((Err.Abs(1,1).^2+Err.Abs(1,2).^2+Err.Abs(2,1).^2+Err.Abs(2,2).^2)/c);
% end


trajs=2.^(10:15);
close all;
figure;
num_traj=6;
I=1:num_traj;
X=log2(trajs(I)./log(trajs(I)))';
X_aug=[ones(size(X,1),1) X];
Y=log2(Errtotal(I,1));
B=X_aug\Y;
Y_reg=B(1)+B(2).*X;
Y_opt=log2(Errtotal(1,1))-0.35.*(X-X(1));
plot(X,Y,'r-',X,Y_reg,'b--o',X,Y_opt);
legend('orginal data',strcat('slope=',num2str(B(2))),'Optimal Decay')
xlabel('log_{10}(M)');
ylabel('log_{10}(Err)');