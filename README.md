# rdp-web-dashboard

Docker image that runs `xrdp` to expose an RDP service running Firefox in kiosk mode.

`docker run -d -p 33890:3389 ghcr.io/adrianba/rdp-web-dashboard:latest u p https://example.com/`

This creates a user called `u` with password `p` and sets the kiosk page to `https://example.com/`. Connect using `mstsc.exe` on windows, and send credentials for user and password. Kiosk page will be displayed.
