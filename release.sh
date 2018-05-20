#!/bin/bash

rm -rf build
xcodebuild -target OpenGithub -configuration Release

cd build/Release
zip -r OpenGithub.zip OpenGithub.app
