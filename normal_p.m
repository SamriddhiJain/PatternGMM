function ans = normal_p(X, M, Sigma)
    d = size(Sigma,1);
    den = ((2 * pi).^(d/2)) * sqrt(det(Sigma));
    ans = (exp((-0.5)*(X - M)*inv(Sigma)*(X - M)')/den);
end
