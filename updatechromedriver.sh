#! /bin/bash
# script for download chromedriver and install
# need to send one argument 'latest' or number of need version

arg=$1
error="404"

if [ "$arg" = "latest" ]
then
    version=$(chromedriver --version | awk '{print $2 }')
    version=${version:0:4}
    newversion=$(echo " $version + 0.01  " | bc)
    echo "Current version: $version"
    link="https://chromedriver.storage.googleapis.com/$newversion/chromedriver_linux64.zip"
    echo "$link"
    responsecode=$(curl -Is $link | grep "404" | awk '{print $2}')
    echo " RESPONSE CODE: $responsecode "
    if [ "$responsecode" = "$error"  ]
    then
        echo "Latest version alredy installed"
    else
        wget $link
        unzip chromedriver_linux64.zip -d ~/
        sudo mv -f ~/chromedriver /usr/local/bin/chromedriver
        rm chromedriver_linux64.zip
        sudo chown root:root /usr/local/bin/chromedriver
        sudo chmod 0755 /usr/local/bin/chromedriver
        echo "SUCCESS: New version installed"
    fi
else
    link="https://chromedriver.storage.googleapis.com/$arg/chromedriver_linux64.zip"
    responsecode=$(curl -Is $link | grep "404" | awk '{print $2}')
    echo " RESPONSE CODE: $responsecode "
    if [ "$responsecode" = "$error"  ]
    then
        echo "Version $arg not found"
    else
        wget $link
        unzip chromedriver_linux64.zip -d ~/
        sudo mv -f ~/chromedriver /usr/local/bin/chromedriver
        rm chromedriver_linux64.zip
        sudo chown root:root /usr/local/bin/chromedriver
        sudo chmod 0755 /usr/local/bin/chromedriver
        echo "SUCCESS: version $arg was installed"
    fi
fi
