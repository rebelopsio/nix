{ config, lib, pkgs, self, ... }:

{
  # Specific packages and settings for charmander
  environment.systemPackages = with pkgs; [
    sketchybar
  ];
  home.username = "smorgan";
  home.homeDirectory = "/Users/smorgan";
  users.users.smorgan = {
   name = "smorgan";
   home = "/Users/smorgan";

  };

}
