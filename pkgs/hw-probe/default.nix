{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,

  coreutils,
  curl,
  dmidecode,
  grep,
  tar,
  hwinfo,
  iproute2,
  kmod,
  pciutils,
  perl,
  smartmontools,
  usbutils,
  libv4l,
  xz,

  systemdSupport ? true,
  systemd,

  withRecommended ? true,
  mcelog,
  hdparm,
  acpica-tools,
  drm_info,
  mesa-demos,
  memtester,
  sysstat,
  cpuid,
  util-linuxMinimal,
  xinput,
  libva-utils,
  inxi,
  vulkan-tools,
  i2c-tools,
  opensc,
}:

stdenv.mkDerivation rec {
  pname = "hw-probe";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = pname;
    rev = version;
    sha256 = "sha256-8dLfk2k7xG2CXMHfMPrpgq43j3ttj5a0bgNPEahl2rQ=";
  };

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeWrapperArgs =
    let
      requiredPrograms = [
        hwinfo
        dmidecode
        smartmontools
        pciutils
        usbutils
        iproute2
        coreutils
        grep
        curl
        tar
        libv4l
        xz
        kmod
      ];
      recommendedPrograms = [
        mcelog
        hdparm
        acpica-tools
        drm_info
        mesa-demos
        memtester
        sysstat
        util-linuxMinimal
        xinput
        libva-utils
        inxi
        vulkan-tools
        i2c-tools
        opensc
      ]
      ++ lib.optional (lib.elem stdenv.hostPlatform.system cpuid.meta.platforms) cpuid;
      conditionallyRecommendedPrograms = lib.optional systemdSupport systemd;
      programs =
        requiredPrograms
        ++ conditionallyRecommendedPrograms
        ++ lib.optionals withRecommended recommendedPrograms;
    in
    [
      "--set"
      "PERL5LIB"
      "${perlPackages.makePerlPath [
        perlPackages.LWP
        perlPackages.LWPProtocolHttps
        perlPackages.HTTPMessage
        perlPackages.URI
        perlPackages.HTTPDate
        perlPackages.TryTiny
      ]}"
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath programs}"
    ];

  postInstall = ''
    wrapProgram $out/bin/hw-probe \
      $makeWrapperArgs
  '';

  meta = {
    description = "Probe for hardware, check operability and find drivers";
    homepage = "https://github.com/linuxhw/hw-probe";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      lgpl21
      bsdOriginal
    ];
    mainProgram = "hw-probe";
  };
}
