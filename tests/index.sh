#! /bin/bash

#Test la gestion de l'argument index

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

galerie-shell.sh --source source --dest dest --index nouveau_nom

if [ -f dest/nouveau_nom.html ]
then
    echo "Now run 'firefox dest/nouveau_nom.html' to check the result"
else
    echo "ERROR: dest/nouveau_nom.html was not generated"
fi
