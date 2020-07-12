%% Transform the y coordinate of SVG points according to the comments on the
%% make-me-a-hanzi webpage, so that the coordinates will be suited for a
%% 1024x1024 canvas without any transform

function y = fixYCoordinate(valuein)

y = -valuein + 900;
