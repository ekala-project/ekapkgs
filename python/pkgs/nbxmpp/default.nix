{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  gobject-introspection,
  idna,
  libsoup_3,
  packaging,
  precis-i18n,
  pygobject3,
  pyopenssl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "7.4.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "gajim";
    repo = "python-nbxmpp";
    tag = version;
    hash = "sha256-Xg2RFEUbvshVDjWftnAx4nbOor1q8naeG2vvukDFwHY=";
  };

  nativeBuildInputs = [
    gobject-introspection
    setuptools
  ];

  buildInputs = [ precis-i18n ];

  propagatedBuildInputs = [
    gobject-introspection
    idna
    libsoup_3
    packaging
    pygobject3
    pyopenssl
  ];

  pythonImportsCheck = [ "nbxmpp" ];

  meta = {
    homepage = "https://gitlab.com/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = lib.licenses.gpl3Plus;
  };
}
