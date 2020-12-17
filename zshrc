# Showing VCS/virtualenv infos in your prompt

# get the name of the current git HEAD
function git_ref {
# the first git command returns the reference to the current HEAD
# this command will return something like (refs/heads/foo)
# the second git command is triggered if we are in a detached HEAD and returns
# a name relative to HEAD
  rf=$(git symbolic-ref -q HEAD || git name-rev --name-only --always HEAD)
# if we got the first form, we only keep the HEAD name
  rf=${rf#refs/heads/}
  echo $rf
}

# check if the current dir is in a VCS tree, and return relevant info
function prompt_vcs {
   git branch >&/dev/null && echo -n '[git<'&& echo -n $(git_ref) && echo '>]' && return
   hg root >&/dev/null && echo -n '[hg<' && echo -n $(hg branch) && echo  '>]' && return
   svn info >& /dev/null && echo -n '[svn]' && return
}

# are we using python virtualenv
function virtualenv_info {
   [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

# ツ -> Japanese TSU katakana
# ヅ -> Japanese DZU katakana+dakuten
# If your terminal does not support UTF-8 replace with your favorite prompt
# delimiter

# precmd is run before the prompt is displayed so we run the previous commands
# to forge the PROMPT var
function precmd() {
   PROMPT="%B%m$(virtualenv_info)$(prompt_vcs)ヅ%b "
}

