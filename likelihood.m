function temp=likelihood(test_data,pi,mean,cov,k)
    [tr,tc]=size(test_data);
    temp=1;
    for i = 1:tr
        cl=0;        
        for j=1:k
            cv(:,:)=cov(j,:,:);
            cl=cl+pi(j)*normal_p(test_data(i,:),mean(j,:),cv);
        end
        
        temp=temp*cl;
    end
end