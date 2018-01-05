#! /bin/bash
#. /make-img.sh
html_head () {
    echo -e '<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv="content-type" content="text/html; charset=utf-8" />'
    cat << EOF
    <style type="text/css">
    header {
    text-align: center;
    }
    body {
        background-color: #f2f6df;
    }

    .imgframe {
        float: left;
        background-color: white;
        border: dashed 1px #BDDDBB;
        margin: 1ex;
        padding: 1ex;
        text-align:center;
    }

    .image {
        margin: 1ex;
        border: solid 1px lightgrey;
    }

    .legend {
        font-style:italic;
        color: #002000;
    }
    </style>
EOF
    if [ $# != 0 ]; then
      echo "<title> $1 </title>"
    fi
    echo -e "</head>\n<body>"
}

html_title () {
    echo "<h1> $1 </h1>"
}

html_tail () {
    cat << EOF

    <div style="clear: both; text-align: center;">
      <p>
        <a href="https://validator.w3.org/nu/#file"><img #ne marche pas car page non hebergée
            src="http://www.w3.org/html/logo/downloads/HTML5_Logo_64.png"
            alt="Valid HTML 5"></a>
      </p>
    </div>
EOF
    echo -e "</body>\n</html>"
}

generate_img_fragment () {
fichier=$(basename "$1")
  if [[ "$fichier" == *.jpg ]]; then
    date=$(identify -verbose "$fichier" | grep "date:c" | cut -c17-27)
    nom=$(identify -verbose "$fichier" | grep "name" | cut -c15-)
    echo -e '\n<div class="imgframe">'
    echo "<a href=$fichier.html><img class=\"image\" src=$fichier alt=$nom></a>"
    echo "<span class=\"legend\">$nom $date</span>"
    echo "</div>"
  fi
}


galerie_main () {                                                                                   #$1 = force
  if [[ $5 == 1 ]];then #verbose                                                                     $2 = source
    echo "Appelle de la fonction generer_vignettes"                                                 #$3 = dest
  fi
  if [[ "$7" != 0 ]] && [[ "$7" != 1 ]];then # si on est en mode parallélisme -n
    generer_vignettes_opti "$1" "$2" "$3" "$5" "$7"                                                   #4=index
  else                                                                                                #5 = verbose
    generer_vignettes "$1" "$2" "$3" "$5"                                                             #6 = open
  fi                                                                                                   #7 = processeurs
  if [[ $5 == 1 ]];then #verbose
    echo "Génération d'une page html individuelles pour chaque image"
  fi
  generer_html_image "$2" "$3" "$4" # dans destination
  cd "$3" || exit #on rentre dans la destination qui contient les vignettes créées
  if [[ "$5" == 1 ]];then #verbose
    echo Appelle de la fonction "html_head" dans "$4"
  fi
  html_head "Galerie d'images" > "$4"
  html_title "Galerie de Tomy et Theo" >> "$4"
  for vignette in *.jpg;do #seulement les images de la destination
    generate_img_fragment "$vignette" >> "$4"
    if [[ $5 == 1 ]];then #verbose
      echo "Ecriture du code html pour la vignette $vignette dans $4"
    fi
  done
  html_menu_deroulant_head >> "$4"
  for page in *.jpg.html;do
    html_menu_deroulant_body "$page" >> "$4"
  done
  temp="$4" #juste pour une erreur shell check mais inutile
  html_menu_deroulant_tail "$temp" >> "$4"
  if [[ $5 == 1 ]];then #verbose
    echo Appelle de la fonction "html_tail" dans "$4"
  fi
  html_tail >> "$4"
  if [[ "$6" == 1 ]]; then # Paramètre --open ouvre le html
    firefox "$4" &
  fi
  cd ..
}


generer_vignettes () { #Génère les vignettes de source dans le répertoire destination en gérant "force"
  for elt in "$2"/*.jpg;do #elt image de la source
    if [[ "$1" == 1 ]] || ! [ -f "$3"/"$(basename "$elt")" ];then #force est sur 1 ou le fichier n'existe pas
      gmic "$elt" -cubism , -resize 200,200 -output "$3"/"$(basename "$elt")"
      if [[ $4 == 1 ]];then #verbose
        echo génération de la vignette "$(basename "$elt")" de "$2" dans "$3"
      fi
    fi
  done
}


generer_vignettes_opti () { #Génère les vignettes de source dans le répertoire destination en gérant "force"
  chaine=''
  compteur=0
  for elt in "$2"/*.jpg;do #elt image de la source
    if ( [[ "$1" == 1 ]] || ! [ -f "$3"/"$(basename "$elt")" ] ) && [ "$compteur" -lt "$5" ];then #force est sur 1 ou le fichier n'existe pas et pas encore 4 vignettes
      chaine=$chaine"$elt -cubism , -resize 200,200 -output $3/$(basename "$elt") " #concaténation des ARGUMENTS passé dans gmic
      compteur=$((compteur+1))
    elif ( [[ "$1" == 1 ]] || ! [ -f "$3"/"$(basename "$elt")" ] ) && [ "$compteur" -eq "$5" ];then
      echo "$chaine" | xargs -n 7 -P "$5" gmic
      chaine="$elt -cubism , -resize 200,200 -output $3/$(basename "$elt") "
      compteur=0
    fi
  done
  if [ "$chaine" != '' ];then
    echo "$chaine" | xargs -n 7 -P "$5" gmic
  fi
  if [[ $4 == 1 ]];then #verbose
    echo génération de vignettes en parallèle "$5" par "$5"
  fi
}



generer_html_image () {
  for elt in "$1"/*.jpg;do
    image="$(basename "$elt")"
    if ! [ -f "$2"/"$image".html ]; then #si la page html n'existe pas déja dans dest
      DIR=$(cd "$(dirname "$elt")" && pwd)
      html_head "Image unique" > "$2"/"$image".html
      html_title "$image" >> "$2"/"$image".html
      echo "<img src=$DIR/$image alt=$image><br>" >> "$2"/"$image".html # chemin absolu de l'image !
      html_menu_deroulant_head >> "$2"/"$image".html #creation des menus déroulant pour les pages html des images seules
      for futur_html in "$1"/*;do
        if [[ "$futur_html" == *.jpg ]] && [ "$futur_html" != "$elt" ]; then #On enlève le lien vers la page où l'on se trouve déjà
          html_menu_deroulant_body "$futur_html".html >> "$2"/"$image".html
        fi
      done
      html_menu_deroulant_tail "$3" >> "$2"/"$image".html
      html_tail >> "$2"/"$image".html
    fi
  done
}



html_menu_deroulant_head () {
  echo "<FORM>"
  echo "  <SELECT onChange="
  echo '    "document.location=this.options[this.selectedIndex].value">'
  echo '    <OPTION VALUE="#" SELECTED>     CHOISIR     </OPTION>'

}

html_menu_deroulant_body () {
  nom="$(basename "${1%.*}")"
  location="$(basename "$1")"
  echo "    <OPTION VALUE=$location>$nom</OPTION>"
}

html_menu_deroulant_tail () {
  echo "    <OPTION VALUE=$1>Retour</OPTION>"
  echo -e "  </SELECT>\n</FORM>"

}
