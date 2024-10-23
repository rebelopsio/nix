{ config, lib, pkgs, self, ... }:

{
  # Specific packages and settings for charmander
  environment.systemPackages = with pkgs; [
  ];
  users.users.pidgey = {
   name = "pidgey";
   home = "/home/pidgey";

  };

}
