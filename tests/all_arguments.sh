#! /bin/bash

#Teste avec les 3 arguments différents imposés

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

galerie-shell.sh --source source --dest dest --index nouveau_nom --force --verb

if [ -f dest/nouveau_nom.html ]
then
    echo "Now run 'firefox dest/nouveau_nom.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi
