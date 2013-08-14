close all;clear all;clc

im_rgb = im2double(imread('463_rgb.png'));
im_gray = rgb2gray(im_rgb);
im_d = imread('463_d.png');


%img = imread('242078.jpg');
img = im_d;

%// Our implementation can take both color and grey scale images.
%grey_img = double(rgb2gray(im_rgb));
grey_img = im_d;

%%
%//=======================================================================
%// Superpixel segmentation
%//=======================================================================
%// nC is the target number of superpixels.
nC = 15;
%// Call the mex function for superpixel segmentation\
%// !!! Note that the output label starts from 0 to nC-1.
t = cputime;

lambda_prime = 0.5;sigma = 5.0; 
conn8 = 1; % flag for using 8 connected grid graph (default setting).

[labels] = mex_ers(double(img),nC);
%//=======================================================================
%// Output
%//=======================================================================
[height width] = size(grey_img);

%// Compute the boundary map and superimpose it on the input image in the
%// green channel.
%// The seg2bmap function is directly duplicated from the Berkeley
%// Segmentation dataset which can be accessed via
%// http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/
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

%// Compute the superpixel size histogram.
siz = zeros(nC,1);
for i=0:(nC-1)
    siz(i+1) = sum( labels(:)==i );
end
[his bins] = hist( siz, 20 );

scaleFactor = .25;
edge_detector = 'canny';
[~, threshold] = edge(labels, edge_detector);
depth_edges = edge(labels, edge_detector, threshold * scaleFactor);


figure, imshow(labels,[]);
%figure, imshow(depth_edges,[]);

%depth_overlay = im_d;
%depth_overlay = labels;
%depth_overlay(depth_edge) = 255;
%figure, imshow(depth_overlay, []);

%gray_overlay = imoverlay(im_gray, depth_edges, [.1 1 .1]);
%figure, imshow(gray_overlay);


%%
%//=======================================================================
%// Display 
%//=======================================================================
%gcf = figure(1);
%subplot(2,3,1);
%imshow(img,[]);
%title('input image.');
%subplot(2,3,2);
%figure, imshow(bmapOnImg,[]);
%title('superpixel boundary map');
%subplot(2,3,3);
%-- figure, imshow(labels,[]);
%figure, imshow(out,[]);
%title('randomly-colored superpixels');
%subplot(2,3,5);
figure, bar(bins,his,'b');
%title('the distribution of superpixel size');
%ylabel('# of superpixels');
%xlabel('superpixel sizes in pixel');
%scnsize = get(0,'ScreenSize');
%set(gcf,'OuterPosition',scnsize);