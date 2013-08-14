close all;
clear all;
clc;

%//=======================================================================
%// Input Images
%//=======================================================================
%depthImage = '69_d.png';
depthImage = '463_d.png';
%depthImage = '786_d.png';
%depthImage = '2223_d.png';
%depthImage = '2535_d.png';
%depthImage = '3918_d.png';


%//=======================================================================
%// Load Images
%//=======================================================================
directory = 'images/';
im_d = imread(strcat(directory, depthImage));
img = im_d;
grey_img = img;

%//=======================================================================
%// Superpixel segmentation
%//=======================================================================
nC = 15; % nC is the target number of superpixels.
lambda_prime = 0.5;
sigma = 5.0; 
conn8 = 1; % flag for using 8 connected grid graph (default setting).

[labels] = mex_ers(double(img),nC);%// Call the mex function for superpixel segmentation\
figure, imshow(labels,[]);

%//=======================================================================
%// Find average pixel intensity for each region
%//=======================================================================
regions = uint64(zeros(nC, 1));
for i=1:(nC)
    region_idx = find(labels==i);
	for j=1:length(region_idx)
		regions(i, 1) = uint64(im_d(ind2sub(size(labels), region_idx(j)))) + regions(i, 1);		
	end
	regions(i, 1) = regions(i, 1)/length(region_idx);
	if regions(i,1) > 2000
		regions(i, 1) = 0;
	end
end

%//=======================================================================
%// Find neighbours
%//=======================================================================
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

%//=======================================================================
%//  Visualize Neighbourhood
%//=======================================================================
regionToVisualize = 7;
nImage = zeros(size(labels));
for i=1:nC    
	for j=1:nC
		if i == 15
			if neighbours(i,j) == regionToVisualize
				image1 = labels == j;
				nImage = nImage | image1;
			end	
		end		
	end		
end
%figure, imshow(nImage);

%//=======================================================================
%// Find Lowest Regions
%//=======================================================================
threshold = 50;
holes = zeros(size(labels));
count = 0;
 
for i=1:nC
	flag = 0; %-- set to false
	closestNeighbour = regions(i);
	numNeighbours = 0;
	for j=1:nC
	
		if neighbours(i, j) == 1 
			if (regions(i) > regions(j)) 
				flag = 1; 					
				numNeighbours = numNeighbours + 1;
				if closestNeighbour > regions(i)-regions(j);
					closestNeighbour = regions(i)-regions(j);
				end
			else
				flag = 0; 
				break;
			end			
		end		
	end
	
		
	if flag == 1			
		if closestNeighbour > threshold
			count = count + 1;
			tempImage = labels == i;
			holes = holes | tempImage;		
		end
	end	
end
figure, imshow(holes);


%//=======================================================================
%// Create Depth Table
%//=======================================================================
depthTable = single(zeros(2048, 1));
for i = 1:2048
	depthTable(i) = 0.1236 * tan(i/2842.5 + 1.1863);
end


%//=======================================================================
%// Find Dimensions of hole
%//=======================================================================









