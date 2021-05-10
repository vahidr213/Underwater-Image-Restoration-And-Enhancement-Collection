function gradient = gradient_by_A(A,b,p)
%GRADIENT_BY_A Compute gradient by A matrix.
%   A - current A matrix solution
%   b - current b vector solution

    % gradient of first term - picked colors matching
    g_1 = 1/(2*size(p.psi_i,2))*p.lambda_1*2*(A*p.psi_i-p.psi_o+b*ones(1,size(p.psi_o,2)))*p.psi_i';
    % gradient of second term - color covariance matrixes matching
    g_2 = 1/norm(p.Ci+p.Cr,'fro')*p.lambda_2*2*(2*A*p.Ci*A'*A*p.Ci-2*p.Cr*A*p.Ci);
    % gradient of third term - energy minimization
    g_3 = p.lambda_3*2*p.weights*A;
    % final gradient
    gradient = g_1 + g_2 + g_3;
end
