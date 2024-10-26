{ config, pkgs, lib, ... }:

let
  sketchybarConfig = ''
    # This is a demo config to showcase some of the most important commands.
    # It is meant to be changed and configured, as it is intentionally kept sparse.
    # For a (much) more advanced configuration example see my dotfiles:
    # https://github.com/FelixKratz/dotfiles

    PLUGIN_DIR="$CONFIG_DIR/plugins"

    ##### Bar Appearance #####
    sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000

    ##### Changing Defaults #####
    default=(
      padding_left=5
      padding_right=5
      icon.font="Hack Nerd Font:Bold:17.0"
      label.font="Hack Nerd Font:Bold:14.0"
      icon.color=0xffffffff
      label.color=0xffffffff
      icon.padding_left=4
      icon.padding_right=4
      label.padding_left=4
      label.padding_right=4
    )

    # Move array expansion into bash directly, not in the Nix string
    sketchybar --default "''${default[@]}"

    ##### Adding Mission Control Space Indicators #####
    SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
    for i in "''${!SPACE_ICONS[@]}"
    do
      sid="$(($i+1))"
      space=(
        space="$sid"
        icon="''${SPACE_ICONS[i]}"
        icon.padding_left=7
        icon.padding_right=7
        background.color=0x40ffffff
        background.corner_radius=5
        background.height=25
        label.drawing=off
        script="$PLUGIN_DIR/space.sh"
        click_script="yabai -m space --focus $sid"
      )
      sketchybar --add space space."$sid" left --set space."$sid" "''${space[@]}"
    done

    ##### Adding Left Items #####
    sketchybar --add item chevron left \
               --set chevron icon= label.drawing=off \
               --add item front_app left \
               --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
               --subscribe front_app front_app_switched

    ##### Adding Right Items #####
    sketchybar --add item clock right \
               --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock.sh" \
               --add item volume right \
               --set volume script="$PLUGIN_DIR/volume.sh" \
               --subscribe volume volume_change \
               --add item battery right \
               --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
               --subscribe battery system_woke power_source_change

    ##### Force all scripts to run the first time #####
    sketchybar --update
  '';
in
{
  # Write the sketchybar configuration to ~/.config/sketchybar/sketchybarrc
  home.file.".config/sketchybar/sketchybarrc" = {
    text = sketchybarConfig;
  };

  # Ensure sketchybar is installed and managed by Home Manager
  home.packages = with pkgs; [
    sketchybar
  ];

}
