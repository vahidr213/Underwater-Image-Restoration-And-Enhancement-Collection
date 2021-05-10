function covariance_matrix = get_color_cov_matrix(image)
%GET_COLOR_COV_MATRIX Summary of this function goes here
    red_color_vector = double(image(:,:,1));
    green_color_vector = double(image(:,:,2));
    blue_color_vector =  double(image(:,:,3));
    color_variables = [red_color_vector(:) green_color_vector(:) blue_color_vector(:)];
    covariance_matrix = cov(color_variables);
end