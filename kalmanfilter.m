function y = kalmanfilter(A,B,Q,R,U,z) 

H = [ 1 0 0 0 0 0; 0 1 0 0 0 0 ];    

chol_fact_std = chol(Q);

% w =chol_fact_std*randn(6,1);
w = chol_fact_std*zeros(6,1);

persistent x_est p_est                
if isempty(x_est)    
    x_est = zeros(6,1);             
    p_est = zeros(6,6);
    x_prd = A * x_est + B*U + w;
else
    x_prd = A * x_est + w;
end

% x_prd = A * x_est + B*U + w;
p_prd = A * p_est * A' + Q;

S = H * p_prd' * H' + R;
B = H * p_prd';
klm_gain = (S \ B)';

x_est = x_prd + klm_gain * (z - H * x_prd);
p_est = p_prd - klm_gain * H * p_prd;
y = H * x_est;
end                