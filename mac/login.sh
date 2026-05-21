#!/bin/bash
echo "Waiting for ngrok to initialize..."
sleep 10
echo ..........................................................
echo IP:
curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | sed 's/"public_url":"//'
echo Username: runneradmin
echo Password: P@ssw0rd!
