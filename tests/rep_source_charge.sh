#! /bin/bash

#Test sur un repertoire source ne contenant pas seulement des fichiers images

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr dest
mkdir -p dest
rm image1.jpg
rm image2.jpg

make-img.sh image1.jpg
make-img.sh image2.jpg

galerie-shell.sh --source . --dest dest

if [ -f dest/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi
