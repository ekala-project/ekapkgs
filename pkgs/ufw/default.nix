{
  lib,
  python3Packages,
  fetchurl,
  iptables,
  nftables,
  procps,
  iproute2,
}:

python3Packages.buildPythonApplication rec {
  pname = "ufw";
  version = "0.36.2";
  pyproject = false;

  src = fetchurl {
    url = "https://launchpad.net/ufw/${lib.versions.majorMinor version}/${version}/+download/ufw-${version}.tar.gz";
    hash = "sha256-Klepnuzva0TbNTftJSCzC643WfhGVFbiLkBM1kODi/U=";
  };

  postPatch = ''
    # Remove Makefile so buildPythonApplication uses setup.py directly
    rm -f Makefile

    substituteInPlace setup.py \
      --replace "/etc" "$out/etc" \
      --replace "/lib/ufw" "$out/lib/ufw" \
      --replace "/usr/sbin" "$out/bin"

    substituteInPlace src/ufw-init \
      --replace "/lib/ufw" "$out/lib/ufw" \
      --replace "/etc/ufw" "$out/etc/ufw" \
      --replace "/usr/sbin/iptables" "${iptables}/bin/iptables" \
      --replace "/usr/sbin/ip6tables" "${iptables}/bin/ip6tables"

    substituteInPlace src/util.py \
      --replace "/sbin/iptables" "${iptables}/bin/iptables" \
      --replace "/sbin/ip6tables" "${iptables}/bin/ip6tables" \
      --replace "/bin/ss" "${iproute2}/bin/ss"
  '';

  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [
    iptables
    nftables
    procps
    iproute2
  ];

  doCheck = false;

  meta = {
    description = "Uncomplicated Firewall — easy-to-use frontend for iptables";
    homepage = "https://launchpad.net/ufw";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "ufw";
  };
}
