{
  lib,
  asciidoc,
  coreutils,
  cryptsetup,
  curl,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  jansson,
  jose,
  libpwquality,
  luksmeta,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  stdenv,
  systemd,
  tpm2-tools ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clevis";
  version = "22";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "clevis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1glqXKOP0GdzbQLMzUEgacRCafneFH9+MTHRYNgjG3Q=";
  };

  patches = [
    ./0000-tang-timeout.patch
  ];

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    cryptsetup
    curl
    jansson
    jose
    libpwquality
    luksmeta
    systemd
  ]
  ++ lib.optionals (tpm2-tools != null) [
    tpm2-tools
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = false;

  postPatch = ''
    for f in $(find src/ -type f -print0 |\
                 xargs -0 -I@ sh -c 'grep -q "/bin/cat" "$1" && echo "$1"' sh @); do
      substituteInPlace "$f" --replace-fail '/bin/cat' '${lib.getExe' coreutils "cat"}'
    done

    substituteInPlace src/luks/systemd/meson.build \
      --replace-fail "unitdir = systemd.get_pkgconfig_variable('systemdsystemunitdir')" \
        "unitdir = join_paths(get_option('prefix'), 'lib', 'systemd', 'system')"
  '';

  postInstall =
    let
      includeIntoPath = [
        coreutils
        cryptsetup
        gnugrep
        gnused
        jose
        libpwquality
        luksmeta
      ]
      ++ lib.optionals (tpm2-tools != null) [
        tpm2-tools
      ];
      askpassPath = [
        coreutils
        cryptsetup
        curl
        gawk
        gnugrep
        gnused
        jose
        luksmeta
      ];
    in
    ''
      wrapProgram $out/bin/clevis \
        --prefix PATH ':' "${lib.makeBinPath includeIntoPath}:${placeholder "out"}/bin"

      wrapProgram $out/libexec/clevis-luks-askpass \
        --prefix PATH ':' "${lib.makeBinPath askpassPath}:${placeholder "out"}/bin"
    '';

  meta = {
    homepage = "https://github.com/latchset/clevis";
    description = "Automated Encryption Framework";
    changelog = "https://github.com/latchset/clevis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "clevis";
  };
})
