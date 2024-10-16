# My Nix Flake for macOS

This repository contains a Nix flake to configure a macOS system using the [Nix package manager](https://nixos.org/) with support for [nix-darwin](https://github.com/LnL7/nix-darwin) and [nix-homebrew](https://github.com/LnL7/nix-homebrew).

## Features

- **Cross-platform configuration:** Manage your macOS system with Nix.
- **Nix-Darwin integration:** System-wide configuration using `nix-darwin` modules.
- **Homebrew compatibility:** Integrate `nix-homebrew` packages in your environment.
- **Reproducible environment:** Define a consistent, versioned configuration for your system.

## Prerequisites

Ensure that you have the following installed on your macOS system:

- [Nix](https://nixos.org/download.html) installed with multi-user mode enabled.
- [nix-darwin](https://github.com/LnL7/nix-darwin#readme) installed.
- [nix-homebrew](https://github.com/LnL7/nix-homebrew) for using Homebrew packages.

### Installation of Prerequisites

1. **Install Nix:**

   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Install nix-darwin:**
   Follow the instructions [here](https://github.com/LnL7/nix-darwin#install).

3. **Install nix-homebrew:**
   ```bash
   nix-shell -p nix-homebrew
   ```

## Usage

### Cloning the Repository

Clone this repository locally and navigate to the directory:

```bash
git clone https://github.com/your-username/your-nix-flake-repo.git
cd your-nix-flake-repo
```

### Running the Flake

You can apply the Nix flake by running the following command:

```bash
nix build
```

Or you can enter a Nix shell environment with the flake configuration:

```bash
nix develop
```

### Using nix-darwin

To use the `nix-darwin` configuration, rebuild the system using:

```bash
darwin-rebuild switch --flake .#
```

This will apply the system configuration defined in the `darwinConfigurations` module of the flake.

### Using nix-homebrew

You can use Homebrew packages via Nix. For example:

```bash
nix-shell -p nix-homebrew gcc
```

This will open a shell with `gcc` installed using Homebrew through Nix.

## Flake Structure

The `flake.nix` defines the following outputs:

- `packages`: Nix packages for the environment.
- `nix-darwin`: System configurations for `nix-darwin`.
- `nix-homebrew`: Support for integrating Homebrew into Nix environments.

### Example Structure

```nix
{
  description = "A simple Nix flake for macOS using nix-darwin and nix-homebrew";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    homebrew.url = "github:LnL7/nix-homebrew";
  };

  outputs = { self, nixpkgs, darwin, homebrew }: {
    packages = {
      darwinConfigurations = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ ./darwin-configuration.nix ];
      };
    };
  };
}
```

## Customization

You can modify `flake.nix` or `darwin-configuration.nix` to suit your requirements. Add your preferred Homebrew and Nix packages, system settings, and other configurations as needed.

## Contributing

Feel free to open issues or submit pull requests if you encounter any bugs or have suggestions for improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
