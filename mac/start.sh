#Downloads
# curl -s -o login.sh -L "https://raw.githubusercontent.com/JohnnyNetsec/github-vm/main/mac/login.sh"
#disable spotlight indexing
sudo mdutil -i off -a
#Create new account
sudo dscl . -create /Users/runneradmin
sudo dscl . -create /Users/runneradmin UserShell /bin/bash
sudo dscl . -create /Users/runneradmin RealName Runner_Admin
sudo dscl . -create /Users/runneradmin UniqueID 1001
sudo dscl . -create /Users/runneradmin PrimaryGroupID 80
sudo dscl . -create /Users/runneradmin NFSHomeDirectory /Users/tcv
VM_PASS="${2:-P@ssw0rd!}"
sudo dscl . -passwd /Users/runneradmin "$VM_PASS"
sudo dscl . -passwd /Users/runneradmin "$VM_PASS"
sudo createhomedir -c -u runneradmin > /dev/null
sudo dscl . -append /Groups/admin GroupMembership runneradmin
#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 
echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt
#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate
# Generate SSH key if not exists to connect to Serveo / Pinggy
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
fi

# Try Serveo
echo "Starting Serveo tunnel on port 5900..."
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o ServerAliveInterval=10 -R 0:localhost:5900 serveo.net > tunnel.log 2>&1 &
sleep 5

# Check if tunnel.log has a forwarding address, otherwise try Pinggy
if grep -q "Forwarding TCP connections" tunnel.log; then
  echo "Serveo tunnel started successfully."
else
  echo "Serveo failed, trying Pinggy..."
  kill $! 2>/dev/null || true
  ssh -p 443 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o ServerAliveInterval=10 -R 0:localhost:5900 tcp@a.pinggy.io > tunnel.log 2>&1 &
  sleep 5
fi
