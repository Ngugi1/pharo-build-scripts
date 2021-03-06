#!bash -lex
#
# build-vm.sh -- Builds Cog Virtual Machine. Have to be used together with Jenkins.
#
# Copyright (c) 2012 Christophe Demarey
#

# Set environment
PROCESS_PLUGIN="UnixOSProcessPlugin"
ZIP_FILTER='*'

if [ "$OS" == "win" ]; then
    set -e # Stop the execution if a command fails!
	CONFIGNAME="CogWindowsConfig"
    PROCESS_PLUGIN="Win32OSProcessPlugin"
    ZIP_FILTER=' *.exe *.dll'
elif [ "$OS" == "mac" ]; then
    CONFIGNAME="CogCocoaIOSConfig"
    export MACOSX_DEPLOYMENT_TARGET=10.5
else # OS == linux
    CONFIGNAME="CogUnixConfig"
fi

# Unpack sources
cd "$WORKSPACE"

rm -rf cog
tar xvzf cog.tar.gz || echo # echo needed for Windows build (error on symlinks creation)

mkdir -p cog/build
mkdir -p cog/image

cd cog/image
unzip -o ../../vmmaker-image.zip


# Generate sources
echo "$CONFIGNAME new
  addExternalPlugins: #( FT2Plugin );
  addInternalPlugins: #( $PROCESS_PLUGIN );
  generateSources; generate.

Smalltalk snapshot: false andQuit: true." > ./script.st
"$SQUEAKVM" -headless generator.image script.st -headless

cd ../../
tar -cvzf ${CONFIGNAME}-sources.tar.gz -C cog .


# Compile
cd cog/build
if [ "$OS" == "win" ]; then
  cmake -G "MSYS Makefiles" .
else
  cmake .
fi
make
cd ../results

# Archive
COG_ZIP_FILE="Cog-${OS}.zip"

zip -r $COG_ZIP_FILE $ZIP_FILTER
mv -f $COG_ZIP_FILE ../../

#if [ "$OS" == "mac" ]; then
#    zip -r ../build/CogVM.zip CogVM.app
#    mv -f ../build/CogVM.zip ../../
#else
#    zip -r Cog.zip $ZIP_FILTER
#    mv Cog.zip ../../
#fi

# success
exit 0
