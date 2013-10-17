################################################################################
#
# weston
#
################################################################################
WESTON_VERSION = 1.1.1
WESTON_SITE = http://wayland.freedesktop.org/releases/
WESTON_SOURCE = weston-$(WAYLAND_VERSION).tar.xz
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING
WESTON_AUTORECONF = YES
WESTON_DEPENDENCIES = wayland libxkbcommon pixman libpng \
	jpeg mtdev udev cairo
WESTON_CONF_OPT = \
	--disable-xwayland \
	--disable-x11-compositor \
	--disable-drm-compositor \
	--disable-headless-compositor \
	--disable-rpi-compositor \
	--disable-weston-launch \
	--disable-libunwind	\
	--disable-wayland-compositor \
	--with-cairo-glesv2	\
	--enable-fbdev-compositor 


WESTON_NATIVE_BACKEND="fbdev-backend.so"

ifeq ($(BR2_PACKAGE_WESTON_FBDEV),y)
WESTON_CONF_OPT += --enable-fbdev-compositor \
	COMPOSITOR_CFLAGS="-I$${SYSROOT}/usr/include/pixman-1 -DLINUX=1 -DEGL_API_FB " \
	COMPOSITOR_LIBS="-lGLESv2 -lEGL -lGAL -lwayland-server -lxkbcommon -lpixman-1"  \
	LDFLAGS="-lwayland-server  -lEGL  -lwayland-cursor -lpixman-1"  \
	CLIENT_CFLAGS="-DLINUX=1 -DEGL_API_FB"	\
	CLIENT_LIBS="-lGLESv2 -lEGL -lwayland-client -lEGL -lwayland-cursor -lxkbcommon -lcairo" \
	SIMPLE_EGL_CLIENT_CFLAGS="-DLINUX=1 -DEGL_API_FB -DEGL_API_WL " \
	SIMPLE_EGL_CLIENT_LIBS="-lGLESv2 -lEGL -lwayland-client -lwayland-cursor -lcairo" \
	SIMPLE_CLIENT_LIBS="-lGLESv2 -lEGL  -lwayland-client -lwayland-cursor -lcairo" \
	IMAGE_LIBS="-lwayland-cursor -lcario" \
	WESTON_INFO_LIBS="-lwayland-client" \
	WESTON_NATIVE_BACKEND="fbdev-backend.so"
else
WESTON_CONF_OPT += --disable-fbdev-compositor
endif

$(eval $(autotools-package))

