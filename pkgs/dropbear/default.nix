{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libxcrypt,
  enableSCP ? false,
  sftpPath ? "/run/current-system/sw/libexec/sftp-server",
}:

let
  dflags = {
    SFTPSERVER_PATH = sftpPath;
    DROPBEAR_PATH_SSH_PROGRAM = "${placeholder "out"}/bin/dbclient";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dropbear";
  version = "2026.94";

  src = fetchFromGitHub {
    owner = "mkj";
    repo = "dropbear";
    tag = "DROPBEAR_${finalAttrs.version}";
    hash = "sha256-AJ6JvTPhd+Y4xnIIVqbJiU1rkmRmojoZX3pwKV0qrxA=";
  };

  patches = [
    ./pass-path.patch
  ];

  env.CFLAGS = lib.pipe (lib.attrNames dflags) [
    (map (name: "-D${name}=\\\"${dflags.${name}}\\\""))
    (lib.concatStringsSep " ")
  ];

  configureFlags = lib.optionals stdenv.hostPlatform.isMusl [
    "--enable-wtmp=no"
    "--enable-wtmpx=no"
  ];

  preConfigure = ''
    makeFlagsArray=(
      VPATH=$(cat $NIX_CC/nix-support/orig-libc)/lib
      PROGRAMS="${
        lib.concatStringsSep " " (
          [
            "dropbear"
            "dbclient"
            "dropbearkey"
            "dropbearconvert"
          ]
          ++ lib.optionals enableSCP [ "scp" ]
        )
      }"
    )
  '';

  buildInputs = [
    zlib
    libxcrypt
  ];

  postInstall = lib.optionalString enableSCP ''
    ln -rs $out/bin/scp $out/bin/dbscp
  '';

  meta = {
    description = "Small memory footprint ssh server/client suitable for memory-constrained environments";
    homepage = "https://matt.ucc.asn.au/dropbear/dropbear.html";
    changelog = "https://github.com/mkj/dropbear/releases/tag/DROPBEAR_${finalAttrs.version}";
    downloadPage = "https://matt.ucc.asn.au/dropbear/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
