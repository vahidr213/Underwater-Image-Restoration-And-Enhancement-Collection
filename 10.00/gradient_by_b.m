function gradient = gradient_by_b(A,b,p)
%GRADIENT_BY_B Compute gradient by b vector.
%   A - current A matrix solution
%   b - current b vector solution

    % gradient of first term - picked colors matching
    g_1 = 1/(2*size(p.psi_i,2))*p.lambda_1*2*(A*p.psi_i-p.psi_o+b*ones(1,size(p.psi_o,2)))*ones(size(p.psi_o,2),1);
    % gradient of third term - energy minimization
    g_2 = p.lambda_3*2*p.weights*b;
    % final gradient
    gradient = g_1 + g_2;
end
