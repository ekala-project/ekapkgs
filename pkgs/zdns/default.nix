{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zdns";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wQXw68Ffa6i09+RkIDUQhIhezDR27eSZ0ppBB8/ihOo=";
  };

  vendorHash = "sha256-yvrIj2XBBWRlhTYl8sveq9eu6LYRo3aMzRy1Jgj7+f0=";

  preCheck = ''
    # Tests require network access
    substituteInPlace src/cli/worker_manager_test.go \
      --replace-fail "TestConvertNameServerStringToNameServer" "SkipTestConvertNameServerStringToNameServer"
    substituteInPlace src/zdns/zdns_test.go \
      --replace-fail "TestNetworkConditions" "SkipTestNetworkConditions"
  '';

  meta = {
    description = "CLI DNS lookup tool";
    mainProgram = "zdns";
    homepage = "https://github.com/zmap/zdns";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
