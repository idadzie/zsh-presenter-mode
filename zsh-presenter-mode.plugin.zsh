0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

# Then ${0:h} to get plugin's directory

typeset -gAH PRESENTER_MODE
: ${PRESENTER_MODE[BANNER_SHOW]:=1}
: ${PRESENTER_MODE[SHOW_PREEXEC_ARRAY]:=0}
: ${PRESENTER_MODE[BANNER_TEXT]:='PRESENTATION MODE'}

if [[ -z "$TMUX" ]]; then
  : ${PRESENTER_MODE[BG_DEFAULT]:=$(source ${0:h}/bin/get-terminal-emulator-bg-color)}
elif [[ -n "$TMUX" ]]; then
  : ${PRESENTER_MODE[BG_DEFAULT]:="#282828"}
fi

# Function which sets up the terminal for use during demos and explainers
function presenter_mode_start() {
  # Function that prints the expanded command right-aligned before running it
  # (e.x. shows aliases in expanded form so peeps aren't lost)
  function preshow_expanded_command() {
    if [[ "$1" != "$2" ]]; then
      printf "%$(($(tput cols)))b\n" "expanded: \033[0;1m$2\033[0;0m"
    fi
  }
  __PRESENTER_PREEXEC_FUNCTIONS_BACKUP=$preexec_functions

  if [[ "${PRESENTER_MODE[SHOW_PREEXEC_ARRAY]}" == 1 ]]; then
    echo "Backed up preexec array: $__PRESENTER_PREEXEC_FUNCTIONS_BACKUP"
  fi

  preexec_functions+=(preshow_expanded_command)
  __PRESENTER_MODE_ENABLED=1

  # Set terminal background to black to improve contrast
  if [[ -n "$TMUX" ]]; then
    echo -e "\ePtmux;\e\033]11;#000000\a\\e\\"
  else
    echo -e "\033]11;#000000\a"
  fi

  # Switch toggle command
  alias presenter-toggle=presenter_mode_stop
  zle -N toggle-presenter-mode presenter_mode_stop_widget
  sleep 1
  clear
  if [[ "${PRESENTER_MODE[BANNER_SHOW]}" == 1 ]] then;
    echo ""
    title="${PRESENTER_MODE[BANNER_TEXT]}"
    printf "%*s\n" $(((${#title}+$(tput cols))/2)) "$title"
    echo ""
  fi
}

function presenter_mode_stop() {
  # Restore background color
  if [[ -n "$TMUX" ]]; then
    echo -e "\ePtmux;\e\033]11;${PRESENTER_MODE[BG_DEFAULT]}\a\\e\\"
  else
    echo -e "\033]11;${PRESENTER_MODE[BG_DEFAULT]}\a"
  fi

  # Check that we're not gonna accidentally set the preexec array blank
  if (( $+__PRESENTER_MODE_ENABLED )) && (( $+__PRESENTER_PREEXEC_FUNCTIONS_BACKUP )); then
    preexec_functions=($__PRESENTER_PREEXEC_FUNCTIONS_BACKUP)

    if [[ "${PRESENTER_MODE[SHOW_PREEXEC_ARRAY]}" == 1 ]]; then
      echo "restored preexec array: $preexec_functions"
    fi

    unset __PRESENTER_MODE_ENABLED
    unset __PRESENTER_PREEXEC_FUNCTIONS_BACKUP
    # Switch toggle command
    alias presenter-toggle=presenter_mode_start
    zle -N toggle-presenter-mode presenter_mode_start_widget
  else
    >&2 echo "Presenter mode not enabled."
    return 1
  fi
}

function presenter_mode_start_widget() {
  presenter_mode_start
  # Simulate 'Enter' key press to render prompt.
  zle accept-line
}
function presenter_mode_stop_widget() {
  presenter_mode_stop
  # Simulate 'Enter' key press to render prompt.
  zle accept-line
}

alias presenter-toggle=presenter_mode_start

zle -N toggle-presenter-mode presenter_mode_start_widget
bindkey '^P^M' toggle-presenter-mode
