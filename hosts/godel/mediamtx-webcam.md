# Godel webcam RTSP via MediaMTX

This host publishes `/dev/video1` to MediaMTX path `cam` and exposes it on:

- `rtsp://<desktop-ip>:8554/cam`

## Build

From the flake root:

```bash
nix fmt
nix build .#nixosConfigurations.godel.config.system.build.toplevel
nix flake check
```

## Apply

```bash
nixos-rebuild --flake .#godel switch --target-host=godel --sudo
```

## Verify service and stream

```bash
systemctl status mediamtx
journalctl -u mediamtx -f
ffplay -rtsp_transport tcp rtsp://<desktop-ip>:8554/cam
```

Expected behavior:

- MediaMTX starts at boot.
- The `cam` path auto-runs ffmpeg publishing from `/dev/video1`.
- If ffmpeg exits (disconnect or failure), `runOnInitRestart` relaunches it.

## Frigate / go2rtc example

```yaml
go2rtc:
  streams:
    godel-cam: rtsp://<desktop-ip>:8554/cam

cameras:
  godel_cam:
    ffmpeg:
      inputs:
        - path: rtsp://127.0.0.1:8554/godel-cam
          roles: [detect, record]
```

## Firewall behavior

TCP `8554` is opened by default when `my.mediamtxWebcam.enable = true`.

To disable LAN exposure:

```nix
my.mediamtxWebcam.openFirewall = false;
```

To use another webcam device, override:

```nix
my.mediamtxWebcam.videoDevice = "/dev/video0";
```
