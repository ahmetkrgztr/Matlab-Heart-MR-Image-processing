
time_pos=2
z_pos=6
cIM = grayimage(:,:,z_pos,time_pos); %sharpgray; %grayim;
figure, imshow(cIM), hold all       
initPos = [];
thresVal = 0.10; %(max(cIM,[],'all')-min(cIM,[],'all'))*(0.05);
maxDist = 100;
tfMean = 'false';
tfFillHoles = 'true';
tfSimplify = 'true';

[P, J(:,:,z_pos,time_pos)] = regionGrowing(cIM, initPos, thresVal, maxDist, tfMean, tfFillHoles, tfSimplify);
%[P, J] = regionGrowing(cIM, initPos, thresVal, maxDist, tfMean, tfFillHoles, tfSimplify);
hold on;
plot(P(:,1), P(:,2), 'LineWidth', 2)
save('J.mat','J');


% for time_pos=1:20
%     for z_pos=3:i_zval-2
%         imshow(J(:,:,z_pos,time_pos))
%         %pause(1)
%     end
% end


%file:///C:/Users/ahmet/Downloads/Documents/MatlabImage_Class12_CFLu.pdf

% figure
% for i=1:20
%     [F,V] = isosurface(J(:,:,:,i),0);
% 
%     %patch('Faces',F,'Vertices',V)
% 
%     patch('Faces',F,'Vertices',V,'FaceColor',[0.94 0.16 0.261])
%     lighting gouraud
%     camlight(0,0)
%     %axis equal
%     view(-155,50)
%     pause(0.5);
%     clf;
% end





