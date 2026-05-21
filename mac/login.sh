#!/bin/bash
echo "Waiting for ngrok to initialize..."
sleep 10
echo ..........................................................
echo IP:
curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | sed 's/"public_url":"//'
VM_PASS="${1:-P@ssw0rd!}"
if [ "$VM_PASS" = "P@ssw0rd!" ]; then
  echo Password: P@ssw0rd!
else
  echo "Password: [The custom password you set in VM_PASSWORD]"
fi
