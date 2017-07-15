#!/bin/bash

if [ -z "$1" ]; then
    echo '> Feed me a file!'
    exit
else
    FILE=$1
fi

PAGES=$(pdftk $FILE dump_data | grep NumberOfPages | sed 's/[^0-9]*//')

# One paper contains four pdf pages - two on the front, and two on the back side
PAGES_ON_PAPER=4

if [ -z "$2" ]; then
    # One block has five piece of paper (to work without blocks, set this value to $PAGES)
    PAPER_IN_BLOCK=5
    echo '> No value for paper blocks given - set to default(5)'
else
    # One block has five piece of paper (to work without blocks, set this value to $PAGES)
    PAPER_IN_BLOCK=$2
    echo '> '$PAPER_IN_BLOCK' paper per block set'
fi

# Total amount of pages in one block
PAGES_IN_BLOCK=$(echo $PAGES_ON_PAPER"*"$PAPER_IN_BLOCK | bc)


function 2nup {
    local PAGE_NUM=$1
    local START_AT=$(echo $PAGES_IN_BLOCK"*"$2 | bc)

    # declare array
    declare -a nup=()

    local COUNTER=0
    local ITERATE_TO=$(echo $PAGE_NUM"/2" | bc)
    while [[ $COUNTER -lt $ITERATE_TO ]]; do
        nup=("${nup[@]}" $(echo $START_AT"+"$PAGE_NUM"-"$COUNTER | bc))
        nup=("${nup[@]}" $(echo $START_AT"+"$COUNTER"+1" | bc))
        nup=("${nup[@]}" $(echo $START_AT"+"$COUNTER"+2" | bc))
        nup=("${nup[@]}" $(echo $START_AT"+"$PAGE_NUM"-"$COUNTER"-1" | bc))
        let COUNTER=COUNTER+2
    done

    echo ${nup[@]}
}

# Calculate the amount of needed paper
PAPER=$(echo $PAGES"/"$PAGES_ON_PAPER | bc)
PAPER_ADD=$(echo $PAGES"%"$PAGES_ON_PAPER | bc)
HELPER=$(echo $PAPER_ADD"+"$PAGES | bc)

if ! (( $PAPER_ADD == 0 )); then
    echo 'Next possible pagenumber is '$HELPER
    echo 'Bye ...'
    exit
else
    #echo $PAPER' pieces of paper will be printed with '$PAGES_ON_PAPER' pages on each!'

    # How many full Blocks do we have
    FULL_BLOCKS=$(echo $PAPER"/"$PAPER_IN_BLOCK | bc)
    #echo $FULL_BLOCKS' full blocks'

    # How many piece of paper remain in the not full block
    REMAINING_PAPER=$(echo $PAPER"%"$PAPER_IN_BLOCK | bc)
    #echo $REMAINING_PAPER' paper(s) not full block'
    REMAINING_PAGES=$(echo $REMAINING_PAPER"*"$PAGES_ON_PAPER | bc)
    #echo $REMAINING_PAGES' remaining'

    # Declare output array
    declare -a NUP_ARR=()

    # Calculate page order for full blocks
    C_FUL=0
    while [[ $C_FUL -lt $FULL_BLOCKS ]]; do
        NUP_ARR=("${NUP_ARR[@]}" $(2nup $PAGES_IN_BLOCK $C_FUL))
        let C_FUL=C_FUL+1
    done

    # Calculate page order for not full blocks
    NUP_ARR=("${NUP_ARR[@]}" $(2nup $REMAINING_PAGES $FULL_BLOCKS))

    # print my nup array!
    echo '> Created 2nup array with blocks of '$PAPER_IN_BLOCK
    #echo ${NUP_ARR[@]}


    # -----------------------------------------
    # From this point on we only work with pdfs
    # -----------------------------------------

    # Cut extension
    FILENAME=$(echo $FILE | rev | cut -d '.' -f 2 | rev)

    # Create a working dir
    mkdir ./tmp
    cp $FILE ./tmp
    cd ./tmp

    # Reorder pdf pages with our created nup array :)
    pdftk $FILE cat $echo ${NUP_ARR[@]} output $FILENAME-RE.pdf

    # Merge n sites on one page
    pdfnup -n 2 $FILENAME-RE.pdf

    # Remove copied pdf
    rm $FILE
    rm $FILENAME-RE.pdf

    # Pdfnup creates duplets, save even pages to new file
    pdftk $FILENAME-RE-2up.pdf cat 1-endeven output ../booklet-n.pdf

    # Remove original -2up.pdf file
    rm $FILENAME-RE-2up.pdf

    # Cleanup
    cd ..
    rm -r ./tmp

    # U still here?!
    echo '> Done'

    # Go sleep yourself!
    exit
fi

