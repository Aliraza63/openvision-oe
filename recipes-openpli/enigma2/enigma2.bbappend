FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
        ${@bb.utils.contains("TARGET_ARCH", "sh4", "", "file://enigma2_bh_skin_support.patch", d)} \
	${@bb.utils.contains("TARGET_ARCH", "sh4", "", "git://github.com/PLi-metas/extra_rc_models.git;destsuffix=extra_rc_models;name=extra_rc_models", d)} \
        "

SRCREV[extra_rc_models] = "${AUTOREV}"
SRCREV_FORMAT = "enigma2"

do_configure_prepend() {
	if [ ! "${TARGET_ARCH}" == "sh4" ]
	then
		# Restore the files first in case we run configure twice between checking out the source
		git --git-dir="${S}/.git" --work-tree="${S}" checkout "${S}/data/rc_models/Makefile.am"
		git --git-dir="${S}/.git" --work-tree="${S}" checkout "${S}/data/rc_models/rc_models.cfg"
		for i in $(find "${WORKDIR}/extra_rc_models" -type f -name "*.xml" -o -name "*.png" -o -name "*.jpg")
		do
			file="$(echo "${i}" | sed 's:.*/::')"
			sed -i '${s/$/'" $file"'/}' "${S}/data/rc_models/Makefile.am"
			cp -f "${i}" "${S}/data/rc_models/"
		done
		cat "${WORKDIR}/extra_rc_models/rc_models.cfg" >> "${S}/data/rc_models/rc_models.cfg"
	fi
}
