DESCRIPTION = "Open Vision version info"
SECTION = "base"
PRIORITY = "required"
MAINTAINER = "Open Vision Developers"
require conf/license/license-gplv2.inc

PV = "${VISIONVERSION}"
PR = "${VISIONREVISION}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "file://settings file://openvision-remover.sh"

FILES_${PN} = "/etc /usr"

INHIBIT_PACKAGE_STRIP = "1"

ALLOW_EMPTY_${PN} = "1"

S = "${WORKDIR}"

PACKAGES = "${PN}"

do_install() {
			if [ "${DISTRO_TYPE}" = "experimental" ] ; then
				BUILDTYPE="1"
			else
				BUILDTYPE="0"
			fi
			install -d ${D}/etc
			echo "STB=${MACHINE}" > ${D}/etc/image-version
			echo "build_type=${BUILDTYPE}" >> ${D}/etc/image-version
			echo "version=${VISIONVERSION}-${VISIONREVISION}" >> ${D}/etc/image-version
			echo "build=${VISIONREVISION}" >> ${D}/etc/image-version
			echo "Python=2.7" >> ${D}/etc/image-version
			echo "date=${DATETIME}" >> ${D}/etc/image-version
			echo "comment=Open Vision" >> ${D}/etc/image-version
			echo "target=9" >> ${D}/etc/image-version
			echo "creator=Open Vision Developers" >> ${D}/etc/image-version
			echo "url=http://openvision.tech" >> ${D}/etc/image-version
			echo "catalog=https://github.com/OpenVisionE2" >> ${D}/etc/image-version
			install -d ${D}${sysconfdir}/enigma2
			install -m 0755 ${WORKDIR}/settings	${D}${sysconfdir}/enigma2
			install -d ${D}/usr/share/enigma2/picon
			install -d ${D}${sysconfdir}/init.d
			install -m 0755 ${WORKDIR}/openvision-remover.sh ${D}${sysconfdir}/init.d
			install -d ${D}${sysconfdir}/rcS.d
			ln -sf ../init.d/openvision-remover.sh ${D}${sysconfdir}/rcS.d/S02openvision-remover.sh
}
