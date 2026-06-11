# proton-cachyos-nix

Nix flake packaging [CachyOS/proton-cachyos](https://github.com/CachyOS/proton-cachyos) release tarballs as Steam compatibility tools.

This is a maintained fork of [powerofthe69/proton-cachyos-nix](https://github.com/powerofthe69/proton-cachyos-nix), kept up to date automatically via GitHub Actions.

## Usage

Add the flake as an input:

```nix
inputs.proton-cachyos.url = "github:luxus/proton-cachyos-nix";
```

Then either use the overlay or reference packages directly:

```nix
nixpkgs.overlays = [ proton-cachyos.overlays.default ];
```

```nix
programs.steam.extraCompatPackages = with pkgs; [
  proton-cachyos-x86_64-v3
];
```

## Variants

| Package | Description |
| --- | --- |
| `proton-cachyos` | Standard x86-64 build |
| `proton-cachyos-x86_64-v3` | x86-64-v3 microarchitecture build |

All packages are **x86_64-linux only**. Upstream no longer ships an x86-64-v4 tarball. An arm64 tarball is available upstream but is not packaged here.

Packages are intended for `programs.steam.extraCompatPackages` only — do not install them into a regular Nix environment.

## Updates

A daily GitHub Action runs [nvfetcher](https://github.com/nix-community/nvfetcher) to bump Proton-CachyOS sources when new releases are published. The nixpkgs input in `flake.lock` is updated weekly.

## License

BSD-3-Clause (same as upstream Proton-CachyOS).