Capistrano tasks for Shopware6
===============================

This gem contains instructions to deploy a [Shopware](https://www.shopware.com) 6.5 on production template instance with [Capistrano](https://capistranorb.com/).

Details
-------

* `bin/console maintenance:enable`
* `touch install.lock`
* `composer install`
* `bin/console database:migrate --all`
* `deps build build_js.sh`
* `bin/console theme:compile`
* `bin/console maintenance:disable`
* `bin/console cache:warmup`

Usage
-----

To use this gem add this to your `Gemfile`

`gem "capistrano_shopware6_5"`

and then this line to your `Capfile`

`require "capistrano/shopware"`
