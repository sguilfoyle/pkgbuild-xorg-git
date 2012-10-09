LOCAL=/home/packages
REMOTE=74.72.157.140:/home/serkan/public_html

DIRS = \
	   pacaur-git \
	   glproto-git \
	   pixman-git \
	   drm-git \
	   mesa-git \
	   xorg-server-git \
	   cairo-git \
	   glu-git \
	   xf86-video-ati-git \
	   xf86-input-evdev-git \
	   xf86-input-synaptics-git \
	   monodevelop-git \
	   muffin-git \
	   cinnamon-git \
	   nemo-git \
	   nemo-fileroller-git \
	   nemo-dropbox-git \

DATE=$(shell date +"%Y%m%d")

TARGETS=$(addsuffix /built-$(DATE), $(DIRS))

all: $(TARGETS)

clean:
	find -name '*tar.xz' -exec rm {} \;

show:
	@echo $(DATE)
	@echo $(TEST)

%/built-$(DATE):
	@cd $* ; \
		yes "" | makepkg -f ; \
		touch built-$(DATE)


$(DIRS):
	@echo "-- $@ --"; cd $@ ; \
	yes "" | makepkg -fsi

push: add
	@rsync -rv \
		$(LOCAL)/* \
		$(REMOTE)/

add:
	@cd $(LOCAL)
	@rm -rf mine.db*
	@repo-add $(LOCAL)/mine.db.tar.gz $(LOCAL)/*.xz

fetch:
	@rsync -rv \
		$(REMOTE)/* \
		$(LOCAL)/

xorg-server-git: glproto-git

mesa-git: glproto-git

xf86-video-ati-git: drm-git xorg-server-git

xf86-video-evdev-git: drm-git mesa-git xorg-server-git

xf86-video-synaptics-git: mesa-git xorg-server-git

libglu-git: mesa-git

cinnamon-git: muffin-git
