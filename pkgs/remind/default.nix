{
  lib,
  stdenv,
  fetchFromGitea,
  tk,
  tcl,
  withGui ? true,
  writeText,
}:

stdenv.mkDerivation rec {
  pname = "remind";
  version = "06.02.08";

  src =
    let
      domain = "git.skoll.ca";
    in
    fetchFromGitea {
      inherit domain;
      owner = "Skollsoft-Public";
      repo = "Remind";
      rev = version;
      hash = "sha256-+5ms52n5W2fmW7YhloB67vI0gF4+q8i1CyciSvY5lg0=";
    };

  buildInputs = [
    tcl
  ]
  ++ lib.optionals withGui [
    tk
  ];

  postPatch = lib.optionalString withGui ''
    substituteInPlace scripts/tkremind.in \
      --replace-fail "exec wish" "exec ${lib.getExe' tk "wish"}" \
      --replace-fail 'set Remind "remind"' "set Remind \"$out/bin/remind\"" \
      --replace-fail 'set Rem2PDF "rem2pdf"' "set Rem2PDF \"$out/bin/rem2pdf\""
  '';

  meta = {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = lib.licenses.gpl2Only;
    mainProgram = "remind";
    platforms = lib.platforms.unix;
  };
}
