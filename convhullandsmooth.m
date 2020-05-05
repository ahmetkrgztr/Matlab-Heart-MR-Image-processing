close all
%Ground truth contour oluþturma ve içini doldurma
load('manual_seg_32points_pat7.mat');
segs = manual_seg_32points;
newsegs = segs;
ground=zeros(256,256,13,20);

for t=1:20
    for z=1:13
        
        if(segs{z,t}~=-99999)
            newsegs{z,t}(33,1)=segs{z,t}(1,1);
            newsegs{z,t}(33,2)=segs{z,t}(1,2);
            ground(:,:,z,t)=poly2mask(newsegs{z,t}(1:33,1), newsegs{z,t}(1:33,2),256,256);
            %hold on;
            %fill(newsegs{z,t}(1:33,1), newsegs{z,t}(1:33,2),'w');
            imshow(ground(:,:,z,t))
            pause(1);
            %close all;
        end
    end
end

%  Ground  truth için  marching cube
for t=1:20        
    [x,y,z] = meshgrid(1:256,1:256,1:13);
    %data = sqrt(x.^2 + y.^2 + z.^2);
    %cdata = smooth3(rand(size(data)),'box',7);
    [F,V] = MarchingCubes(x,y,z,ground(:,:,:,t),0.2);
    figure('color',[1 1 1])
    patch('vertices',V,'faces',F,'edgecolor','none',...
        'facecolor',[1 0 0],'facelighting','phong')
    camlight(0,0)
    %light
    view(-170,20)
    axis off %axisequal
    %lighting gouraud
    set(gca,'zdir','reverse')
    pause(1);
    %clf;
    close all;
end



load('J.mat');
A=J;
bwcon=zeros(256,256,13,20);
img=zeros(256,256,13,20);


%Convex hull for our data
for time=1:20
    for z=1:13
        A1=squeeze(A(:,:,:,time));
        bwcon(:,:,z,time)=bwconvhull(A1(:,:,z));
        %imshow(bwcon(:,:,z,time))
        
    end
    %img(:,:,:,time)=smooth3(bwcon(:,:,:,time),'box',3);
end

%cropping out of ground truth
bwcon2=bwcon;
for time=1:20
    for z=1:13
        for i=1:256
            for j=1:256
                if bwcon2(i,j,z,time)==1 && ground(i,j,z,time)==0
                    bwcon2(i,j,z,time)=0;
                end
                    
            end
        end
        
    end
    %img(:,:,:,time)=smooth3(bwcon(:,:,:,time),'box',3);
end


%Marching cube process for our data
for t=1:20        
    [x,y,z] = meshgrid(1:256,1:256,1:13);
    %data = sqrt(x.^2 + y.^2 + z.^2);
    %cdata = smooth3(rand(size(data)),'box',7);
    [F,V] = MarchingCubes(x,y,z,bwcon(:,:,:,t),0.2);
    figure('color',[1 1 1])
    patch('vertices',V,'faces',F,'edgecolor','none',...
        'facecolor',[1 0 0],'facelighting','phong')
    
    
    camlight(0,0)
    light
    view(-170,20)
    axis off %axisequal
    %lighting gouraud
    set(gca,'zdir','reverse')
    pause(1);
    %clf;
    close all;
end

%marchin cube for croped images
for t=1:20        
    [x,y,z] = meshgrid(1:256,1:256,1:13);
    %data = sqrt(x.^2 + y.^2 + z.^2);
    %cdata = smooth3(rand(size(data)),'box',7);
    [F,V] = MarchingCubes(x,y,z,bwcon2(:,:,:,t),0.2);
    figure('color',[1 1 1])
    patch('vertices',V,'faces',F,'edgecolor','none',...
        'facecolor',[1 0 0],'facelighting','phong')
    
    
    camlight(0,0)
    %light
    view(-170,20)
    axis off %axisequal
    %lighting gouraud
    set(gca,'zdir','reverse')
    pause(1);
    %clf;
    close all;
end

% for time=3:12
%     for z=3:12
%         subplot(3,1,1);
%         imshow(A(:,:,z,time))
%         title('Subplot 1: Segmented Image')
% 
%         subplot(3,1,2);
%         imshow(bwcon(:,:,z,time))
%         title('Subplot 2: Convex Hull')
% 
%         subplot(3,1,3);
%         imshow(img(:,:,z,time))
%         title('Subplot 3: Convex Hull and Smoothing')
%         
%         pause(0.2);  
%     end
% end


% figure('WindowState','FullScreen','color',[1 1 1],'MenuBar','none');
% for i=1:20
%     [F,V] = isosurface(bwcon(:,:,:,i),0);
% 
%     patch('Faces',F,'Vertices',V)
% 
%     patch('Faces',F,'Vertices',V,'FaceColor',[0.94 0.16 0.261])
%     lighting gouraud
%     camlight(0,0)
%     axis off
%     view(-170,20)
%     set(gca,'zdir','reverse')
%     pause;
%     clf;
% end


%Marching cube Preparetion
% [ay,ax,az,at]=size(A);
% lastim = zeros(256,256,13,20);
% for t=1:1
%     for z=1:az
%         lastim(:,:,13-z+1,t)=bwcon(:,:,z,t);
%     end
% end





%image = reshape(image,[256,256,20]);
% for t=1:1
%     for z=1:256
%         imshow(mat2gray(image(:,:,z)))
%         clf;
%     end
% end




%ground truth segmentasyon yapma
% ground=zeros(256,256,13,20);
% for t=1:20
%     for z=4:11
%         figure
%         imshow(ground(:,:,z,t))
%         hold on;
%         plot(newsegs{z,t}(1:33,1), newsegs{z,t}(1:33,2), 'LineWidth', 2)
%         Frame = getframe(gcf);
%         FrameData = Frame.cdata;
%         ground(:,:,z,t) = rgb2gray(FrameData);
%         close all;
%         
%     end
% end

% for t=1:20
% 
%         
%     [Fgro,Vgro] = MarchingCubes(x,y,z,ground(:,:,:,t),0.2);
%     [F,V] = MarchingCubes(x,y,z,bwcon(:,:,:,t),0.2);
% 
%     [iV,iF] = reducepatch(size(V,1),size(F,1),size(Fgro,1));
%     figure('color',[1 1 1])
%     patch('vertices',iV,'faces',iF,'edgecolor','none',...
%     'facecolor',[1 0 0],'facelighting','phong')
% 
% 
%     camlight(0,0)
%     %light
%     view(-170,20)
%     axis off %axisequal
%        
%         
% end

%Intersection over union
sumintersects=zeros(13,20);
sumoutside=zeros(13,20);
intersectratio=zeros(13,20);
for t=1:20
    for z = 4:11
        for i=1:256
            for j=1:256
                if bwcon(i,j,z,t) == 1 && ground(i,j,z,t)
                    sumintersects(z,t) = sumintersects(z,t) + 1;
                elseif bwcon(i,j,z,t)-ground(i,j,z,t)==1 || bwcon(i,j,z,t)-ground(i,j,z,t)==-1
                    sumoutside(z,t)=sumoutside(z,t)+1;
                end
            end
        end
        intersectratio(z,t)=sumintersects(z,t)/(sumintersects(z,t)+sumoutside(z,t));
    end
end


overallratio=sum(sum(intersectratio(4:11,:)))/(8*t);

                    
                
        






