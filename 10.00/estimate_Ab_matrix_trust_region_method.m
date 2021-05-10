function [A_final,b_final,cost_y] = estimate_Ab_matrix_trust_region_method(...
    picked_colors_input, picked_colors_reference,...
	input_im, ref_im,...
    lambda_1, lambda_2, lambda_3,...
    weights)

psi_i=picked_colors_input;
psi_o=picked_colors_reference;

% initial solution - starting point of A,b
T = estimate_initial_color_t_matrix(...
    psi_o(1,:)', psi_o(2,:)', psi_o(3,:)',...
    psi_i(1,:)', psi_i(2,:)', psi_i(3,:)',0);
A0=T(1:3,1:3);
b0 = T(:,4);

% initial solution from 0
% A0=ones(3);
% b0=ones(3,1);
x0 = [A0(:) ; b0(:)];

% compute color covariance matrixes
Ci = get_color_cov_matrix(input_im);
Cr = get_color_cov_matrix(ref_im);

% pack equation params/weight to struct
eq_params = struct;
eq_params.lambda_1 = lambda_1;
eq_params.lambda_2 = lambda_2;
eq_params.lambda_3 = lambda_3;
eq_params.psi_i = psi_i;
eq_params.psi_o = psi_o;
eq_params.Ci = Ci;
eq_params.Cr = Cr;
eq_params.weights = weights;

options = optimoptions('fminunc','Algorithm','trust-region',...
                        'SpecifyObjectiveGradient',true,...
                        'Display','off', 'OutputFcn',@outfun);

history.fval = [];
fun = @rosenbrockwithgrad;
% start timer
tic;
[x,fval,exitflag,output] = fminunc(fun,x0,options);
% stop timer
total_computation_time=toc;
cost_x=1:length(history.fval);
cost_y=history.fval;
% figure;
% plot(cost_x,cost_y);
% % semilogx(cost_x,cost_y);
% xlabel('No of iterations');
% ylabel('Cost value');
% title('Trust Region Method');

fprintf('\n ###Trust Region Method### \n')
fprintf('Algorithm stopped after %d iterations. \n',output.iterations)
fprintf('Final cost value: %f. \n',cost_y(end))
fprintf('Total computation time: %.3f seconds. \n',total_computation_time)
A_final = reshape(x(1:9),3,3);
b_final = reshape(x(10:end),3,1);


function [f,g] = rosenbrockwithgrad(x)
    A = reshape(x(1:9),3,3);
    b = reshape(x(10:end),3,1);
    
    % Calculate objective f
    f = evaluate_cost(A,b,eq_params);

    if nargout > 1 % gradient required

        gA = gradient_by_A(A,b,eq_params);
        gb = gradient_by_b(A,b,eq_params);

        g = [gA(:) ; gb(:)];
    end

end

 function stop = outfun(x,optimValues,state)
     stop = false;
     switch state
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
     end
 end
 
end