{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acpi";
  version = "1.8";

  src = fetchurl {
    url = "mirror://sourceforge/acpiclient/${finalAttrs.version}/acpi-${finalAttrs.version}.tar.gz";
    hash = "sha256-5kxuALU815dCfqMqFgUTQlsD7U8HdzP3Hx8J/zQPIws=";
  };

  meta = {
    description = "Show battery status and other ACPI information";
    mainProgram = "acpi";
    homepage = "https://sourceforge.net/projects/acpiclient/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
