# ekapkgs-specific home modules
#
# Loaded in addition to core-pkgs' home-module-list.nix (which provides
# bash, git, ssh, gpg-agent and the core home.users infrastructure).
[
  ./home/programs/zsh.nix
  ./home/programs/fish.nix
  ./home/programs/tmux.nix
  ./home/programs/kitty.nix
  ./home/programs/foot.nix
  ./home/programs/ghostty.nix
  ./home/programs/wezterm.nix
  ./home/programs/emacs.nix
  ./home/programs/neomutt.nix
  ./home/programs/mpv.nix
  ./home/programs/zathura.nix
  ./home/services/dunst.nix
  ./home/services/mako.nix
]
