{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
}:

let
  version = "0.1.42";

  platformMap = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "jules: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-c869LI+Jubsk703MuM15Q8y2npmzfeJnwvV5Mjen0QM=";
    aarch64-linux = "sha256-cB0Eo25xUC3G6p/Jc0U7IsoIVQatLLqmwLZzkX7N+/w=";
    aarch64-darwin = "sha256-iedh0tQC3dLObgY0Xf5HPfwCSxqYp2OZCQ9xPuKuklQ=";
  };
in
stdenv.mkDerivation {
  pname = "jules";
  inherit version;

  src = fetchurl {
    url = "https://storage.googleapis.com/jules-cli/v${version}/jules_external_v${version}_${platform}.tar.gz";
    hash = hashes.${system};
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # The tarball extracts to a directory with the jules binary and a licenses/
  # subdirectory; pin sourceRoot so Nix doesn't pick licenses/ as the source.
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 jules $out/bin/jules
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # Jules uses the "version" subcommand, not a --version flag.
  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Asynchronous coding agent from Google, in the terminal";
    homepage = "https://jules.google";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "jules";
  };
}
