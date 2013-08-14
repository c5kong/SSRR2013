close all;clear all;clc

%//=======================================================================
%// Input Images
%//=======================================================================
im = rgb2gray(im2double(imread('463_rgb.png')));
im_d = imread('463_d.png');

%img = im;
img = im_d;
grey_img = img;


%//=======================================================================
%// Superpixel segmentation
%//=======================================================================

nC = 15; % nC is the target number of superpixels.
%// Call the mex function for superpixel segmentation\
%// !!! Note that the output label starts from 0 to nC-1.
lambda_prime = 0.5;
sigma = 5.0; 
conn8 = 1; % flag for using 8 connected grid graph (default setting).

[labels] = mex_ers(double(img),nC);
figure, imshow(labels,[]);


%//=======================================================================
%// Output
%//=======================================================================
[height width] = size(grey_img);

%// Compute the boundary map and superimpose it on the input image in the green channel.
[bmap] = seg2bmap(labels,width,height);
bmapOnImg = img;
idx = find(bmap>0);
timg = grey_img;
timg(idx) = 255;
bmapOnImg(:,:,2) = timg;
bmapOnImg(:,:,1) = grey_img;
bmapOnImg(:,:,3) = grey_img;

%// Randomly color the superpixels
[out] = random_color( double(img) ,labels,nC);


%//=======================================================================
%// Find average pixel intensity for each region
%//=======================================================================
tic
regions = uint16(zeros(nC, 1));
for i=0:(nC-1)
    region_idx = find(labels==i);
	for j=1:length(region_idx)
		regions(i+1, 1) = im_d(ind2sub(size(labels), region_idx(j))) + (regions(i+1, 1)/length(region_idx));		
	end
end
toc


%//=======================================================================
%// Find neighbours
%//=======================================================================
tic
neighbours = zeros(nC, nC);
for i=1:nC    
	for j=1:nC
		image1 = labels == i;
		image2 =  labels == j;
		image3 = image1 | image2;
		[ L num ]  = bwlabel(image3);
		if i==j
			neighbours(i, j) = 0;
		elseif num == 1
			neighbours(i, j) = 1;
		end
	end
end
toc


