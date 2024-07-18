{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.*";
  };

  outputs = { self, ... }@inputs:
    let
      forSystems = s: f: inputs.nixpkgs.lib.genAttrs s (system: f rec {
        pkgs = import inputs.nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
      });
      forEachSupportedSystem = forSystems [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
    {
      devShells = forEachSupportedSystem ({ system, pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ ponysay ];
          };
        });
    };
}
