function [E,E0] = findedge(I)

%% Parameters
Nmin = 30;

%% find edge image 
E = edge(I.^(1/2.2),'prewitt',0.01);

%% throw away edges with few connections
E0 = bwareaopen(E, Nmin);

