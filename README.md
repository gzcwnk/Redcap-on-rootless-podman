ssh in ( do not sudo ) as the user who will run the rootless container, in my case svc_redcaptest (this is the test environment)

Create the build directory

mkdir -p ~/podman/redcaptest

cd ~/podman/redcaptest

Place Containerfile, entrypoint.sh and php.in into  ~/podman/redcaptest

Either add subuid and subgid's ranges locally or to IPA. If using IPA add the line "subid: sss" to /etc/nsswitch.conf

logout and ssh back in for change to take effect.

Create the start directory,

mkdir -p ~/.config/containers/systemd/

cd ~/.config/containers/systemd/

Place the redcapt1.container and volumes files in ~/.config/containers/systemd/

Create the volumes, run,

podman volume create systemd-redcapt1-redcap
podman volume create systemd-redcapt1-ssl2
podman volume create systemd-redcapt1-http2
podman volume create systemd-redcapt1-logs
podman volume create systemd-redcapt1-home

This will creat the 5 volumes under ~/.local/share/containers/storage/volumes/

cd ~/podman/redcaptest  and build the conatiner with the command,

podman build -t redcapt1:xx .  # note increment xx as needed do not use latest as it is considfered bad practice.

TO BE COMPLETED
