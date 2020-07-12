%% Given the coordinates of the median line of a character, taken from the
%% make-me-a-hanzi database, this function returns the coordinates normalized
%% for a 1024x1024 canvas, and the total length of the median line.
%%
%% ALLCOORDS is a cell array, each element being a matrix with the coordinates
%% of all the points of a median line; a row for each point, X coordinates on
%% the first column, Y on the second.

function [fixedCoords lengths] = medians( allCoords )

for m = 1 : length(allCoords)
    coords = allCoords{m};
    coords(1,2) = fixYCoordinate( coords(1,2) );

    total_length = 0;
    for c = 2:length(coords)
        coords(c,2) = fixYCoordinate( coords(c,2) );
        len = sqrt( (coords(c,1)-coords(c-1,1))^2 + (coords(c,2)-coords(c-1,2))^2 );
        total_length = total_length + len;
    end
    
    fixedCoords{m} = coords;
    lengths{m} = total_length;
end

