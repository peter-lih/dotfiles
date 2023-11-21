# dotfiles

My .config for Tmux, fish, and nvim  
99% based on [Takuya's dotfiles](https://github.com/craftzdog/dotfiles-public/tree/master/.config)

### Setup

For Mac  
Remember to configure the terminal to treat the option/alt key as a "Ecs+", so fzf-fish keybinds work.

```bash
brew install iterm2 --cask
brew install git fish fisher exa ghq node ripgrep fd wget tmux bat fzf

fisher install FabioAntunes/fish-nvm edc/bass jethrokuan/z IlanCosman/tide@v5 andreiborisov/sponge PatrickF1/fzf.fish

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

npm install -g @fsouza/prettierd eslint_d neovim pyright typescript-language-server commitizen cz-conventional-changelog

### setup commitizen
echo '{
  "path": "cz-conventional-changelog"
}' > ~/.czrc

```
