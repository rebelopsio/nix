{ pkgs, config, self, ... }: 

{
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [
            neovim
            mkalias
            alacritty
            flameshot
            podman
            _1password
            skhd
      # yabai
            terramate
            tenv
            qmk
            lazygit
            act
            ansible
            ansible-lint
            argocd
            git
            fish
            fzf
            bat
            lsd
            stats
            tmux
            eslint_d
            exercism
            gh
            fd
            gitsign
            golangci-lint
            kubernetes-helm
            helm-ls
            helmsman
            kubectl
            k9s
            jq
            yq
            starship
            zoxide
            zellij
            nil
            obsidian
        ];
      fonts.packages = 
        [
            pkgs.nerdfonts
        ];

      homebrew = {
          enable = true;
          taps = [
            "cloudquery/tap"
          ];
          brews = [
            "mas"
            "cloudquery"
          ];
          casks = [
            "firefox@developer-edition"
            "iina"
            "the-unarchiver"
            "caffeine"
          ];
          masApps = {
            "iBar" = 6443843900;
            "Meetingbar" = 1532419400;
            "Tailscale" = 1475387142;
            "Slack" = 803453959;
          };
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
          onActivation.cleanup = "zap";
        };

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      # Apple system settings
      system.defaults = {
          dock.autohide = true;
          finder.FXPreferredViewStyle = "clmv";
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
        };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      # system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

        # Optionally, start yabai as a service via launchd
        services.yabai = {
          enable = true;
        };
    }
