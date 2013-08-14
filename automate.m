function X = automate()
	
	tic
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  # superPixels
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%nC = 9; % nC is the target number of superpixels.
	depthThreshold = 20; %--min depth from surrounding region in cm
	boundingBoxThresh = 55;  %--percent of bounding box area region must fill
	minHoleThresh = 100;  %--width in pixels
	rbgRegionContrastThresh = 1500;  %--in pixel intensity

	nC = 3;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 4;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 5;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 6;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	nC = 7;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	nC = 8;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 9;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	nC = 10;
	callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 11;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);	
	
	nC = 12;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 13;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);	
	
	nC = 14;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 15;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);	
	
	nC = 16;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	nC = 20;
	callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Depth Threshold
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	nC = 9; % nC is the target number of superpixels.
	%depthThreshold = 100; %--min depth from surrounding region in cm
	boundingBoxThresh = 35;  %--percent of bounding box area region must fill
	minHoleThresh = 100;  %--width in pixels
	rbgRegionContrastThresh = 1500;  %--in pixel intensity

	depthThreshold = 25; %--min depth from surrounding region in cm
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	depthThreshold = 50; %--min depth from surrounding region in cm	
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	depthThreshold = 100; %--min depth from surrounding region in cm
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	depthThreshold = 150; %--min depth from surrounding region in cm
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	depthThreshold = 200; %--min depth from surrounding region in cm
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	depthThreshold = 250; %--min depth from surrounding region in cm
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	depthThreshold = 300; %--min depth from surrounding region in cm
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Bounding Box Percent
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	nC = 9; % nC is the target number of superpixels.
	depthThreshold = 100; %--min depth from surrounding region in cm
	%boundingBoxThresh = 50;  %--percent of bounding box area region must fill
	minHoleThresh = 100;  %--width in pixels
	rbgRegionContrastThresh = 1500;  %--in pixel intensity

	boundingBoxThresh = 35;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	boundingBoxThresh = 40;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	boundingBoxThresh = 45;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	boundingBoxThresh = 50;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	boundingBoxThresh = 55;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	boundingBoxThresh = 60;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	boundingBoxThresh = 65;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Minimum Width
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	nC = 9; % nC is the target number of superpixels.
	depthThreshold = 100; %--min depth from surrounding region in cm
	boundingBoxThresh = 35;  %--percent of bounding box area region must fill
	%minHoleThresh = 100;  %--width in pixels
	rbgRegionContrastThresh = 1500;  %--in pixel intensity

	minHoleThresh = 25;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	minHoleThresh = 50;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	minHoleThresh = 75;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	minHoleThresh = 100;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	minHoleThresh = 125;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	minHoleThresh = 150;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	minHoleThresh = 175;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Hole Grayscale Contrast
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	nC = 9; % nC is the target number of superpixels.
	depthThreshold = 100; %--min depth from surrounding region in cm
	boundingBoxThresh = 35;  %--percent of bounding box area region must fill
	minHoleThresh = 100;  %--width in pixels
	%rbgRegionContrastThresh = 250;  %--in pixel intensity

	rbgRegionContrastThresh = 250;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	rbgRegionContrastThresh = 500;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	rbgRegionContrastThresh = 750;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	rbgRegionContrastThresh = 1000;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	rbgRegionContrastThresh = 1250;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	rbgRegionContrastThresh = 1500;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);

	rbgRegionContrastThresh = 1750;
	%callSeg(nC, depthThreshold, boundingBoxThresh, minHoleThresh, rbgRegionContrastThresh);
	
	
	toc
end