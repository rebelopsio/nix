
{ config, lib, pkgs, ... }:

{
  # Specific packages and settings for charmander
  environment.systemPackages = with pkgs; [
    telegram-desktop
  ];

}
