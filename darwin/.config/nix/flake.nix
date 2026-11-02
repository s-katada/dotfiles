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
            # bun 1.4.2 → 1.4.4。nixpkgs が 1.4.4 以上に追いついたらこの上書きを外す。
            # 理由: GHSA-663w-cv8g-jj2p（同梱 brotli、CVE-2026-111497、CISA KEV）、
            #       GHSA-26q8-h657-pf84（eMudhra 中間 CA を信頼）、GHSA-cf8x-9m69-3gg3
            # nixpkgs の bun は src を passthru.sources から引くので、version と sources を差し替える
            # （ハッシュは公式リリースの SHASUMS256.txt と一致を確認済み）
            (final: prev: {
              bun = prev.bun.overrideAttrs (finalAttrs: old: {
                version = "1.4.4";
                # 元の定義と同じく passthru.sources から選ぶ（未対応プラットフォームでは元の throw になる）
                src = finalAttrs.passthru.sources.${prev.stdenvNoCC.hostPlatform.system} or old.src;
                passthru = old.passthru // {
                  sources = {
                    "aarch64-darwin" = prev.fetchurl {
                      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.4/bun-darwin-aarch64.zip";
                      hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
                    };
                    "aarch64-linux" = prev.fetchurl {
                      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.4/bun-linux-aarch64.zip";
                      hash = "sha256-uqa7NvUdblhWHgK76oJQOKnfRU9nPW13bou/hvjHhQ4=";
                    };
                    "x86_64-linux" = prev.fetchurl {
                      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.4/bun-linux-x64-baseline.zip";
                      hash = "sha256-4ERutVmVdy65iUvrrppr42jZhai5Jx7hJEhvmUbu3XY=";
                    };
                  };
                };
              });
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
