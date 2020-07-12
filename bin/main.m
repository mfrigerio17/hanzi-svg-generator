#!/usr/bin/octave

%% This program is the main generator of the content of the SVG files for each
%% character.
%% Basically, it takes the original graphical information extracted from the
%% make-me-a-hanzi database, and produces SVG code. Note that the raw data in the
%% database is already in the form of SVG-paths.

addpath('./bin');
args = argv();


%% STROKES INPUT DATA
%%
%% args{1} is a single, long string with all the SVG-paths for a chinese character
%% It is the text extracted from the make-me-a-hanzi database.
%%
%% Here, we parse the string to separate the SVG-path of each character stroke,
%% and we put them in a cell array. The function 'strokes' also fixes the
%% coordinates so that they match the 1024x1024 canvas.

strokepaths = strsplit( args{1} , ',');
strokepaths = fixpaths( strokepaths );



%% MEDIANS INPUT DATA
%%
%% Similar thing for the medians path, although we have the coordinates already
%% in Octave format, as numbers, in a temporary script. The function 'medians'
%% fixes the coordinates and computes the lenght of the path.

run('mediansdata.m');
[medianscoords lengths] = medians( mediansdata );


%%
%% Other arguments to this program, the names of temporary files where to put
%% the generated SVG code

pathsFile   = args{2};
mediansFile = args{3};
styleFile   = args{4};
ssequenceFile = args{5};
standaloneSSequenceFile = args{6};

genStrokesSequenceSVG(length(strokepaths), ssequenceFile);
genStrokesSequenceSVG(strokepaths, standaloneSSequenceFile);




%%   STROKES
%% SVG paths representing the strokes of the character.
%%

pathsF = fopen(pathsFile, 'w');
for s = 1 : length(strokepaths)
    fprintf(pathsF,['<path id="stroke' num2str(s) '" d=' strokepaths{s} '></path>\n']);
end
fclose(pathsF);



%%   MEDIANS
%% SVG paths representing the median line of each stroke of the character.
%%

mediansF = fopen(mediansFile, 'w');
for m = 1 : length(medianscoords)
    coords = medianscoords{m};
    str    = ['"M ' num2str(coords(1,1)) ' ' num2str(coords(1,2))];

    for c = 2:length(coords)
        str = [str ' L ' num2str(coords(c,1)) ' ' num2str(coords(c,2))];
    end
    str = strcat(str, '"');
    mstr = num2str(m);

    fprintf(mediansF,['<path id="median' mstr '" d=' str '></path>\n']);
end
fclose(mediansF);



%%   CLIP-PATHS
%% SVG code for the clip-paths with the same shape as the strokes, and the
%% paths to be used for the painting animation (i.e. the medians).
%%

styleF = fopen(styleFile, 'w');

for s = 1 : length(strokepaths)
    sstr = num2str(s);
    fprintf(styleF,['<clipPath id="clip' sstr '"><use href="paths.svg#stroke' sstr '"/></clipPath>\n']);
end

fprintf(styleF,['<defs id="clipped-medians">\n']);

for s = 1 : length(strokepaths)
    sstr = num2str(s);
    l    = lengths{s};
    lstr = num2str(l);
    fprintf(styleF,['<use id="paint' sstr '" href="paths.svg#median' sstr '" clip-path="url(#clip' sstr ')" class="animation-guidepath" stroke-dashoffset="' lstr '"  stroke-dasharray="' lstr ' ' num2str(l+64) '"/>\n']);
end

fprintf(styleF,['</defs>\n']);
fclose(styleF);



