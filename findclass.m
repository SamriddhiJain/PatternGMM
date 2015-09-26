function [prob]=findclass(test_data,mean,cov,pi,k)
    [tr,tc]=size(test_data);
    prob=[tr,1];
    for i = 1:tr
        cl=0;
        
        for j=1:k
            cv(:,:)=cov(j,:,:);
            cl=cl+pi(j)*normal_p(test_data(i,:),mean(j,:),cv);  
        end
        
        prob(i)=cl;
    end
end