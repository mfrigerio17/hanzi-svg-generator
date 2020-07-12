**Chinese character SVG generator**

Copyright (c) 2020 Marco Frigerio

This package contains Unix shell scripts to generate some SVG images of
Chinese characters. It is based on the source data provided by the [Make Me a
Hanzi][ahanzi] project, which you have to fetch separately.

The SVG generator requires [Octave](https://www.gnu.org/software/octave/).

I tested the code only in Ubuntu Linux, and tried the generated SVGs with
Firefox only.


# Motivation

The "Make Me a Hanzi" repository already includes a nice animated SVG image for
each character. What I wanted was neater and more reusable svg code.
Building blocks allowing to create multiple SVGs of the same character, animated
or not, without repetition of code. Also, I wanted to be able to style the
resulting images with CSS.

# Description

The scripts in this package generate the following files, for each character
specified in an input list (see below for usage information):

- `paths.svg` : the core geometric data for a character, that is the paths
  representing the strokes and the median line of each stroke; this file is not
  meant for direct display, it is a container of building blocks to create
  other svg images.

- `guidepaths.svg` : other svg elements useful to make an animation showing
  the painting of the strokes; also not meant for direct display.

- `animated.svg` : an image of the character, simulating the painting of the
  strokes in the right sequence; this is _visually_ almost the same as what is
  available in [Make Me a Hanzi][ahanzi].
  The SVG code references the previous two files.

- `sequence.svg` : an image showing the stroke sequence statically; ready for
  display. It references `paths.svg`

For convenience, the process generates two more SVG files with the plain
character and the stroke sequence, respectively:

- `standalone.svg`
- `standalone-sequence.svg`

These files are standalone, they do not refer to the other ones and they
replicate the code of the svg-paths. These files are provided for compatibility
with frontends that do not support the referencing of external SVG files.

All the svg-paths in the generated files are normalized for a 1024x1024 canvas,
no coordinate transform is required.

## Sample
See the svg files in the `sample/我` folder.

Samples of how to include the images in html pages are available in
[`sample/readme.html`](sample/readme.html).

# Usage
After cloning this repository, download `graphics.txt` and `dictionary.txt` from
the [Make Me a Hanzi][ahanzi] git repo. Copy these two files in the subfolder
`db/` of this project; create it if necessary. (*)

Then, type:
```
make
```
in the root of this package. All the outputs are generated in a subfolder of
`out/`, named as the chinese character - e.g. `out/你/`.

By default, the makefile uses a sample input file, `etc/example-list`. To
use another file, type:

`make chars_list=<your input file>`

The input file must be a text file, containing a list of chinese characters
separated by a space, encoded in UTF-8.

(*)  My original plan was to include
Make me a hanzi as a git-submodule, but the repo is big (because of thousands
of SVGs) and I decided not to.

**Important**: SVG code referencing external files (like other SVG files) might
not work in the browser due to the
[`origin_policy`](http://kb.mozillazine.org/Security.fileuri.strict_origin_policy)
security setting.
You may have to disable it. In Firefox, go to the URL `about:config` and search
for the key `security.fileuri.strict_origin_policy`.


# License
The code in this repository is released under the BSD 3-clause license. See the
`LICENSE` file.

The data files from the "Make me a hanzi" project come with their own licensing
terms. Details can be found in the [git repository][ahanzi].

[ahanzi]: https://github.com/skishore/makemeahanzi

