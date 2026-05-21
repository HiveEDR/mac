#!/bin/bash
echo "Waiting for tunnel to initialize..."
sleep 10
echo ..........................................................
echo "Connection Address / Port (IP):"
cat tunnel.log
VM_PASS="${1:-P@ssw0rd!}"
if [ "$VM_PASS" = "P@ssw0rd!" ]; then
  echo Password: P@ssw0rd!
else
  echo "Password: [The custom password you set in VM_PASSWORD]"
fi
