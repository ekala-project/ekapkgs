{
  lib,
  cloud-utils,
  dmidecode,
  fetchFromGitHub,
  iproute2,
  openssh,
  python3,
  shadow,
  systemd,
  coreutils,
  busybox,
  procps,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cloud-init";
  version = "25.2";
  pyproject = true;

  namePrefix = "";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "cloud-init";
    tag = finalAttrs.version;
    hash = "sha256-Ww76dhfoGrIbxPiXHxDjpgPsinmfrs42NnGmzhBeGC0=";
  };

  patches = [
    ./0001-add-nixos-support.patch
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace /lib/systemd $out/lib/systemd

    substituteInPlace cloudinit/net/networkd.py \
      --replace '["/usr/sbin", "/bin"]' '["/usr/sbin", "/bin", "${iproute2}/bin", "${systemd}/bin"]'
  '';

  postInstall = ''
    install -D -m755 ./tools/write-ssh-key-fingerprints $out/libexec/write-ssh-key-fingerprints
    for i in $out/libexec/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath [ openssh ]}"
    done
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    configobj
    jinja2
    jsonpatch
    jsonschema
    netifaces
    oauthlib
    pyserial
    pyyaml
    requests
  ];

  doCheck = false;

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        dmidecode
        cloud-utils.guest
        busybox
      ]
    }/bin"
  ];

  pythonImportsCheck = [
    "cloudinit"
  ];

  meta = {
    homepage = "https://github.com/canonical/cloud-init";
    description = "Provides configuration and customization of cloud instance";
    changelog = "https://github.com/canonical/cloud-init/raw/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      asl20
      gpl3Plus
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
