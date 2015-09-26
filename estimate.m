function [mean,sigma,pi]= estimate(X,res,n,k) 
    mean=[];
    sigma=[];
    for j=1:k
        %%%%%%%%%%%%%Initailise%%%%%%%%%%
        N(j)=0;
        temp=0;
        temp2=0;
        pi(j)=0;
        
        %%%%%%%%%%%%%%%%N(k)%%%%%%%%%%%%%%
        for i=1:n
            N(j)=N(j)+res(i,j);
        end

        %%%%%%%%%%%%%%%pi(k)%%%%%%%%%%%%%%%%%%%
        pi(j)=N(j)/n;

        %%%%%%%%%%%%%%%mean(k)%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:n
            temp= temp+(res(i,j)*X(i,:));
        end
        mean(j,:)=temp/N(j);  
        
        %%%%%%%%%%%%%%%%cov(k)%%%%%%%%%%%%%%%%%%%%%%
        for i=1:n
            temp2=temp2+(res(i,j)*(transpose(X(i,:)-mean(j,:))*(X(i,:)-mean(j,:))));
        end
        sigma(j,:,:)=temp2/N(j);
        
    end
end