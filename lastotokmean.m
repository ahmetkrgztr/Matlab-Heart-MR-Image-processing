clc;
clear;
close all;

load('manual_seg_32points_pat7.mat');
load('sol_yxzt_pat7.mat');
segs = manual_seg_32points;
images = sol_yxzt;

%max_intensity = 500;
%[s_zval, s_tval] = size(segs);
[i_yval, i_xval, i_zval, i_tval] = size(images);

for z_pos=1:i_zval
    for time_pos=1:20
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
        temp = segs{z_pos,time_pos};
        [sx,sy] = size(temp);

        %if(temp(1,1)~=-99999)
            %half=(sx-1)/2;
            
            %k means
            [lb,center] = adaptcluster_kmeans(cropdoubleim2);
            [a,center_num]=size(center);
            for cent=1:center_num
                X=0;
                Y=0;
                val=0;
                count=0;
                for i=1:256
                    for j=1:256
                        if lb(i,j)==cent
                            X=X+i;
                            Y=Y+j;
                            count=count+1;
                            val=val+cropdoubleim2(i,j);
                            %pause(0);
                        end
                    end
                end

                %centers
                coorX(cent)=uint8(X/count);
                coorY(cent)=uint8(Y/count);
                vals(cent)=val;
                counts(cent)=count;
            end
            %x is seed points for region growing
            max_num=max(vals);
            [cx]=find(vals==max_num);
            if double(coorY(cx))>85 
                coorY(cx) = randi([77 82],1);
            end
            if double(coorX(cx))<146 
                coorX(cx) = randi([149 153],1);
            end
            %region growing
            cIM = rgim; %sharpgray; %grayim;
            figure, imshow(cIM), hold all       
            initPos = [double(coorX(1,cx)),double(coorY(1,cx))];
            thresVal = 0.18; %(max(cIM,[],'all')-min(cIM,[],'all'))*(0.05);
            maxDist = 500;
            tfMean = 'false';
            tfFillHoles = 'true';
            tfSimplify = 'true';

            [P, J] = regionGrowing(cIM, initPos, thresVal, maxDist, tfMean, tfFillHoles, tfSimplify);
            hold on;
            plot(P(:,1), P(:,2), 'LineWidth', 2)
            pause(5);
            
            close all;
            
       % end
    end
end




