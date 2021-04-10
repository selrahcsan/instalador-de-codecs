#!/bin/bash

[ ! "${EUID}" = "0" ] && {
  echo "Execute esse script como root:"
  echo
  echo "  sudo ${0}"
  echo
  exit 1
}

HERE="$(dirname "$(readlink -f "${0}")")"

working_dir=$(mktemp -d)

mkdir -p "${working_dir}/usr/bin"                     \
         "${working_dir}/usr/share/applications/"     \
         "${working_dir}/usr/share/mime/application/" \
         "${working_dir}/DEBIAN"

cp "${HERE}/src/wrapper-codecs.sh"            "${working_dir}/usr/bin"
cp "${HERE}/src/codecs-installer.desktop"     "${working_dir}/usr/share/applications/"
cp "${HERE}/src/vnd.apple-dmg-compressed.xml" "${working_dir}/usr/share/mime/application/"

chmod a+x "${working_dir}/usr/bin/wrapper-codecs.sh"

(echo "Package: instalador-de-codecs"
 echo "Priority: optional"
 echo "Version: 1.0"
 echo "Architecture: all"
 echo "Maintainer: Natanael Barbosa Santos"
 echo "Depends: yad"
 echo "Description: $(cat ${HERE}/README.md  | sed -n '1p')"
 echo
) > "${working_dir}/DEBIAN/control"

dpkg -b ${working_dir}
rm -rfv ${working_dir}

mv "${working_dir}.deb" "${HERE}/instalador-de-codecs.deb"

chmod 777 "${HERE}/instalador-de-codecs.deb"
chmod -x  "${HERE}/instalador-de-codecs.deb"


