#!/bin/bash
RED_CD="\033[0;31m"
GREEN_CD="\033[0;32m"
NORMAL_CD="\033[0m"
export FAIL_STRING="@@failure@@"
export PASS_MSG="$GREEN_CD ✔ Pass $NORMAL_CD"
export FAIL_MSG="$RED_CD ✘ Fail $NORMAL_CD"

start_tst()
{
    FAILED=0
    declare -a tsts=("${!1}")
    spacer=''
    echo ""
    if [ ! -z "$2" ]; then
        for ((i=0;i<=$2;i++));do spacer="$spacer "; done;
    fi
    for (( i=0; i<${#tsts[@]}; i=$i+2 ));
    do
        test=${tsts[$i]}
        test_name=${tsts[$i+1]}
        echo -ne "$spacer"[$(($i/2+1))/$((${#tsts[@]}/2))] ${test_name} ""
        
        if eval "$test"; then
            echo -ne "$PASS_MSG\r\n"
        else
            FAILED=$(($FAILED+1))
            echo -ne "$FAIL_MSG ("$test")\r\n"
        fi
    done
    if [[ $FAILED -gt 0 ]]; then
        echo "$FAILED failed tests."
        exit 1
    fi
}

export start_test