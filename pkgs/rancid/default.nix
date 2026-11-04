{
  stdenv,
  lib,
  fetchFromGitHub,
  writeShellScriptBin,
  autoreconfHook,
  libtool,
  makeBinaryWrapper,
  coreutils,
  expect,
  git,
  grep,
  sed,
  openssh,
  perl,
  runtimeShell,
  inetutils,
}:

let
  inherit (lib)
    concatStringsSep
    getExe
    makeBinPath
    mapAttrsToList
    replaceStrings
    ;

  wrappedPing = writeShellScriptBin "ping" ''
    for b in /run/wrappers/bin/ping /usr/bin/ping /usr/local/bin/ping; do
      if [ -x "$b" ]; then
        exec "$b" "$@"
      fi
    done
    exit 0
  '';

  needsBin = {
    hlogin = [ (placeholder "out") ];
    ulogin = [ (placeholder "out") ];
    rancid-cvs = [ git ];
  };

  telnet' = inetutils;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rancid";
  version = "3.13";

  src = fetchFromGitHub {
    owner = "haussli";
    repo = "rancid";
    rev = "v" + replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    hash = "sha256-TAeOSwdDhP06OSV0en/hMVF3qWVwJUsiqt97rdgtAzE=";
  };

  postPatch = ''
    patchShebangs .

    substituteInPlace configure.ac \
      --replace 'm4_esyscmd(configure.vers package_name),' ${finalAttrs.pname}, \
      --replace 'm4_esyscmd(configure.vers package_version),' ${finalAttrs.version},

    substituteInPlace etc/rancid.conf.sample.in \
      --replace @ENV_PATH@ ${
        makeBinPath [
          "/run/wrappers"
          (placeholder "out")
          coreutils
          git
          grep
          sed
          openssh
          perl
          runtimeShell
          telnet'
        ]
      }

    for f in bin/*.in; do \
      if grep -q /usr/bin/tail $f ; then
        substituteInPlace $f --replace /usr/bin/tail ${coreutils}/bin/tail
      fi
    done

    substituteInPlace bin/par.c \
      --replace '"sh"' '"${runtimeShell}"'

    substituteInPlace bin/rancid-run.in \
      --replace '>$LOGDIR/$GROUP.`date +%Y%m%d.%H%M%S` 2>&1' ' ' \
      --replace 'perl ' '${getExe perl} ' \
      --replace 'sh ' '${runtimeShell} ' \
      --replace '"control_rancid ' '"${placeholder "out"}/bin/control_rancid ' \

    substituteInPlace bin/control_rancid.in \
      --replace "'rancid-fe " "'${placeholder "out"}/bin/rancid-fe "
  '';

  nativeBuildInputs = [
    autoreconfHook
    expect
    libtool
    makeBinaryWrapper
    perl
    wrappedPing
  ];

  buildInputs = [
    expect
    openssh
    perl
    telnet'
  ];

  postInstall = concatStringsSep "\n" (
    mapAttrsToList (n: v: ''
      mkdir -p $out/libexec
      mv $out/bin/${n} $out/libexec/
      makeWrapper $out/libexec/${n} $out/bin/${n} \
        --prefix PATH : ${makeBinPath v}
    '') needsBin
  );

  meta = {
    description = "Really Awesome New Cisco confIg Differ";
    homepage = "https://shrubbery.net/rancid/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
