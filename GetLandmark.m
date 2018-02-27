function [ landmarks ] = GetLandmark( filename )    
    API_KEY = 'd45344602f6ffd77baeab05b99fb7730';
    API_SECRET = 'jKb9XJ_GQ5cKs0QOk6Cj1HordHFBWrgL';
    api = facepp(API_KEY, API_SECRET);
    imwrite(imresize(imread(filename),[256 256]),filename);
    rst1 = detect_file(api, filename, 'pose');
    num = length(rst1{1}.face);
    face = rst1{1}.face{1};
    ret = api.landmark(face.face_id, '83p');
	landmark_points = ret{1}.result{1}.landmark;
    img_width = rst1{1}.img_width;
    img_height = rst1{1}.img_height;
    landmark_names = fieldnames(landmark_points);
    
    landmark.x = zeros(length(landmark_names) + 8, 1);
    landmark.y = zeros(length(landmark_names) + 8, 1);        
        
        landmark.x(1) = 0;
        landmark.y(1) = 0;
        landmark.x(2) = img_width/2-1;
        landmark.y(2) = 0;
        landmark.x(3) = img_width-1;
        landmark.y(3) = 0;
        landmark.x(4) = 0;
        landmark.y(4) = img_height/2-1;
        landmark.x(5) = 0;
        landmark.y(5) = img_height-1;
        landmark.x(6) = img_width-1;
        landmark.y(6) = img_height/2-1;
        landmark.x(7) = img_width/2-1;
        landmark.y(7) = img_height-1;
        landmark.x(8) = img_width-1;
        landmark.y(8) = img_height-1;
       
        for j = 9 : (length(landmark_names)+8)
            pt = getfield(landmark_points, landmark_names{j-8});
            landmark.x(j) = pt.x * img_width / 100;
            landmark.y(j) = pt.y * img_height / 100;
        end
        landmarks = [landmark.y landmark.x];        