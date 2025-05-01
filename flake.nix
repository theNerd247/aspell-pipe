{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];

      perSystem = { self', pkgs, config, ... }:
      {
        haskellProjects.default = 
        { devShell.enable = false; 
        };

        devShells.default = pkgs.mkShell
        { name = "aspell-pipe-dev";
          inputsFrom = [ config.haskellProjects.default.outputs.devShell ];
          packages = 
          [ (pkgs.aspellWithDicts (d: [d.en]))
            pkgs.haskell-language-server
          ];
        };
      };
  };
}
