DIST_ROOT      := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
orig  		= orig
patched 	= patched
DIFF 		= /usr/bin/diff -ru --new-file
TARGET 		= unified_diff.patch
INSTALL    	= /usr/bin/install
SHPP		= /usr/bin/shpp
install_files   = $(DIST_ROOT)/scripts/install_files
diff_root 	= to_diff
DESTDIR =
installdir 	:= $(DESTDIR)/usr/patchmanager/patches
include 	project.mk
all: $(TARGET)

$(TARGET): $(orig) $(patched)
	cd $(orig); \
	$(install_files) -r ../$(diff_root)/$(orig) ../dir.install
	cd $(patched); \
	 $(install_files) -r ../$(diff_root)/$(patched) ../dir.install
	cd $(diff_root) ; \
	$(DIFF) $(orig) $(patched) > ../$@|| exit 0
install:
	$(INSTALL) -dm644 $(installdir)/$(NAME)
	$(INSTALL) -m644 $(TARGET) $(installdir)/$(NAME)/$(TARGET)

patch.spec:  $(DIST_ROOT)/scripts/template.spec
	$(SHPP) -DNAME=$(NAME) \
		-DVER=$(VER) \
		-DSUMMARY=$(SUMMARY) \
		-DDESCRIPTION=$(DESCRIPTION) \
		-DLISENSE=$(LISENSE) \
		$(<) -o $(@)

patch.json: $(DIST_ROOT)/scripts/patch.json.template
	$(SHPP) -DNAME=$(NAME) \
		-DDESCRIPTION=$(DESCRIPTION) \
		-DSUMMARY=$(SUMMARY) \
		-DCATEGORY=$(CATEGORY) \
		-DMAINTAINER=$(MAINTAINER) \
		$(<) -o $(@)
clean:
	rm  -f $(TARGET)
	rm -rf $(diff_root)

.PHONY: clean install