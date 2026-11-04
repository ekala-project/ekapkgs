{
  buildPerlModule,
  fetchurl,
  lib,
  stdenv,
  ModuleBuildXSUtil,
  TestException,
  TestFatal,
  TestLeakTrace,
  TestOutput,
  TestRequires,
  TryTiny,
}:
buildPerlModule {
  pname = "Mouse";
  version = "2.5.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SK/SKAJI/Mouse-v2.5.11.tar.gz";
    hash = "sha256-4qDQkwGQwhpES5YHk6ouNp7yih3QuPNIKXlfhqGRWVY=";
  };

  buildInputs = [
    ModuleBuildXSUtil
    TestException
    TestFatal
    TestLeakTrace
    TestOutput
    TestRequires
    TryTiny
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-fno-stack-protector";

  hardeningDisable = lib.optional stdenv.hostPlatform.isi686 "stackprotector";

  meta = {
    description = "Moose minus the antlers";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
