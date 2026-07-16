{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fail2ban";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fail2ban";
    repo = "fail2ban";
    rev = finalAttrs.version;
    hash = "sha256-0xPNhbu6/p/cbHOr5Y+PXbMbt5q/S13S5100ZZSdylE=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

  patches = [
    (fetchpatch {
      url = "https://github.com/fail2ban/fail2ban/commit/2fed408c05ac5206b490368d94599869bd6a056d.patch";
      hash = "sha256-uyrCdcBm0QyA97IpHzuGfiQbSSvhGH6YaQluG5jVIiI=";
    })
    (fetchpatch {
      url = "https://github.com/fail2ban/fail2ban/commit/50ff131a0fd8f54fdeb14b48353f842ee8ae8c1a.patch";
      hash = "sha256-YGsUPfQRRDVqhBl7LogEfY0JqpLNkwPjihWIjfGdtnQ=";
    })
  ];

  preConfigure = ''
    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail
    done
  '';

  doCheck = false;

  preInstall = ''
    substituteInPlace setup.py --replace /usr/share/doc/ share/doc/

    ${python3.pythonOnBuildForHost.interpreter} setup.py install_data --install-dir=$out --root=$out
  '';

  postInstall =
    let
      sitePackages = "$out/${python3.sitePackages}";
    in
    ''
      install -m 644 -D -t "$out/lib/systemd/system" build/fail2ban.service
      sed -i "s#build/bdist.*/wheel/fail2ban.*/scripts/#$out/bin/#g" $out/lib/systemd/system/fail2ban.service
      sed -i "/ExecStartPre/d" $out/lib/systemd/system/fail2ban.service

      rm -r "${sitePackages}/etc"

      installManPage man/*.[1-9]

      rm $out/bin/fail2ban-python
      ln -s ${python3.interpreter} $out/bin/fail2ban-python

      rm -r $out/var
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      rm -r "${sitePackages}/usr"
    '';

  meta = {
    homepage = "https://www.fail2ban.org/";
    description = "Program that scans log files for repeated failing login attempts and bans IP addresses";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
