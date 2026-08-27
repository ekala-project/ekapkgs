# Shared builder for GNOME Shell extensions downloaded from extensions.gnome.org.
# Ported from nixpkgs pkgs/desktops/gnome/extensions/buildGnomeExtension.nix
{
  lib,
  stdenv,
  fetchzip,
  glib,
}:

{
  # Every gnome extension has a UUID. It's the name of the extension folder once unpacked
  # and can always be found in the metadata.json of every extension.
  uuid,
  pname,
  version,
  sha256,
  # Hex-encoded string of JSON bytes
  metadata,
  description ? "",
  homepage ? "",
  license ? lib.licenses.gpl2Plus,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-${pname}";
  version = toString version;
  src = fetchzip {
    url = "https://extensions.gnome.org/extension-data/${
      builtins.replaceStrings [ "@" ] [ "" ] uuid
    }.v${toString version}.shell-extension.zip";
    inherit sha256;
    stripRoot = false;
    # The download URL may change content over time. This is because the
    # metadata.json is automatically generated, and parts of it can be changed
    # without making a new release. We simply substitute the possibly changed fields
    # with their content from when we last updated, and thus get a deterministic output
    # hash.
    postFetch = ''
      echo "${metadata}" | base64 --decode > $out/metadata.json
    '';
  };
  nativeBuildInputs = [ glib ];
  buildPhase = ''
    runHook preBuild
    if [ -d schemas ]; then
      glib-compile-schemas --strict schemas
    fi
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
  # TODO: gnome-shell dependency (being ported)
  meta = {
    inherit description homepage license;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
  passthru = {
    extensionPortalSlug = pname;
    extensionUuid = uuid;
  };
}
