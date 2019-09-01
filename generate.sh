#!/usr/bin/env bash
#
# dorar-history-encyclopedia epub generator
#

# Install requirments
apt-get update > /dev/null
apt-get install -y python3 python3-pip > /dev/null
wget -q https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-1-amd64.deb
dpkg -i pandoc-2.7.3-1-amd64.deb
go get -u github.com/aktau/github-release
pip3 install -r requirements.txt > /dev/null

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
echo "Converting HTML to epub"
pandoc -s dorar-history-encyclopedia.html -o dorar-history-encyclopedia.epub -f html -t epub --css=epub.css --metadata-file=epub.yml --toc --toc-depth=1

# Upload to GitHub
date=$(date +%d.%m.%Y)
$GOPATH/bin/github-release release -u yshalsager -r dorar-history-encyclopedia -t $date -n $date -d $date
for i in dorar-history-encyclopedia.*; do
$GOPATH/bin/github-release upload -u yshalsager -r dorar-history-encyclopedia -t $date -n $i -f $i
done

# Add markdown files
git config --global user.email $DRONE_COMMIT_AUTHOR_EMAIL
git config --global user.name $DRONE_COMMIT_AUTHOR_NAME
git add out/*.md
git commit -m "[ci skip] Sync: $date"
git push -q https://$GITHUB_TOKEN@github.com/yshalsager/dorar-history-encyclopedia.git HEAD:master