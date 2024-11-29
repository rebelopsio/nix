{ config, lib, pkgs, self, ... }:

{
  # Specific packages and settings for charmander
  environment.systemPackages = with pkgs; [
    sketchybar
  ];
  users.users.smorgan = {
   name = "smorgan";
   home = "/Users/smorgan";

  };

}
