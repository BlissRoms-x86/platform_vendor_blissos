#!/bin/bash

rom_fp="$(date +%y%m%d)"
rompath=$(pwd)
mkdir -p release/$rom_fp/
set -e

localManifestBranch="q-x86"
rom="Android-PC"
bliss_variant=""
bliss_variant_name=""
bliss_release="n"
bliss_partiton=""
filename=""
file_size=""
clean="n"
sync="n"
patch="n"
proprietary="n"
romBranch=""
desktopmode="n"

if [ -z "$USER" ];then
        export USER="$(id -un)"
fi
export LC_ALL=C

if [[ $(uname -s) = "Darwin" ]];then
        jobs=$(sysctl -n hw.ncpu)
elif [[ $(uname -s) = "Linux" ]];then
        jobs=$(nproc)
fi


while test $# -gt 0
do
  case $1 in

  # Normal option processing
    -h | --help)
      echo "Usage: $0 options buildVariants blissBranch/extras"
      echo "options: -s | --sync: Repo syncs the rom (clears out patches), then reapplies patches to needed repos"
      echo "		 -p | --patch: Run the patches only"
      echo "		 -r | --proprietary: build needed items from proprietary vendor (non-public)"
      echo "		 -d | --desktopmode: Duild without any traditional launchers and only use Taskbar/TSL from @farmerbb"
      echo "buildVariants: "
      echo "android_x86-user, android_x86-userdebug, android_x86-eng,  "
      echo "android_x86_64-user, android_x86_64-userdebug, android_x86_64-eng"
      echo "blissBranch: select which bliss branch to sync, default is p9.0"
      echo "extras: specify 'foss', 'go', 'gms', 'gapps' or 'none' to be built in"
      ;;
    -c | --clean)
      clean="y";
      echo "Cleaning build and device tree selected."
      ;;
    -v | --version)
      echo "Version: Bliss x86 Builder 2.0"
      echo "Updated: 10/19/2019"
      ;;
    -s | --sync)
      sync="y";
      echo "Repo syncing and patching selected."
      ;;
    -p | --patch)
      patch="y";
      echo "patching selected."
      ;;
    -r | --proprietary)
      proprietary="y";
      echo "proprietary selected."
      ;;
    -d | --desktopmode)
	  desktopmode="y";
	  echo "desktop mode selected"
      ;;
  # ...

  # Special cases
    --)
      break
      ;;
    --*)
      # error unknown (long) option $1
      ;;
    -?)
      # error unknown (short) option $1
      ;;

  # FUN STUFF HERE:
  # Split apart combined short options
    -*)
      split=$1
      shift
      set -- $(echo "$split" | cut -c 2- | sed 's/./-& /g') "$@"
      continue
      ;;

  # Done with options
    *)
      break
      ;;
  esac

  # for testing purposes:
  shift
done


if [ "$1" = "android_x86_64-user" ];then
        bliss_variant=android_x86_64-user;
        bliss_variant_name=android_x86_64-user;

elif [ "$1" = "android_x86_64-userdebug" ];then
        bliss_variant=android_x86_64-userdebug;
        bliss_variant_name=android_x86_64-userdebug;

elif [ "$1" = "android_x86_64-eng" ];then
        bliss_variant=android_x86_64-eng;
        bliss_variant_name=android_x86_64-eng;
        
elif [ "$1" = "android_x86-eng" ];then
        bliss_variant=android_x86-eng;
        bliss_variant_name=android_x86-eng;

elif [ "$1" = "android_x86-userdebug" ];then
        bliss_variant=android_x86-userdebug;
        bliss_variant_name=android_x86-userdebug;

elif [ "$1" = "android_x86-eng" ];then
        bliss_variant=android_x86-eng;
        bliss_variant_name=android_x86-eng;
else
	echo "you need to at least use '--help'"

fi

