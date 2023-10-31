# dotfiles
My .config for Tmux, fish, and nvim  
99% based on [Takuya's dotfiles](https://github.com/craftzdog/dotfiles-public/tree/master/.config)

### Setup 
For Mac   
```bash
brew install iterm2 --cask
brew install git fish fisher exa ghq node ripgrep fd wget tmux bat fzf

fisher install FabioAntunes/fish-nvm edc/bass jethrokuan/z IlanCosman/tide@v5 andreiborisov/sponge  

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

npm install -g @fsouza/prettierd eslint_d neovim pyright typescript-language-server
```

