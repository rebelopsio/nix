{ config, lib, pkgs, currentHostname, ... }:

let
  dotfilesPaths = {
    squirtle = "/Users/stephenmorgan/dots/.config/nvim";
    charmander = "/Users/smorgan/dots/.config/nvim";
  };

  dotfilesPath = dotfilesPaths.${currentHostname} or dotfilesPaths.squirtle;
in
{
  home = {
    username = if currentHostname == "squirtle" then "stephenmorgan" else "smorgan";
    homeDirectory = if currentHostname == "squirtle" 
      then "/Users/stephenmorgan"
      else "/Users/smorgan";
    
    packages = with pkgs; [
      git
      vim
    ];

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
  };

  home.file.".config/nvim" = {
  source = config.lib.file.mkOutOfStoreSymlink dotfilesPath;
  recursive = true;  # If you want to symlink the entire directory
  onChange = ''
    echo "Updating nvim configuration..."
  '';
};

  imports = [
    ./../home/yabai.nix
    ./../home/sketchybar.nix
  ];

  programs = {
    # tmux = import ../home/tmux.nix {inherit pkgs;};
    # zsh = import ../home/zsh.nix {inherit config pkgs lib; };
    # zoxide = (import ../home/zoxide.nix { inherit config pkgs; });
    # fzf = import ../home/fzf.nix {inherit pkgs;};
    # oh-my-posh = import ../home/oh-my-posh.nix {inherit pkgs;};
  };
}
