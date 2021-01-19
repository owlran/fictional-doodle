#!/bin/bash
GTI_REPORT_URL=$(git config remote.origin.url)

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
# rm -rf .deploy