function LM2OpenCV(database, HOMEIMAGES, base_folder, num_neg, patch_size)
% LM2OpenCV Outputs query in OpenCV Haar-detector format.
%   LM2OpenCV(database, HOMEIMAGES, base_folder, num_neg, patch_size)
%   converts and stores the object images specified by the LabelMe database
%   struct to the OpenCV haar-detector format. base_folder specifies the
%   target directory for which positive and negative training examples are
%   stored for input to the OpenCV haar-detector training utility
%   (createsamples.exe and haartraining.exe).
%
%   To form positive training examples, object images are copied from the
%   LabelMe database into the folder base_folder/positives and the file
%   positives.txt is created and  stored in base_folder. The positives.txt
%   file lists for each image in database the object bounding boxes and is
%   provided as input to the OpenCV createsamples routine.
%
%   The negative examples are generated by taking num_neg subwindows of
%   size patch_size=[width height] from the images in database that do not
%   contain an object instance. These windows are sampled at random
%   locations in the images. The cropped subwindows are stored in the
%   directory base_folder/negatives and the file negatives.txt is created
%   and stored in base_folder, which lists the image filenames stored in
%   the negatives directory. The negatives.txt file is used by the OpenCV
%   haartraining routine.
%
%   The variable HOMEIMAGES specifies the physical location of the LabelMe
%   database used by the database index database.
%
%   To understand how to train an OpenCV haar-detector with the training
%   samples and files  generated by this script use example command line
%   calls are provided below.
%
%   Example (Pedestrian Detector):
%
%      (In MATLAB)
%
%      HOMEIMAGES = 'C:/LabelMe/Images';
%      HOMEANNOTATIONS = 'C:/LabelMe/Annotations';
%      base_folder = 'D:/dtd';
%      num_neg = 10000;
%      patch_size = [16 32]; % width=16, height=32
%
%      LMdb = LMdatabase(HOMEANNOTATIONS);
%      query = 'pedestrian,person,human,man,woman';
%      database = LMquery(LMdb, 'object.name', query);
%      LM2OpenCV(database, HOMEIMAGES, base_folder, num_neg, patch_size);
%      counts = LMcountobject(database, query);
%
%      (Command Prompt, Let counts=900)
%
%      createsamples -info D:\dtd\positive.txt -vec D:\dtd\positives.vec
%      -num 900 -w 16 -h 32
%
%      haartraining -data D:\dtd\peddetector\ -vec D:\dtd\positives.vec -bg
%      D:\dtd\negatives.txt -npos 900 -nneg 10000 -w 16 -h 32
%
%   In the above example, the call to createsamples generates the file
%   positives.vec used by the haartraining routine. The haartraining
%   routine then creates the OpenCV Haar pedestrian detector and saves it
%   in the director 'D:\dtd\peddetector'.
%

% get number of images in the database
Nimages = length(database);


% sample negatives evenly from each image
nneg_per_image = ceil(num_neg/Nimages);
if(nneg_per_image<1)
    nneg_per_image = 1;
end

% create directories positives and negatives
pos_res = mkdir(base_folder, 'positives');
neg_res = mkdir(base_folder, 'negatives');
if ~(pos_res & neg_res)
    error('LM2OpenCV error: Unable to create positives and/or negatives directories.');
end

% create files positives.txt and negatives.txt
pbdir = sprintf('%s/positives',base_folder);
nbdir = sprintf('%s/negatives',base_folder);
pfilename = sprintf('%s/positives.txt', base_folder);
nfilename = sprintf('%s/negatives.txt', base_folder);
pos_file = fopen(pfilename, 'w+t');
neg_file = fopen(nfilename, 'w+t');
if (pos_file<0 || neg_file<0)
    error('LM2OpenCV error: Unable to create files positive.txt and/or negatives.txt.');
end

