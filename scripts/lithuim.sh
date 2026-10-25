#!/bin/sh

echo "Installing lithum.."

# patch
cd /tmp
[ -e lithiumpatch ] && sudo rm -rf lithiumpatch
git clone https://github.com/pgaskin/lithiumpatch
cd lithiumpatch

# dict
go generate ./dict/edgedict
# font
cp "$GIT_PATH"/linux-setup/appconfig/fonts-powerline/fonts/Bookerly/* fonts/

# generate
go generate ./app
go run . app/*.apk
