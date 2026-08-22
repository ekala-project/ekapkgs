{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsi686Linux,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  dbus,
  inih,
  systemd,
  appstream,
  findutils,
  gawk,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gamemode";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = "gamemode";
    tag = finalAttrs.version;
    hash = "sha256-V0rewbSVOGFqJqXyCz4jXpuDM0EfjdkpGPl+WdDwI5I=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  patches = [
    ./preload-nix-workaround.patch
  ];

  postPatch = ''
    substituteInPlace data/gamemoderun \
      --subst-var-by libraryPath ${
        lib.makeLibraryPath (
          [
            (placeholder "lib")
          ]
          ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
            pkgsi686Linux.gamemode.lib
          ]
        )
      }
  '';

  nativeBuildInputs = [
    makeWrapper
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    inih
    systemd
  ];

  mesonFlags = [
    "-Dwith-pam-limits-dir=etc/security/limits.d"
    "-Dwith-systemd-user-unit-dir=lib/systemd/user"
    "-Dwith-systemd-group-dir=lib/sysusers.d"
    "--libexecdir=libexec"
  ];

  doCheck = true;
  nativeCheckInputs = [
    appstream
  ];

  postFixup = ''
    for bin in "$out/bin/gamemoded" "$out/bin/gamemode-simulate-game"; do
      patchelf --set-rpath "$lib/lib:$(patchelf --print-rpath "$bin")" "$bin"
    done

    wrapProgram "$out/bin/gamemodelist" \
      --prefix PATH : ${
        lib.makeBinPath [
          findutils
          gawk
          procps
        ]
      }
  '';

  meta = {
    description = "Optimise Linux system performance on demand";
    homepage = "https://feralinteractive.github.io/gamemode";
    changelog = "https://github.com/FeralInteractive/gamemode/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "gamemoderun";
  };
})
