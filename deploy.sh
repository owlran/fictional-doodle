#!/bin/bash
GTI_REPORT_URL=$(git config remote.origin.url)

while [ ! -f ./dist/index.html ]; do sleep 1; done
mkdir .deploy
cp -R ./dist/* .deploy
cd .deploy
git init .
git remote add github $GTI_REPORT_URL
git checkout -b gh-pages
git add .
git commit -m "Static site deploy"
git push github gh-pages -f
cd ..
rm -rf .deploy