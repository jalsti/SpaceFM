#!/bin/bash
$fm_import    # import file manager variables 


if [ ${#fm_files[@]} -eq 0 ]; then
    FMFILES="$fm_pwd"
else
    FMFILES="${fm_filenames[@]}"
fi
SVN_STATE="svn status "$FMFILES""

FILELIST=$(mktemp)
NEW_FILES=$($SVN_STATE | grep "^?" | sed -r "s/^\? +//g" | xargs -I % echo -n %\\n)

if [ -n "$NEW_FILES" ]; then
    echo -e $NEW_FILES > $FILELIST
    eval "`spacefm -g --label --nowrap "There are unversioned files you might want me to add before comitting:" \
            --viewer --scroll $FILELIST \
            --label "Add unversioned files before commit?"  \
            --button yes --button no`"
    if [[ "$dialog_pressed" == "button1" ]]; then
        svn add $($SVN_STATE | grep "^?" | sed -r "s/^\? +//g")
    fi
fi

FILES=$($SVN_STATE | grep -ve "^?" | xargs -I % echo -n %\\n)

if [ -z "$FILES" ]; then
    spacefm -g  --hbox --icon messagebox_info --label "No changes to commit."  --button close &>/dev/null
    rm $FILELIST
    exit 0
fi

echo -e $FILES > $FILELIST
TEMPMESSAGE="commit message"
eval "`spacefm -g --label --nowrap "Enter commit message for:" \
        --viewer $FILELIST \
        --vbox --compact --input "$TEMPMESSAGE"      \
        --button ok --button cancel`"
if [[ "$dialog_pressed" == "button2" ]]; then
    rm $FILELIST
    exit 0
fi

if [ "$dialog_input1" == "$TEMPMESSAGE" ] || [ -z "$(echo $TEMPMESSAGE | sed "s/\s//g")" ]; then
    spacefm -g --hbox \
            --icon messagebox_warning \
            --label --nowrap  "Cowardly rejecting commits without real message.\n(This means nothing was commited.)" \
            --button close &>/dev/null
    rm $FILELIST
    exit 0
fi

svn commit $FMFILES -m "$dialog_input1"
RES=$?
rm $FILELIST

exit $RES