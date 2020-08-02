# v2ray-autoswitch
switch to the fastest node automatically

```sh
sudo touch /tmp/v2ray-autoswitch.log
```


create `v2ray-autoswitch.timer` in `/etc/systemd/system`
```sh
[Unit]
Description=v2ray autoswitch timer

[Timer]
OnCalendar=*:0/15

[Install]
WantedBy=timers.target
```

create `v2ray-autoswitch.service` in `/etc/systemd/system`
```sh
[Unit]
Description=v2ray autoswitch service

[Service]
Type=oneshot
ExecStart=/home/vyce/repos/v2ray-autoswitch/autoswitch.sh

[Install]
WantedBy=multi-user.target
```