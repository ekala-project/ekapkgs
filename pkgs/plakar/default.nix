{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  fuse,
}:
buildGoModule (finalAttrs: {
  pname = "plakar";
  version = "1.1.7";

  # to avoid having all the Test(Get|Set|Validate)Service.* tests fail on darwin
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cbfPWNlTcpQsjd3a1aE+wXos5EN8b96fpA2Cz+qzyR4=";
  };

  vendorHash = "sha256-RQ1HhWL33Zi5n8G6RerLLgE2YJk/7HD4k1yiK+sQTBU=";

  buildInputs = [
    fuse
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags =
    let
      skippedTests = [
        # hangs even outside Nix, so probably an upstream issue:
        "TestRebuildStateVersionMismatch"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestBTreeScanMemory"
        "TestBTreeScanPebble"
        "TestExecuteCmdServerDefault"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    installManPage $(find $src -regex '.*\.[0-9]$')
  '';

  meta = {
    mainProgram = "plakar";
    description = "Encrypted, queryable backups for engineers based on an immutable data store and portable archives";
    homepage = "https://www.plakar.io";
    license = lib.licenses.isc;
  };
})
