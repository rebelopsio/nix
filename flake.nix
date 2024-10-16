{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
            pkgs.neovim
            pkgs.mkalias
            pkgs.alacritty
            pkgs.flameshot
            pkgs.podman
            pkgs._1password
            pkgs.skhd
            pkgs.yabai
            pkgs.terramate
            pkgs.tenv
            pkgs.qmk
            pkgs.lazygit
            pkgs.act
            pkgs.ansible
            pkgs.ansible-lint
            pkgs.argocd
            pkgs.git
            pkgs.fish
            pkgs.fzf
            pkgs.bat
            pkgs.lsd
            pkgs.stats
            pkgs.tmux
            pkgs.eslint_d
            pkgs.exercism
            pkgs.gh
            pkgs.fd
            pkgs.gitsign
            pkgs.golangci-lint
            pkgs.kubernetes-helm
            pkgs.helm-ls
            pkgs.helmsman
            pkgs.kubectl
            pkgs.k9s
            pkgs.jq
            pkgs.yq
            pkgs.starship
            pkgs.zoxide
            pkgs.zellij
            pkgs.nil
            pkgs.telegram-desktop
            pkgs.obsidian
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
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#personalmbp
    darwinConfigurations."personalmbp" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "smorgan";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.smorgan = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."personalmbp".pkgs;
  };
}
