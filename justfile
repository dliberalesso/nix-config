default:
  @just --list

update:
  nix flake update

diff:
  git diff ':!flake.lock'

# Rebuild nixos
rebuild:
  git add *
  nixos-rebuild switch --flake .#nixosWSL --use-remote-sudo

# Rebuild home
remodel:
  git add *
  home-manager switch --flake .#dli

clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  sudo nix-collect-garbage --delete-older-than 30d
  nix-collect-garbage --delete-older-than 30d
  sudo nix-store --optimise
  nix-store --optimise

upgrade: clean rebuild remodel clean

repair:
  sudo nix-store --verify --check-contents --repair

fmt:
  nix fmt

lint:
  nix flake check

nvim-lazy:
  nvim --headless "+Lazy! sync" +qa

nvim-startuptime:
  nvim --startuptime startuptime.log -c 'autocmd VimEnter * if has('\''nvim'\'') | set shada= shadafile=NONE | else | set viminfo= viminfofile=NONE | endif' -c 'if exists('\''*timer_start'\'') | call timer_start(0, {-> execute('\''qall!'\'')}) | else | autocmd VimEnter * qall! | endif'
  bat startuptime.log
  just nvim-remove-startuptime

[private]
[confirm]
nvim-remove-startuptime:
  rm startuptime.log
