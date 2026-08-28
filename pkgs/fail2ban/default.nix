{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fail2ban";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fail2ban";
    repo = "fail2ban";
    rev = finalAttrs.version;
    hash = "sha256-6L8lSoFdf/KL1AQfN0lfGthEfeLlxodVsMI3LXCq+XY=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

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
  };
})
