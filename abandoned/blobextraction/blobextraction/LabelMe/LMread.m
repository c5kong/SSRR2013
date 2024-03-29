%function [annotation, img] = LMread(filename, HOMEIMAGES)
function [annotation, img] = LMread(varargin)
%
% Reads the annotations and the image 
% [annotation, img] = LMread(annotation_filename, HOMEIMAGES)
% 
% or 
%
% [annotation, img] = LMread(D, ndx, HOMEIMAGES)

switch length(varargin)
    case 1
        if nargout==2
            error('Not enough input arguments.')
        else
            filename = varargin{1};
            if exist(filename, 'file')
                v = loadXML(filename);
                annotation = v.annotation;
            else
                disp('Annotation file does not exist')
                annotation = -1;
            end
        end
    case 2
        filename = varargin{1};
        HOMEIMAGES = varargin{2};
        
        if exist(filename, 'file')
            v = loadXML(filename);
            annotation = v.annotation;
        else
            disp('Annotation file does not exist')
            annotation = -1;
        end
    case 3
        D = varargin{1};
        ndx = varargin{2};
        HOMEIMAGES = varargin{3};

        annotation = D(ndx).annotation;
    otherwise
        error('Too many input arguments.')
end

if nargout == 2
    if isstruct(annotation)
        filenameimage = fullfile(HOMEIMAGES, annotation.folder, annotation.filename);
        if strcmp(filenameimage(1:5), 'http:');
            filenameimage = strrep(filenameimage, '\', '/');
        end

        img = imread(filenameimage);
    else
        img = imread(strrep(filename, '.xml', '.jpg'));
    end
end
