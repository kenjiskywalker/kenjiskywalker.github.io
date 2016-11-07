#!/bin/bash
rm -rf ./public
hugo
cp ./CNAME ./public/CNAME
mv ./sitemap.xml ./atom.xml
git subtree push --prefix=public origin master



