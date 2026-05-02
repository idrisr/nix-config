{ bash, coreutils, imageFile, writeShellApplication, zstd }:

writeShellApplication {
  name = "write-cust-sd";
  runtimeInputs = [
    bash
    coreutils
    zstd
  ];
  text = ''
    exec bash ${../scripts/write-sd.sh} ${imageFile} "$@"
  '';
}
