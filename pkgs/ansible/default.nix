{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage {
  pname = "ansible";
  version = "14.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ansible";
    version = "14.4.0";
    hash = "sha256-8LO4hx1vTk7dfkd2OxgUSjLCFfc1VpvkTEmnDgSJNRk=";
  };

  # we make ansible-core depend on ansible, not the other way around,
  # since when you install ansible-core you will not have ansible
  # executables installed in the PATH variable
  pythonRemoveDeps = [ "ansible-core" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    # ansible.netcommon
    passlib
    jxmlease
    ncclient
    netaddr
    paramiko
    ansible-pylibssh
    xmltodict
    # ansible.utils
    jsonschema
    textfsm
    # ttp - omitted due to broken aiohttp transitive dependency (pkgconfig setup-hook bug)
    # community.general
    jmespath
  ];

  # don't try and fail to strip 48000+ non strippable files, it takes >5 minutes!
  dontStrip = true;

  # difficult to test
  doCheck = false;

  meta = {
    description = "Radically simple IT automation";
    mainProgram = "ansible-community";
    homepage = "https://www.ansible.com";
    changelog = "https://github.com/ansible-community/ansible-build-data/blob/14.3.1/14/CHANGELOG-v14.rst";
    license = lib.licenses.gpl3Plus;
  };
}
