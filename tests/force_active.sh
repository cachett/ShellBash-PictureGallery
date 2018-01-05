#! /bin/bash

#Test avec le mode force
#On voit dans le terminal que la date donnée par Modify a changé

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

./simple_v2.sh
stat dest/image1.jpg
avant=$(stat dest/image1.jpg)
sleep 2
galerie-shell.sh --source source --dest dest --force
stat dest/image1.jpg
apres=$(stat dest/image1.jpg)

if [ -f dest/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi

if [[ "$avant" != "$apres" ]];then
  echo "Le programme regénère bien les vignettes"
else
  echo "Oops, force a échoué"
fi
