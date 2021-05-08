function varargout=buildpyramid(im, num_levels,option)

if option == 1
    pyr = cell(1,num_levels);
    pyr{1}=im;
    for i=2:num_levels
        pyr{i}=impyramid(pyr{i-1},'reduce');
    endfor
    varargout{1} = pyr;
elseif option == 2
    %%%%%% laplacian pyr
    pyr = cell(1,num_levels);
    lappyr=cell(1,num_levels);
    pyr{1}=im;
    for i=2:num_levels
        pyr{i}=impyramid(pyr{i-1},'reduce');
    endfor

    lappyr{num_levels} =  pyr{num_levels};
    for i = 1 : (num_levels-1)
        A = pyr{i};
        B = imresize( pyr{i+1},2 );
        [M,N,~] = size(A);
        lappyr{i} = A - B(1:M,1:N,:);
    endfor
    lappyr{end} = pyr{end};
    varargout{1}=lappyr;
endif


end% function