% traverse images:
%   - copy over positive image files to the positives directory
%   - crop negative examples and store in negatives directory
%   - create files positives.txt and negatives.txt
neg_ctr = 0;
obj_ctr = 0;
pw = patch_size(1);
ph = patch_size(2);
for i = 1:Nimages
    if isfield(database(i).annotation, 'object')
        Nobjects = length(database(i).annotation.object);
        try
            % load image
            img = LMimread(database, i, HOMEIMAGES); % Load image
            [nrows ncols c] = size(img);
            if (c==3) % convert to grayscale? (I'm not sure if this is required by OpenCV...)
                img = rgb2gray(img);
            end;
                        
            % crop and add positive examples from image i to positive image
            % directory
            bboxes = []; % store bounding boxes for negative patch generation
            for j = 1:Nobjects
                [X,Y] = getLMpolygon(database(i).annotation.object(j).polygon);
                
                % compute bounding box of object
                x = min(X)-2;
                y = min(Y)-2;
                w = max(X)+2 - x;
                h = max(Y)+2 - y;
                ctr_x = x+w/2;
                ctr_y = y+h/2;
                
                % round width and height to be a multiple of the patch size
                % width and height, and re-center bounding box
                sfactor = max(w/pw,h/ph);
                w = floor(sfactor*pw);
                h = floor(sfactor*ph);
                x = floor(ctr_x - w/2);
                y = floor(ctr_y - h/2);
                
                % make sure that patch fits inside image (otherwise skip
                % this positive)
                if (w>ncols || h>nrows)
                    continue;
                end
                
                % check boundaries
                if(x<1); x = 1; end;
                if(y<1); y = 1; end;
                if((x+w)>ncols); x = ncols-w; end;
                if((y+h)>nrows); y = nrows-h; end;
                
                % crop and save image in positive image directory                
                img_filename = sprintf('%s/pos%06d.jpg', pbdir, obj_ctr);
                cimg = img(y:(y+h-1),x:(x+w-1));
                imwrite(cimg, img_filename, 'JPG', 'Quality', 100);
                
                % add entry into positives file:
                % OpenCV format is upper-left corner (x,y), width (w) and
                % height (h)                
                fprintf(pos_file, 'positives\\pos%06d.jpg\t1\t0 0 %d %d\n', obj_ctr, w, h);
                
                % use bboxes below...
                bboxes = [bboxes; x y w h];
                
                % next object
                obj_ctr = obj_ctr + 1;
            end
            
            % generate negative patches
            x = [];
            y = [];
            for j = 1:nneg_per_image
                if neg_ctr > num_neg
                    break;
                end
                
                cx = floor(rand(1)*(ncols-pw-1));
                cy = floor(rand(1)*(nrows-ph-1));
                
                % check boundaries
                if(cx<1); cx = 1; end;
                if(cy<1); cy = 1; end;
                if((cx+pw)>ncols); cx = ncols-pw; end;
                if((cy+ph)>nrows); cy = nrows-ph; end;                
                
                while (sum(cx==x) || sum(cy==y) || ...
                        isOverlap(cx,cy,pw,ph,bboxes))
                    cx = floor(rand(1)*(ncols-pw-1));
                    cy = floor(rand(1)*(nrows-ph-1));
                    
                    % check boundaries
                    if(cx<1); cx = 1; end;
                    if(cy<1); cy = 1; end;
                    if((cx+pw)>ncols); cx = ncols-pw; end;
                    if((cy+ph)>nrows); cy = nrows-ph; end;
                end
                
                x = [x cx];
                y = [y cy];
                    
                % crop and save negative patch
                cimg = img(cy:(cy+ph-1),cx:(cx+pw-1));
                img_filename = sprintf('%s/neg%06d.jpg', nbdir, neg_ctr);
                imwrite(cimg, img_filename, 'JPG', 'Quality', 100);
                    
                % update negatives file
                fprintf(neg_file, 'negatives\\neg%06d.jpg\n', neg_ctr);
                    
                neg_ctr = neg_ctr + 1;
            end
        catch
            i
            'dimensions (x, y, w, h)'
            x
            y
            w
            h
        end
    end
end

% done.
fclose(pos_file);
fclose(neg_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% isOverlap
%

function ans = isOverlap(x, y, w, h, bboxes)

ans = 0;
n = size(bboxes,1);
for idx = 1:n
    cx = bboxes(idx,1);
    cy = bboxes(idx,2);
    cw = bboxes(idx,3);
    ch = bboxes(idx,4);
    
    if ~(x>(cx+cw) || y>(cy+ch) || (x+w)<cx || (y+h)<cy)
        ans = 1;
        return;
    end
end
