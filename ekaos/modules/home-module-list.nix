# ekapkgs-specific home modules
#
# Loaded in addition to core-pkgs' home-module-list.nix (which provides
# bash, git, ssh, gpg-agent and the core home.users infrastructure).
[
  ./home/programs/alacritty.nix
  ./home/programs/direnv.nix
  ./home/programs/fzf.nix
  ./home/programs/htop.nix
  ./home/programs/neovim.nix
  ./home/programs/obs-studio.nix
  ./home/programs/vscode.nix
  ./home/programs/waybar.nix
  ./home/programs/xdg.nix
]
