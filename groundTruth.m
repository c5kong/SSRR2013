function [ X ] = groundTruth(depthImage, directory, nC)
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
	%// Output File Name
	%//=======================================================================
	filename = strcat(num2str(nC), '_test.csv');

	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	
	lambda_prime = 0.5;
	sigma = 5.0; 
	conn8 = 1; % flag for using 8 connected grid graph (default setting).

	[labels] = mex_ers(double(img),nC);%// Call the mex function for superpixel segmentation
	labels(labels == 0) = nC; %-- Normalize regions to matlab convention of 1:nC instead of 0:nC-1
	%figure, imshow(labels,[]);

	%//=======================================================================
	%// Find Region
	%//=======================================================================
	figure, imshow(labels, []), colormap(gray), axis off, hold on;
	[x y b] = ginput(2);

	minX = 9999;
	minY = 9999;
	maxX = 0;
	maxY = 0;	
	
	for k=1:length(b)
	
		if b(k,1) == 1
			t = sub2ind(size(labels), y(k,1), x(k,1));

			for i=1:(nC)
				region = find(labels == i);
				for j=1:length(region)
					if region(j, 1) == t	
						%FIND MIN AND MAX
						[rows cols] = ind2sub(size(img), region);
						minX;
						min(cols);
						if min(cols) < minX
							minX = min(cols);
						end
						
						if min(rows) < minY
							minY = min(rows);
						end
						
						if max(cols) > maxX
							maxX = max(cols);
						end
						
						if max(rows) > maxY
							maxY = max(rows);
						end

					end
				end
			end
		end	
		
	end
	 M{1, 1} = depthImage;
	 M{1, 2} = minX;
	 M{1, 3} = minY;
	 M{1, 4} = (maxX-minX);
	 M{1, 5} = (maxY-minY);	
	dlmcell(filename, M, ',', '-a');
	rectangle('Position',[minX minY  (maxX-minX) (maxY-minY) ], 'LineWidth', 4, 'EdgeColor','r');
	hold off;

	clear all;
end