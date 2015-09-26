clear;
class1=importdata('Class1.txt');
class2=importdata('Class2.txt');
train1=class1(1:375,:);
train2=class2(1:375,:);
test_data(1:125,:)=class1(376:500,:);
test_data(126:250,:)=class2(376:500,:);
actual_class(1:125)=1;
actual_class(126:250)=2;
x1 = -1.5:.01:3; x2 = -2:.01:2;
[X1,X2] = meshgrid(x1,x2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot Points%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(class1(:,1),class1(:,2),'bO', class2(:,1),class2(:,2),'rO');
title('Points');
saveas(gcf,'Points.png');
figure();

%%%%%%class1 k=4%%%%%%%
%%%%%Initialisation by k means%%%%
pi1=[0.2;0.3;0.3;0.2];
mean1=[0,0;1,0.5;2,0.75;2.5,0];
% cov1=[[1,0.5;0.5,1];[1.3,0,7;0,7,1.4];[1.2,0.8;0.8,1.8];[0.3,1.5;1.5,0.7]];
cov1(1,:,:)=[1,0.5;0.5,1];
cov1(2,:,:)=[1.3,0.7;0.7,1.4];
cov1(3,:,:)=[1.2,0.8;0.8,1.8];
cov1(4,:,:)=[0.3,1.5;1.5,0.7];


lio=likelihood(train1,pi1,mean1,cov1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%% E-M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:1000
    %%%%%%%%%%%%%%%%%%%%%%%%%Calculate Responsibility%%%%%%%%%%%%%%%%%%%%%%
    y1=[];

    for i=1:375
        sum=0;
        for j=1:4
           cv(:,:)=cov1(j,:,:);
           prod(j)=pi1(j)*normal_p(train1(i,:),mean1(j,:),cv);
           sum=sum+prod(j);
        end

        for j=1:4
           y1(i,j) = prod(j)/sum;
        end
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Restimate Parameters%%%%%%%%%%%%%%%%%%%%%
    [mean1,sigma1,pi1]=estimate(train1,y1,375,4);

    lin=likelihood(class1,pi1,mean1,sigma1,4);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Check Convergence%%%%%%%%%%%%%%%%%%%%%%%%%%
%     abs(lin-lio)
   mean1
    if(abs(lin-lio)< 0.000001)
        break;
    else
        lio=lin;
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot Clusters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [val,clust]=max(y1');
% plot(mean1(1,1),mean1(1,2),'bO', mean1(2,1),mean1(2,2),'rO',mean1(3,1),mean1(3,2),'yO',mean1(4,1),mean1(4,2),'gO');
% title('clusters1');
% figure();
% 
% cl1=[];
% cl2=[];
% cl3=[];
% cl4=[];
% i1=0;
% i2=0;
% i3=0;
% i4=0;
% for i=1:375
%    if(clust(i)==1)
%        i1=i1+1;
%        cl1(i1,:)=class1(i,:);
%    elseif(clust(i)==2)
%        i2=i2+1;
%        cl2(i2,:)=class1(i,:);
%    elseif(clust(i)==3)
%        i3=i3+1;
%        cl3(i3,:)=class1(i,:);
%    elseif(clust(i)==4)
%        i4=i4+1;
%        cl4(i4,:)=class1(i,:);
%    end
% end
% plot(cl1(:,1),cl1(:,2),'bO', cl2(:,1),cl2(:,2),'rO',cl3(:,1),cl3(:,2),'yO',cl4(:,1),cl4(:,2),'gO');
% title('Pt1');
% figure();


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%class2 k=4%%%%%%%
%%%%%Initialisation by k means%%%%
pi2=[0.2;0.3;0.3;0.2];
mean2=[-1.3,0;-1,-0.8;1,-1;1.5,-0.5];
cov2(1,:,:)=[1,0.5;0.5,1];
cov2(2,:,:)=[1.3,0.7;0.7,1.4];
cov2(3,:,:)=[1.2,0.8;0.8,1.8];
cov2(4,:,:)=[0.3,1.5;1.5,0.7];


lio=likelihood(train2,pi2,mean2,cov2,4);

%%%%%%%%%%%%%%%%%%%%%%%%%% E-M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:10
    %%%%%%%%%%%%%%%%%%%%%%%%%Calculate Responsibility%%%%%%%%%%%%%%%%%%%%%%
    y2=[];

    for i=1:375
        sum=0;
        for j=1:4
           cv(:,:)=cov2(j,:,:);
           prod(j)=pi2(j)*normal_p(train2(i,:),mean2(j,:),cv);
           sum=sum+prod(j);
        end

        for j=1:4
           y2(i,j) = prod(j)/sum;
        end
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Restimate Parameters%%%%%%%%%%%%%%%%%%%%%
    [mean2,sigma2,pi2]=estimate(train2,y2,375,4);

    lin=likelihood(class2,pi2,mean2,sigma2,4);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Check Convergence%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(abs(lin-lio)<0.00001)
        break;
    else
        lio=lin;
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot Clusters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [val,clust]=max(y2');
% plot(mean2(1,1),mean2(1,2),'bO', mean2(2,1),mean2(2,2),'rO',mean2(3,1),mean2(3,2),'yO',mean2(4,1),mean2(4,2),'gO');
% title('clusters2');
% for i=1:375
%    if(clust(i)==1)
%        plot(class2(i,1),class2(i,2),'bO');
%    elseif(clust(i)==2)
%        plot(class2(i,1),class2(i,2),'rO');
%    elseif(clust(i)==3)
%        plot(class2(i,1),class2(i,2),'yO');
%    elseif(clust(i)==4)
%        plot(class2(i,1),class2(i,2),'gO');
%    end
% end
% title('Pt2');
% figure();



%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test_Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1=findclass(test_data,mean1,sigma1,pi1,4);
p2=findclass(test_data,mean2,sigma2,pi2,4);
value=[];

for i=1:250
    if(p1(i)>p2(i))
        value(i)=1;
    else
        value(i)=2;
    end
end

[c1,order]=confusionmat(double(actual_class),value);
c1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%Decision Region%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pg1=findclass([X1(:) X2(:)],mean1,sigma1,pi1,4);
pg2=findclass([X1(:) X2(:)],mean2,sigma2,pi2,4);
[r,c]=size([X1(:) X2(:)]);
value2=[];

for i=1:r
    if(pg1(i)>pg2(i))
        value2(i)=1;
    else
        value2(i)=2;
    end
end

gscatter(X1(:), X2(:),value2, 'bk','.');
hold on;

plot(class1(:,1),class1(:,2),'wO', class2(:,1),class2(:,2),'yO');
title('Points1ai');
saveas(gcf,'Points1ai.png');








