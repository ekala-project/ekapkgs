{
  lib,
  stdenv,
  fetchFromGitHub,
  gzip,
  popt,
  autoreconfHook,
  aclSupport ? stdenv.hostPlatform.isLinux,
  acl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logrotate";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = finalAttrs.version;
    sha256 = "sha256-D7E2mpC7v2kbsb1EyhR6hLvGbnIvGB2MK1n1gptYyKI=";
  };

  configureFlags = [
    "--with-compress-command=${gzip}/bin/gzip"
    "--with-uncompress-command=${gzip}/bin/gunzip"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ] ++ lib.optionals aclSupport [ acl ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    homepage = "https://github.com/logrotate/logrotate";
    description = "Rotates and compresses system logs";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "logrotate";
  };
})
