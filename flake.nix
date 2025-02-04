{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python312;
        pythonPackages = pkgs.python312Packages;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python
            ruff
            uv
          ];
          shellHook = ''

            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib python ]}:$LD_LIBRARY_PATH"
            export PYTHONUNBUFFERED=1
            export PIP_NO_PYTHON_VERSION_WARNING=1
            export PIP_DISABLE_PIP_VERSION_CHECK=1

            git config user.name "Daniel Garcia Medina"

            exec ${pkgs.nushell}/bin/nu
          '';
        };
      }
    );
}
