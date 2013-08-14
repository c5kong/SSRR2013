clear all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outputFile = ('output.csv');
gtFile = ('groundTruth_perfectdata.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

outputDirectory = ('data/extendedDataset/output/');
gtDirectory = ('data/extendedDataset/output/groundTruth/');


fileID = fopen(strcat(outputDirectory, outputFile));
C = textscan(fileID, '%s %d %d %d %d','delimiter', ',', 'EmptyValue', -Inf);
fclose(fileID);

detectedImgs = char(C{1});
detectedRegionsX = int32(C{2});
detectedRegionsY = int32(C{3});
detectedRegionsW = int32(C{4});
detectedRegionsH = int32(C{5});

fileID = fopen(strcat(gtDirectory, gtFile));
C = textscan(fileID, '%s %d %d %d %d','delimiter', ',', 'EmptyValue', -Inf);
fclose(fileID);

groundTruthPosImgs = char(C{1});
groundTruthPosRegionsX = int32(C{2});
groundTruthPosRegionsY = int32(C{3});
groundTruthPosRegionsW = int32(C{4});
groundTruthPosRegionsH = int32(C{5});

dImgs = {};
dRegions = [];
count = 1;

for i = 1:length(detectedRegionsX)
	flag = 0;
	if isempty(dImgs)
		flag = 1;	
	else
		for j = 1:length(dImgs)
			if strcmp(dImgs{j}, strtrim(detectedImgs(i,:))) ...
			& dRegions(j, 1) == detectedRegionsX(i) ...
			& dRegions(j, 2) == detectedRegionsY(i) ...
			& dRegions(j, 3) == detectedRegionsW(i) ...
			& dRegions(j, 4) == detectedRegionsH(i)
				flag = 0;
			else				

				flag = 1;
				
			end
		end	
	end
	
	if flag == 1
		dImgs{count} = strtrim(detectedImgs(i,:));
		dRegions(count, 1) = detectedRegionsX(i);
		dRegions(count, 2) = detectedRegionsY(i);
		dRegions(count, 3) = detectedRegionsW(i);
		dRegions(count, 4) = detectedRegionsH(i);		
		count = count + 1;				
	end		
end


truePositive = 0;
falsePositive = 0;
for i = 1:length(dImgs)
	dImg = dImgs{i};
	dRegion(1, 1) = dRegions(i, 1);
	dRegion(1, 2) = dRegions(i, 2);
	dRegion(1, 3) = dRegions(i, 3);
	dRegion(1, 4) = dRegions(i, 4);
	
	detectedArea = detectedRegionsW(i) * detectedRegionsH(i);
	
	for j = 1:length(groundTruthPosRegionsX)
		gtImg = strtrim(groundTruthPosImgs(j,:));
		gtRegion(1, 1) = groundTruthPosRegionsX(j);
		gtRegion(1, 2) = groundTruthPosRegionsY(j);
		gtRegion(1, 3) = groundTruthPosRegionsW(j);
		gtRegion(1, 4) = groundTruthPosRegionsW(j);
		
		gtArea = groundTruthPosRegionsW(j) * groundTruthPosRegionsW(j);

		if strcmp(dImg, gtImg) 			
			largerArea = max(detectedArea, gtArea);
			
			if rectint(dRegion, gtRegion) > (0.5*detectedArea)
				truePositive = truePositive + 1;	
			else
				falsePositive = falsePositive + 1;
			end			
		end
	end
	
end	

falseNegatives = length(groundTruthPosRegionsX) - truePositive;
precision =  truePositive/(truePositive+falsePositive);%-- Precision = TP/(TP + FP) 
recall =  truePositive/length(groundTruthPosRegionsX);%-- Recall = TP/nP,

recall 
precision 
truePositive
falseNegatives
falsePositive


