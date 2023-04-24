# idris.zsh-theme
# forked from fino

set -u

my_current_branch() {
  git_current_branch || echo "(no branch)"
}

my_git_prompt() {
    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""

  # is branch ahead?
  local -r ahead=$(git log --pretty=oneline origin/"$(git_current_branch)"..HEAD 2> /dev/null| wc -l)
  STATUS="+$ahead$STATUS"

  # is branch behind?
  local -r behind=$(git log --pretty=oneline HEAD..origin/"$(git_current_branch)" 2> /dev/null| wc -l)
  if [[ $behind -gt 0 ]]; then
      STATUS="-$behind$STATUS"
  fi

  echo " $(my_current_branch) $STATUS"
}

prompt_char() {
  command git branch &>/dev/null && echo "±" || echo '○'
}

box_name() {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

# shellcheck disable=SC2168,SC2016
local -r git_info='$(my_git_prompt)'
# shellcheck disable=SC2168,SC2016
local -r prompt_char='$(prompt_char)'

# shellcheck disable=SC2154,SC2168
local ret_status="%(?:%{%}:%{%})%?%{%}"
PROMPT="╭─%n@$(box_name) %B%~%b${git_info}
╰─${prompt_char} ${ret_status} "
export PROMPT

set +u
