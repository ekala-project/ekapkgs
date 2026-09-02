{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "amneziawg-go";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j5tKv+ZPi+XY9eHV0iO/8/TomZXpqUKbdVjD5t/Iws0=";
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

  vendorHash = "sha256-Y2dCwlKMVLrkzDcNKyCPxFJwMbCA2mQKkakvzwbamCY=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  strictDeps = true;

  meta = {
    description = "Userspace Go implementation of AmneziaWG";
    homepage = "https://github.com/amnezia-vpn/amneziawg-go";
    license = lib.licenses.mit;
    mainProgram = "amneziawg-go";
  };
})
