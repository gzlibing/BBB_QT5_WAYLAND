################################################################################
#
# gpu-viv-bin-mx6q
#
################################################################################

GPU_VIV_WL_BIN_MX6S_VERSION = 3.0.35-4.0.0
GPU_VIV_WL_BIN_MX6S_SITE    = $(FREESCALE_IMX_MIRROR_SITE)
GPU_VIV_WL_BIN_MX6S_SOURCE  = gpu-viv-wl-bin-mx6s-$(GPU_VIV_WL_BIN_MX6S_VERSION).bin

GPU_VIV_WL_BIN_MX6S_INSTALL_STAGING = YES

GPU_VIV_WL_BIN_MX6S_LICENSE = Freescale Semiconductor Software License Agreement

# No license file is included in the archive; we could extract it from
# the self-extractor, but that's just too much effort.
# This is a legal minefield: the EULA specifies that
# the Board Support Package includes software and hardware (sic!)
# for which a separate license is needed...
GPU_VIV_WL_BIN_MX6S_REDISTRIBUTE = NO

# DirectFB is not supported (wrong version)
ifeq ($(BR2_PACKAGE_XORG7),y)
GPU_VIV_WL_BIN_MX6S_LIB_TARGET = x11
else
GPU_VIV_WL_BIN_MX6S_LIB_TARGET = wl
endif

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (gpu-viv-bin-mx6q-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info.
define GPU_VIV_WL_BIN_MX6S_EXTRACT_CMDS
        (cd $(BUILD_DIR); \
                sh $(DL_DIR)/$(GPU_VIV_WL_BIN_MX6S_SOURCE) --force --auto-accept)
endef

# Instead of building, we fix up the inconsistencies that exist
# in the upstream archive here.
# Make sure these commands are idempotent.
define GPU_VIV_WL_BIN_MX6S_BUILD_CMDS
	$(SED) 's/defined(LINUX)/defined(__linux__)/g' $(@D)/usr/include/*/*.h
	for lib in EGL GAL VIVANTE; do \
		ln -sf lib$${lib}-$(GPU_VIV_WL_BIN_MX6S_LIB_TARGET).so \
			$(@D)/usr/lib/lib$${lib}.so; \
		rm -f		 $(@D)/usr/lib/lib$${lib}.so.1; \
		ln -sf lib$${lib}-$(GPU_VIV_WL_BIN_MX6S_LIB_TARGET).so \
			$(@D)/usr/lib/lib$${lib}.so.1; \
	done
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so.1
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so
endef

define GPU_VIV_WL_BIN_MX6S_INSTALL_STAGING_CMDS
	cp -r $(@D)/usr/* $(STAGING_DIR)/usr
endef

ifeq ($(BR2_PACKAGE_GPU_VIV_WL_BIN_MX6S_EXAMPLES),y)
define GPU_VIV_WL_BIN_MX6S_INSTALL_EXAMPLES
	mkdir -p $(TARGET_DIR)/usr/share/examples/
	cp -r $(@D)/opt/* $(TARGET_DIR)/usr/share/examples/
endef
endif

# On the target, remove the unused libraries.
# Note that this is _required_, else ldconfig may create symlinks
# to the wrong library
define GPU_VIV_WL_BIN_MX6S_INSTALL_TARGET_CMDS
	$(GPU_VIV_WL_BIN_MX6S_INSTALL_EXAMPLES)
	cp -a $(@D)/usr/lib $(TARGET_DIR)/usr
	for lib in EGL GAL VIVANTE; do \
		for f in $(TARGET_DIR)/usr/lib/lib$${lib}-*.so; do \
			case $$f in \
				*-$(GPU_VIV_WL_BIN_MX6S_LIB_TARGET).so) : ;; \
				*) $(RM) $$f ;; \
			esac; \
		done; \
	done
endef

$(eval $(generic-package))