echo -e ${CL_CYN}""${CL_CYN}
echo -e ${CL_CYN}"      ___           ___                   ___           ___      "${CL_CYN}
echo -e ${CL_CYN}"     /\  \         /\__\      ___        /\  \         /\  \     "${CL_CYN}
echo -e ${CL_CYN}"    /::\  \       /:/  /     /\  \      /::\  \       /::\  \    "${CL_CYN}
echo -e ${CL_CYN}"   /:/\:\  \     /:/  /      \:\  \    /:/\ \  \     /:/\ \  \   "${CL_CYN}
echo -e ${CL_CYN}"  /::\~\:\__\   /:/  /       /::\__\  _\:\~\ \  \   _\:\~\ \  \  "${CL_CYN}
echo -e ${CL_CYN}" /:/\:\ \:\__\ /:/__/     __/:/\/__/ /\ \:\ \ \__\ /\ \:\ \ \__\ "${CL_CYN}
echo -e ${CL_CYN}" \:\~\:\/:/  / \:\  \    /\/:/  /    \:\ \:\ \/__/ \:\ \:\ \/__/ "${CL_CYN}
echo -e ${CL_CYN}"  \:\ \::/  /   \:\  \   \::/__/      \:\ \:\__\    \:\ \:\__\   "${CL_CYN}
echo -e ${CL_CYN}"   \:\/:/  /     \:\  \   \:\__\       \:\/:/  /     \:\/:/  /   "${CL_CYN}
echo -e ${CL_CYN}"    \::/__/       \:\__\   \/__/        \::/  /       \::/  /    "${CL_CYN}
echo -e ${CL_CYN}"     ~~            \/__/                 \/__/         \/__/     "${CL_CYN}
echo -e ${CL_CYN}""${CL_CYN}

if [ "$2" = "foss" ];then
   export USE_OPENGAPPS=false
   export USE_FDROID=false
   export USE_FOSS=true
   export USE_GO=false
   export USE_GMS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"======-Bliss-OS(x86) Building w/ microG & F-Droid-====="${CL_RST}
   echo -e ${CL_CYN}"       Thank you for contributing to our project"     ${CL_RST}
   echo -e ${CL_CYN}"====================================================="${CL_RST}
   echo -e ""
   
elif [ "$2" = "gapps" ];then
   export USE_FOSS=false
   export USE_FDROID=false
   export USE_GO=false
   export USE_OPENGAPPS=true
   export USE_GMS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"=========-Bliss-OS(x86) Building w/ OpenGapps-========="${CL_RST}
   echo -e ${CL_CYN}"       Thank you for contributing to our project"     ${CL_RST}
   echo -e ${CL_CYN}"====================================================="${CL_RST}
   echo -e ""
   
elif [ "$2" = "go" ];then
   export USE_GO=true
   export USE_FDROID=false
   export USE_FOSS=false
   export USE_OPENGAPPS=false
   export USE_GMS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"=============-Bliss-OS(x86) Building w/ Go-============"${CL_RST}
   echo -e ${CL_CYN}"       Thank you for contributing to our project"     ${CL_RST}
   echo -e ${CL_CYN}"====================================================="${CL_RST}
   echo -e ""
   
   
elif [ "$2" = "none" ];then
   export USE_FOSS=false
   export USE_FDROID=false
   export USE_GO=false
   export USE_OPENGAPPS=false
   export USE_GMS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"=============-Bliss-OS(x86) Building Clean-============"${CL_RST}
   echo -e ${CL_CYN}"       Thank you for contributing to our project"     ${CL_RST}
   echo -e ${CL_CYN}"====================================================="${CL_RST}
   echo -e ""
   
elif [ "$2" = "gms" ];then
   export USE_GMS=true
   export USE_FDROID=false
   export USE_FOSS=false
   export USE_GO=false
   export USE_OPENGAPPS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"===========-Bliss-OS(x86) Building with GMS-==========="${CL_RST}
   echo -e ${CL_CYN}"       Thank you for contributing to our project"     ${CL_RST}
   echo -e ${CL_CYN}"====================================================="${CL_RST}
   echo -e ""

elif [ "$2" = "fdroid" ];then
   export USE_FDROID=true
   export USE_GMS=false
   export USE_FOSS=false
   export USE_GO=false
   export USE_OPENGAPPS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"=========-Bliss-OS(x86) Building with FDROID-=========="${CL_RST}
   echo -e ${CL_CYN}"       Thank you for contributing to our project"     ${CL_RST}
   echo -e ${CL_CYN}"====================================================="${CL_RST}
   echo -e ""
   
else
   export USE_FDROID=false
   export USE_GMS=false
   export USE_FOSS=false
   export USE_GO=false
   export USE_OPENGAPPS=false
   echo -e ${CL_CYN}""${CL_CYN}
   echo -e ${CL_CYN}"======-Bliss-OS(x86) Building with no additions-======"${CL_RST}
   echo -e ${CL_CYN}"      Thank you for contributing to our project"       ${CL_RST}
   echo -e ${CL_CYN}"======================================================"${CL_RST}
   echo -e ""
   
