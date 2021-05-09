function plotColorSpace(org, wb, final)
figure,plot3(org(:,:,1),org(:,:,2),org(:,:,3), '.b'),grid on
xlabel('R'),ylabel('G'),zlabel('B')%,title('RGB space of original')

figure,plot3(wb(:,:,1),wb(:,:,2),wb(:,:,3), '.b'),grid on
xlabel('R'),ylabel('G'),zlabel('B')%,title('RGB space of white balance')

figure,plot3(final(:,:,1),final(:,:,2),final(:,:,3), '.b'),grid on
xlabel('R'),ylabel('G'),zlabel('B')%,title('RGB space of final output')