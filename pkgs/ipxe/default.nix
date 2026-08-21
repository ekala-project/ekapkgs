{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPackages,
  mtools,
  openssl,
  perl,
  xz,
  embedScript ? null,
  additionalTargets ? { },
  additionalOptions ? [ ],
  firmwareBinary ? "ipxe.efirom",
}:

let
  targets =
    additionalTargets
    // lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
      "bin-x86_64-efi/ipxe.efi" = null;
      "bin-x86_64-efi/ipxe.efirom" = null;
      "bin-x86_64-efi/snp.efi" = null;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
      "bin-arm64-efi/ipxe.efi" = null;
      "bin-arm64-efi/ipxe.efirom" = null;
      "bin-arm64-efi/snp.efi" = null;
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ipxe";
  version = "1.21.1-unstable-2025-06-02";

  nativeBuildInputs = [
    mtools
    openssl
    perl
    xz
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "ipxe";
    rev = "5b3ebf8b24ae40a6f9f9f78491702d508f843e56";
    hash = "sha256-uGR82lR6gpp6IKBVDsKYLtovnbTiWg3RgbVQt6mug+I=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace src/util/genfsimg --replace "	syslinux " "	true "
  '';

  hardeningDisable = [
    "pic"
    "stackprotector"
  ];

  makeFlags = [
    "ECHO_E_BIN_ECHO=echo"
    "ECHO_E_BIN_ECHO_E=echo"
    "CROSS=${stdenv.cc.targetPrefix}"
  ]
  ++ lib.optional (embedScript != null) "EMBED=${embedScript}";

  enabledOptions = [
    "PING_CMD"
    "IMAGE_TRUST_CMD"
    "DOWNLOAD_PROTO_HTTP"
    "DOWNLOAD_PROTO_HTTPS"
  ]
  ++ additionalOptions;

  configurePhase = ''
    runHook preConfigure
    for opt in ${lib.escapeShellArgs finalAttrs.enabledOptions}; do echo "#define $opt" >> src/config/general.h; done
    substituteInPlace src/Makefile.housekeeping --replace '/bin/echo' echo
    runHook postConfigure
  '';

  preBuild = "cd src";

  buildFlags = lib.attrNames targets;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        from: to: if to == null then "cp -v ${from} $out" else "cp -v ${from} $out/${to}"
      ) targets
    )}

    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru = {
    firmware = "${finalAttrs.finalPackage}/${firmwareBinary}";
  };

  meta = {
    description = "Network boot firmware";
    homepage = "https://ipxe.org/";
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl2Only
      isc
      mit
      mpl11
    ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
