<!-- TODO: async/await bcrypt.genSalt and bcrypt.hash -->
<!-- TODO: exif, console.error(error) but resolve([0,0]) instead of reject -->

# BCWT - Week 5

## Security

### HTTPS

- [HTTPS](https://en.wikipedia.org/wiki/HTTPS)
  - HTTP over [TLS/SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) (TLS is the new progression of SSL but the term SSL is still generally used)
  - [SSL certificate](https://www.kaspersky.com/resource-center/definitions/what-is-a-ssl-certificate) _authenticates_ a website's identity and enables an encrypted connection
  - protection of the _privacy_ and _integrity_ of the exchanged data
- Generally better to implement TLS in reverse-proxy such as Apache or Nginx, ([just like we already did after installing Apache on Ubuntu](./week3-virtual-server-azure.md))
  - all HTTP connections (port 80) are automatically edirected to HTTPS (port 443) by using [HTTP status codes](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html), the 3XX codes are redirect, 301 means Moved Permanently.
- for localhost development secure connections are not needed

Note:

You could create and sign the certificate for SSL by yourself. It still encrypts your web traffic but the self-signed certs are not trusted by browsers. If testing such a site, browser will show a warning page instead of your web app. In Chrome, type 'thisisunsafe' or click [details and proceed unsafe](https://support.google.com/chrome/answer/99020?co=GENIE.Platform%3DDesktop&hl=en-GB). In Firefox, click [Advanced and Accept the Risk and Continue](https://support.mozilla.org/en-US/kb/what-does-your-connection-is-not-secure-mean).

### Hashing Passwords

- [Salted Password Hashing - Doing it Right](https://crackstation.net/hashing-security.htm)

1. Setup bcrypt

   - Continue the app started on week 2. You should be now in your `token` branch. Make sure you have committed all files (`git status`) then create new branch `week5`
   - Install [bcryptjs](https://www.npmjs.com/package/bcryptjs): `npm i bcryptjs` ([bcrypt](https://www.npmjs.com/package/bcrypt) is another option)

1. Use `wop-ui/ui4` as front-end

#### Login

1. `utils/passport.js` should be currently something like this:

```javascript
passport.use(
  new Strategy(async (username, password, done) => {
    const params = [username];
    try {
      const [user] = await getUserLogin(params);
      console.log('Local strategy', user); // result is binary row
      if (user === undefined) {
        // user not found
        return done(null, false);
      }
      // TODO: use bcrypt to check of passwords don't match
      if (password !== user.password) {
        // passwords dont match
        console.log('here');
        return done(null, false);
      }
      // delete user.password; // remove password propety from user object if it's still there
      return done(null, {...user}); // use spread syntax to create shallow copy to get rid of binary row type
    } catch (err) {
      // general error
      return done(err);
    }
  })
);
```

1. `getUserLogin` function in `models/userModel.js` should be something like this:

   ```javascript
   const getUserLogin = async (params) => {
     try {
       console.log(params);
       const [rows] = await promisePool.execute(
         'SELECT * FROM wop_user WHERE email = ?;',
         params
       );
       return rows;
     } catch (e) {
       console.log('error', e.message);
     }
   };
   ```

1. Test login with `wop-ui/ui4`
1. Logout by deleting the token from browser's session storage (developer tools/application)
1. You should have at least two users in your database. Change the clear text passwords in the database to these hashed versions:

   - `$2a$10$5RzpyimIeuzNqW7G8seBiOzBiWBvrSWroDomxMa0HzU6K2ddSgixS` (this is a hashed version of `1234`)
   - `$2a$10$H7bXhRqd68DjwFIVkw3G1OpfIdRWIRb735GvvzCBeuMhac/ZniGba` (this is a hashed version of `qwer`)

1. Require `bcryptjs` in `utils/passport.js` and modify the if statement under TODO to use [compareSync](https://github.com/dcodeIO/bcrypt.js#comparesyncs-hash) or better `await compare(...)` to check password
1. Test login with `wop-ui/ui4`

#### Register

1. Delete `/user` route for post method in `/routes/userRoute.js`

   - we'll move adding users (registration) to `/routes/authRoute.js`:

   ```javascript
   'use strict';
   const express = require('express');
   const router = express.Router();
   const {body, sanitizeBody} = require('express-validator');
   const authController = require('../controllers/authController');

   router.post('/login', authController.login);
   router.get('/logout', authController.logout);
   router.post(
     '/register',
     [
       body('name', 'minimum 3 characters').isLength({min: 3}),
       body('username', 'email is not valid').isEmail(),
       body('password', 'at least one upper case letter').matches(
         '(?=.*[A-Z]).{8,}'
       ),
       sanitizeBody('name').escape(),
     ],
     authController.register
   );

   module.exports = router;
   ```

1. Remove `createUser` function from `controllers/userController.js` (or keep it and use as an administrator level feature) and add/adapt following to `controllers/authController.js`:

   ```javascript
   const register = async (req, res, next) => {
     // Extract the validation errors from a request.
     const errors = validationResult(req); // TODO require validationResult, see userController

     if (!errors.isEmpty()) {
       console.log('user create error', errors);
       res.send(errors.array());
     } else {
       // TODO: use bcrypt for creatign a password hash
       const params = [
         req.body.name,
         req.body.username,
         // TODO: save the hash instead of the actual password
         req.body.password, 
       ];

       const result = await addUser(params);
       if (result.insertId) {
         res.json({message: `User added`, user_id: result.insertId});
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

   - remember to update the requires and exports of both files
   - now users can be added (registered) without logging in first
   - Complete the TODOs in the code above (refer to [bcryptjs docs](https://github.com/dcodeIO/bcrypt.js#usage))
   - Create a new user by using the register form in `wop-ui/ui4`
   - Test logout button and login again

## Creating image thumbnails

1. Use `wop-ui/ui4` as front-end for testing
   - ask mapbox key from the teacher or create your own
1. Add new folder `thumbnails`, put it in version control; but not its content as you did with [uploads folder](week2.md#middleware)
1. Add to `app.js`:

   ```javascript
   app.use('/thumbnails', express.static('thumbnails'));
   ```

1. Install [sharp](https://github.com/lovell/sharp): `npm i sharp`
1. Add new file `utils/image.js`:

   ```javascript
   'use strict';
   const sharp = require('sharp');

   const makeThumbnail = async (file, thumbname) => {
     // file = full path to image (req.file.path), thumbname = filename (req.file.filename)
     // TODO: use sharp to create a png thumbnail of 160x160px, use async await
   };

   module.exports = {
     makeThumbnail,
   };
   ```

1. Complete TODO in the code above. Call `makeThumbnail` function in `catController` before you add the cat to database.
1. Use UI in `wop-ui/ui4` and upload a new cat

## Extracting image metadata (exif)

1. Study [Creating a Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise#Creating_a_Promise)
1. Take a couple of photos with your phone. Make sure that location services are enabled so that the gps data is stored in the images.
1. Email the images to yourself
1. Add new field `coords` of type text to `wop_cat` table
1. Add this as the value for `coords` to existing cats in the table: [24.74,60.24]
1. Install [node-exif](https://github.com/gomfunkel/node-exif#readme): `npm i exif`
1. Add exif functions to `utils/image.js`:

   ```javascript
   ...
   ...
   const ExifImage = require('exif').ExifImage;

   const getCoordinates = (imgFile) => {
     // imgFile = full path to uploaded image
     return new Promise((resolve, reject) => {
       try {
         // TODO: Use node-exif to get longitude and latitude from imgFile
         // coordinates below should be an array of GPS coordinates in decimal format: [longitude, latitude]
         resolve(coordinates);
       } catch (error) {
         reject(error);
       }
     });
   };

   // convert GPS coordinates to decimal format
   // for longitude, send exifData.gps.GPSLongitude, exifData.gps.GPSLongitudeRef
   // for latitude, send exifData.gps.GPSLatitude, exifData.gps.GPSLatitudeRef
   const gpsToDecimal = (gpsData, hem) => {
     let d =
       parseFloat(gpsData[0]) +
       parseFloat(gpsData[1] / 60) +
       parseFloat(gpsData[2] / 3600);
     return hem === 'S' || hem === 'W' ? (d *= -1) : d;
   };

   module.exports = {
    ...
     getCoordinates,
   };
   ```

1. Complete TODO in `utils/image.js`
1. Require `image/getCoordinates` in `catController.js`
1. Modify `addCat` function in `models/catModel.js` by adding coords to sql query:

   ```javascript
   const addCat = async (params) => {
     try {
       const [rows] = await promisePool.execute(
         'INSERT INTO wop_cat (name, age, weight, owner, filename, coords) VALUES (?, ?, ?, ?, ?, ?);',
         params
       );
       return rows;
     } catch (e) {
       console.log('error', e.message);
     }
   };
   ```

1. Modify `createCat` in `catController.js` accordingly:

   ```javascript
   const createCat = async (req, res) => {
    ...
       try {
         // make thumbnail
         image.makeThumbnail(req.file.path, req.file.filename);
         // get coordinates
         const coords = await image.getCoordinates(req.file.path);
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

1. Use UI in `wop-ui/ui4` and upload a new cat

### Deployment to virtual server

Deploy your final app to your virtual server

1. [recap the VM setup instructions](./week3-virtual-server-azure.md)
1. once your app works on your localhost machine, remember to update all `.js` files in `whatever_public/js/` around line 2 to `const url = 'https://your_ip/app/';`
1. git commit/push on your local machine and pull on server (or copy all files excl. `node_modules/` to the server using scp), make sure to be in right folder
    - Instructions for direct Git cloning/pulling repositories on Ubuntu server: [Setting up GitHub SSH authentication](https://cis106.com/guides/Ubuntu%20Github%20Setup/) 
1. don't upload node_modules (should normally be in `.gitignore`)
1. after pulling (if any conflict, just delete the conflicting files (e.g. `$ rm pacakge-lock.js`) and pull again), make sure to be in right branch (`$ git branch`), checkout if not, then run `npm install`
1. check that `thumbnails` folder got created with the git pull (in case it is in `.gitignore`, then create it `mkdir thumbnails`)
1. make sure that database is up to date (`mysql -u dbuser -p catdb` (adapt your database user and database name))

  ```sql
  ALTER TABLE wop_cat ADD coords text;
  UPDATE wop_user SET password = 'SomeHashOfThePassword...' WHERE user_id = 2; # and same for jane (user_id = 3)
  ```

1. remember to update `.env` file if needed and run `node app.js` or with [pm2](https://www.npmjs.com/package/pm2) `pm2 start/restart app.js`
1. visit `https://your-server-address/wop-ui/ui4`, test that it redirects to https and that you can login and add cats

### Single Page App

There is a [Sinlge Page App (or SPA)](https://medium.com/@NeotericEU/single-page-application-vs-multiple-page-application-2591588efe58) version of the UI in `wop-ui/ui5`. You can also test that and study the code.
