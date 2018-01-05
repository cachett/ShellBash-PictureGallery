#! /bin/bash

#Test le temps d'execution avec et sans le mode parallele
#En regardant la sortie de time perl dans le terminal on voit bien que

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

echo "génération de la galerie dans un premier temps"
./simple_v2

echo "temps de génération des vignettes sans utiliser le parallélisme"
time (galerie-shell.sh --source source --dest dest -f -n 1)
echo "temps de génération des vignettes en utilisant 4 coeurs"
time (galerie-shell.sh --source source --dest dest -f -n 4) #par défaut
echo "gain de temps de environ 0.6s sur 1,5s pour deux vignettes (augmente avec le nombre de vignettes)"
