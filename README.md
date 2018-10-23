# Autobook script

## Install Rpi

    cd ~/Downloads

* Install nodejs


    sudo apt-get update
    sudo apt-get install nodejs npm
    sudo ln -s /usr/bin/nodejs /usr/local/bin/node
    sudo ln -s /usr/bin/npm /usr/local/bin/npm
    node -v
    npm -v

* Install phantomjs


    git clone https://github.com/piksel/phantomjs-raspberrypi.git
    chmod -x phantomjs-raspberrypi/bin/phantomjs
    chmod 775 phantomjs-raspberrypi/bin/phantomjs
    sudo ln -s /home/pi/Downloads/phantomjs-raspberrypi/bin/phantomjs /usr/bin/
    phantomjs -v

* Install casperjs


    sudo npm install -g casperjs
    casper

* Install and run scrapper


    git clone https://github.com/romaincoeur/autobook.git
    casperjs autobook/script.js --email=<your email> --password=<password>
