{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "resterm";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "unkn0wn-root";
    repo = "resterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vp1/yWDqx8fQp4NifjENr/x8e0TVSRlLYv7TshfwC2Y=";
  };

  vendorHash = "sha256-K6edyYLkVQwEZBAfRwgckUJI8dmo/ZxFRjEkExtyLxY=";

  # modernc.org/libc (via modernc.org/sqlite) tries to read /etc/protocols
  modPostBuild = ''
    substituteInPlace vendor/modernc.org/libc/honnef.co/go/netdb/netdb.go \
      --replace-fail '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';

  subPackages = [ "cmd/resterm" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.date=1970-01-01_00:00:00_UTC"
  ];

  nativeInstallCheckInputs = [
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  meta = {
    description = "Terminal-based REST client";
    homepage = "https://github.com/unkn0wn-root/resterm";
    mainProgram = "resterm";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = [ ];
  };
})
