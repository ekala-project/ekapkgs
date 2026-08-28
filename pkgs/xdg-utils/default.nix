{
  lib,
  stdenv,
  fetchFromGitLab,
  libxslt,
  docbook_xml_dtd_412,
  docbook_xml_dtd_43,
  docbook-xsl,
  xmlto,
  bash,
  withXdgOpenUsePortalPatch ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-utils";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "xdg-utils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-58ElbrVlk+13DUODSEHBPcDDt9H+Kuee8Rz9CIcoy0I=";
  };

  patches = lib.optionals withXdgOpenUsePortalPatch [
    ./allow-forcing-portal-use.patch
    ./enable-xdg-terminal.patch
  ];

  nativeBuildInputs = [
    libxslt
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook-xsl
    xmlto
  ];

  buildInputs = [ bash ];

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/xdg-utils/";
    description = "Set of command line tools that assist applications with a variety of desktop integration tasks";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
