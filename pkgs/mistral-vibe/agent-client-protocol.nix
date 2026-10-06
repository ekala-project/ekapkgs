{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "agent-client-protocol";
  version = "0.10.1";
  pyproject = true;

  src = fetchPypi {
    pname = "agent_client_protocol";
    inherit version;
    hash = "sha256-NVxlyhnwVoNEqvwsFVK3BmqPxJHfI6so5+JTxsmoWiU=";
  };

  build-system = with python3.pkgs; [ pdm-backend ];

  dependencies = with python3.pkgs; [
    pydantic
  ];

  pythonImportsCheck = [ "acp" ];

  meta = with lib; {
    description = "Agent Client Protocol - A protocol for AI agent communication";
    homepage = "https://github.com/agentclientprotocol/agent-client-protocol";
    changelog = "https://github.com/agentclientprotocol/agent-client-protocol/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
  };
}
