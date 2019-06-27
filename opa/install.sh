# Install the interactive shell
cd ~
cd opa
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.9.0/opa_linux_amd64
chmod +x opa

# Install the docker container
docker pull openpolicyagent/opa
docker run -p 8181:8181 openpolicyagent/opa run --server --log-level debug
