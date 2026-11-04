{
  buildPerlPackage,
  fetchurl,
  lib,
  DateSimple,
}:
buildPerlPackage {
  pname = "Date-Range";
  version = "1.41";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TM/TMTM/Date-Range-1.41.tar.gz";
    hash = "sha256-v5iXSSsQHAUDh50Up+fr6QJUQ4NgGufGmpXedcvZSLk=";
  };

  propagatedBuildInputs = [ DateSimple ];

  meta = {
    description = "Work with a range of dates";
    license = lib.licenses.gpl2Plus;
  };
}
