self: super: {
  telegram-desktop = super.telegram-desktop.overrideAttrs (oldAttrs: rec {
    version = "5.6.1";  # Set the desired version
    src = super.fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v${version}";
      sha256 = "sha256-xxxxxxxxxx";  # Replace with the correct sha256 hash
    };
  });
}
