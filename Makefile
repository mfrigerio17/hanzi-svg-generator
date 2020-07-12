dir_gen := out
dir_etc := etc
dir_bin := bin

markername := .lastmade

chars_list   := $(dir_etc)/example-list
chars        := $(shell cat ${chars_list})
all_folders  := $(foreach ch,$(chars),$(dir_gen)/$(ch))
mademarkers  := $(foreach folder, $(all_folders), $(folder)/$(markername))
svgtemplates := $(wildcard $(dir_etc)/svgtpl*)
genscripts   := $(wildcard $(dir_bin)/*)

# Binaries to generate the SVGs and the text info ($* expands to the stem)
exe_svggen = $(dir_bin)/generate.sh $* db/graphics.txt
exe_txtgen = $(dir_bin)/getTextInfo.sh $* db/dictionary.txt


all : $(all_folders)

$(all_folders) : % : %/$(markername)

$(mademarkers) : $(dir_gen)/%/$(markername) : $(genscripts) $(svgtemplates)
	@$(exe_svggen)
	@$(exe_txtgen)
	@touch $@

debug :
	@echo $(all_folders)

.PHONY: all debug
