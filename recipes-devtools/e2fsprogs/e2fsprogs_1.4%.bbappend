inherit upx_compress

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://005-misc-rename-copy_file_range-to-copy_file_chunk.patch \
"

EXTRA_OECONF += "--enable-defrag"

do_install_append() {
	if [ -e ${D}${base_sbindir}/e4defrag ]; then
		install -d ${D}${sbindir}
		mv ${D}${base_sbindir}/e4defrag ${D}${sbindir}/e4defrag
	fi
}

PACKAGES =+ "e2fsprogs-e4defrag"
FILES_e2fsprogs-e4defrag = "/usr/sbin/e4defrag"
