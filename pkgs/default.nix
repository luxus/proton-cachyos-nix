{
  pkgs,
  source,
  variant,
  renameInternalName ? true,
}:

let
  lib = pkgs.lib;

  folderName = if variant == "base" then "proton-cachyos" else "proton-cachyos-${variant}";
  steamName = if variant == "base" then "Proton CachyOS" else "Proton CachyOS ${variant}";
  version = lib.removePrefix "cachyos-" source.version;

  unpackedSrc = pkgs.runCommand "${folderName}-unpacked-${version}" { } ''
    mkdir -p $out
    tar -xf ${source.src} -C $out --strip-components=1
  '';

in
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = folderName;
  inherit version;

  src = unpackedSrc;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  preFixup = ''
    sed -i -r 's|"display_name".*|"display_name" "${steamName}"|' \
      "$steamcompattool/compatibilitytool.vdf"
    ${lib.optionalString renameInternalName ''
      sed -i -r 's|"proton-cachyos-[^"]*"(\s*// Internal name)|"${steamName}"\1|' \
        "$steamcompattool/compatibilitytool.vdf"
    ''}
  '';

  meta = with lib; {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
})