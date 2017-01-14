String occurrences "charset=utf-8" or "encoding=utf-8"
Ademir Moreno Escribano
São Paulo

# boot

# tty 1 - geo
ssh -o ServerAliveInterval=120 geo.maphome.io

# tty 2 - alpha - gis related
ssh -o ServerAliveInterval=120 alpha.maphome.io
sudo -u maphome shp2pgsql -d -t 2D -N abort -I -s 31983 -W LATIN1 /var/lib/maphome/inbox/empfase-20160503/RMBS_EMPR_29-04-16_region.shp inbox.empfase_20160503_31983 | sudo -u maphome psql -d maphome

# tty 3 - win - sync
cd /d/code/go/src/github.com/escribano
rsync --exclude=.git --exclude=webmap/test --exclude=webmap/src/lib --delete --filter=":- .gitignore" -avhe ssh /d/code/go/src/github.com/escribano alpha.maphome.io:code/local/go/src/github.com/

# tty 4 - win - make hs
cd /d/code/go/src/github.com/escribano/habisoft
make hs

# tty 5 - alpha - make hs
ssh -o ServerAliveInterval=120 alpha.maphome.io
cd ~/code/local/go/src/github.com/escribano/habisoft
make hs

# tty 6 - alpha - webmap
ssh -o ServerAliveInterval=120 alpha.maphome.io
cd ~/code/local/go/src/github.com/escribano/webmap
make clean
source ../habisoft/webmap/rcdebug
PYTHONIOENCODING=utf-8 make debug
lessc -ru --no-ie-compat src/style/app.less src/style/app.css

# tty 7 - alpha - nginx
ssh -o ServerAliveInterval=120 alpha.maphome.io
sudo cp ~/code/local/go/src/github.com/escribano/syntax/etc/nginx/wms.maphome.conf /etc/nginx/sites-available/
sudo cp ~/code/local/go/src/github.com/escribano/syntax/etc/nginx/alpha.maphome.conf /etc/nginx/sites-available/
sudo service nginx reload