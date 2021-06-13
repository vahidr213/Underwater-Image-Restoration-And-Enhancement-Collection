function varargout=buildpyramid(im, num_levels,option)

if option == 1
    pyr = cell(1,num_levels);
    pyr{1}=im;
    for i=2:num_levels
        pyr{i}=impyramid(pyr{i-1},'reduce');
    end
    varargout{1} = pyr;
elseif option == 2
    %%%%%% Residual pyr
    pyr = cell(1,num_levels);
    residualPyr=cell(1,num_levels);
    pyr{1}=im;
    for i=2:num_levels
        pyr{i}=impyramid(pyr{i-1},'reduce');
    end

    residualPyr{num_levels} =  pyr{num_levels};
    for i = 1 : (num_levels-1)
        A = pyr{i};
        B = imresize( pyr{i+1},2 );
        [M,N,~] = size(A);
        residualPyr{i} = A - B(1:M,1:N,:);
    end
    residualPyr{end} = pyr{end};
    varargout{1}=residualPyr;
elseif option == 3 % laplacian of Gaussian pyramid
    %%%%%% Laplacian of Gaussian pyr
    pyr = cell(1,num_levels);
    laplacianPyr=cell(1,num_levels);
    pyr{1}=im;
    for i=2:num_levels
        pyr{i}=pyr{i-1}(1:2:end,1:2:end);        
    end
    
    for i = 1 : num_levels
        laplacianPyr{i} = imfilter(pyr{i},fspecial('log',3),'replicate','conv');        
    end
    
    varargout{1}=laplacianPyr;
elseif option == 4
    pyr = cell(1,num_levels);
    laplacianPyr=cell(1,num_levels);
    pyr{1}=im;
    for i=2:num_levels
        pyr{i}=pyr{i-1}(1:2:end,1:2:end);        
    end
    
    for i = 1 : num_levels
        laplacianPyr{i} = imfilter(pyr{i},fspecial('laplacian',0.2),'replicate','conv');        
    end


end % option


end% function