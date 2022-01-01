function dispcheck(im,varargin)
  disp('-----------');
  if nargin == 2
    disp(varargin{1})
  endif
  disp( [ num2str( min( im(:) ) ),'     ', num2str( max(im(:)) ),'   ', class(im),'   ',num2str( size(im) )] );  
  
end