{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  darwin ? { },
  replaceVars,
}:

let
  platform =
    with stdenv.hostPlatform;
    if isDarwin then
      "macosx"
    else if isCygwin then
      "cygwin"
    else if (isFreeBSD || isOpenBSD) then
      "bsd"
    else if isSunOS then
      "solaris"
    else
      "linux";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chicken";
  version = "6.0.0";

  binaryVersion = 12;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${finalAttrs.version}/chicken-${finalAttrs.version}.tar.gz";
    hash = "sha256-koNVUrG2h60mc35Cm1q6NlEL9Cn4gW7A9tM2yMtB9EM=";
  };

  setupHook = replaceVars ./setup-hook.sh {
    binaryVersion = toString finalAttrs.binaryVersion;
  };

  # CHICKEN's configure script is hand-written and rejects standard flags.
  # Pass variables directly to make instead.
  dontConfigure = true;

  makeFlags = [
    "PLATFORM=${platform}"
    "PREFIX=$(out)"
    "C_COMPILER=$(CC)"
    "CXX_COMPILER=$(CXX)"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "XCODE_TOOL_PATH=${darwin.binutils.bintools}/bin"
    "LINKER_OPTIONS=-headerpad_max_install_names"
    "POSTINSTALL_PROGRAM=install_name_tool"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "HOSTSYSTEM=${stdenv.hostPlatform.config}"
    "TARGET_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "TARGET_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  # CHICKEN 6's csc tests run binaries whose install name has already been
  # rewritten to $out/lib/libchicken.dylib, which does not exist until install.
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkTarget = "check";

  postCheck = ''
    ./csi -R chicken.pathname -R chicken.platform \
       -p "(assert (equal? \"${toString finalAttrs.binaryVersion}\" (pathname-file (car (repository-path)))))"
  '';

  meta = {
    homepage = "https://call-cc.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    description = "Portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R7RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, macOS,
      Windows, and many Unix flavours.
    '';
  };
})