fi

if [ "$3" = "croshoudini" ];then
	export USE_HOUDINI=true
	echo -e ${CL_CYN}""${CL_CYN}
	echo -e ${CL_CYN}"======-Bliss-OS(x86) Building with Houdini addon-====="${CL_RST}
	echo -e ${CL_CYN}"Source: https://github.com/me176c-dev/android_vendor_google_chromeos-x86 "${CL_RST}
	echo -e ${CL_CYN}"======================================================"${CL_RST}
	echo -e ""

elif [ "$3" = "croswidevine" ];then
	export USE_WIDEVINE=true
	echo -e ${CL_CYN}""${CL_CYN}
	echo -e ${CL_CYN}"=====-Bliss-OS(x86) Building with Widevine addon-====="${CL_RST}
	echo -e ${CL_CYN}"Source: https://github.com/me176c-dev/android_vendor_google_chromeos-x86 "${CL_RST}
	echo -e ${CL_CYN}"======================================================"${CL_RST}
	echo -e ""

elif [ "$3" = "crosboth" ];then
	export USE_HOUDINI=true
	export USE_WIDEVINE=true
	echo -e ${CL_CYN}""${CL_CYN}
	echo -e ${CL_CYN}"====-Bliss-OS(x86) Building w/ Widevine & Houdini-===="${CL_RST}
	echo -e ${CL_CYN}"Source: https://github.com/me176c-dev/android_vendor_google_chromeos-x86 "${CL_RST}
	echo -e ${CL_CYN}"======================================================"${CL_RST}
	echo -e ""

elif [ "$3" = "crosnone" ];then
	export USE_HOUDINI=false
	export USE_WIDEVINE=false

else
	export USE_HOUDINI=false
	export USE_WIDEVINE=false

fi

if [ $desktopmode == "y" ];then
	export BLISS_DESKTOPMODE=true
fi

if  [ $sync == "y" ];then
         #~ repo init -u https://github.com/BlissRoms/platform_manifest.git -b $romBranch 
         #~ rm -f .repo/local_manifests/*
	#~ if [ -d $rompath/.repo/local_manifests ] ;then
		 #~ cp -r $rompath/build/make/core/x86/x86_manifests/* $rompath/.repo/local_manifests
	#~ else
		 #~ mkdir -p $rompath/.repo/local_manifests
		 #~ cp -r $rompath/build/make/core/x86/x86_manifests/* $rompath/.repo/local_manifests
	#~ fi
	
	repo sync -c -j$jobs --no-tags --no-clone-bundle --force-sync
	
else 
	echo "Not gonna sync this round"
fi

if [ $clean == "y" ];then
	echo "Cleaning up a bit"
    make clean && make clobber 
fi

if  [ $sync == "y" ];then
	echo "Let the patching begin"
	bash "$rompath/vendor/blissos/autopatch.sh"
fi

if  [ $patch == "y" ];then
	echo "Let the patching begin"
	bash "$rompath/vendor/blissos/autopatch.sh"
fi


if [[ "$1" = "android_x86_64-user" || "$1" = "android_x86_64-userdebug" || "$1" = "android_x86_64-eng" || "$1" = "android_x86-user" || "$1" = "android_x86-userdebug" || "$1" = "android_x86-eng" ]];then
echo "Setting up build env for: $1"
	. build/envsetup.sh
fi

buildProprietary() {
	echo "Setting up Proprietary environment for: $1"
	lunch $bliss_variant
	echo "Building proprietary tools, part 1... This won't take too long..."
	cd vendor/google/chromeos-x86
	./extract-files.sh
	cd ..
	cd ..
	cd ..
	
	# mka update_engine_applier
	# echo "Building proprietary tools... part 2... This may take a while..."
	# mka proprietary
}

buildVariant() {
	echo "Starting lunch command for: $1"
	lunch $1
	echo "Starting up the build... This may take a while..."
	make -j$((`nproc`-2)) iso_img
	# nproc | xargs -I % make -j% iso_img
}

if  [ $proprietary == "y" ];then
	. build/envsetup.sh
	buildProprietary $bliss_variant
fi

if [[ "$1" = "android_x86_64-user" || "$1" = "android_x86_64-userdebug" || "$1" = "android_x86_64-eng" || "$1" = "android_x86-user" || "$1" = "android_x86-userdebug" || "$1" = "android_x86-eng" ]];then
	buildVariant $bliss_variant $bliss_variant_name
fi
