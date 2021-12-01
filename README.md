## 目录结构

`debug.sh` 启动调试模式，打开 http://localhost/ 即可测试，打开 http://localhost:81/ 可以进行xhrof性能分析；

`docker/` 自定义配置参考

### `tinyadmin/` 部署目录

* `index.php` 入口文件
* `favicon.ico` 网站icon

* `composer.json` 和 `vendor/` 用于composer组件管理，框架会自动加载

* `core/` 框架核心代码
  + `Core.php` 核心框架入口文件
  + `lib/` 类库，可以直接使用
* `app/` 应用代码
  + `config/` 相关配置
  + `controller/`、`model/`、`view/` 对应MVC框架，model的类可以直接使用
  + `lib/` 类库，可以直接使用
  + `cron/` 定时任务和周期任务
* `3rd/vendor/` js 和 css 相关文件

## 路由设置 `app/config/route.php`

```php
return [
    //url完整匹配，用于首页和根路径的映射，注意需要全小写
    'urlMatch' => [
        '/' => '/base/overview',
        '/session/' => '/base/session'
    ],
    //用于controller同时服务多个路径使用，主要需要全小写
    'controllerMatch' => [
        'css' => 'cache',
        'js' => 'cache',
        'static' => 'cache'
    ],
];
```

## 页面渲染

### Sso 配置 `app/config/Sso.php`

### 定时任务 `app/config/Cron.php`

## 框架代码解释
+ controller/
  + Corectrl.php 系统默认路由，处理登录等常规要求
+ driver/
  + Cache.php
  + Db.php
  + Mq.php
  + MqMan.php
+ lib/
  + CacheManager.php
  + Crypto.php
  + DbManager.php
  + Des.php
  + Log.php
  + PdoDB.php
  + Request.php
  + Utils.php
  + View.php
  + Widget.php
+ serivce/
  + BackendServer.php
  + BaseCronTable.php
  + MqManager.php
+ widgets/
  + bootstrap3/
  + bootstrap3.php
  + sbadmin2.php

app/
+ config/
+ cron/
+ model/
+ lib/
+ thirdpart/
  + pluginman/
+ tools/
  + supervisord/
  + dojob.php
  + phperr_monitor.php
+ widgets/
  + bootstrap3/


Core::getConfig();

Core::run();


使用环境：
php7 with module:
 curl :上传下载组件使用，cdn相关的脚本使用
 pcntl :分析工具使用
 php-amqp :rabbitmq支持

cmdline tools:
 mediainfo :上传媒体是需要分析媒体的信息, VideoCrawl,WeiboFeedFilter,Upload使用
 covalkit :低质图过滤, WeiboFeedFilter使用
 range-show :文字图片过滤, WeiboFeedFilter使用
 wget :lib/Download库使用

依赖软件：
 supervisord:
  yum install epel-release
  yum install supervisor
  systemctl enable supervisord.service
  配置详见tools/supervisord/makeconf.php	
 ffmpeg:
  rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
  7: rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
  6: rpm -Uvh http://li.nux.ro/download/nux/dextop/el6/x86_64/nux-dextop-release-0-2.el6.nux.noarch.rpm
  yum install ffmpeg ffmpeg-devel -y
 增加webp：
  wget https://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2
  tar xvjf ffmpeg-4.1.tar.bz2
  yum install libwebp libwebp-devel faac faac-devel nasm gnutls-utils gnutls-devel ladspa ladspa-devel libass libass-devel openjpeg2-devel x264-devel x264 x265-devel x265 xvidcore-devel xvidcore openal-soft openal-soft-devel
  // --enable-libgsm  --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-libopus --enable-libpulse --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libv4l2 
  ./configure --prefix=/usr --bindir=/usr/bin --datadir=/usr/share/ffmpeg --incdir=/usr/include/ffmpeg --libdir=/usr/lib64 --mandir=/usr/share/man --arch=x86_64 --optflags='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' --extra-ldflags='-Wl,-z,relro ' --enable-version3 --enable-bzlib --disable-crystalhd --enable-gnutls --enable-ladspa --enable-libass --disable-indev=jack --enable-libfreetype --enable-openal --enable-libopenjpeg  --enable-libx264 --enable-libx265 --enable-libxvid --enable-avfilter --enable-avresample --enable-postproc --enable-pthreads --disable-static --enable-shared --enable-gpl --disable-debug --disable-stripping --shlibdir=/usr/lib64 --enable-runtime-cpudetect --enable-libwebp
如何增加Cron任务：
 1. git下，修改tools/supervisord/admin.ini
 2. root下，执行php tools/supervisord/makeconf.php admin.ini
 3. supervisorctl update

upload config:
	/home/git/nginx/conf/nginx.conf 
	    client_max_body_size 512m;
	vi /home/git/php/lib/php.ini 
	    post_max_size = 512M
	    upload_max_filesize = 512M
    vi /home/git/php/etc/php-fpm.d/admin.conf
        request_terminate_timeout = 60
