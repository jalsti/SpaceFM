#!/bin/bash
$fm_import    # import file manager variables 


DIFFTOOL=""
if [ ${#fm_files[@]} -eq 1 ]; then
	DIFFTOOL=$(which meld || which kdiff3)

	if [ -n "$DIFFTOOL" ]; then
		DIFFTOOL="--diff-cmd $DIFFTOOL"
	fi
fi

[ ${#fm_files[@]} -eq 0 ] \
&& (svn diff -rPREV "$fm_pwd" $DIFFTOOL || svn diff -rPREV "$fm_pwd")  \
|| (svn diff -rPREV "${fm_files[@]}" $DIFFTOOL || svn diff -rPREV "${fm_files[@]}")

exit $?