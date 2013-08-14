function [ X ] = segmentation(frameNumber, baseDirectory, nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh)
	close all;
	clc;

	depthScore =[];
	widthScore =[];
	bbScore =[];
	contrastScore =[];
	detectionScore=[];
	
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	frameNumber		
	depthDirectory = strcat(baseDirectory, 'depth/');
	rgbDirectory = strcat(baseDirectory, 'rgb/');
	depthImage = strcat(frameNumber, '_d.png');
	rgbImage = strcat(frameNumber, '_rgb.png');
	img = imread(strcat(depthDirectory, depthImage));
	gray_img = rgb2gray(imread(strcat(rgbDirectory, rgbImage)));

	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	
	lambda_prime = 0.5;
	sigma = 5.0; 
	conn8 = 1; % flag for using 8 connected grid graph (default setting).

	[labels] = mex_ers(double(img),nC);%-- Call the mex function for superpixel segmentation\
	labels(labels == 0) = nC; %-- Normalize regions to matlab convention of 1:nC instead of 0:nC-1
	%figure, imshow(labels,[]);

	%//=======================================================================
	%// Create Depth Table
	%//=======================================================================
	depthTable = single(zeros(2048, 1));
	for i = 1:2048
		depthTable(i) = 0.1236 * tan(i/2842.5 + 1.1863);
	end
	
	%//=======================================================================
	%// Find average pixel intensity for each region and save Distance in cm
	%//=======================================================================
	regions = single(zeros(nC, 1));	
	meterToCentimetersRatio = 100;
	neighbours = zeros(nC, nC);	
	
	for i=1:(nC)
		regionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			regionSum = uint64(img(region_idx(j))) + regionSum;
		end
		
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

	holes = zeros(size(img));
	count = 0;	
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
			if closestNeighbour > 25		
				count = count + 1;
				holeList(count, 1) = i;
				tempImage = labels == i;
				holes = holes | tempImage;		
				
				if closestNeighbour > 200
					depthScore(i,1) = 0.25;
				elseif closestNeighbour > 150
					depthScore(i,1) = 0.2;
				elseif closestNeighbour > 100
					depthScore(i,1) = 0.15;
				elseif closestNeighbour > 50
					depthScore(i,1) = 0.10;
				else
					depthScore(i,1) = 0.05;					
				end								
			end
		end	
	end

	%figure, imshow(holes);

	%//=======================================================================
	%// Find Grayscale Contrast Value for Low Regions
	%//=======================================================================
	%figure, imshow(gray_img, []);
	rbgRegionContrast=[];
	for i = 1:length(holeList)
		rgbRegionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			rgbRegionSum = uint64(gray_img(region_idx(j))) + rgbRegionSum;
		end
		rbgRegionContrast(i,1) = rgbRegionSum/length(region_idx);	
	end
	

	%//=======================================================================
	%// Find Difference of Candidate Region Area and Boundary Box Area
	%//=======================================================================
	bbAreaLessHoleArea=[];
	boundingBoxArea=[];
	for i = 1:length(holeList)	
		[rows cols] = ind2sub(size(img), find(labels==holeList(i)));
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
		[rows cols] = ind2sub(size(img), find(labels==holeList(i)));
		holeWidth = (max(rows)-min(rows));
		holeHeight = (max(cols)-min(cols));
		minHoleDistance(i,1)= min(holeWidth, holeHeight);
	end

	
	%//=======================================================================
	%// Calculate Detection Scores
	%//=======================================================================
	for i = 1:length(holeList)
		if minHoleDistance(i,1) > 125
			widthScore(i,1) = 0.25;
		elseif minHoleDistance(i,1) > 100
			widthScore(i,1) = 0.2; 
		elseif minHoleDistance(i,1) > 75
			widthScore(i,1) = 0.15; 
		elseif minHoleDistance(i,1) > 50
			widthScore(i,1) = 0.1; 
		else
			widthScore(i,1) = 0.05; 
		end
		
		if (bbAreaLessHoleArea(i,1) < (boundingBoxArea(i,1) * 0.55))
			bbScore(i,1) = 0.05;
		elseif (bbAreaLessHoleArea(i,1) < (boundingBoxArea(i,1) * 0.50))
			bbScore(i,1) = 0.10;
		elseif (bbAreaLessHoleArea(i,1) < (boundingBoxArea(i,1) * 0.45))
			bbScore(i,1) = 0.15;
		elseif (bbAreaLessHoleArea(i,1) < (boundingBoxArea(i,1) * 0.40))
			bbScore(i,1) = 0.20;
		else
			bbScore(i,1) = 0.25;
		end
		
		if (rbgRegionContrast(i,1) < 300)
			contrastScore(i,1) = 0.25;
		elseif (rbgRegionContrast(i,1) < rbgRegionContrastThresh)
			contrastScore(i,1) = 0.2;
		elseif (rbgRegionContrast(i,1) < rbgRegionContrastThresh)
			contrastScore(i,1) = 0.15;
		elseif (rbgRegionContrast(i,1) < rbgRegionContrastThresh)
			contrastScore(i,1) = 0.10;
		else
			contrastScore(i,1) = 0.05;
		end
		
		detectionScore(i,1) = depthScore(i,1) + widthScore(i,1) + bbScore(i,1) + contrastScore(i,1));
	end

	
	
	%//=======================================================================
	%// Display
	%//=======================================================================
	
	figure, imshow(holes), colormap(gray), axis off, hold on
	for i = 1:length(detectionScore)	
		if detectionScore > 0
		
			[rows cols] = ind2sub(size(img), find(labels==holeList(i)));
			rectangle('Position',[min(cols) min(rows)  (max(cols)-min(cols)) (max(rows)-min(rows)) ], 'LineWidth', 4, 'EdgeColor','g');
			M{1, 1} = depthImage;
			M{1, 2} = min(cols);
			M{1, 3} = min(rows);
			M{1, 4} = (max(cols)-min(cols));	
			M{1, 5} = detectionScore;	
			%dlmcell(strcat(baseDirectory, 'output/output.csv'), M, ',', '-a');
		end
	end
	f=getframe(gca);
	[X, map] = frame2im(f);
	%imwrite(X, strcat(outputDirectory, depthImage));
	hold off;


end






