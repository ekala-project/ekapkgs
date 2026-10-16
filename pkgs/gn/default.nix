{
  stdenv,
  lib,
  fetchgit,
  ninja,
  python3,

  # These can be overridden (e.g. by chromium) to build a specific gn version
  version ? "0-unstable-2026-09-11",
  rev ? "cfcd774b98f3433e18b722f9a7ff06119825b8eb",
  hash ? "sha256-HllmWYlbBMhSXVaOjB7+ncBUF8GUdKm8LfNjiV+EdL0=",
}:

stdenv.mkDerivation {
  pname = "gn";
  inherit version;

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev hash;
    leaveDotGit = true;
    deepClone = true;
    postFetch = ''
      cd "$out"
      mkdir .nix-files
      git rev-parse --short=12 HEAD > .nix-files/REV_SHORT
      git describe --match initial-commit | cut -d- -f3 > .nix-files/REV_NUM
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [
    ninja
    python3
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  hardeningDisable = [ "format" ];

  configurePhase = ''
    runHook preConfigure

    python build/gen.py --no-last-commit-position
    cat > out/last_commit_position.h << EOF
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION_NUM $(<.nix-files/REV_NUM)
    #define LAST_COMMIT_POSITION "$(<.nix-files/REV_NUM) ($(<.nix-files/REV_SHORT))"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
    EOF

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ninja -v -j $NIX_BUILD_CORES -C out gn

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -vD out/gn "$out/bin/gn"

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Meta-build system that generates build files for Ninja";
    mainProgram = "gn";
    homepage = "https://gn.googlesource.com/gn";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
