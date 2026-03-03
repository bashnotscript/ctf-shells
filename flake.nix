{
  description = "CTF / pentest devShells by opt-in category (macOS + Linux)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        lib = pkgs.lib;

        C = import ./pkgs/categories.nix { inherit pkgs lib; };
        L = import ./pkgs/linux.nix { inherit pkgs lib; };
        D = import ./pkgs/darwin.nix { inherit pkgs lib; };

        isLinux = pkgs.stdenv.isLinux;
        isDarwin = pkgs.stdenv.isDarwin;

        # helper: flatten lists
        cat = xs: lib.flatten xs;

        mk = name: packages:
          pkgs.mkShell {
            inherit name;
            packages = packages;

            shellHook = ''
              export NIX_SHELL_PROMPT="${name}> "
              mkdir -p "$PWD"/{loot,reports,wordlists,tmp}
              echo "Loaded ${name} (${system})"
            '';
          };

        # Convenience bundles that many people want
        basePkgs = cat [ C.base C.langs C.utils ];

      in {
        devShells = {
          # default is intentionally lightweight
          default = mk "ctf-base" basePkgs;

          base = mk "ctf-base" basePkgs;

          # Categories (opt-in)
          exploitation = mk "ctf-exploitation"
            (cat [ basePkgs C.exploitation C.reversing ]);

          forensics = mk "ctf-forensics"
            (cat [ basePkgs C.forensics ]);

          hardware = mk "ctf-hardware"
            (cat [ basePkgs ]
              ++ lib.optionals isLinux (L.hardware or [])
              ++ lib.optionals isDarwin (D.hardware or []));

          info = mk "ctf-info-gathering"
            (cat [ basePkgs C.infoGathering ]);

          access = mk "ctf-maintaining-access"
            (cat [ basePkgs C.maintainingAccess ]
              ++ lib.optionals isLinux (L.accessExtras or []));

          passwords = mk "ctf-passwords"
            (cat [ basePkgs C.passwords ]);

          reporting = mk "ctf-reporting"
            (cat [ basePkgs C.reporting ]);

          sniff = mk "ctf-sniffing-spoofing"
            (cat [ basePkgs C.sniffSpoof ]
              ++ lib.optionals isLinux (L.sniffSpoof or [])
              ++ lib.optionals isDarwin (D.sniffSpoof or []));

          stress = mk "ctf-stress-testing"
            (cat [ basePkgs C.stressTesting ]
              ++ lib.optionals isLinux (L.stressTesting or []));

          vuln = mk "ctf-vulnerability-analysis"
            (cat [ basePkgs C.vulnAnalysis ]);

          web = mk "ctf-web-apps"
            (cat [ basePkgs C.webApps C.vulnAnalysis ]);

          wireless = mk "ctf-wireless"
            (cat [ basePkgs C.infoGathering C.sniffSpoof ]
              ++ lib.optionals isLinux (L.wireless or []));

          # A few practical combos
          webplus = mk "ctf-webplus"
            (cat [ basePkgs C.webApps C.vulnAnalysis C.infoGathering C.sniffSpoof ]);

          pwn = mk "ctf-pwn"
            (cat [ basePkgs C.exploitation C.reversing ]);

          full = mk "ctf-full"
            (cat [
              basePkgs
              C.infoGathering
              C.webApps
              C.vulnAnalysis
              C.exploitation
              C.reversing
              C.forensics
              C.passwords
              C.reporting
              C.sniffSpoof
              C.stressTesting
              C.maintainingAccess
            ]
            ++ lib.optionals isLinux (L.sniffSpoof or [])
            ++ lib.optionals isLinux (L.stressTesting or [])
            ++ lib.optionals isLinux (L.wireless or [])
            ++ lib.optionals isLinux (L.hardware or []));
        };
      });
}
