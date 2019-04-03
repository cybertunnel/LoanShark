#!/bin/bash

VERSION=`date +%Y%m%d%H%M`

# Get the absolute path of the directory containing this script
# https://unix.stackexchange.com/questions/9541/find-absolute-path-from-a-script

dir=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)

# Every use should have read rights and scripts should be executable

/bin/chmod -R o+r "${dir}/payload/"
/bin/chmod +x "${dir}/scripts"

/usr/bin/find "${dir}" -name .DS_Store -delete

# Build package

/usr/bin/pkgbuild --root "${dir}/payload" \
	 --scripts "${dir}/scripts" \
	 --identifier com.github.cybertunnel.LoanShark.Installer \
	 --version ${VERSION} \
	 --component-plist "${dir}/LoanShark-component.plist" \
	 "${dir}/LoanSharkInstaller-${VERSION}.pkg"
