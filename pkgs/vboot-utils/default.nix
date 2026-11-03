{
  lib,
  stdenv,
  fetchFromGitiles,
  pkg-config,
  makeBinaryWrapper,
  libuuid,
  openssl,
  libyaml,
  xz,
  flashrom,

  withFlashrom ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vboot-utils";
  version = "143.16463";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    rev = "refs/heads/release-R${finalAttrs.passthru.versionFormatted}.B";
    hash = "sha256-8a49xD+EYXDouFuBmLyAtPxThYET6DtKImBPzXVhpxE=";
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    libuuid
    libyaml
    openssl
    xz
  ]
  ++ lib.optional withFlashrom finalAttrs.passthru.flashromChromeos;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "ar qc" '${stdenv.cc.bintools.targetPrefix}ar qc'
    substituteInPlace Makefile \
      --replace-fail "-Wno-unknown-warning" ""
    patchShebangs scripts
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "HOST_ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    "USE_FLASHROM=${if withFlashrom then "1" else "0"}"
    "UB_DIR=${placeholder "out"}/bin"
    "UL_DIR=${placeholder "out"}/lib"
    "UI_DIR=${placeholder "out"}/include/vboot"
    "US_DIR=${placeholder "out"}/share/vboot"
  ];

  postInstall = ''
    mkdir -p $out/share/vboot
    cp -r tests/devkeys* $out/share/vboot/
  ''
  + lib.optionalString withFlashrom ''
    wrapProgram $out/bin/crossystem \
      --prefix PATH : ${lib.makeBinPath [ finalAttrs.passthru.flashromChromeos ]}
  '';

  passthru = {
    versionFormatted = lib.concatStringsSep "-" (lib.versions.splitVersion finalAttrs.version);
    flashromChromeos = flashrom.overrideAttrs (_prev: {
      src = fetchFromGitiles {
        url = "https://chromium.googlesource.com/chromiumos/third_party/flashrom";
        rev = "refs/heads/release-R${finalAttrs.passthru.versionFormatted}.B-master";
        hash = "sha256-zOoWpuS/vDLvnRPdA9FNGhNbcwh3PMQwbdfqsyqj858=";
      };
      mesonFlags = (_prev.mesonFlags or [ ]) ++ [ (lib.mesonEnable "documentation" false) ];
    });
  };

  meta = {
    description = "Chrome OS partitioning and kernel signing tools";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    broken = true; # chromeos flashrom fails to build with -Werror
  };
})
