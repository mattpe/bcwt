# BCWT - Week 4

Now we start to implementing our REST API to follow the [second version of the API Documentation](week4-apiDoc-v0.2.md)

## State Management with Cookies and Sessions

- Study [Maintaining state in web applications](week4-state-management.md)

1. Task: Setup

   - Navigate to your course folder in terminal or Git Bash
     - Create a new Git branch `week4`
     - Create `state-management` folder to your course folder.
     - Download [starter files as zip](./week4-state-starter.zip), extract and copy all files to `state-management` folder
     - Run `npm install` and `npm start` to start app.js with nodemon and test `http://localhost:3000`
     - Remember to commit the changes to the code regularly

1. Task: Cookies

   - Create the following routes for GET method:
     - `/setCookie`
       - receives a path variable `clr`
       - sets a new cookie `color` which gets the value of `clr` path variable
     - `/getCookie`
       - reads the value of `color` cookie and sends it to the client
     - `/deleteCookie`
       - delete `color` cookie
   - Open 'Application' tab in Developer Tools to see cookies in browser
   - Test in browser: `localhost:3000/setCookie/<someColor>` and `localhost:3000/deleteCookie`

1. Task: Session

   - Add the following code to `app.js` after `const port = 3000;`

   ```javascript
   const username = "foo";
   const password = "bar";
   ```

   - Create the following routes for GET method:
     - `/form`
       - render `views/form.pug`
     - `/secret`
       - render `views/secret.pug`
   - Create the following route for POST method:
     - `/login`
       - receives `username` and `password` from `req.body`
       - if received `username` and `password` match the username and password variables create session variable `logged` and set it to `true` and [redirect](https://expressjs.com/en/api.html#res.redirect) to `/secret`. Else set session variable `logged` to `false` and redirect to `/form`
     - In `/secret` route check if session variable `logged` is not true, then redirect to `/form`.
     - Open 'Application' tab in Developer Tools to see cookies in browser
     - Test in browser: `localhost:3000/form` and `localhost:3000/secret`

## Authentication with [passport.js](http://www.passportjs.org/docs/downloads/html/)

### Setup

- Continue the `state-management` exercise. Make sure you have committed all files (`git status`) and then create a new branch `passport`
- Install _passport_ and _passport-local_ packages: `npm i passport passport-local`

### [Local Strategy](http://www.passportjs.org/docs/username-password/)

1. Modify `app.js`:

   ```javascript
   // add following to around line 4
   const passport = require("./utils/pass");

   // add following after const port = 3000;
   const loggedIn = (req, res, next) => {
     if (req.user) {
       next();
     } else {
       res.redirect("/form");
     }
   };

   // add following after app.use(session...
   app.use(passport.initialize());
   app.use(passport.session());

   // modify app.post('/login',...
   app.post(
     "/login",
     passport.authenticate("local", { failureRedirect: "/form" }),
     (req, res) => {
       console.log("success");
       res.redirect("/secret");
     }
   );

   // modify app.get('/secret',...
   app.get("/secret", loggedIn, (req, res) => {
     res.render("secret");
   });
   ```

1. Add new folder `utils` and create new file `./utils/passport.js`

   ```javascript
   "use strict";
   const passport = require("passport");
   const Strategy = require("passport-local").Strategy;

   // fake database: ****************
   const users = [
     {
       user_id: 1,
       name: "Foo Bar",
       email: "foo@bar.fi",
       password: "foobar",
     },
     {
       user_id: 2,
       name: "Bar Foo",
       email: "bar@foo.fi",
       password: "barfoo",
     },
   ];
   // *******************

   // fake database functions *********
   const getUser = (id) => {
     const user = users.filter((usr) => {
       if (usr.user_id === id) {
         return usr;
       }
     });
     return user[0];
   };

   const getUserLogin = (email) => {
     const user = users.filter((usr) => {
       if (usr.email === email) {
         return usr;
       }
     });
     return user[0];
   };
   // *****************

   // serialize: store user id in session
   passport.serializeUser((id, done) => {
     console.log("serialize", id);
     // serialize user id by adding it to 'done()' callback
   });

   // deserialize: get user id from session and get all user data
   passport.deserializeUser(async (id, done) => {
     // get user data by id from getUser
     console.log("deserialize", user);
     // deserialize user by adding it to 'done()' callback
   });

   passport.use(
     new Strategy((username, password, done) => {
       // get user by username from getUserLogin
       // if user is undefined
       // return done(null, false);
       // if passwords dont match
       // return done(null, false);
       // if all is ok
       // return done(null, user.user_id);
     })
   );

   module.exports = passport;
   ```

1. Follow the comments in the code above to finish the task
   - [Serialize & deserialize](http://www.passportjs.org/docs/downloads/html/#sessions)
1. Run with nodemon and open localhost:3000 to test
   - use foo@bar.fi and bar@foo.fi as usernames
   - use foobar and barfoo as passwords
   - logout by deleting session cookie in browser
1. Add [logout](http://www.passportjs.org/docs/logout/) functionality
1. Commit and push to git

### [JSON Web Token Strategy](http://www.passportjs.org/packages/passport-jwt/)

- [JSON Web Tokens](https://jwt.io/)
- [Session vs Token](https://medium.com/@sherryhsu/session-vs-token-based-authentication-11a6c5ac45e4)

- The following task is based on [this](https://medium.com/front-end-weekly/learn-using-jwt-with-passport-authentication-9761539c4314) article

1. Setup

   - Continue the _server_ app started on week 2. You should be now in a branch having the latest _server_ app code . Make sure you have committed all files (`git status`) then create a new branch `token`
   - Install passport, passport-local, passport-jwt and jsonwebtoken `npm i passport passport-local passport-jwt jsonwebtoken`

1. Create a function getUserLogin to `./models/userModel.js`

   ```javascript
   ...
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
   ...
   ```

1. Add new file `./controllers/authController.js`

   ```javascript
   "use strict";
   const jwt = require("jsonwebtoken");
   const passport = require("passport");

   const login = (req, res) => {
     // TODO: add passport authenticate
   };

   module.exports = {
     login,
   };
   ```

1. Study [this](https://medium.com/front-end-weekly/learn-using-jwt-with-passport-authentication-9761539c4314#025a) example and add passport local strategy authentication to TODO section

   - the example starts with passport.authenticate...

1. Add new file `./routes/authRoute.js`

   ```javascript
   "use strict";
   const express = require("express");
   const router = express.Router();
   const { login } = require("../controllers/authController");

   router.post("/login", login);

   module.exports = router;
   ```

1. Add new folder `utils` and create new file `./utils/passport.js`

   ```javascript
   "use strict";
   const passport = require("passport");
   const Strategy = require("passport-local").Strategy;
   const { getUserLogin } = require("../models/userModel");

   // local strategy for username password login
   passport.use(
     new Strategy(async (username, password, done) => {
       const params = [username];
       try {
         const [user] = await getUserLogin(params);
         console.log("Local strategy", user); // result is binary row
         if (user === undefined) {
           return done(null, false, { message: "Incorrect email." });
         }
         if (user.password !== password) {
           return done(null, false, { message: "Incorrect password." });
         }
         return done(null, { ...user }, { message: "Logged In Successfully" }); // use spread syntax to create shallow copy to get rid of binary row type
       } catch (err) {
         return done(err);
       }
     })
   );

   // TODO: JWT strategy for handling bearer token
   // consider .env for secret, e.g. secretOrKey: process.env.JWT_SECRET

   module.exports = passport;
   ```

1. Study [this](https://medium.com/front-end-weekly/learn-using-jwt-with-passport-authentication-9761539c4314#fcdf) example and add JWT strategy to TODO section

   - use arrow functions
   - instead of `cb`, use `done` as the name for the callback function
   - use the local strategy for username password login in the code above as an example

1. Require `./utils/passport.js` as passport and `./routes/authRoute.js` as authRoute in `app.js`
1. Add `app.use(passport.initialize());` and `app.use('/auth', authRoute);` before cat and user routes.
1. Add `passport.authenticate('jwt', {session: false})` [middleware](https://medium.com/front-end-weekly/learn-using-jwt-with-passport-authentication-9761539c4314#dfa8) to `/cat` and `/user` routes.
1. Test with postman

   - start with login: `POST http://localhost:3000/auth/login` with correct login credentials
   - after login is succesful, copy the token from response
   - test token with `GET http://localhost:3000/cat` and `GET http://localhost:3000/user`
     - paste token to _Authorization_ tab, choose _Type: Bearer Token_

1. Test also with the UI in folder `wop-ui/ui3`

   - UI3 checks the token so add the following to userRoute and userController

   ```javascript
   // userController.js
   const checkToken = (req, res) => {
     res.json({user: req.user});
   };

   // userRoute.js
   router.get("/token", userController.checkToken);
   ```

   - Logout by deleting the token from browser's session storage (developer tools/application)

1. Now that we have login etc. it's better not to send the owner id from the front end. Modify `catRoute.js`, `catController.js` and `catModel.js` so that you get owner's id from `req.user`
1. Refer to the [second version of the API Documentation](week4-apiDoc-v0.2.md) and implement all endpoints accordingly
   - Note: new user registration endpoint is moved from `/user` to `/auth/register`

### User Roles

Quite often you might want to have different user roles in your app such as administrator and regular user. One way to achieve this is to add one column to the user table in your database. In our wop_user table there is already a column 'role' of type integer. The idea is that _administrator_ role is _0_ and _regular user_ is _1_. Other roles would be 2, 3 etc. Of course the role column could also be a string like 'admin', 'user', 'moderator' etc.

Tip: Advanced solution would be adding a new table 'wop_user_role' including user role names and descriptions to the database and use the 'wop_user.role' column as a _foreign key_ referencing to _id_ of the user role table.

#### Tasks

1. Regular users can only delete and edit their own cats
   - modify the SQL queries for deleting and modifying in catModel.js so that queries will also check that owner matches the `user_id` property in `req.user` object `req.user` is decoded from token by passport and needs to come as a parameter from `catController.js`.
2. Administrator users can delete and edit everyone's cats
   - now you need two SQL queries in your modify and delete functions: one for regular users that checks that `user_id` in `req.user` matches the `owner` (query A) the other is for admin and it does not check the owner (query B).
   - add conditional statements to catModel.js which define whether to use query A or query B
3. How can you achieve similar functionality for users?
