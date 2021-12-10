<!-- TODO: async/await bcrypt.genSalt and bcrypt.hash -->
<!-- TODO: exif, console.error(error) but resolve([0,0]) instead of reject -->
# Week 5

## HTTPS


* [HTTPS](https://en.wikipedia.org/wiki/HTTPS)
  * HTTP over [TLS/SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security)
    * TLS is the new progression of SSL
  * _authentication_ of the visited website
  * protection of the _privacy_ and _integrity_ of the exchanged data
* Generally better to implement TLS in reverse-proxy such as Apache or Nginx

### express (localhost development)

* Generate keys and certificate with [openssl](https://www.openssl.org/) (in real life, you would need to get certified by a third party, e.g. [Let’s Encrypt](https://letsencrypt.org/))
* If you target [modern compatibility](https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility), recommendation is to use elliptic curve algorithm [ECDSA](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm) with prime256v1, secp384r1 or secp521r1 TLS curves (e.g. [see](https://msol.io/blog/tech/create-a-self-signed-ecc-certificate/)) instead of [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem))
  * For intermediate compatibility (IE7, Android 2.3, Java 7,...), minimum is 2048 bit RSA key; but you can safely use 4096 key

```shell
$ openssl genrsa -out ssl-key.pem 2048
$ openssl req -new -key ssl-key.pem -out certrequest.csr
$ openssl x509 -req -in certrequest.csr -signkey ssl-key.pem -out ssl-cert.pem
```

* Put the keys and certificate in the app folder and make sure to **add them in .gitignore** too!
  * Alternative, put the keys and certificate outside the app folder and use relative (e.g. ../certs/) or absolute (e.g. /etc/pki/tls/certs/) path to them
* In case missing, install file sync: `npm i fs`

```javascript
'use strict';

const express = require('express');
const https = require('https');
const fs = require('fs');

const sslkey = fs.readFileSync('ssl-key.pem');
const sslcert = fs.readFileSync('ssl-cert.pem')

const options = {
  key: sslkey,
  cert: sslcert
};

const app = express();

https.createServer(options, app).listen(8000);

app.get('/', (req, res) => {
  if (req.secure) {
    res.send('Hello Secure World!');
  } else {
    res.send('not secured?');
  }
});
```

* Force redirection from HTTP to HTTPS

```javascript
const http = require('http');
// ...

http.createServer((req, res) => {
  res.writeHead(301, { 'Location': 'https://localhost:8000' + req.url });
  res.end();
}).listen(3000);

// Make sure to redirect BEFORE any middleware/routers/...!
app.use(express.static('uploads'));
app.use('/cat', passport.authenticate('jwt', { session: false }), require('./routes/catRoute'));
//app.use(....);
```

Notes:
* about [HTTP status code](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html), the 3XX codes are redirect, 301 means Moved Permanently.
* when testing with your browser, because of self-signed certificate, it will show a warning page instead of your app. In Chrome, click [details and proceed unsafe](https://support.google.com/chrome/answer/99020?co=GENIE.Platform%3DDesktop&hl=en-GB). In Firefox, click [Advanced and Accept the Risk and Continue](https://support.mozilla.org/en-US/kb/what-does-your-connection-is-not-secure-mean).
* if/when you run https in port 8000 in localhost, you need to change `const url = 'http://localhost:3000';` in `wop-ui` JavaScript files to `const url = 'https://localhost:8000';`

### express (production server)

1. Generate a self-signed certificate for [CentOS](https://wiki.centos.org/HowTos/Https)
1. configure apache httpd proxy for https: ``sudo vim /etc/httpd/conf.d/https-node.conf`` (or any .conf file)
    ```apacheconf
    <VirtualHost *:443>
        ServerName tunnus-numero.metropolia.fi
        SSLEngine on
        SSLCertificateFile /etc/pki/tls/certs/ca.crt
        SSLCertificateKeyFile /etc/pki/tls/private/ca.key
        SSLProxyCACertificateFile /etc/pki/tls/certs/ca.crt

        SSLProxyEngine on
        SSLProxyCheckPeerCN off
        SSLProxyCheckPeerName off
        ProxyPreserveHost On
        RequestHeader set X-Forwarded-Proto https

        ProxyPass /app/ http://127.0.0.1:3000/
        ProxyPassReverse /app/ http://127.0.0.1:3000/
    </VirtualHost>
    ```
    * Don't forget to restart apche server ``sudo systemctl restart httpd``
    * Note, the proxy pass to http (not https), it's the X-Forwarded-Proto that does it
1. Express app need to trust the tls/ssl configuration from the proxy server
1. Force the redirection from HTTP to HTTPS

```javascript
'use strict';

require('dotenv').config();
const express = require('express');
const app = express();

app.enable('trust proxy');

// Add a handler to inspect the req.secure flag (see
// http://expressjs.com/api#req.secure). This allows us
// to know whether the request was via http or https.
// https://github.com/aerwin/https-redirect-demo/blob/master/server.js
app.use ((req, res, next) => {
  if (req.secure) {
    // request was via https, so do no special handling
    next();
  } else {
    // if express app run under proxy with sub path URL
    // e.g. http://www.myserver.com/app/
    // then, in your .env, set PROXY_PASS=/app
    // Adapt to your proxy settings!
    const proxypath = process.env.PROXY_PASS || ''
    // request was via http, so redirect to https
    res.redirect(301, `https://${req.headers.host}${proxypath}${req.url}`);
  }
});

app.listen(3000);
```

### consider separating development and production code

* create node modules for localhost (development) and remote (production) server, e.g in `utils` folder
  * cut/paste corresponding code and use node export e.g. for localhost.js

 ```javascript
// cut-pasted code about localhost: require, tls certs, options,...

module.exports = (app, httpsPort, httpPort) => {
  https.createServer(options, app).listen(httpsPort);
  http.createServer(httpsRedirect).listen(httpPort);
};
```

* use .env file to choose which code to load

```javascript
process.env.NODE_ENV = process.env.NODE_ENV || 'development';
if (process.env.NODE_ENV === 'production') {
  require('./utils/production')(app, process.env.PORT || 3000);
} else {
  require('./utils/localhost')(app, process.env.HTTPS_PORT || 8000, process.env.HTTP_PORT || 3000);
}
app.get('/', (req, res) => {
  res.send('Hello Secure World!');
});
```


## Password hash
* [Salted Password Hashing - Doing it Right](https://crackstation.net/hashing-security.htm)

### Bcrypt
1. Setup
   * Continue the app started on week 2. You should be now in `week4` branch. Make sure you have committed all files (`git status`) then create new branch `week5`
   * Install [bcryptjs](https://www.npmjs.com/package/bcryptjs): `npm i bcryptjs` ([bcrypt](https://www.npmjs.com/package/bcrypt) is another option)

1. Use `wop-ui/ui4` as front-end

### Login

1.  `utils/pass.js` should be currently something like this:
   ```javascript
   passport.use(new Strategy(
       async (username, password, done) => {
         const params = [username];
         try {
           const [user] = await getUserLogin(params);
           console.log('Local strategy', user); // result is binary row
           if (user === undefined) { // user not found
             return done(null, false);
           }
           // TODO: use bcrypt to check of passwords don't match
           if (password !== user.password) { // passwords dont match
             console.log('here');
             return done(null, false);
           }
           // delete user.password; // remove password propety from user object if it's still there
           return done(null, {...user}); // use spread syntax to create shallow copy to get rid of binary row type
         } catch (err) { // general error
           return done(err);
         }
       }));
   ```

1. `getUserLogin` function in `models/userModel.js` should be something like this:
   ```javascript
   const getUserLogin = async (params) => {
     try {
       console.log(params);
       const [rows] = await promisePool.execute(
           'SELECT * FROM wop_user WHERE email = ?;',
           params);
       return rows;
     } catch (e) {
       console.log('error', e.message);
     }
   };
   ```

1. Test login with `wop-ui/ui4`

1. Logout by deleting the token from browser's session storage (developer tools/application)

1. You should have at least two users in your database. Change the passwords in the database to these:
   * $2a$10$5RzpyimIeuzNqW7G8seBiOzBiWBvrSWroDomxMa0HzU6K2ddSgixS
      * this is a hashed version of 1234
   * $2a$10$H7bXhRqd68DjwFIVkw3G1OpfIdRWIRb735GvvzCBeuMhac/ZniGba
       * this is a hashed version of qwer

1. Require bcryptjs in `utils/pass.js` and modify the if statement under TODO to use [compareSync](https://github.com/dcodeIO/bcrypt.js#comparesyncs-hash) or better ``await compare(...)`` to check password

1. Test login with `wop-ui/ui4`

### Register

1. Delete `/user` route for post method in `/routes/userRoute.js`
   * we'll move adding users (registration) to `/routes/authRoute.js`:
   ```javascript
   'use strict';
   const express = require('express');
   const router = express.Router();
   const {body, sanitizeBody} = require('express-validator');
   const authController = require('../controllers/authController');

   router.post('/login', authController.login);
   router.get('/logout', authController.logout);
   router.post('/register',
       [
         body('name', 'minimum 3 characters').isLength({min: 3}),
         body('username', 'email is not valid').isEmail(),
         body('password', 'at least one upper case letter').
             matches('(?=.*[A-Z]).{8,}'),
         sanitizeBody('name').escape(),
       ],
       authController.user_create_post
   );

   module.exports = router;
   ```
   * note the addition on third middelware `login` in `/register` route. Why is it there?

1. Delete `user_create_post` function from `controllers/userController.js` and add following to `controllers/authController.js`:
   ```javascript
   const user_create_post = async (req, res, next) => {
     // Extract the validation errors from a request.
     const errors = validationResult(req); // TODO require validationResult, see userController

     if (!errors.isEmpty()) {
       console.log('user create error', errors);
       res.send(errors.array());
     } else {
       // TODO: bcrypt password

       const params = [
         req.body.name,
         req.body.username,
         req.body.password, // TODO: save hash instead of the actual password
       ];

       const result = await addUser(params);
       if (result.insertId) {
         res.json({ message: `User added`, user_id: result.insertId });
       } else {
         res.status(400).json({error: 'register error'});
       }
     }
   };

   const logout = (req, res) => {
     req.logout();
     res.json({message: 'logout'});
   };

   ```
   * remember to update the requires and exports of both files
   * now users can be added (registered) without logging in first
   * Complete the TODOs in the code above
   * Create a new user by using the register form in `wop-ui/ui4`
   * Test logout button and login again

## Create thumbnails
1. Use `wop-ui/ui4` as front-end for testing
   * ask mapbox key from the teacher or create your own
1. Add new folder `thumbnails`, put it in version control; but not its content as you did with [uploads folder](week2.md#middleware)
1. Add to `app.js`:
   ```javascript
   app.use('/thumbnails', express.static('thumbnails'));
   ```
1. Install [sharp](https://github.com/lovell/sharp): `npm i sharp`
1. Add new file `utils/resize.js`:
   ```javascript
   'use strict';
   const sharp = require('sharp');

   const makeThumbnail = async (file, thumbname) => { // file = full path to image (req.file.path), thumbname = filename (req.file.filename)
     // TODO: use sharp to create a png thumbnail of 160x160px, use async await
   };

   module.exports = {
     makeThumbnail,
   };
   ```
1. Complete TODO in the code above. Call `makeThumbnail` function in `catController` before you add the cat to database.
1. Use UI in `wop-ui/ui4` and upload a new cat

## Metadata from image
1. Study [Creating a Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise#Creating_a_Promise)
1. Take a couple of photos with your phone. Make sure that location services are enabled so that the gps data is stored in the images.
1. Email the images to yourself
1. Add new field `coords` of type text to `wop_cat` table
1. Add this as the value for `coords` to existing cats in the table: [24.74,60.24]
1. Modify `addCat` function in `models/catModel.js`:
   ```javascript
   const addCat = async (params) => {
     try {
       const [rows] = await promisePool.execute(
           'INSERT INTO wop_cat (name, age, weight, owner, filename, coords) VALUES (?, ?, ?, ?, ?, ?);',
           params);
       return rows;
     }
     catch (e) {
       console.log('error', e.message);
     }
   };
   ```
1. Modify `cat create post` in `catController.js`:
   ```javascript
   const cat_create_post = async (req, res) => {
    ...
       try {
         // make thumbnail
         resize.makeThumbnail(req.file.path, req.file.filename);
         // get coordinates
         const coords = await imageMeta.getCoordinates(req.file.path);
         console.log('coords', coords);
         // add to db
         const params = [
           req.body.name,
           req.body.age,
           req.body.weight,
           req.body.owner,
           req.file.filename,
           coords,
         ];
         const cat = await catModel.addCat(params);
         await res.json({message: 'upload ok'});
       }
       catch (e) {
         console.log('exif error', e);
         res.status(400).json({message: 'error'});
       }
     ...
   };
   ```
1. Install [node-exif](https://github.com/gomfunkel/node-exif#readme): `npm i exif`
1. Add new file `utils/imageMeta.js`:
   ```javascript
   'use strict';
   const ExifImage = require('exif').ExifImage;

   const getCoordinates = (imgFile) => { // imgFile = full path to uploaded image
     return new Promise((resolve, reject) => {
       try {
         // TODO: Use node-exif to get longitude and latitude from imgFile
         // coordinates below should be an array of GPS coordinates in decimal format: [longitude, latitude]
         resolve(coordinates);
       }
       catch (error) {
         reject(error);
       }
     });
   };

   // convert GPS coordinates to decimal format
   // for longitude, send exifData.gps.GPSLongitude, exifData.gps.GPSLongitudeRef
   // for latitude, send exifData.gps.GPSLatitude, exifData.gps.GPSLatitudeRef
   const gpsToDecimal = (gpsData, hem) => {
     let d = parseFloat(gpsData[0]) + parseFloat(gpsData[1] / 60) +
         parseFloat(gpsData[2] / 3600);
     return (hem === 'S' || hem === 'W') ? d *= -1 : d;
   };

   module.exports = {
     getCoordinates,
   };
   ```
1. Require `utils/imageMeta.js` as `imageMeta` in `catController.js`
1. Complete TODO in `utils/imageMeta.js`
1. Use UI in `wop-ui/ui4` and upload a new cat

### Upload to virtual server and run
1. Deploy final app to your virtual server
   * once your app works on your localhost machine, remember to update all `.js` files in `whatever_public/js/` around line 2 to `const url = 'https://your_ip/app/';`
   * git commit/push on your local machine and pull on server, make sure to be in right folder, e.g.
     ```console
     $ cd week2
     $ git status
     ```
   * don't upload node_modules (should normally be in `.gitignore`)
   * after pulling (if any conflict, just delete the conflicting files (e.g. `$ rm pacakge-lock.js`) and pull again), make sure to be in right branch (`$ git branch`), checkout if not, then run `$ npm install`
   * check that `thumbnails` folder got created with the git pull (in case it is in `.gitignore`, then create it `$ mkdir thumbnails`)
   * make sure that database is up to date (`$ mysql -u dbuser -p catdb` (adapt your database user and database name))
     ```sql
     ALTER TABLE wop_cat ADD coords text;
     UPDATE wop_user SET password = 'SomeHashOfThePassword...' WHERE user_id = 2; # and same for jane (user_id = 3)
     ```
   * edit .env (add the `PROXY_PASS` and `NODE_ENV`) and run `node app.js` or with [pm2](https://www.npmjs.com/package/pm2) `pm2 restart app.js`
   * visit `http://your_ip/~wantedUsername/wop-ui/ui4`, test that it redirects to https and that you can login and add cats

### Single Page App
There is a [Sinlge Page App (or SPA)](https://medium.com/@NeotericEU/single-page-application-vs-multiple-page-application-2591588efe58) version of the UI in `wop-ui/ui5`. You can also test that and study the code.
