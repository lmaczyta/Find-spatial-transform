function [ Coordinates, Precision ] = readMeasures( name_file )
% Reads a file with the measures of one kinect. Returns the coordinates of
% the data with the associated precision

    id = fopen(name_file);

    % Read all the data in the file
    
    offset = 0;
    
    Coordinates = [];
    Precision = [];
    
    while ~feof(id)
        kinectId = fscanf(id, '%c', 1);
        fscanf(id, '%c', 1);
        time = fscanf(id, '%ld', 1);

        % The coordinates of the 25 points
        for i=1:25
            fscanf(id, '%c', 1);
            Coordinates(1,i+offset) = fscanf(id, '%f', 1);

            fscanf(id, '%c', 1);
            Coordinates(2,i+offset) = fscanf(id, '%f', 1);

            fscanf(id, '%c', 1);
            Coordinates(3,i+offset) = fscanf(id, '%f', 1);
        end

        fscanf(id, '%c', 2);
        
        % The precision of the measures

        for i=1:25
            fscanf(id, '%c', 1);
            Precision(i+offset) = fscanf(id, '%d', 1);
        end
        
        fscanf(id, ':E\n', 1);
        
        offset = offset + 25;

    end
        

    fclose(id);

end