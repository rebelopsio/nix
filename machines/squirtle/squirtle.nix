{ config, lib, pkgs, self, ... }:

{
  # Specific packages and settings for charmander
  environment.systemPackages = with pkgs; [
  ];
  users.users.smorgan = {
   name = "stephenmorgan";
   home = "/Users/stephenmorgan";

  };

}
