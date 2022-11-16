# BCWT - Installing a Virtual Server on Azure cloud environmnent

## Materials & links

Browse, read, watch & study:

- [Introduction to Azure fundamentals](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-fundamentals/)
- [Get started with Azure](https://azure.microsoft.com/en-us/get-started/)
- [MS Azure Youtube channel](https://www.youtube.com/channel/UC0m-80FnNY2Qb7obvTL_2fA)
- [Azure portal](https://portal.azure.com/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure network security group](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)

Help for Linux usage:

- [Using Linux command line](https://ubuntu.com/tutorials/command-line-for-beginners)
- [The Beginner’s Guide to Nano, the Linux Command-Line Text Editor](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/)
- [Ubuntu package management](https://ubuntu.com/server/docs/package-management)
- [Ubuntu firewall](https://ubuntu.com/server/docs/security-firewall)

## Getting started & setting up the environment

1. Sign up for a free [student account](https://azure.microsoft.com/en-us/free/students/) using your school email address & login, you should get some free credits (100 USD), [more info](https://docs.microsoft.com/en-us/azure/education-hub/azure-dev-tools-teaching/program-faq)
1. Go to [Azure portal](https://portal.azure.com/)
1. Create a resource: Virtual machine (VM), use server instance, e.g. latest Ubuntu server LTS)

   - select [VM size](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes) & disks according your needs (Think about what is the minimum for a web server? Check the OS system requirements, etc.) 
   - 'Standard_B1ms' is the teacher's recommendation for this course
   - NOTE: you have 100 USD of student credits to spend in total (for a one year)
   - Allow access to SSH, HTTP and HTTPS ports

   [Basic example setup](img/azure-vm-settings.png)

   - Finally hit the _CREATE_ button and after successful deployment of the virtual machine go to the resources's _Overview_ page and configure the _DNS name_.

2. Use SSH connection for managing your VM (`ssh username@PUBLIC_IP/YOUR_DOMAIN_NAME` in terminal/git bash or use e.g. [Putty](https://www.putty.org/))

   - Optional: use public key authentication instead of username/password: [Instructions](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-22-04)

3. Make sure you have all recent updates installed (this should be done on weekly basis)

   ```bash
   sudo apt update # checks for available updates
   sudo apt dist-upgrade # installs updates including kernel packages
   ```

   All administrator level tasks needs superuser (root) privileges. `sudo` (_superuser do_) needs to used before the actual command for gaining the access rights. Use your login password if prompted. 

## Installing & configuring web server software

### Apache web server

1. Install

   ```sh
   sudo apt update
   sudo apt upgrade
   sudo apt install apache2
   ```

2. Check configuration files `/etc/apache2/` & start `sudo systemctl start apache2`
3. Add write permissions to your user account for the webroot folder `/var/www/html`: `sudo chown <MYUSERNAME>.<GROUP> /var/www/html`
4. Copy your UI files to the webroot using e.g. scp/filezilla/winscp or clone/pull from GitHub
5. Test with browser <http://my.server.ipaddress.or.hostname/>
6. Enable HTTPS connections using Let's encrypt & Certbot

   - [Let’s Encrypt is a free, automated, and open certificate authority (CA)](https://letsencrypt.org/about/)
   - Use the [Certbot](https://certbot.eff.org/) for easy installation:

   ```sh
   # Ensure that your version of snapd is up to date
   sudo snap install core; sudo snap refresh core
   # Install Certbot 
   sudo snap install --classic certbot
   # Get a certificate and have Certbot edit your apache configuration automatically to serve it, turning on HTTPS access in a single step
   sudo certbot --apache
   # Answer the questions when prompted, you need to provide your server DNS-name, something like <my.website>.cloudapp.azure.com
   ```

   - To confirm that your site is set up properly, visit https://yourwebsite.cloudapp.azure.com/ in your browser and look for the lock icon in the URL bar

### MariaDB database server

1. Install MariaDB server ([more detailed instructions](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-22-04)):

   ```bash
   sudo apt install mariadb-server
   ```

1. Start and enable it:

   ```bash
   sudo systemctl start mariadb
   sudo systemctl enable mariadb
   ```

1. Secure it by running the sript (optional in our one server system):

   ```console
   mysql_secure_installation
   ```

   Note: In Ubuntu you don't necessary need root password at all. Just use sudo for gaining root access: `sudo mysql -u root`. Skip that step when prompted.

1. Connect to your database server as a root user: `sudo mysql -u root` and create a database and a user with privileges on it:

   ```sql
   CREATE DATABASE catdb;
   CREATE USER 'dbuser' IDENTIFIED BY 'test123';
   GRANT USAGE ON *.* TO 'dbuser'@localhost IDENTIFIED BY 'test123';
   GRANT ALL ON catdb.* TO 'dbuser'@'localhost';
   FLUSH PRIVILEGES;
   exit
   ```

   (in case you would need outside access (e.g. during project, separate database server from app server), replace `localhost` with `'%'` in the two GRANT queries and remember that the settings you did with `mysql_secure_installation` may prevent this).

1. Download the [cat-db-starter.sql](./cat-db-starter.sql) SQL script. Can be done directly from server using curl: `curl -O <FILE-URL>` (note: click the _Raw_ button on script's GitHub page in order to get a working url) or downloaded at first to your local computer and then uploaded with any SCP file transfer tool to the server. (e.g. using command line secure copy tool **scp**: `scp cat-db-starter.sql <YOUR-USERNAME>@<YOUR-SERVE-NAME/IP>:`)
1. Import the tables and insert the data: `mysql -u dbuser -p catdb < cat-db-starter.sql`
1. Eventually check that data is there: `mysql -u dbuser -p catdb`

   ```sql
   SHOW TABLES;
   SELECT * FROM wop_cat;
   exit
   ```

1. (Optional) if you would like to install phpMyAdmin to administrate your databases, tables and data with a graphical user interface, check for example [instructions here](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-22-04)

### NodeJS application server

1. Install _node.js_ and _npm_ (read e.g. [some instructions](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-22-04)):

   ```bash
   curl -sL https://deb.nodesource.com/setup_18.x -o /tmp/nodesource_setup.sh
   sudo bash /tmp/nodesource_setup.sh
   sudo apt install nodejs
   # check that the installed tools are working:
   node -v
   npm -v
   ```

1. Configure Apache httpd server as a reverse proxy to Node server:

   1. Edit the Apache configuration (Let's encrypt's default SSL configuration file):

      ```bash
      sudo nano /etc/apache2/sites-available/000-default-le-ssl.conf
      ```

   1. Add the following content (to the bottom of `<VirtualHost *:443>` block) & save the conf file:

      ```apacheconf
      <VirtualHost *:443>
        # stuff ...
        # some more stuff ...

        ProxyPreserveHost On
        ProxyPass /app/ http://127.0.0.1:3000/
        ProxyPassReverse /app/ http//:127.0.0.1:3000/
      </VirtualHost>
      ```

1. When working with Ubuntu 22.04 default installation you need to enable modules `proxy` and `proxy_http` by using command `sudo a2enmod <MODULE-NAME>` and restart the web server:

      ```bash
      sudo a2enmod proxy proxy_http
      sudo systemctl restart apache2
      ```

1. Install and run your node application:

   1. make sure you are in your home folder: `cd`
   2. clone or copy your back-end app to your home folder on the server (exluding the contents of `node_modules` & `uploads` folders)
   3. go to the app directory: `cd <my-app>`
   4. if you cloned the repo, check that you are in the right branch (checkout if not)
   5. install your dependencies: `npm install`
   6. create/edit `.env` file with your db credentials (you set in [MariaDB](#install-and-configure-mariadb-database-server)):

      ```apacheconf
       DB_HOST=127.0.0.1
       DB_USER=<your-db-user>
       DB_PASS=<your-db-user_password>
       DB_NAME=<your-db-name>
      ```

   7. start your application: `node app.js` or `npm start`
   8. to kill the app, use `CTRL+C`, or if no more hanging in your terminal session, try `pkill node` or use `top`
   9. test: open a browser and visit `https://<your-ip-address-or-hostname>/app/`
   10. test: open a browser and visit `https://<your-ip-address-or-hostname>/app/`
   11. to have your app running "forever", including restart on crash, use e.g. [pm2](https://pm2.keymetrics.io/):

      ```bash
      sudo npm install -g pm2
      pm2 start app.js --name <MY-SERVER-APP-NAME>
      ```

   12. to check the status of running node apps, run `pm2 status`
   13. to check for possible errors log files can be accessed with `pm2 logs` 
   14. if you want that the app reload on change (e.g. on next `git pull`), use the `--watch` flag.
   15. (optional) "pure" linux option could be using [systemd](https://nodesource.com/blog/running-your-node-js-app-with-systemd-part-1/) for creating a system process.
