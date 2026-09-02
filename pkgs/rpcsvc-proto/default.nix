{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  fetchpatch,
  targetPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpcsvc-proto";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "rpcsvc-proto";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-DEXzSSmjMeMsr1PoU/ljaY+6b4COUU2Z8MJkGImsgzk=";
  };

  patches = [
    (fetchpatch {
      name = "follow-RPCGEN_CPP-env-var";
      url = "https://github.com/thkukuk/rpcsvc-proto/commit/e772270774ff45172709e39f744cab875a816667.diff";
      sha256 = "sha256-KrUD6YwdyxW9S99h4TB21ahnAOgQmQr2tYz++MIbk1Y=";
    })
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  env.RPCGEN_CPP = "${stdenv.cc.targetPrefix}cpp";

  postPatch = ''
    substituteInPlace rpcgen/rpc_main.c \
      --replace 'CPP = "cpp"' \
                'CPP = "${targetPackages.stdenv.cc.targetPrefix}cpp"'
  '';

  meta = {
    homepage = "https://github.com/thkukuk/rpcsvc-proto";
    description = "This package contains rpcsvc proto.x files from glibc, which are missing in libtirpc";
    license = lib.licenses.mit;
    mainProgram = "rpcgen";
  };
})
