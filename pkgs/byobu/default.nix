{
  lib,
  autoreconfHook,
  bc,
  fetchFromGitHub,
  gettext,
  makeWrapper,
  perl,
  python3,
  screen,
  stdenv,
  vim,
  tmux,
}:

let
  pythonEnv = python3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "byobu";
  version = "6.15";

  src = fetchFromGitHub {
    owner = "dustinkirkland";
    repo = "byobu";
    tag = finalAttrs.version;
    hash = "sha256-QovoXH8cm8CZMSYGjI7FgynHtJjahpe9R2s62F7aZvo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    makeWrapper
  ];

  buildInputs = [
    perl
    screen
    tmux
  ];

  doCheck = true;
  strictDeps = true;

  postPatch = ''
    for file in usr/bin/byobu-export.in usr/lib/byobu/menu; do
      substituteInPlace $file \
        --replace "gettext" "${gettext}/bin/gettext"
    done
  '';

  postInstall = ''
    for po in po/*.po; do
      lang=''${po#po/}
      lang=''${lang%.po}
      mkdir -p $out/share/byobu/po/$lang/LC_MESSAGES/
      msgfmt --verbose $po -o $out/share/byobu/po/$lang/LC_MESSAGES/byobu.mo
    done

    cp --remove-destination $out/bin/byobu $out/bin/byobu-screen
    cp --remove-destination $out/bin/byobu $out/bin/byobu-tmux

    for file in $out/bin/byobu*; do
      bname="$(basename $file)"

      if [ $bname == "byobu-launch" ]; then
        continue
      fi

      mv "$file" "$out/bin/.$bname"
      makeWrapper "$out/bin/.$bname" "$out/bin/$bname" \
        --argv0 $bname \
        --prefix PATH ":" "$out/bin" \
        --set BYOBU_PATH ${
          lib.makeBinPath [
            vim
            bc
          ]
        } \
        --set BYOBU_PYTHON "${pythonEnv}/bin/python"
    done
  '';

  meta = {
    homepage = "https://www.byobu.org/";
    description = "Text-based window manager and terminal multiplexer";
    license = lib.licenses.gpl3Plus;
    mainProgram = "byobu";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
