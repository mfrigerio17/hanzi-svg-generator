%% Fixes the coordinates of the svg-paths, to fit the 1024x1024 canvas.
%%
%% The only argument SVGPATHS must be a cell array, each element being a string
%% with a complete svg-path as extracted from the make-me-a-hanzi database.
%% The returned value has the exact same format, but the coordinates in the
%% svg-paths are, in general, changed.

function fixedPaths = fixpaths(svgpaths)

for s = 1 : length(svgpaths)
    strs  = strsplit( svgpaths{s} );
    flags = regexp(strs, '\d+');

    state = 0;
    out = '';

    for i = 1 : length(strs)
        if(flags{i}) % it is a number
            state = state + 1;
        else
            state = 0;
        end

        if(state == 2) % it is the y coordinate
            val = str2num(strs{i});
            strs{i} = num2str( fixYCoordinate(val) );
            state = 0;
        end
        out = [out ' ' strs{i}];
    end

    fixedPaths{s} = out;
end
