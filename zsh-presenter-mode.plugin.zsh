# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

# Then ${0:h} to get plugin's directory

typeset -g TERM_EMULATOR_BG_DEFAULT

if [[ -z "$TMUX" ]]; then
  : ${TERM_EMULATOR_BG_DEFAULT:=$(source ${0:h}/bin/get-terminal-emulator-bg-color)}
elif [[ -n "$TMUX" ]]; then
  : ${TERM_EMULATOR_BG_DEFAULT:="#282828"}
fi

export TERM_EMULATOR_BG_DEFAULT=${~TERM_EMULATOR_BG_DEFAULT}

# Function which sets up the terminal for use during demos and explainers
function presenter_mode_start() {
  # Function that prints the expanded command right-aligned before running it
  # (e.x. shows aliases in expanded form so peeps aren't lost)
  function preshow_expanded_command() {
    if [[ "$1" != "$2" ]]; then
      printf "%$(($(tput cols)))b\n" "expanded: \033[0;1m$2\033[0;0m"
    fi
  }
  Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP=$preexec_functions
  echo "Backed up preexec array: $Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP"
  preexec_functions+=(preshow_expanded_command)
  Z_PRESENTER_MODE_ENABLED=1

  # Set terminal background to black to improve contrast
  if [[ -n "$TMUX" ]]; then
    tmux select-pane -P 'bg=colour232'
  else
    echo -e "\033]11;#000000\a"
  fi

  # Switch toggle command
  alias presenter-toggle=presenter_mode_stop
  zle -N toggle-presenter-mode presenter_mode_stop_widget
  sleep 1
  clear
  echo ""
  title="PRESENTATION MODE"
  printf "%*s\n" $(((${#title}+$(tput cols))/2)) "$title"
  echo ""
}

function presenter_mode_stop() {
  # Restore background color
  if [[ -n "$TMUX" ]]; then
    tmux select-pane -P "bg=${TERM_EMULATOR_BG_DEFAULT}"
  else
    echo -e "\033]11;${TERM_EMULATOR_BG_DEFAULT}\a"
  fi

  # Check that we're not gonna accidentally set the preexec array blank
  if (( $+Z_PRESENTER_MODE_ENABLED )) && (( $+Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP )); then
    preexec_functions=($Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP)
    echo "restored preexec array: $preexec_functions"
    unset Z_PRESENTER_MODE_ENABLED
    unset Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP
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
