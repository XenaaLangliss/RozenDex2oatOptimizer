# Setup
setup_native_libs() {
  case "$ARCH" in
    arm64)
      mv -f "$MODPATH"/libs/arm64-v8a/* "$MODPATH/libs"
      rm -rf "$MODPATH/libs/arm64-v8a" "$MODPATH/libs/armeabi-v7a" "$MODPATH/libs/x86" "$MODPATH/libs/x86_64"
      ;;
    arm)
      mv -f "$MODPATH"/libs/armeabi-v7a/* "$MODPATH/libs"
      rm -rf "$MODPATH/libs/armeabi-v7a" "$MODPATH/libs/arm64-v8a" "$MODPATH/libs/x86" "$MODPATH/libs/x86_64"
      ;;
    x86)
      mv -f "$MODPATH"/libs/x86/* "$MODPATH/libs"
      rm -rf "$MODPATH/libs/x86" "$MODPATH/libs/armeabi-v7a" "$MODPATH/libs/arm64-v8a" "$MODPATH/libs/x86_64"
      ;;
    x64)
      mv -f "$MODPATH"/libs/x86_64/* "$MODPATH/libs"
      rm -rf "$MODPATH/libs/x86_64" "$MODPATH/libs/armeabi-v7a" "$MODPATH/libs/x86" "$MODPATH/libs/arm64-v8a"
      ;;
  esac
}

# Module Info
MODNAME=$(grep_prop name $MODPATH/module.prop)
MODVER=$(grep_prop version $MODPATH/module.prop)
DV=$(grep_prop author $MODPATH/module.prop)

# Device Info
Device=$(getprop ro.product.device)
Model=$(getprop ro.product.model)
Brand=$(getprop ro.product.brand)
Architecture=$(getprop ro.product.cpu.abi)
SDK=$(getprop ro.system.build.version.sdk)
Android=$(getprop ro.system.build.version.release)
Type=$(getprop ro.system.build.type)
Built=$(getprop ro.system.build.date)
Time=$(date "+%d, %b - %H:%M %Z")

# Output Info
ui_print " "
ui_print "-------------------------------------"
ui_print " Fetching module & device info..."
ui_print "-------------------------------------"
sleep 1.5
ui_print "- Author       : $DV"
sleep 0.3
ui_print "- Module       : $MODNAME"
sleep 0.3
ui_print "- Version      : $MODVER"
sleep 0.3
ui_print "- Device       : $Model [$Device]"
sleep 0.3
ui_print "- Brand        : $Brand"
sleep 0.3
ui_print "- Android      : $Android (SDK $SDK)"
sleep 0.3
ui_print "- CPU Arch     : $Architecture"
sleep 0.3
ui_print "- Build Type   : $Type"
sleep 0.3
ui_print "- Build Time   : $Built"
sleep 0.3
ui_print "- Installed at : $Time"
sleep 0.3
if [ "$KSU" ]; then
  ui_print "- Root Provider: KernelSU"
  ui_print "- KernelSU Ver : $KSU_KERNEL_VER_CODE (kernel), $KSU_VER_CODE (ksud)"
  if [ "$(which magisk)" ]; then
    ui_print "-------------------------------------"
    ui_print "! Multiple root systems detected!"
    abort "! Please use only one (Magisk OR KernelSU)."
  fi
elif [ "$MAGISK_VER_CODE" ]; then
  ui_print "- Root Provider: Magisk"
  ui_print "- Magisk Versn : $MAGISK_VER_CODE"
else
  ui_print "- Root Provider: Unknown"
fi
ui_print "-------------------------------------"
ui_print " "
sleep 3
ui_print "- Please wait..."
ui_print " "
sleep 5
ui_print "- Setup native libs"
setup_native_libs
ui_print "- Done"
ui_print " "
sleep 5
ui_print "- Setup permission"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive $MODPATH/system 0 0 0777 0755
set_perm_recursive $MODPATH/libs 0 0 0777 0755
ui_print "- Done"
ui_print " "
sleep 3
ui_print "- Setup completed"
sleep 2
ui_print "- Please reboot your phone!!!!"