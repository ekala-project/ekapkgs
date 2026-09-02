{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "naabu";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rjGTicUzdFRpJ3VGl/eXLKGdrbuwM3jQbOd0pmknabg=";
  };

  vendorHash = "sha256-Qay0jAWRnK5oRfOmYLrfWFR5eOT5glcsQ9BgSr2LiS8=";

  buildInputs = [ libpcap ];
  subPackages = [ "cmd/naabu/" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Fast SYN/CONNECT port scanner";
    longDescription = ''
      Naabu is a port scanning tool written in Go that allows you to enumerate
      valid ports for hosts in a fast and reliable manner. It is a really simple
      tool that does fast SYN/CONNECT scans on the host/list of hosts and lists
      all ports that return a reply.
    '';
    homepage = "https://github.com/projectdiscovery/naabu";
    changelog = "https://github.com/projectdiscovery/naabu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "naabu";
  };
})
