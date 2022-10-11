# BCWT - Week 3

## Data Validation

* Study [client-side form validation](https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms/Form_validation)
* Read this article about [server-side data validation](https://medium.com/@BaYinMin/application-security-what-is-server-side-input-validation-why-is-it-needed-anyway-e0613c733548)
   * code in the article is not important but the principles are
* Read this article about [data sanitization](https://medium.com/@abderrahman.hamila/what-sanitize-mean-and-why-sanitize-in-code-data-5c68c9f76164)
* Regular Expressions
   * [Wikipedia](https://en.wikipedia.org/wiki/Regular_expression)
   * [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)
   * [HTML](https://html.com/attributes/input-pattern/)
   * [RegEx Lesson](https://regexone.com/)
   * [Online tester](https://regex101.com/)

1. HTML5 Built-in form validation
   * Continue last week's exercise. Make sure you have committed previous git branch then create new branch `week3`
   * In `wop-ui/ui2` there are HTML files with forms for adding user, adding cat and modifying cat
   * Add the following validation properties:
      * Add user
         * name: minimum length 3 characters, required
         * email: valid email address
         * password: minimum length 8 characters, at least one capital letter
      * Add cat
         * name: required
         * birthdate: date, required
         * weight: number, required
         * select owner: required
         * file: required, accept only images (jpg, gif, png)
      * Modify cat:
         * same as Add cat
1. Server side data validation
   * Study [express-validator](https://express-validator.github.io/docs/)
      * [List of all validators](https://github.com/validatorjs/validator.js#validators)
      * [MDN Example](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Express_Nodejs/forms#Using_express-validator)
   * Add `novalidate` attribute to `<form>` elements to disable front-end validation. Remove it after you have tested the server-side validation.
   * Validate the same properties on the server side as with above forms:
      * Add user
         * name: minimum length 3 characters, required
         * email: valid email address
         * password: minimum length 8 characters, at least one capital letter
      * Add cat
         * name: required
         * birthdate: date, required
         * weight: number, required
         * select owner: required
         * file: required, accept only images (jpg, gif, png)
            * file needs to be validated wiht Multer's [fileFilter](https://github.com/expressjs/multer#filefilter)
      * Modify cat:
         * same as Add cat
1. Server side data sanitization
   * Study [express-validator sanitization](https://express-validator.github.io/docs/sanitization.html)
   * Some of the fields could be still used to perform [XSS and SQL injections](https://keirstenbrager.tech/sql-vs-xxs-injection-attacks-explained/). Think which they could be and sanitize those fields.

## Cookies and Sessions

- Study [Maintaining state in web applications](week3-state-management.md)

1. Setup
   * Navigate to your course folder in terminal or Git Bash
      * Create `state-management` folder to your course folder.
      * Start new git repository to `state-management` folder: `cd state-management`, `git init` etc...
      * [Download starter files as zip](https://github.com/patrick-ausderau/wop-starters/tree/state-management), extract and copy all files to `state-management` folder
      * Run `npm install` and `nodemon app.js` to test `localhost:3000`
      * Commit changes to code regularly

1. Cookies
   * Create the following routes for GET method:
      * `/setCookie`
         * recieves a path variable `clr`
         * sets a new cookie `color` which gets the value of `clr` path variable
      * `/getCookie`
         * reads the value of `color` cookie and sends it to the client
      * `/deleteCookie`
         * delete `color` cookie
   * Open 'Application' tab in Developer Tools to see cookies in browser
   * Test in browser: `localhost:3000/setCookie/someColor` and `localhost:3000/deleteCookie`

1. Session
   * Add the following code to `app.js` after `const port = 3000;` (in row 4)
   ```javascript
   const username = 'foo';
   const password = 'bar';
   ```
   * Create the following routes for GET method:
      * `/form`
         * render `views/form.pug`
      * `/secret`
         * render `views/secret.pug`
   * Create the following route for POST method:
      * `/login`
         * recieves `username` and `password` from `req.body`
         * if recieved `username` and `password` match the username and password variables create session variable `logged` and set it to `true` and [redirect](https://expressjs.com/en/api.html#res.redirect) to `/secret`. Else set session variable `logged` to `false` and redirect to `/form`
      * In `/secret` route check if session variable `logged` is not true, then redirect to `/form`.
      * Open 'Application' tab in Developer Tools to see cookies in browser
      * Test in browser: `localhost:3000/form` and `localhost:3000/secret`

1. Creating a remote server
   - Option 1 (recommended): [Create a virtual server on Azure cloud environment](week3-virtual-server-azure.md) (you need to activate a student account for this)
   - Option 2: [Install Educloud virtual computer](week3-virtual-server-educloud.md)
   - Deploy your app on the server (note: if using Educlouad computer from outside school's network, make sure to use [metropolia vpn](https://vpn.metropolia.fi))
