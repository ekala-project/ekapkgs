{
  stdenv,
  lib,
  fetchurl,
  makeDesktopItem,
  unzip,
  writeText,
  scummvm,
  runtimeShell,
}:

let
  plong = "Beneath a Steel Sky";
  pshort = "bass";
  pcode = "sky";
  description = "2D point-and-click science fiction thriller set in a bleak vision of the future";
  version = "1.2";
  pname = "beneath-a-steel-sky";

  desktopItem = makeDesktopItem {
    categories = [
      "Game"
      "AdventureGame"
    ];
    comment = description;
    desktopName = plong;
    exec = "@out@/bin/${pshort}";
    genericName = description;
    icon = "scummvm";
    name = pname;
  };

  run = writeText "${pshort}.sh" ''
    #!${runtimeShell} -eu

    exec ${scummvm}/bin/scummvm \
      --path=@out@/share/${pname} \
      --fullscreen \
      ${pcode}
  '';
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "mirror://sourceforge/scummvm/${pshort}-cd-${version}.zip";
    sha256 = "14s5jz67kavm8l15gfm5xb7pbpn8azrv460mlxzzvdpa02a9n82k";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{applications,${pname},doc/${pname}}

    mv readme.txt $out/share/doc/${pname}
    mv sky.* $out/share/${pname}

    substitute ${run} $out/bin/${pshort} \
      --subst-var out
    substitute ${desktopItem}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop \
      --subst-var out

    chmod 0755 $out/bin/${pshort}

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.scummvm.org";
    license = lib.licenses.free;
    inherit description;
    inherit (scummvm.meta) platforms;
  };
}
