{ pkgs, ... }:
let
  # obtained via `autorandr --fingerprint`
  surfID =
    "00ffffffffffff0030e41907a103000900200104a51b127803ef70a7514ca8260e4f5300000001010101010101010101010101010101de8a4078b08037703020550012b71000001a000000fd001e78f0f048010a202020202020000000fe004c47445f4d50312e305f0a2020000000fe004c503132395754322d53504136010970137900000301145f1701083f0b630007801f007f074f004100070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006d90";
  monitorID =
    "00ffffffffffff0004724707b28d31042b1e0104b53e22783bad65ad50459f250e50542308008140818081c081009500b300d1c001014dd000a0f0703e80302035006d552100001a565e00a0a0a02950302035006d552100001e000000fd00283ca0a03c010a202020202020000000fc0056473238304b0a2020202020200183020339f150010304121305141f9007025d5e5f60612309070783010000e200d56d030c0010003878200060010203e305e301e6060701606045023a801871382d40582c45006d552100001e011d007251d01e206e2855006d552100001e8c0ad08a20e02d10103e96006d55210000180000000000000000000000000000000011";
  frameID =
    "00ffffffffffff0009e55f0900000000171d0104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a00fb";
  notify = "${pkgs.libnotify}/bin/notify-send";
  framework = {
    crtc = 0;
    primary = true;
    position = "0x0";
    mode = "2256x1504";
    rate = "60.00";
    rotate = "normal";
    scale.x = 1.0;
    scale.y = 1.0;
  };
  surface = {
    crtc = 0;
    primary = true;
    position = "0x0";
    mode = "2880x1920";
    rate = "60.00";
    rotate = "normal";
  };
  desk-monitor = {
    crtc = 0;
    primary = true;
    position = "0x0";
    mode = "3840x2160";
    rate = "60.00";
    rotate = "normal";
  };
in {
  programs.autorandr = {
    enable = true;
    hooks = {
      predetect = { };
      preswitch = { };
      postswitch = {
        "notify-xmonad" = ''
          ${notify} -i display "Display profile" "$AUTORANDR_CURRENT_PROFILE"
        '';
        "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            away)
              DPI=96
              ;;
            home)
              DPI=178
              ;;
            *)
              ${notify} -i display "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac
          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';
      };
    };
    profiles = {
      desk-surface = {
        fingerprint = {
          eDP-1 = surfID;
          DP-2 = monitorID;
        };
        config = {
          eDP-1.enable = false;
          DP-2 = desk-monitor // { enable = true; };
        };
      };

      desk-framework = {
        fingerprint = {
          eDP-1 = frameID;
          DP-2 = monitorID;
        };
        config = {
          eDP-1 = framework // { enable = false; };
          DP-2 = desk-monitor // { enable = true; };
        };
      };

      surface = {
        fingerprint = { eDP-1 = surfID; };
        config = { eDP-1 = surface // { enable = true; }; };
      };

      framework = {
        fingerprint = { eDP-1 = frameID; };
        config = { eDP-1 = framework // { enable = true; }; };
      };
    };
  };
}
