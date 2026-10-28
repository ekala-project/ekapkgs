{
  lib,
  stdenv,
  msmtp,
}:

# Minimal sendmail wrapper that delegates to msmtp.
# Many packages expect /usr/sbin/sendmail; this provides that interface.
stdenv.mkDerivation {
  pname = "sendmail";
  version = msmtp.version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/sbin
    ln -s ${msmtp}/bin/msmtp $out/bin/sendmail
    ln -s ${msmtp}/bin/msmtp $out/sbin/sendmail

    runHook postInstall
  '';

  meta = {
    description = "Sendmail-compatible wrapper using msmtp as the backend";
    homepage = "https://marlam.de/msmtp/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "sendmail";
  };
}
