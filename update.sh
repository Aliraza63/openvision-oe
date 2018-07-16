#!/bin/sh
echo ""
echo "pli-extras by MastaG, Persian Prince and Hains"
echo ""
echo "https://github.com/PLi-metas"
echo ""
echo "Each time you run this script all git repositories will get updated to their latest versions!"
echo ""
echo "For extra rc support you need to add your STB files to https://github.com/PLi-metas/extra_rc_models"
echo ""
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}"
git pull
git submodule sync
git submodule update --init
METAS="$( ls | grep meta- | tr '\n' ' ' | sed 's/ $//g' )"
cd ..
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
    cat pli-extras/Makefile-dm7020hdv2 >> Makefile
    echo "Done, now you can compile dm7020hdv2 image too."
    echo ""
fi
# Regenerate bblayers.conf so we can add our own
rm -f build/conf/bblayers.conf
make init update
# Remove existing meta-dream from bblayers.conf
sed -i "s# $(pwd)/meta-dream##g" build/conf/bblayers.conf
for i in ${METAS}
do
	sed -E -i "s%^(BBLAYERS =.*)(\"$)%\1 ${SCRIPTPATH}/${i}\"%g" build/conf/bblayers.conf
done
sed -E -i "s%^(BBLAYERS =.*)(\"$)%\1 ${SCRIPTPATH}\"%g" build/conf/bblayers.conf
