#!/bin/bash
$fm_import    # import file manager variables

# svn status

echo -n "svn status "
if [ ${#fm_files[@]} -eq 0 ]; then
	echo for "$fm_pwd":
	echo –––
	svn status "$fm_pwd" 
else
	echo for $(find "${fm_filenames[@]}" -maxdepth 0 | xargs -I % echo -n \'%\',\  | sed -r "s/, $//g"):
	echo –––
	svn status "${fm_files[@]}"
fi
echo –––

exit $?
