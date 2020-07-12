%% Generates the body of an SVG that displays the sequence of strokes of a
%% chinese character.
%%
%% Arguments:
%% STROKES must be either A) a cell array, each element being a string with
%% valid SVG code for the svg-path of an individual stroke, or B) the integer
%% number of strokes.
%% In the first case, the path code will be inserted as it is, whereas in the
%% second case a reference to an external 'paths.svg' will be generated.
%%
%% OUTFILEPATH the file path where to write the generated code

function [w h] = genStrokesSequenceSVG(strokes, outFilePath)

unityL = 1024;
maxCols= 5;

pathCodeF = @strokePathInline;

if( iscell(strokes) )
    strokesCount = length(strokes);
else
    if( ! isscalar(strokes) )
        error('The first parameter STROKES must be either a cell array or a scalar')
    end
    strokesCount = strokes;
    pathCodeF = @strokeReference;
end


rowsCount = ceil(strokesCount / maxCols);
colsCount = min(strokesCount, maxCols);

w = colsCount * unityL;
h = rowsCount * unityL;


file = fopen(outFilePath, 'w');

fprintf(file,['viewBox="0 0 ' num2str(w) ' ' num2str(h) '"\n']);


for s = 1 : strokesCount
    tx = mod(s-1,maxCols) * unityL;
    ty = floor( (s-1) / maxCols) * unityL;

    fprintf(file,['<g transform="translate(' num2str(tx) ',' num2str(ty) ')">\n']);

    fprintf(file,['<g class="background-stroke">\n']);
    for i = (s+1) : strokesCount
        code = pathCodeF(strokes, i);
        fprintf(file, code);
    end
    fprintf(file,['</g>\n']);
    
    fprintf(file,['<g class="painted-stroke">\n']);
    for i = 1 : s-1
        code = pathCodeF(strokes, i);
        fprintf(file, code);
    end
    fprintf(file,['</g>\n']);

    code = pathCodeF(strokes, s);
    fprintf(file, ['<g class="fresh-stroke">\n']);
    fprintf(file, code);
    fprintf(file, ['</g>\n']);

    fprintf(file,['</g>\n']);
    fprintf(file,['\n\n']);
end

fclose(file);


function code = strokePathInline(strokes, num)
  code = ['<path d=' strokes{num} '/>\n'];

function code = strokeReference(strokes, num)
  code = ['<use href="paths.svg#stroke' num2str(num) '"/>\n'];


