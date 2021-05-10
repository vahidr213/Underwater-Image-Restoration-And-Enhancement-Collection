function [cost] = evaluate_cost(A,b,p)
%EVALUATE_COST Evaluate cost function.
%   A - current A matrix solution
%   b - current b vector solution
%   p - equation params

    % picked colors matching
    first_term = 1/(2*size(p.psi_i,2))*p.lambda_1*norm(A*p.psi_i-p.psi_o+b*ones(1,size(p.psi_o,2)),'fro')^2;
    % color covariance matrixes matching
    second_term = 1/norm(p.Ci+p.Cr,'fro')*p.lambda_2*norm(A*p.Ci*A'-p.Cr,'fro')^2;
    % energy minimization term
    third_term = p.lambda_3*norm(p.weights*A,'fro')^2+p.lambda_3*norm(p.weights*b,'fro')^2;
    % final cost
    cost = first_term + second_term + third_term;
end

