{
  description = "My macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs 未収録の CLI。flake を提供しているので brew ではなく input として管理
    hunk.url = "github:modem-dev/hunk";
    hunk.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-antigravity.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-antigravity, nix-darwin, home-manager, hunk, ... }: {
    darwinConfigurations."s-katada-private" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          # flake input のパッケージを pkgs.hunk / pkgs.antigravity-cli として参照できるようにする
          nixpkgs.overlays = [
            (final: prev: {
              hunk = hunk.packages.${prev.stdenv.hostPlatform.system}.default;
              antigravity-cli = (import nixpkgs-antigravity {
                inherit (prev.stdenv.hostPlatform) system;
                config.allowUnfree = true;
              }).antigravity-cli;
            })
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.awesomemr = import ./home.nix;
        }
      ];
    };
  };
}
