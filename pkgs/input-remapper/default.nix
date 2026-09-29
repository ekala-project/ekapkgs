{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  gtk3,
  glib,
  dbus,
  gobject-introspection,
  xmodmap,
  procps,
  gtksourceview4,
  bash,
  withXmodmap ? true,
}:

let
  maybeXmodmap = lib.optional withXmodmap xmodmap;
in
(python3Packages.buildPythonApplication rec {
  pname = "input-remapper";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sezanzeb";
    repo = "input-remapper";
    tag = version;
    hash = "sha256-CFg/AvmZseU1f9bWI4CtYp9blvAhCgGzVWE8csVDbyE=";
  };

  postPatch = ''
    # fix FHS paths
    substituteInPlace inputremapper/installation_info.py \
      --replace-fail 'DATA_DIR = "/usr/share/input-remapper"' \
        "DATA_DIR = \"$out/usr/share/input-remapper\""
  '';

  nativeBuildInputs = [
    gtk3.wrapGAppsHook
    gettext
    gtk3
    glib
    gobject-introspection
    python3Packages.pygobject3
  ]
  ++ maybeXmodmap;

  buildInputs = [
    gtksourceview4
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dasbus
    evdev
    packaging
    psutil
    pycairo
    pydantic
    pygobject3
  ];

  doCheck = false;

  postInstall = ''
    substituteInPlace data/99-input-remapper.rules \
      --replace-fail 'RUN+="/bin/input-remapper-control' "RUN+=\"$out/bin/input-remapper-control"
    substituteInPlace data/input-remapper.service \
      --replace-fail "ExecStart=/usr/bin/input-remapper-service" "ExecStart=$out/bin/input-remapper-service"
    substituteInPlace data/input-remapper-autoload.desktop \
      --replace-fail "bash" "${lib.getExe bash}"

    install -m644 -D -t $out/share/applications/ data/*.desktop
    install -m644 -D -t $out/share/polkit-1/actions/ data/input-remapper.policy
    install -m644 -D data/69-input-remapper-forwarded.rules $out/etc/udev/rules.d/69-input-remapper-forwarded.rules
    install -m644 -D data/99-input-remapper.rules $out/etc/udev/rules.d/99-input-remapper.rules
    install -m644 -D data/input-remapper.service $out/lib/systemd/system/input-remapper.service
    install -m644 -D data/input-remapper.policy $out/share/polkit-1/actions/input-remapper.policy
    install -m644 -D data/inputremapper.Control.conf $out/etc/dbus-1/system.d/inputremapper.Control.conf
    install -m644 -D data/input-remapper.svg $out/share/icons/hicolor/scalable/apps/input-remapper.svg
    install -m644 -D -t $out/usr/share/input-remapper/ data/*

    # Only install input-remapper prefixed binaries
    install -m755 -D -t $out/bin/ bin/input-remapper*
  '';

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${lib.makeBinPath maybeXmodmap}"
    )
  '';

  meta = {
    description = "Easy to use tool to change the mapping of your input device buttons";
    homepage = "https://github.com/sezanzeb/input-remapper";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "input-remapper-gtk";
  };
}).overrideAttrs
  (
    final: prev: {
      postPatch = prev.postPatch or "" + ''
        # set revision for --version output
        substituteInPlace inputremapper/installation_info.py \
          --replace-fail 'COMMIT_HASH = "unknown"' 'COMMIT_HASH = "${final.src.rev}"'
      '';
    }
  )
