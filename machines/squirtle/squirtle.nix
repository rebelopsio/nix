{ config, lib, pkgs, currentHostname, ... }: {
  users.users.stephenmorgan = {
    name = "stephenmorgan";
    home = "/Users/stephenmorgan";
  };

  environment.systemPackages = with pkgs; [
    # System-wide packages specific to squirtle
  ];
}
