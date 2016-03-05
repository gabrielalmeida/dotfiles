#!/bin/bash

# TODO Verify which OS is running this install and make it agnostic(remove .osx configs for eg)
# TODO Make it more flexible/optional steps
# TODO Check if its a full install(including apps/OS configs/etc)  or if want ONLY dotfiles installed/re-installed
# TODO #4 Make an "namespaced/isolated" mode for dotfiles, where everything overwritten will be backup'ed and can be restored to original version with a single command run(./setup.sh restore-original)

echo "Make sure git and curl are installed to get this setup working!
You MUST have sudo permission to complete most of the installs.


           ********  ******   *******               *******     *******   ********** ******** ** **       ********  ********
          **//////**/*////** /**////**             /**////**   **/////** /////**/// /**///// /**/**      /**/////  **//////
         **      // /*   /** /**   /**             /**    /** **     //**    /**    /**      /**/**      /**      /**
        /**         /******  /*******              /**    /**/**      /**    /**    /******* /**/**      /******* /*********
        /**    *****/*//// **/**///**              /**    /**/**      /**    /**    /**////  /**/**      /**////  ////////**
        //**  ////**/*    /**/**  //**             /**    ** //**     **     /**    /**      /**/**      /**             /**
         //******** /******* /**   //**            /*******   //*******      /**    /**      /**/********/******** ********
          ////////  ///////  //     //             ///////     ///////       //     //       // //////// //////// ////////

"

cd "${0%/*}"
cat "$PWD"/scripts/functions.sh > /tmp/script
set -a
. /tmp/script

if [ $# -eq 0 ]; then
  display_help
else
  while [ $# -ne 0 ]; do
    case $1 in
      -h|--help|help)                  display_help ;;
      -i|--install|install)            install ;;
      -d|--dotfiles|dotfiles)          install_only_dotfiles ;;
      -u|--update|update)              update ;;
      -r|--revert|revert)              revert ;;
      *)                               display_help ;;
    esac
    shift
  done
fi

echo "Dotfiles setup is complete."
