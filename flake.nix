{
  description = "Nix flake packaging Proton-CachyOS for Steam";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      sources = pkgs.callPackage ./pkgs/_sources/generated.nix { };

      mkProton =
        sourceKey: variantName:
        pkgs.callPackage ./pkgs/default.nix {
          source = sources.${sourceKey};
          variant = variantName;
        };

      proton = mkProton "proton-cachyos" "base";
      protonv3 = mkProton "proton-cachyos-x86_64-v3" "x86_64-v3";

    in
    {
      packages.x86_64-linux = {
        proton-cachyos = proton;
        proton-cachyos-x86_64-v3 = protonv3;
        default = proton;
      };

      overlays.default =
        final: prev:
        pkgs.lib.optionalAttrs (final.stdenv.hostPlatform.system == "x86_64-linux") {
          proton-cachyos = self.packages.x86_64-linux.proton-cachyos;
          proton-cachyos-x86_64-v3 = self.packages.x86_64-linux.proton-cachyos-x86_64-v3;
        };
    };
}