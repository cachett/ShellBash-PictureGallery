#! /bin/bash

#Test sans le mode force
#On voit dans le terminal que l'heure affichée par Modify ne change pas entre les 2 exécutions

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

./simple_v2.sh
stat dest/image1.jpg
avant=$(stat dest/image1.jpg)
sleep 2
galerie-shell.sh --source source --dest dest
stat dest/image1.jpg
apres=$(stat dest/image1.jpg)

if [ -f dest/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi

if [[ "$avant" == "$apres" ]];then
  echo "Le programme ne re-génére pas les vignettes"
else
  "Oops, force a échoué"
fi
