{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  asciidoctor,
  fmt,
  hiredis,
  xxhash,
  zstd,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccache";
  version = "4.13.6";

  src = fetchFromGitHub {
    owner = "ccache";
    repo = "ccache";
    tag = "v${finalAttrs.version}";
    postFetch = ''
      sed -i -E \
        's/version_info "([0-9a-f]{40}) .*(tag: v[^,]+).*"/version_info "\1 \2"/g w match' \
        $out/cmake/CcacheVersion.cmake
      if [ -s match ]; then
        rm match
      else
        exit 1
      fi
    '';
    hash = "sha256-A0n+DO6IznETsAFUNIpBkQI6A3UilgEUbuyP3sqKDTk=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    patchShebangs --build doc/scripts
    patchShebangs --build test/fake-compilers
  '';

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    cmake
    cmake.configurePhaseHook
    perl
  ];

  buildInputs = [
    fmt
    hiredis
    xxhash
    zstd
  ];

  cmakeFlags = [ "-DENABLE_TESTING=OFF" ];

  passthru.links =
    { unwrappedCC, extraConfig }:
    stdenv.mkDerivation {
      pname = "ccache-links";
      inherit (finalAttrs) version;
      passthru = {
        isClang = unwrappedCC.isClang or false;
        isGNU = unwrappedCC.isGNU or false;
        isCcache = true;
      };
      lib = lib.getLib unwrappedCC;
      nativeBuildInputs = [ makeWrapper ];
      buildCommand =
        let
          targetPrefix =
            if unwrappedCC.isClang or false then
              ""
            else
              (lib.optionalString (
                unwrappedCC ? targetConfig && unwrappedCC.targetConfig != null && unwrappedCC.targetConfig != ""
              ) "${unwrappedCC.targetConfig}-");
        in
        ''
          mkdir -p $out/bin

          wrap() {
            local cname="${targetPrefix}$1"
            if [ -x "${unwrappedCC}/bin/$cname" ]; then
              makeWrapper ${finalAttrs.finalPackage}/bin/ccache $out/bin/$cname \
                --run ${lib.escapeShellArg extraConfig} \
                --add-flags ${unwrappedCC}/bin/$cname
            fi
          }

          wrap cc
          wrap c++
          wrap gcc
          wrap g++
          wrap clang
          wrap clang++

          for executable in $(ls ${unwrappedCC}/bin); do
            if [ ! -x "$out/bin/$executable" ]; then
              ln -s ${unwrappedCC}/bin/$executable $out/bin/$executable
            fi
          done
          for file in $(ls ${unwrappedCC} | grep -vw bin); do
            ln -s ${unwrappedCC}/$file $out/$file
          done
        '';
    };

  meta = {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = "https://ccache.dev";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "ccache";
  };
})
