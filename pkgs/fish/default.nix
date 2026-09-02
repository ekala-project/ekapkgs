{
  stdenv,
  lib,
  fetchFromGitHub,
  coreutils,
  gnused,
  gnugrep,
  groff,
  gettext,
  man-db,
  ninja,
  getent,
  libiconv,
  pcre2,
  pkg-config,
  ncurses,
  python3,
  cargo,
  cmake,
  rustc,
  rustPlatform,
  writableTmpDirAsHomeHook,
  gawk,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fish";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "fish-shell";
    repo = "fish-shell";
    tag = finalAttrs.version;
    hash = "sha256-UpoZPipXZbzLWCOXzDjfyTDrsKyXGbh3Rkwj5IeWeY4=";
  };

  env = {
    FISH_BUILD_VERSION = finalAttrs.version;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src patches;
    hash = "sha256-FkJB33vVVz7Kh23kfmjQDn61X2VkKLG9mUt8f3TrCHg=";
  };

  patches = [
    ./disable_suid_test.patch
  ];

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    cmake
    cmake.configurePhaseHook
    gettext
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libiconv
    pcre2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DOCDIR" "${placeholder "doc"}/share/doc/fish")
    (lib.cmakeFeature "Rust_CARGO_TARGET" stdenv.hostPlatform.rust.rustcTarget)
  ];

  preConfigure = ''
    patchShebangs ./build_tools/git_version_gen.sh
  '';

  propagatedBuildInputs = [
    coreutils
    gnugrep
    gnused
    groff
    gettext
    man-db
  ];

  doCheck = false;

  postInstall = ''
    substituteInPlace "$out/share/fish/functions/grep.fish" \
      --replace-fail "command grep" "command ${lib.getExe gnugrep}"

    substituteInPlace "$out/share/fish/functions/__fish_print_help.fish" \
      --replace-fail "nroff" "${lib.getExe' groff "nroff"}"

    substituteInPlace $out/share/fish/completions/{sudo.fish,doas.fish} \
      --replace-fail "/usr/local/sbin /sbin /usr/sbin" ""

    cat > $out/share/fish/functions/__fish_anypython.fish <<EOF
    function __fish_anypython
        echo ${python3.interpreter}
        return 0
    end
    EOF

    for cur in $out/share/fish/functions/*.fish; do
      substituteInPlace "$cur" \
        --replace-quiet '/usr/bin/getent' '${lib.getExe getent}' \
        --replace-quiet 'awk' '${lib.getExe' gawk "awk"}'
    done
    for cur in $out/share/fish/completions/*.fish; do
      substituteInPlace "$cur" \
        --replace-quiet 'awk' '${lib.getExe' gawk "awk"}'
    done
  '';

  meta = {
    description = "Smart and user-friendly command line shell";
    homepage = "https://fishshell.com/";
    changelog = "https://github.com/fish-shell/fish-shell/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "fish";
  };

  passthru = {
    shellPath = "/bin/fish";
  };
})
