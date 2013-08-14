function [BlobDetectorall,BlobDetectorremoved]=blobdetector(image_file_name,Parameters);

% This file is part of the Blob detection Toolbox - Copyright (C) 2009
% by Mohammad Jahangiri and Imperial College London.

Input_image=imread(image_file_name,'jpg');
im=double(Input_image);
[M,N,S]=size(im);
alpha=1;
if max(M,N)>400
    im=imresize(im,400/max(M,N),'bicubic');
    alpha=400/max(M,N);
end
imresized=im;
if strcmp(Parameters.Toboggan,'enable')
%     tic
%      imtobo=Color_Tobogann_3D(im,3);
%      figure
%      imshow(uint8(imtobo))
%     toc       
    tic
    imwrite(uint8(im),'.\Tempimage.bmp');
    dos('Toboc ".\Tempimage.bmp"');
    imtobo=imread('Toboggan.bmp');
    %figure
    %imshow(imtobo);
    imtobo=double(imtobo);    
    toc 
end

% Constructing the interest map
%imtobo=im;
MAP=MAPBUILDING3(imtobo,1,7);
[XX,YY,ZZ]=size(imtobo);
CMAP=MAP(10:XX-10,10:YY-10);
imnew=im;
[XXNEW,YYNEW]=size(CMAP);


if strcmp(Parameters.Thresholding,'global')
    MODE='PCNN';
    Binary_map=KNEETHRESH(CMAP,Parameters,MODE);
else
    T=ADAPTIVE_THRESH(CMAP);
    Binary_map=CMAP>T;
end

[ACCEPTEDMOD1,ACCEPTEDMOD2,ACCEPTEDMOD3]=ExtractingBlobs(imnew,Binary_map);
Polygons=[ACCEPTEDMOD1,ACCEPTEDMOD2,ACCEPTEDMOD3];
%BlobDetector.Blobdetection.Date=DATE;
countpoly=0;
for ii=1:max(size(Polygons))
    s=max(size(Polygons{1,ii}));
    if min(size(Polygons{1,ii}))>0
        countpoly=countpoly+1;
        for j=1:s
            BlobDetectorall.Blobdetection.object(countpoly).polygon.pt(j).x=(1/alpha)*(Polygons{ii}(j,1)+9);
            BlobDetectorall.Blobdetection.object(countpoly).polygon.pt(j).y=(1/alpha)*(Polygons{ii}(j,2)+9);
        end
    end
end
% If No Blobs were found
if countpoly==0
    BlobDetectorall.Blobdetection.object(1).polygon.pt(1).x=-10000;
    BlobDetectorall.Blobdetection.object(1).polygon.pt(1).y=-10000;
end


%*************Test with and without removing********************************

%**************************** Removing Overlapping Regions *****************
%[MODEAREA,MODEAREA2,OUT,MODE]=SHOWING(Binary_map,Polygons,imnew,CMAP);
[LLEN,WWID]=size(CMAP);
[XXLEN,YYLEN]=meshgrid([1:WWID],[1:LLEN]);
COUNTTEMP=0;
for i=1:max(size(Polygons))
    if max(size(Polygons{i}))>0        
        clear DETECTED
        in=inpolygon(XXLEN(:),YYLEN(:),Polygons{i}(:,1),Polygons{i}(:,2));
        DETECTED=reshape(in,LLEN,WWID);
        PixelsBlob{i}=find(DETECTED==1);
        fff=bwlabel(DETECTED);
        hhh=regionprops(fff,'BoundingBox');
        XMIN=hhh(1).BoundingBox(1);
        XMAX=hhh(1).BoundingBox(1)+hhh(1).BoundingBox(3);
        YMIN=hhh(1).BoundingBox(2);
        YMAX=hhh(1).BoundingBox(2)+hhh(1).BoundingBox(4);
        vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
        PixelsCenter{i}=[mean(vertices2');-1 -1];
        PixelsSimilarity{i}=-1;
        vertices2=vertices2';
        in2=inpolygon(XXLEN(:),YYLEN(:),vertices2(:,1),vertices2(:,2));
        DETECTED2=reshape(in2,LLEN,WWID);
        PixelsBounding{i}=find(DETECTED2==1);        
    end
    if min(size(Polygons{max(size(Polygons))}))==0
        PixelsBlob{max(size(Polygons))}=[];
        PixelsBounding{max(size(Polygons))}=[];
        PixelsCenter{max(size(Polygons))}=[];
        PixelsSimilarity{max(size(Polygons))}=[];
    end
end

% Without merging
%Polygonsnew=REMOVEREGIONS2(Binary_map,Polygons,PixelsBlob,PixelsBounding,im,CMAP);

% With merging if the prominency increases
%[Polygonsnew,PixelsBlob,PixelsBounding]=REMOVEREGIONS22(Binary_map,Polygons,PixelsBlob,PixelsBounding,imnew,CMAP); 

% With Merging if at least two regions overlap
[Polygonsnew,PixelsBlob,PixelsBounding]=REMOVEREGIONS(Binary_map,Polygons,PixelsBlob,PixelsBounding,imnew,CMAP); 
%BlobDetector.Blobdetection.Date=DATE;
countpoly=0;
for ii=1:max(size(Polygonsnew))
    s=max(size(Polygonsnew{1,ii}));
    if min(size(Polygonsnew{1,ii}))>0
        countpoly=countpoly+1;
        for j=1:s
            BlobDetectorremoved.Blobdetection.object(countpoly).polygon.pt(j).x=(1/alpha)*(Polygonsnew{ii}(j,1)+9);
            BlobDetectorremoved.Blobdetection.object(countpoly).polygon.pt(j).y=(1/alpha)*(Polygonsnew{ii}(j,2)+9);
        end
    end
end

% If No Blobs were found
if countpoly==0
    BlobDetectorremoved.Blobdetection.object(1).polygon.pt(1).x=-10000;
    BlobDetectorremoved.Blobdetection.object(1).polygon.pt(1).y=-10000;
end


%FilterRegions1(Binary_map,Polygons,imnew,Conf,Mask,s,h1,h2,h3,h4);
