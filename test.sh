#!/usr/bin/env bash
set -ev
export PATH="$PWD/test/here/bin:$PATH"
HEREROCKS="python hererocks.py test/here --downloads=test/cache"

rm test/here -rf
$HEREROCKS -l^ -r^
lua -v
luarocks --version
luarocks make
hererocks-test | grep "5\.3"
$HEREROCKS -l^ -r^ | grep "already installed"

rm test/here -rf
$HEREROCKS -j 2.1 -r^ | grep "Fetching" | grep "cached"
lua -v
luarocks --version
luarocks make
hererocks-test | grep "2\.1"

rm test/here -rf
$HEREROCKS -l 5.1 --compat=none
lua -e "assert(not pcall(string.gfind, '', '.'))"
lua -e "(function(...) assert(arg == nil) end)()"
lua -e "assert(math.mod == nil)"

rm test/here -rf
$HEREROCKS -l 5.3 --compat=none --builds=test/builds
lua -e "assert(module == nil)"

rm test/here -rf
$HEREROCKS -l 5.3 --compat=none --builds=test/builds | grep "Building" | grep "cached"