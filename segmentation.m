function [ X ] = segmentation(depthImage, directory)
	close all;
	clc;

	%//=======================================================================
	%// Load Images
	%//=======================================================================
	depthImage
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
	%figure, imshow(labels,[]);

	%//=======================================================================
	%// Create Depth Table
	%//=======================================================================
	depthTable = single(zeros(2048, 1));
	for i = 1:2048
		depthTable(i) = 0.1236 * tan(i/2842.5 + 1.1863);
	end
	
	%//=======================================================================
	%// Find average pixel intensity for each region
	%//=======================================================================
	regions = single(zeros(nC, 1));	
	meterToCentimetersRatio = 100;
	neighbours = zeros(nC, nC);	
	
	for i=1:(nC)
		regionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			regionSum = uint64(im_d(region_idx(j))) + regionSum;
		end
		regionSum;
		
		if regionSum ~=0
			regions(i, 1) = depthTable(regionSum/length(region_idx))*meterToCentimetersRatio;
		else
			regions(i, 1) = 0;
		end
	end

	%//=======================================================================
	%// Find neighbours
	%//=======================================================================

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
	%// Find Lowest Regions
	%//=======================================================================

	holes = zeros(size(labels));
	count = 0;
	depthThreshold = 150; %-- in cm
	holeList =[];
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
			if closestNeighbour > depthThreshold
				count = count + 1;
				holeList(count, 1) = i;
				tempImage = labels == i;
				holes = holes | tempImage;		
			end
		end	
	end

	%figure, imshow(holes);



	%//=======================================================================
	%// Find Difference of Candidate Region Area and Boundary Box Area
	%//=======================================================================
	bbAreaLessHoleArea=[];
	boundingBoxArea=[];
	for i = 1:length(holeList)	
		[rows cols] = ind2sub(size(labels), find(labels==holeList(i)));
		boundingBoxArea(i,1) = (max(rows)-min(rows))*(max(cols)-min(cols));
		bbAreaLessHoleArea(i,1)= boundingBoxArea(i,1) - length(find(labels==holeList(i)));
	end

	%//=======================================================================
	%// Find Ratio of Region Area to Perimeter
	%//=======================================================================
	perimAreaRatio=[];
	for i = 1:length(holeList)	
		perim = length(find(bwperim(labels==holeList(i))>0));
		perimAreaRatio(i,1)=perim/length(find(labels==holeList(i)));
	end

	%//=======================================================================
	%// Find Minimum Width/Height
	%//=======================================================================
	minHoleDistance=[];
	for i = 1:length(holeList)	
		[rows cols] = ind2sub(size(labels), find(labels==holeList(i)));
		holeWidth = (max(rows)-min(rows));
		holeHeight = (max(cols)-min(cols));
		minHoleDistance(i,1)= min(holeWidth, holeHeight);
	end


	%//=======================================================================
	%// Display
	%//=======================================================================
	outputDirectory = strcat(directory, 'output/output_');
	
	%Number of Super Pixels
	outputDirectory = strcat(outputDirectory, num2str(nC) );
	outputDirectory = strcat(outputDirectory, '_');
	
	%Hole Depth Threshold
	outputDirectory = strcat(outputDirectory, num2str(depthThreshold));
	outputDirectory = strcat(outputDirectory, '_');
	
	%Bounding Box
	boundingBoxThresh = 50;  %--percent of bounding box area region must fill
	outputDirectory = strcat(outputDirectory, num2str(boundingBoxThresh));
	outputDirectory = strcat(outputDirectory, '_');
	
	%Min Hole Width
	minHoleThresh = 100;
	outputDirectory = strcat(outputDirectory, num2str(minHoleThresh));
	outputDirectory = strcat(outputDirectory, '_');
		
	perimAreaThresh = 0.2;
	
	%figure, imshow(holes), colormap(gray), axis off, hold on
	for i = 1:length(holeList)	
		if (bbAreaLessHoleArea(i,1) < (boundingBoxArea(i,1) * (boundingBoxThresh/100))) & (minHoleDistance(i,1) > minHoleThresh)
	%		[rows cols] = ind2sub(size(labels), find(labels==holeList(i)));
	%		rectangle('Position',[min(cols) min(rows)  (max(cols)-min(cols)) (max(rows)-min(rows)) ], 'LineWidth',1, 'EdgeColor','g');
			M{1, 1} = depthImage;
			M{1, 2} = holeList(i);
			dlmcell(strcat(outputDirectory, '.csv'), M, ',', '-a');
		end
	end
	%f=getframe(gca);
	%[X, map] = frame2im(f);
	%imwrite(X, strcat(outputDirectory, depthImage));
	%hold off;

end






