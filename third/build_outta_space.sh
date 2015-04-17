#!/bin/bash

cd outta_space
npm install
./node_modules/.bin/browserify -d src/main.js -t babelify -o bundle.js
./node_modules/.bin/lessc theme/style.less > theme/style.css


