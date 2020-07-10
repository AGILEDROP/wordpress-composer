# Setup

Install composer on your local or server machine.
Installation instructions at https://getcomposer.org/download/.

### Environment variable details:
* PROJECT_NAME - Name of your wordpress site
* PROJECT_HOSTNAME - Hostname of your site eg. my.wordpress.com.
Note: If you wish to run site locally through docker, the domain must be
`.localhost`
* WP_USE_SSL - Whether to use https or http on your site. Docker environment
supports both.
* WP_DB_HOST - Database host
* WP_DB_PORT - Database port
* WP_DB_USER - Database username
* WP_DB_PASS - Database password
* WP_DB_NAME - Database name. Database must be created before installation.
* WP_DB_PREFIX - Database tables prefix
* WP_DB_CHARSET - Database character set
* WP_DB_COLLATE - Database collation


## Local development environment

Project ships with docker development environment and contains the following
services:

* Apache with PHP 7.2
* MySQL 5.7
* Mailhog for email interception
* PhpMyAdmin

To install the project locally first copy .env.example to .env and replace
variables with your own then execute the following commands from the project
root:

* `composer install`
* `./start.sh`
* `./install.sh`

Access the website from the link that is outputted at the end of installation.

## Staging/production environment

SSH access to the server is required. Upload the project files to your server
then copy .env.example to .env and replace variables with your own then login
via ssh and run the following commands:

* `composer install`
* `./install-no-docker.sh`

Access the website from the link that is outputted at the end of installation.
