ssh in ( do not sudo ) as the user who will run the rootless container, in this case the user is called, svc_redcaptest (this is the test environment)

Create the build directory

mkdir -p ~/podman/redcaptest

cd ~/podman/redcaptest

Place Containerfile, entrypoint.sh and php.in into  ~/podman/redcaptest

(As root) Either add subuid and subgid's ranges locally or to IPA. If using IPA add the line "subid: sss" to /etc/nsswitch.conf

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

This will create the 5 volumes and (directory structure) under ~/.local/share/containers/storage/volumes/

cd ~/podman/redcaptest  and build the container with the command,

podman build -t redcapt1:xx .  # note increment xx as needed do not use "latest" as it is considered bad practice.

Generate the ssl keys and send off to get the certificate.

cd /home/svc_redcaptest/.local/share/containers/storage/volumes/systemd-redcapt1-ssl/_data

openssl req -new -newkey rsa:2048 -nodes -keyout example.co.nz.key -out example.co.nz.csr

Place the returned crt files in /home/svc_redcaptest/.local/share/containers/storage/volumes/systemd-redcapt1-ssl/_data/

cd /home/svc_redcapdev/.local/share/containers/storage/volumes/systemd-httpd1-http/_data/conf.d

Edit the conf.d/ssl.conf file to point at the certificates.  eg.,

8><---

SSLCertificateFile /etc/pki/tls/certs/example.co.nz.crt

SSLCertificateKeyFile /etc/pki/tls/certs/example.co.nz.key

SSLCertificateChainFile /etc/pki/tls/certs/DigiCertCA.crt

8><---

Download the latest Redcap LTS zip and expand in,

/home/svc_redcaptest/.local/share/containers/storage/volumes/systemd-redcapt1-redcap/_data

copy the contents of the ~redcap sub-directory created up one directory (to /home/svc_redcaptest/.local/share/containers/storage/volumes/systemd-redcapt1-redcap/_data (to what will be /var/www/html/)   

cp -a redcap/* .

Edit database.php setting the database info AND set a salt all of which must be recorded safely.

chmod 0777 modules and temp  sub-directories.

mkdir /home/svc_redcaptest/.local/share/containers/storage/volumes/systemd-redcapt1-redcap/_data/archive and copy all the files and directories 
(especially database.php) to archive for safe keeping as you will need files to recover from an upgrade gone wrong.

Now run,

systemctl --user daemon-reload

systemctl --user start redcapt1.service

At this point you should be running on port 8081.

https://example.co.nz:8081

You will now need an Apache, Nginx or a commercial proxy in front of the server to direct port 443 to 8081.


NOTES

A crontab needs to be set as the rootless account that will trigger an internal cleanup, example provided.





