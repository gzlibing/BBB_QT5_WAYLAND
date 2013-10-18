################################################################################
#
# libfslvpuwrap
#
################################################################################

LIBFSLVPUWRAP_VERSION = 3.5.7-1.0.0
# No official download site from freescale, just this mirror
LIBFSLVPUWRAP_SITE = http://download.ossystems.com.br/bsp/freescale/source
LIBFSLVPUWRAP_SOURCE  = libfslvpuwrap-${IMX_LIB_VERSION}.bin
LIBFSLVPUWRAP_LICENSE = Freescale Semiconductor Software License Agreement
LIBFSLVPUWRAP_LICENSE_FILES = EULA.txt
LIBFSLVPUWRAP_REDISTRIBUTE = NO

LIBFSLVPUWRAP_INSTALL_STAGING = YES

LIBFSLVPUWRAP_DEPENDENCIES += imx-lib


define LIBFSLVPUWRAP_EXTRACT_CMDS
        (cd $(BUILD_DIR); \
                sh $(DL_DIR)/$(LIBFSLVPUWRAP_SOURCE) --force --auto-accept)
endef

$(eval $(autotools-package))
