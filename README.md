# zsh-presenter-mode

[![Maintenance][maintenance badge]]()

Zsh plugin to expand aliases during presentations.

It also increases the terminal window's contrast to enhance visibility. :wink:


## :floppy_disk: Installation

### Using [Zinit][zinit]

Add the snippet below to your **.zshrc** file.

```zsh
zinit ice wait'0' lucid
zinit light idadzie/zsh-presenter-mode

# or using the for syntax
zinit light-mode for idadzie/zsh-presenter-mode
```

### Manual

Clone this repository and source the **zsh-presenter-mode.plugin.zsh** file in your **.zshrc** file.

```zsh
git clone https://github.com/idadzie/zsh-presenter-mode.git $XDG_DATA_HOME/zsh-presenter-mode
echo "source $XDG_DATA_HOME/zsh-presenter-mode/zsh-presenter-mode.plugin.zsh" | tee -a "${ZDOTDIR:-$HOME}/.zshrc"
```


## :rocket: How to use
In any terminal window, use the key binding <kbd>Ctrl  P</kbd>,<kbd>Ctrl  M</kbd> or the alias `presenter-toggle` to quickly switch between modes.


## :wrench: Customisation

You can change the default key binding by adding the snippet below to your **.zshrc**.

```zsh
bindkey '\e\e' toggle-presenter-mode
```


## :handshake: Credit

The main [presenter_mode_{start,stop}][presenter-mode] functions were borrowed from [robobenklein's][robo] amazing [dotfiles][dotfiles].


## :sparkling_heart: Like this project ?

Leave a :star: If you think this project is cool.

[maintenance badge]: https://img.shields.io/maintenance/yes/2022.svg
[zinit]: https://github.com/zdharma-continuum/zinit
[robo]: https://github.com/robobenklein
[dotfiles]: https://github.com/robobenklein/configs
[presenter-mode]: https://github.com/robobenklein/configs/blob/master/zsh/plunks/presenter-mode.zsh
