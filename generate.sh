#!/usr/bin/env bash
#
# dorar-history-encyclopedia epub generator
#

# Install requirments
apt update > /dev/null && apt install -y python3 python3-pip pandoc > /dev/null
go get -u github.com/aktau/github-release

# Download
echo "Downloading latest data"
python3 scraper.py

# combine markdown 
echo "Combining markdown files"
pandoc -s `ls -v out/*.md` -o dorar-history-encyclopedia.md -f gfm -t gfm
# convert markdown to HTML
echo "Converting markdown to HTML"
pandoc -s `ls -v out/*.md` -o dorar-history-encyclopedia.html -f gfm -t html --metadata title="الموسوعة التاريخية -  الدرر السنية" --metadata dir="rtl"
# convert HTML to epub
echo "convert HTML to epub"
pandoc -s dorar-history-encyclopedia.html -o dorar-history-encyclopedia.epub -f html -t epub --css=epub.css --metadata-file=epub.yml --toc --toc-depth=1

# Upload to GitHub
date = $(date +%d.%m.%Y)
$GOPATH/bin/github-release release -u yshalsager -r dorar-history-encyclopedia -t $date -n $date
for i in dorar-history-encyclopedia.*; do
$GOPATH/bin/github-release upload -u yshalsager -r dorar-history-encyclopedia -t $date -n $i -f $i
done