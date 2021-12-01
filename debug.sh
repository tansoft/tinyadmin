#!/bin/bash

docker rm -f -v debugversion
docker run -d -v `pwd`/tinyadmin:/var/www/html --name debugversion -p80:80 -p81:81 tansoft/openresty-php:debug
#注意/var/log/有时候文件还没有完全生成，会tail不到新的文件
sleep 1
docker exec -it debugversion /bin/sh -c "tail -F /var/log/*/*"
