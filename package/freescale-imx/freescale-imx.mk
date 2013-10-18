################################################################################
#
# freescale-imx
#
################################################################################

FREESCALE_IMX_VERSION = 3.5.7-1.0.0

# No official download site from freescale, just this mirror
FREESCALE_IMX_MIRROR_SITE   = http://download.ossystems.com.br/bsp/freescale/source

include $(sort $(wildcard package/freescale-imx/*/*.mk))
