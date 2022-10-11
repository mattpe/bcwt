# Installing Metropolia Educloud virtual computer (CentOS server)

## Working from outside metropolia network

1. Configure [Metropolia VPN](https://wiki.metropolia.fi/display/itservices/Install+and+Use+VPN+Utility+Program+Installation+on+Your+Own+Computer)
2. Other options (e.g. during zoom session to reduce vpn bandwidth)

3. to test your app/webpages, create a [ssh tunnel and configure one of your browsers through it](https://tietohallinto.metropolia.fi/display/itservices/SSH+Tunneling) (use your metropolia username and password).

   ```sh
   ssh -Nf -D 8888 <your-metropolia-username>@shell.metropolia.fi
   ```

4. For the terminal access to your server, use double ssh, first from your local machine to shell.metropolia.fi (with your metropolia username/password):

   ```sh
   ssh <your-metropolia-username>@shell.metropolia.fi
   ```

   once connected to metropolia shell, you can connect to your server:

   ```sh
   ssh <your-server-username>@<your-server-IP>
   ```

## LAMP (well, P is optional and is replaced with NodeJS)

### Configure Linux server

1. Order your virtual server: [https://educloud.metropolia.fi/](https://educloud.metropolia.fi/)
2. login with your Metropolia credentials
3. navigate to _Services/Catalogs_
4. choose CentOS 7 x64 - Basic Install with IP address setup done
5. Lease time 4 months, small size is sufficient for our course
6. Check [Helpdesk page](https://tietohallinto.metropolia.fi/display/itservices/Educational+educloud+virtual+services):

   - Small: 1 CPU , main memory 1 GB, disk 30 Gb \*STRONGLY RECOMMENDED TO LINUX FUNDAMENTALS COURSE
   - Medium: 2 CPU, main memory 2 GB, disk 30 Gb \*RECOMMENDED TO Windows AND Linux ADVANCED COURSES
   - Large: 4 CPU, main memory 4 GB, disk 30 Gb \*Only for ADVANCED SQL & BIG DATA COURSES!
   - **Do Not select LARGE VM unless teacher specifically tells you to use for your Course**

7. Wait for 10-15 minutes for the server to be created
   - You will receive an email with the IP address of the server and the root password (root is default administrator on any Linux/Unix operating system)
8. Open a terminal (CLI). On windows computer, install [bash shell](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or [Git Bash](https://gitforwindows.org/). Mac/Linux already have a terminal to start with (e.g. on Mac under Applications/Utilities, on gnome/mate Linux desktop with `ALT + CTRL + T` shortcut)
9. From terminal, use ssh protocol to connect to your virtual server
   - If you are not in metropolia network, use VPN or double ssh (check [first section](#working-from-outside-metropolia-network))
   - Run the following command: ssh root@IPaddress
   - substitute IPaddress with the address of your server (you got in the mail), root is the username (keep it as it is). After pressing enter, it will ask for password (copy/paste from the mail). Note, blind typing password (the cursor will not move nor show stars nor nothing while you type); it a security measure: if anyone look over your shoulders, they cannot guess the length of your password.
10. After login: first security measures, change root password and create yourself a user account: avoid to do everything as root! If someone crack your root account, s/he can destroy the full server. If s/he “only” crack your user account, s/he will be sandboxed (and can do less damages).
11. Change root password:

   ```sh
   passwd
   ```

12. Create a personal user account and a password for it:

   ```sh
   useradd wantedUsername
   passwd wantedUsername
   ```

13. Optional, install bash completion (to type commands with arguments faster):

   ```sh
   yum install bash-completion bash-completion-extras
   ```

14. Give that user _sudo_ (Super User Do, admin) privileges by adding the user to user group called _wheel_:

   ```sh
   usermod -aG wheel wantedUsername
   ```

15. Switch user to test your new personal account:


    ```sh
    su wantedUsername
    ```

16. Test that you can do ssh login with the new account:

    ```sh
    # 1st logout
    exit
    # log in again
    ssh yourUsername@your-IP
    ```

17. If and only if the login is successful with your new account, disable direct ssh root login permission to the server by editing ssh deamon configuration (we are using [nano](https://www.nano-editor.org/) text editor for this, [Beginners Guide](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/)):

    ```sh
    sudo nano /etc/ssh/sshd_config
    ```

18. Find `PermitRootLogin` setting and change it to:

    ```conf
    PermitRootLogin no
    ```

19. Save file (_ctrl-o_) and quit (_ctrl-x_).
20. Restart the ssh deamon (service)

    ```console
    sudo systemctl restart sshd
    ```

21. The CentOS package manager (to install/update applications and operating system)
    is YUM. For example, to maintain the operating system with the latest bug and security fixes, run the following command about every weeks:

    ```sh
    sudo yum update
    ```

## Install and configure Apache web server (if you don't already have it)

1.  Install & start Apache web server:

    ```sh
    # Install:
    sudo yum install httpd
    # Start:
    sudo systemctl start httpd
    # make sure that the web server starts automatically (e.g. after server reboot):
    sudo systemctl enable httpd
    ```

2.  Open the firewall to allow web traffic through http (port 80) and https (port 443):
    
    ```sh
    # add new fw rules
    sudo firewall-cmd --permanent --zone=public --add-service=http --add-service=https
    # reload the firewall rules
    sudo firewall-cmd --reload
    ```
3.  In your browser, open the URL: `http://<ip-address>/` (substitute with your IP address). You should see your Apache web server welcome page. Follow the instructions to hide that welcome page.

4.  The root of your web server is on following path: `/var/www/html`; but it require root privileges to add/edit/delete files. to create a public_html-folder for your user:

    1.  Edit the configuration file:
        ```console
        $ sudo vim /etc/httpd/conf.d/userdir.conf
        ```
    2.  Change the line `UserDir disabled` to `UserDir enabled wantedUsername`
    3.  Uncomment the line (delete the hash `#`) `UserDir public_html`, so the file should looks like:

    ```apache
    #
    # UserDir: The name of the directory that is appended onto a user's home
    # directory if a ~user request is received.
    #
    # The path to the end user account 'public_html' directory must be
    # accessible to the webserver userid.  This usually means that ~userid
    # must have permissions of 711, ~userid/public_html must have permissions
    # of 755, and documents contained therein must be world-readable.
    # Otherwise, the client will only receive a "403 Forbidden" message.
    #
    <IfModule mod_userdir.c>
        #
        # UserDir is disabled by default since it can confirm the presence
        # of a username on the system (depending on home directory
        # permissions).
        #
        UserDir enabled wantedUsername

        #
        # To enable requests to /~user/ to serve the user's public_html
        # directory, remove the "UserDir disabled" line above, and uncomment
        # the following line instead:
        #
        UserDir public_html
    </IfModule>

    #
    # Control access to UserDir directories.  The following is an example
    # for a site where these directories are restricted to read-only.
    #
    <Directory "/home/*/public_html">
        AllowOverride FileInfo AuthConfig Limit Indexes
        Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
        Require method GET POST OPTIONS
    </Directory>
    ```

    1.  Restart the server
        ```console
        $ sudo systemctl restart httpd
        ```
    2.  Create your personal public_html folder. Make sure you are in your `/home/wantedUsername` directory (check e.g. with `pwd` command):
        ```console
        $ mkdir public_html
        ```
    3.  Change your home folder visibility (so Apache can access it):
        ```console
        $ chmod 711 .
        $ chmod 755 public_html
        ```
    4.  Set the special CentOS/RedHat SELinux security:
        ```console
        $ sudo setsebool -P httpd_enable_homedirs true
        $ sudo chcon -R -t httpd_sys_content_t public_html
        ```
    5.  Visit: `http://<ip-address>/~<wantedUsername>/`

### Deploy your UI (HTML/CSS/JS/images/...) from your git repository

1. Change directory to your public_html:
   ```console
   $ cd public_html
   ```
1. Clone your UI (choose HTTPS (or [generate keys for SSH](https://docs.gitlab.com/ee/ssh/#generate-an-ssh-key-pair))):
   ```console
   $ git clone https://gitlab.metropolia.fi/<your-repo>
   ```
   (substitute your git remote repository URL)
1. Create a `.htacess` file in order to hide `.git` folder and `.gitignore` file:
   ```console
   $ vim .htaccess
   ```
   with the following content:
   ```apache
   # never deliver .git folders, .gitIgnore
   RewriteEngine On
   RewriteRule ^(.*/)?\.git+ - [R=404,L]
   ```
   Escape, save and quit.
1. Visit/refresh: `http://<ip-address>/~<wantedUsername>/`, you should see now your folder. In case you see the `.git` folder, restart the apache httpd server.

## Install and configure MariaDB database server

1. Install MariaDB server:
   ```console
   $ sudo yum install mariadb-server
   ```
   1. Start and enable it:
      ```console
      $ sudo systemctl start mariadb
      $ sudo systemctl enable mariadb
      ```
   1. Secure it:
      ```console
      $ mysql_secure_installation
      ```
      Note: database root user is not operating system root user! Avoid same password!
   1. Connect to your database:
      ```console
      $ mysql -u root -p
      ```
      and create a database and a user with privileges on it:
      ```sql
      > CREATE DATABASE catdb;
      > CREATE USER 'dbuser' IDENTIFIED BY 'test123';
      > GRANT USAGE ON *.* TO 'dbuser'@localhost IDENTIFIED BY 'test123';
      > GRANT ALL ON catdb.* TO 'dbuser'@'localhost';
      > FLUSH PRIVILEGES;
      > exit
      ```
      (in case you would need outside access (e.g. during project, separate database server from app server), replace `localhost` with `'%'` in the two GRANT queries).
   1. Download the `tables.sql` SQL script:
   ```console
   $ curl -O https://raw.githubusercontent.com/patrick-ausderau/wop-starters/week2-1/tables.sql
   ```
   (or upload with any FTP tool the `tables.sql` to your home folder `/home/wantedUsername`\
   (or use `scp` from your local machine, navigate with terminal to the folder and run
   ```console
   $ scp tables.sql <wantedUsername>@<ip-address>:~
   ```
   ))
   1. Import the tables and insert the data:
      ```console
      $ mysql -u dbuser -p catdb < tables.sql
      ```
   1. Eventually check:
      ```console
      $ mysql -u dbuser -p catdb
      ```
      ```sql
      > SHOW TABLES;
      > SELECT * FROM wop_cat;
      > exit
      ```
1. (Optional) if you would like to install phpMyAdmin to administrate your databases, tables and data with a graphical user interface, check e.g. [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-with-apache-on-a-centos-7-server)

## Install and configure NodeJS application server

1.  Install node for Centos: [https://github.com/nodesource/distributions/blob/master/README.md#rpm](https://github.com/nodesource/distributions/blob/master/README.md#rpm)
    use the `# No root privileges` version, so something like:
    ```console
    $ curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
    $ sudo yum install -y nodejs
    ```
1.  Configure Apache httpd server as a reverse proxy to node server:
    1.  create/edit an apache configuration file:
        ```console
        $ sudo vim /etc/httpd/conf.d/node.conf
        ```
    1.  add the following content:
        ```apacheconf
        <VirtualHost *:80>
          ProxyPreserveHost On
          ProxyPass /app/ http://127.0.0.1:3000/
          ProxyPassReverse /app/ http//:127.0.0.1:3000/
        </VirtualHost>
        ```
1.  save and restart apache server:
    ```console
    $ sudo systemctl restart httpd
    ```
1.  give permission to apache server to visit URL:
    ```console
    $ sudo setsebool -P httpd_can_network_connect 1
    ```
1.  install and run your node application:
    1.  make sure you are in your home folder:
        ```console
        $ cd
        ```
    1.  clone your app (choose HTTPS (or [generate keys for SSH](https://docs.gitlab.com/ee/ssh/#generate-an-ssh-key-pair))):
        ```console
        $ git clone https://gitlab.metropolia.fi/<your-repo>
        ```
    1.  go to the cloned repo:
        ```console
        $ cd <your-repo>
        ```
    1.  eventually, check that you are in the right branch (checkout if not)
    1.  install dependencies:
        ```console
        $ npm i
        ```
    1.  create/edit `.env` file with your db credentials (you set in [MariaDB](#install-and-configure-mariadb-database-server), step iii):
        ```apacheconf
         DB_HOST=127.0.0.1
         DB_USER=<your-db-user>
         DB_PASS=<your-db-user_password>
         DB_NAME=<your-db-name>
        ```
    1.  run your application:
        ```console
        $ node app.js
        ```
    1.  test, open a browser and visit `http://<ip-address>/app/`
    1.  to kill the app, use `CTRL+C`, or if no more hanging in your terminal session, try `$ pkill node` or use `$ top`
    1.  to have your app running forever, including restart on crash, use e.g. [pm2](https://pm2.keymetrics.io/):
        ```console
        $ sudo npm install -g pm2
        $ pm2 start app.js
        ```
    1.  if you want that the app reload on change (e.g. on next `git pull`), use the `--watch` flag.
    1.  other "pure" linux option could use [systemd](https://nodesource.com/blog/running-your-node-js-app-with-systemd-part-1/) (`systemctl`).
    <!--   1.  if you want to let your app running forever, run it as a
            background task (note the ampstamp & at the end)
            ```console
            $ node app.js &
            ```
            Note, on MS Windows computer, make sure to exit your session ``$ exit`` (or ``CTRL + D`` shortcut) before closing your power shell (bash shell, git bash,...) application as it may kill your session which will kill your running processes including background tasks 😃.
    1.  and if you want to stop your background app:
        `console $ pkill node `
        -->

## Extra and resources

- [Unix/linux command](https://centoshelp.org/resources/commands/linux-system-commands/)
- [vim commands](https://vim.rtorr.com/) (works with `vi` and `visudo`)
- [autocomplete](https://www.cyberciti.biz/faq/fedora-redhat-scientific-linuxenable-bash-completion/) (make typing command faster using tab key)
- [sudo autocomplete](http://www.webupd8.org/2010/03/how-to-autocomplete-commands-preceded.html) (so tab key works when you type `sudo ...`)
- [installing extra packages](https://wiki.centos.org/AdditionalResources/Repositories)
