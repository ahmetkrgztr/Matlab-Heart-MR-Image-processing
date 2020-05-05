close all

load('manual_seg_32points_pat7.mat');
load('sol_yxzt_pat7.mat');

segs = manual_seg_32points;
images = sol_yxzt;

%volumeViewer(images(:,:,:,13))


%max_intensity = 500;

[s_zval, s_tval] = size(segs);
[i_yval, i_xval, i_zval, i_tval] = size(images);

for z_pos=4:11
    for time_pos=10
        picture = reshape(images(:,:,z_pos,time_pos),256,256);
        grayimage(:,:,z_pos,time_pos) = mat2gray(picture);
        sharpimage(:,:,z_pos,time_pos) = imsharpen(grayimage(:,:,z_pos,time_pos),'Radius',2,'Amount',1);
        %cropimage(:,:,z_pos,time_pos)=sharpimage(99:191,48:140,z_pos,time_pos);
        cropdouble=sharpimage;
        cropdouble(99:191,48:140,z_pos,time_pos)=cropdouble(99:191,48:140,z_pos,time_pos)*2;
        %cropdoubleim=cropdouble(:,:,z_pos,time_pos);
        cropdouble2(:,:,z_pos,time_pos) = cropdouble(:,:,z_pos,time_pos)-sharpimage(:,:,z_pos,time_pos); 
        %cropdouble2(:,:,z_pos,time_pos) = (imsharpen(cropdouble2(:,:,z_pos,time_pos))-grayim)*2 + grayim;
        
        cropdoubleim2=cropdouble2(:,:,z_pos,time_pos);
        grayim=grayimage(:,:,z_pos,time_pos);
        sharpim=sharpimage(:,:,z_pos,time_pos);
        
        grayimage(:,:,z_pos,time_pos)=(sharpimage(:,:,z_pos,time_pos)-grayimage(:,:,z_pos,time_pos))*2 + grayimage(:,:,z_pos,time_pos);
        rgim=grayimage(:,:,z_pos,time_pos);
        imshow(rgim)
        pause(0.3);
        
        cIM = rgim; %sharpgray; %grayim;
        figure, imshow(cIM), hold all       
        initPos = [];
        thresVal = 0.15; %(max(cIM,[],'all')-min(cIM,[],'all'))*(0.05);
        maxDist = 500;
        tfMean = 'false';
        tfFillHoles = 'true';
        tfSimplify = 'true';

        [P, J(:,:,z_pos,time_pos)] = regionGrowing(cIM, initPos, thresVal, maxDist, tfMean, tfFillHoles, tfSimplify);
        hold on;
        plot(P(:,1), P(:,2), 'LineWidth', 2)
        
        z_pos;
        pause(5);
        close all
        save('J.mat','J');
        
    end
    
    
end











