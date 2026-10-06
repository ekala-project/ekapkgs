{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bash,
  cacert,
  makeWrapper,
  nodejs,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "3.0.67";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "cline: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-radOrIsKcamwk5C3sG3UlCJgpj6IYc2eJwhefghNQe0=";
    aarch64-linux = "sha256-wbNOo9NWYZ19V8bdEJkpbXRjMmcwETQavgAR4FoIzLk=";
    aarch64-darwin = "sha256-3dGQN0uUHnM6AD8oZUtfgBKZ+EhDG607sHcs+ZWjrsM=";
  };

  launcher = fetchurl {
    url = "https://registry.npmjs.org/cline/-/cline-${version}.tgz";
    hash = "sha256-NExi0LtGVpVZinyey9kgl/EhXzQULUEJrVeyg6lbK0o=";
  };
in
stdenv.mkDerivation {
  pname = "cline";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@cline/cli-${platform}/-/cli-${platform}-${version}.tgz";
    hash = hashes.${system};
  };

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper nodejs ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cline-platform $out/lib/cline-launcher
    cp -r . $out/lib/cline-platform
  ''
  # NixOS has no /bin/bash. Same-length patch so the Bun SEA stays valid.
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    grep -qF '"/bin/bash"' $out/lib/cline-platform/bin/cline
    sed -i 's|"/bin/bash"|"bash"     |g' $out/lib/cline-platform/bin/cline
  ''
  + ''
    tar -xzf ${launcher} --strip-components=1 -C $out/lib/cline-launcher package/bin

    ln -s $out/lib/cline-platform/bin/cline $out/lib/cline-launcher/bin/.cline
    substituteInPlace $out/lib/cline-launcher/bin/cline \
      --replace-fail '#!/usr/bin/env node' '#!${nodejs}/bin/node'

    makeWrapper $out/lib/cline-launcher/bin/cline $out/bin/cline \
      --suffix PATH : ${lib.makeBinPath [ bash nodejs ]} \
      --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt \
      --set-default SSL_CERT_DIR ${cacert}/etc/ssl/certs

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Autonomous coding agent CLI";
    homepage = "https://cline.bot";
    changelog = "https://github.com/cline/cline/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "cline";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
