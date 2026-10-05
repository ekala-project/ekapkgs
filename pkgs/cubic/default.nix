{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  unzip,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "1.14.2";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "cubic: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-zxyom2a5Urg6Jr284acizK9q5Y4n4PETfBWvIeKTO2w=";
    aarch64-linux = "sha256-2QAuelTHmmAt1IbIyWlECF50wpi8zsGPz6O6F37soSQ=";
    aarch64-darwin = "sha256-bmQEAqCdM90nYwdd9Fh08+BPl8q6lQwt8Y5968RBq4c=";
  };
in
stdenv.mkDerivation {
  pname = "cubic";
  inherit version;

  src = fetchurl {
    url = "https://mcafvrhahbqdwfrtncql.supabase.co/storage/v1/object/public/releases/v${version}/cubic-${platform}.zip";
    hash = hashes.${system};
  };

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  unpackPhase = ''
    unzip $src
  '';

  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 cubic $out/bin/cubic
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "AI code review CLI from cubic.dev";
    homepage = "https://cubic.dev";
    changelog = "https://cubic.dev/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "cubic";
  };
}
