{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  writeText,
  fpc,
  gtk2,
  glib,
  pango,
  atk,
  gdk-pixbuf,
  libxi,
  xorgproto,
  libx11,
  libxext,
  gdb,
  gnumake,
  binutils,
}:

let
  version = "4.0-0";

  majorMinorPatch = v: builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion v));

  overrides = writeText "revision.inc" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: "const ${k} = '${v}';") {
        RevisionStr = version;
      }
    )
  );
in
stdenv.mkDerivation rec {
  pname = "lazarus-gtk2";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/lazarus/Lazarus%20Zip%20_%20GZip/Lazarus%20${majorMinorPatch version}/lazarus-${version}.tar.gz";
    hash = "sha256-vIM7RxzXqCYSiavND1OhFjuMcG5FmD+zq6kmEiM5z8s=";
  };

  postPatch = ''
    cp ${overrides} ide/${overrides.name}
  '';

  buildInputs = [
    fpc
    gtk2
    glib
    libxi
    xorgproto
    libx11
    libxext
    pango
    atk
    stdenv.cc
    gdk-pixbuf
  ];

  enableParallelBuilding = false;

  nativeBuildInputs = [
    makeWrapper
  ];

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "LAZARUS_INSTALL_DIR=${placeholder "out"}/share/lazarus/"
    "INSTALL_PREFIX=${placeholder "out"}/"
    "REQUIRE_PACKAGES+=tachartlazaruspkg"
    "bigide"
  ];

  LCL_PLATFORM = "gtk2";

  NIX_LDFLAGS = lib.concatStringsSep " " [
    "-L${lib.getLib stdenv.cc.cc}/lib"
    "-lX11"
    "-lXext"
    "-lXi"
    "-latk-1.0"
    "-lc"
    "-lcairo"
    "-lgcc_s"
    "-lgdk-x11-2.0"
    "-lgdk_pixbuf-2.0"
    "-lglib-2.0"
    "-lgtk-x11-2.0"
    "-lpango-1.0"
  ];

  preBuild = ''
    mkdir -p $out/share "$out/lazarus"
    tar xf ${fpc.src} --strip-components=1 -C $out/share -m
    substituteInPlace ide/packages/ideconfig/include/unix/lazbaseconf.inc \
      --replace '/usr/fpcsrc' "$out/share/fpcsrc"
  '';

  postInstall =
    let
      ldFlags = ''$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')'';
    in
    ''
      wrapProgram $out/bin/startlazarus \
        --prefix NIX_LDFLAGS ' ' "${ldFlags}" \
        --prefix NIX_LDFLAGS_${binutils.suffixSalt} ' ' "${ldFlags}" \
        --prefix LCL_PLATFORM ' ' "$LCL_PLATFORM" \
        --prefix PATH ':' "${
          lib.makeBinPath [
            fpc
            gdb
            gnumake
            binutils
          ]
        }"
    '';

  meta = with lib; {
    description = "Graphical IDE for the FreePascal language";
    homepage = "https://www.lazarus.freepascal.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
