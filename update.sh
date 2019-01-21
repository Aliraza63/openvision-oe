#!/bin/sh
if [ $# -eq 0 ]
then
	BUILDDIR="build"
else
	BUILDDIR="$1"
fi
echo ""
echo "Open Vision by"
echo "https://github.com/orgs/OpenVisionE2/people"
echo ""
echo "Each time you run this script all git repositories will get updated to their latest versions!"
echo ""
echo "For extra RC support you need to add your STB files to https://github.com/OpenVisionE2/extra_rc_models"
echo ""
echo "Updating from git, please wait ..."
echo ""
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}"
git pull
git submodule sync
git submodule update --init
echo ""
echo "Done!"
echo ""
METAS="$( ls | grep meta- | tr '\n' ' ' | sed 's/ $//g' )"
cd ..
find -maxdepth 1 -name "Makefile" -type f -exec sed -i 's/DISTRO = "openpli"/DISTRO = "openvision"/g' {} \;
find -maxdepth 1 -name "Makefile" -type f -exec sed -i 's/openpli.conf/openvision.conf/g' {} \;
find -maxdepth 1 -name "Makefile" -type f -exec sed -i 's/bitbake openpli/bitbake openvision/g' {} \;
echo "Let us fix the image names ..."
echo ""
find -maxdepth 1 -name "meta-a*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-e*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-f*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-g*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-m*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-qv*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-s*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-v*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-x*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
find -maxdepth 1 -name "meta-z*" -type d -exec find {} -type f \( -iname \*.conf -o -iname \*.inc \) \; | xargs -L1 sed -i 's|${DISTRO_NAME}-${DISTRO_VERSION}-${MACHINE}|${IMAGE_NAME}|g'
echo "Done!"
echo ""
echo "Check for dm7020hdv2 required changes ..."
if grep -Fqi "DMTYPE" Makefile
then
    echo ""
    echo "No need to modify Makefile."
    echo "You can compile dm7020hdv2 image too."
    echo ""
else
    echo ""
    echo "We need to modify Makefile ..."
    find -maxdepth 1 -name "Makefile" -type f -exec sed -i 's/$(MACHINE)/$(MACHINE)$(DMTYPE)/g' {} \;
    find -maxdepth 1 -name "Makefile" -type f -exec sed -i 's/"MACHINE"/"MACHINE DMTYPE"/g' {} \;
    find -maxdepth 1 -name "Makefile" -type f -exec sed -i "s/.@echo 'export MACHINE' >> $@.*/&\n\t@echo 'export DMTYPE' >> \$\@/" {} \;
    cat openvision-oe/dm7020hdv2-changes >> Makefile
    rm -f ${BUILDDIR}/env.source
    echo "Done, now you can compile dm7020hdv2 image too."
    echo ""
fi
# Regenerate bblayers.conf so we can add our own
rm -f ${BUILDDIR}/conf/bblayers.conf
make init update
# Remove existing meta-dream and meta-axasuhd from bblayers.conf
sed -i "s# $(pwd)/meta-dream##g" ${BUILDDIR}/conf/bblayers.conf
sed -i "s# $(pwd)/meta-axasuhd##g" ${BUILDDIR}/conf/bblayers.conf
for i in ${METAS}
do
    echo "BBLAYERS_append = \" ${SCRIPTPATH}/${i}\"" >> ${BUILDDIR}/conf/bblayers.conf
done
echo "BBLAYERS_append = \" ${SCRIPTPATH}\"" >> build/conf/bblayers.conf
rm -rf meta-openpli/recipes-extended/tzdata
