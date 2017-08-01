#!/bin/bash
$fm_import    # import file manager variables 



if [ ${#fm_files[@]} -eq 0 ]; then
    SVN_STATE="svn status $fm_pwd"
else
    SVN_STATE="svn status ${fm_filenames[@]}"
fi

FILES=$($SVN_STATE | grep -v "^?" | tr -s " " " " | cut -f 2 -d" " | xargs -I % echo -n \'%\',\  | sed -r "s/, $//g")
MSG=""

NEW_FILES=$($SVN_STATE | grep "^?" | tr -s " " " " | cut -f 2 -d" " | xargs -I % echo -n \'%\',\  | sed -r "s/, $//g")
if [ -n "$NEW_FILES" ]; then
    MSG+="There are unversioned files you might want me to add before comitting: $NEW_FILES\nAdd unversioned files before commit?"
    eval "`spacefm -g --label "$MSG"  --button yes --button no`"
    if [[ "$dialog_pressed" == "button1" ]]; then
        svn add $NEW_FILES &> /dev/null
        FILES=$($SVN_STATE | tr -s " " " " | cut -f 2 -d" " | xargs -I % echo -n \'%\',\  | sed -r "s/, $//g")
    fi
fi

if [ -z "$FILES" ]; then
    MSG="No changes to commit. "
    spacefm -g --label "$MSG"  --button ok &>/dev/null
    exit 0
fi

eval "`spacefm -g --label "Enter commit message for $FILES" --button ok --button cancel --input "commit message"`"
if [[ "$dialog_pressed" == "button2" ]]; then
    exit 0
fi

[ ${#fm_files[@]} -eq 0 ] \
&& svn commit "$fm_pwd" -m "$dialog_input1" \
|| svn commit "${fm_files[@]}" -m "$dialog_input1"

exit $?