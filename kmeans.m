function [mu,covmatrix]=kmeans(trainingdata1,noclusters)
[nosamples,col]=size(trainingdata1);
nofeatures=col-1;
assigndata=trainingdata1(:,1:nofeatures); mu=[];newmu=[];
tmin=min(min(trainingdata1));tmax=max(max(trainingdata1));
znk=zeros(nosamples,noclusters);

% Intialize
% pd=makedist('uniform',tmin,tmax);
% if tmax>=1
%     coord=round(random(pd,noclusters,nofeatures));
% end;
% mu=trainingdata1(coord);


for i=1:1:nofeatures
    dataaxis(:,i)=min(assigndata(:,i)):(max(assigndata(:,i))-min(assigndata(:,i)))/noclusters:max(assigndata(:,i));
end;
mu=dataaxis(1:length(dataaxis)-1,:);

for iteration=1:1:10

% Assign each data point to cluster k
for i=1:1:nosamples
    [temp,index]=min(pdist2(mu,assigndata(i,1:nofeatures)));   
    znk(i,index)=1;
end;

% Minimization Step

for i=1:1:noclusters
    temp2=0;
    for j=1:1:nosamples
        temp2=temp2+(znk(j,i).*assigndata(j,1:nofeatures));
    end;
    newmu(i,:)= temp2./sum(znk(:,i));
end;
if abs(mean(newmu-mu)) <= 0.001
    break;
else
    mu=newmu;
end;

for i=1:1:nosamples
    [a,b]=unique(znk(i,:));
    assigndata(i,nofeatures+1)=a*b;
end;

% figure;
% gscatter(assigndata(:,1),assigndata(:,2),assigndata(:,3),'bgrcmky','.',4);
% hold on;
% gscatter(mu(:,1),mu(:,2),1:1:noclusters,'mykrcgb','s',10);

end;
j1=1;clusteridata=[];
for i=1:1:noclusters
    for j=1:1:nosamples
        clusteridata(j1,:)=(assigndata(j,nofeatures+1)==i ).*assigndata(j,1:nofeatures);
        j1=j1+1;
    end;
    covmatrix(:,:,i)=cov(clusteridata);
    j1=1;clusteridata=[];
end;
end