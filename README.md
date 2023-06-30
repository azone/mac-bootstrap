# Mac bootstrap
My bootstrap scripts for new Mac setup quickly or sync settings, installed softwares(Homebrew formulae, Homebrew casks, cargo binaries and so on) between Macs. 

## Requirements & initial setups
- [Xcode](https://developer.apple.com/xcode/)
- [homebrew](https://brew.sh)
- [Fish](https://fishshell.com)
- [jq](https://stedolan.github.io/jq/)
- [just](https://just.systems)
- [My fish functions](https://github.com/azone/fish-functions)
- Fonts:
  - [Nerd Font](https://www.nerdfonts.com/)
    - [Iosevka NF](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Iosevka)
  - [Source Code Pro](https://github.com/adobe-fonts/source-code-pro)
  - [Jetbrains Mono](https://www.jetbrains.com/lp/mono/)
  - [Intel One Mono](https://github.com/intel/intel-one-mono)

## Usage
```bash
Available recipes:
    cask-install       # install casks interactively
    cask-install-all   # install all casks in the list file
    default            # generate-list is the default recipe
    generate-cask-list # generate installed casks list json file
    generate-list      # generate installed homebrew formulae list json file
    install            # install formulae interactively
    install-all        # install all formulae in the list file
    preview            # preview changes
    push-changes       # commit & push formulae changes
```
