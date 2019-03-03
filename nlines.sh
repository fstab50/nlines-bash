#!/usr/bin/env bash

##
##  nlines:
##     - Estimates total number of lines in files
##     - See nlines-completion.bash located in .bash_completion.d
##

CONFIG_DIR="$HOME/.config/bash"

# formatting
source "$CONFIG_DIR/colors.sh"
bd=$(echo -e ${bold})
bdwt=$(echo -e ${bold}${a_brightwhite})
bgf=$(echo -e ${greenbold_frame})
bg=$(echo -e ${a_brightgreen})
obf=$(echo -e ${bold}${a_orange})
bbf=$(echo -e ${pv_bluebold})
bcy=$(echo -e ${cyan})
wbf=$(echo -e ${whitebold_frame})
wgc=$(echo -e ${wa_gray})                  # white gray
datec=$(echo -e ${blue})
rst=${reset}


function nlines(){
    ##
    ## length in lines of file provided as parameter
    ##
    local sum='0'
    local pwd=$PWD

    function help_menu(){
        printf -- '\n\t%s\n\n\t\t%s  %s\n' "${bdwt}Count the Number Lines of Code${rst} (total lines of text):" \
                "${bd}\$${rst} ${cyan}nlines${rst} ${bd}<${rst}filename${bd}>${rst}" "${bd}<${rst}directory${bd}>${rst}"
        printf -- '\n\t\t\t%s\n' "[ --help ]"
        printf -- '\n\t%s\n\n' "${rst}If directory given, sums lines in files contained within${rst}"
        return 0
    }

    function print_object(){
        local object="$1"
        local twidth='42'
        local owidth=${#object}
        local sp

        if [ $owidth -ge 34 ]; then
            printname=${object::34}
        else
            printname=$object
        fi

        sp=$(( $twidth - ${#printname} ))

        printf -- "\t%s %${sp}s\n" "$printname" "$(cat $object | wc -l)"
        return 0
    }

    function sum_directory(){
        local dir="$1"

        cd $dir || exit 1
        for i in *; do
            if [ -f $i ]; then
                sum=$(( $sum + $(cat $i | wc -l) ))
                print_object "$i"
            fi
        done
        cd ../
    }

    if [[ ! "$@" ]]; then
        help_menu

    else
        while [ $# -gt 0 ]; do
            case "$1" in

                -h | --help)
                    help_menu
                    shift 1
                    ;;

                *)
                    if [ -f "$1" ]; then
                        # is file object
                        sum=$(( $sum + $(cat $1 | wc -l) ))
                        print_object "$1"
                        shift 1

                    elif [ -d "$1" ]; then
                        # is directory
                        pwd=$PWD
                        cd $1 || exit 1
                        for i in *; do
                            if [ -f $i ]; then
                                sum=$(( $sum + $(cat $i | wc -l) ))
                                print_object "$i"
                            elif [ -d $i ]; then
                                sum_directory "$i"
                            fi
                        done
                        cd $pwd || exit 1
                        shift 1
                    fi
                    ;;
            esac
        done
        sp='56'
        printf -- '\t%s\n' "-------------------------------------------"
        printf -- "\t%s %${sp}s\n" "${bd}Total${rst}:" "${bbf}$sum${rst}"
    fi
}

nlines "$@"

exit 0
