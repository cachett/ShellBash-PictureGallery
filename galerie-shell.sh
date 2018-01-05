#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
#shellcheck source=./utilities.sh
. "$DIR"/utilities.sh



usage () {
    cat << EOF
Utilisation: $(basename "$0") [options]
Options: --help, -h          Ce message daide
         --source, -s DIR    Choisir le répertoire source (chemin)
         --dest, -d DIR      Choisir le répertoire ciblé (chemin)
         --verb, -v          Explique ce qui se passe
         --index, -i FILE    Ecrit dans FILE.html à la place de index.html
         --force, -f         Force la création de vignettes
         --open, -o          Ouvre la galerie après sa création
         -n X                X étant le nombre de coeur de la machine
                             (4 par défaut). Choisir X=0 ou X=1 pour le desactiver.
EOF
}

verbose=0
force=0
open=0
proc=4
index=index.html
while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
        "--source"|"-s")
            shift; rep_source="$1"
            ;;
        "--dest"|"-d")
            shift; rep_dest="$1"
            ;;
        "--verb"|"-v")
            verbose=1
            ;;
        "--index"|"-i")
            shift;
            if [[ "$1" == -* ]];then
              usage
              exit 1
            else
              index="$1".html
            fi
            ;;
        "--force"|"-f")
            force=1
            ;;
        "--open"|"-o")
            open=1
            ;;
        "-n")
        shift;
        if [[ "$1" == -* ]];then
          usage
          exit 1
        else
          proc="$1"
        fi
            ;;

        *)
            echo "Argument non reconnu : $1"
            usage
            exit 1
            ;;
    esac
    shift # DECALE LES ARGUMENTS
done

if [ "$rep_source" = "" ] || [ "$rep_dest" = "" ]; then
    echo "Il manque un argument"
    usage; exit 1
fi

galerie_main "$force" "$rep_source" "$rep_dest" "$index" "$verbose" "$open" "$proc"
