SGXWAYLAND_VERSION = 5c56c8f809f1e08e5b774e3b728efd3d0a756dd3
SGXWAYLAND_SITE = https://github.com/nemomobile/ti-omap3-sgx-wayland-wsegl
SGXWAYLAND_SITE_METHOD = git


SGXWAYLAND_LICENSE = GPLv2
SGXWAYLAND_LICENSE_FILES = COPYING


define SGXWAYLAND_CONFIGURE_CMDS
        (cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define SGXWAYLAND_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SGXWAYLAND_INSTALL_STAGING_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
        $(SGX5_LA_PRL_FILES_FIXUP) 
endef

define SGXWAYLAND_INSTALL_TARGET_CMDS
	cd $(@D); \
	cp -dpfr plugins/platforms/libqwayland-egl.so $(TARGET_DIR)/usr/lib/qt/plugins/platforms
endef

$(eval $(generic-package))
