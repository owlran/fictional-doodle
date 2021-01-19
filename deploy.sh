#!/bin/bash
GTI_REPORT_URL=$(git config remote.origin.url)

while [ ! -f ./dist/index.html ]; do sleep 1; done
mkdir .deploy
cp -R ./dist/* .deploy
cd .deploy
git init .
git remote add github $GTI_REPORT_URL
git checkout -b gb-pages
git add .
git commit -m "Static site deploy"
git push github HEAD:refs/for/gh-pages --force
cd ..
rm -rf .deploy