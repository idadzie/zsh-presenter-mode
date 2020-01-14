# zsh-presenter-mode

[![License: MIT][license badge]][license] [![Maintenance][maintenance badge]]()

This plugin is designed to expand aliases during presentations.
It also increases the terminal window's contrast to enhance visibility.



## Installation

### [Zplugin][zplugin]

Amazing Zsh plugin manager with clean fpath, reports, completion management, turbo mode etc.

```zsh
zplugin ice wait'0' lucid
zplugin light idadzie/zsh-presenter-mode
```



### Settings

### Alias

Alias `presenter-toggle` is provided to switch between modes.

### Key bindings

Key binding <kbd>Ctrl  P</kbd>,<kbd>Ctrl  M</kbd> is enabled to quickly switch between modes. You can override the default keybinding with:

```zsh
# Customize keybinding
bindkey '\e\e' toggle-presenter-mode
```
or using Zplugin's ice modifiers:

```zsh
# Note load **not** light
zplugin ice bindmap'^P^M -> \e\e'
zplugin load idadzie/zsh-presenter-mode
```



## Credit

The main [presenter_mode_{start,stop}][presenter-mode] functions were borrowed from [robobenklein's][robo] amazing [dotfiles][dotfiles].



## License

The MIT License (MIT)

Copyright (c) 2019 idadzie

[license badge]: https://img.shields.io/badge/License-MIT-green.svg
[license]: https://opensource.org/licenses/MIT
[maintenance badge]: https://img.shields.io/maintenance/yes/2020.svg
[zplugin]: https://github.com/zdharma/zplugin
[robo]: https://github.com/robobenklein
[dotfiles]: https://github.com/robobenklein/configs
[presenter-mode]: https://github.com/robobenklein/configs/blob/master/zsh/plunks/presenter-mode.zsh
