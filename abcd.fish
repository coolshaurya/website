#!/usr/bin/env fish

if test $argv[1] = build
    ruby src/main.rb
end

if test $argv[1] = watch; or test $argv[1] = serve
    ls -d articles/** templates/** src/** resources/** *.adoc | entr -d ruby src/main.rb &
end

if test $argv[1] = serve
    ls -d out/** | entr -rd httplz --port 7069 out
end
