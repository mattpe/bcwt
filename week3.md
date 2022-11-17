# BCWT - Week 3

[Teacher's example repo](https://github.com/mattpe/bcwt-assignments-examples22/tree/week3)

## Front-end JavaScript recap & tasks

1. [Document Object Model](./front-end-1-dom.md)
2. [AJAX](./front-end-2-ajax.md)
3. [Events](./front-end-3-events.md)

Check Oma for returning instructions.

## Data Validation

- Study [client-side form validation](https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms/Form_validation)
- Read this article about [server-side data validation](https://medium.com/@BaYinMin/application-security-what-is-server-side-input-validation-why-is-it-needed-anyway-e0613c733548)
  - code in the article is not important but the principles are
- Read this article about [data sanitization](https://medium.com/@abderrahman.hamila/what-sanitize-mean-and-why-sanitize-in-code-data-5c68c9f76164)
- Regular Expressions
  - [Wikipedia](https://en.wikipedia.org/wiki/Regular_expression)
  - [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)
  - [HTML](https://html.com/attributes/input-pattern/)
  - [RegEx Lesson](https://regexone.com/)
  - [Online tester](https://regex101.com/)

1. HTML5 Built-in form validation
   - Continue last week's exercise. Make sure you have committed previous git branch then create new branch `week3`
   - In `example-ui/ui2` there are HTML files with forms for adding user, adding cat and modifying cat
   - Add the following validation properties:
     - Add user
       - name: minimum length 3 characters, required
       - email: valid email address
       - password: minimum length 8 characters
     - Add cat
       - name: required
       - birthdate: date, required
       - weight: number, required
       - select owner: required
       - file: required, accept only images (jpg, gif, png)
     - Modify cat:
       - same as Add cat
1. Server side data validation
   - Study [express-validator](https://express-validator.github.io/docs/)
     - [List of all validators](https://github.com/validatorjs/validator.js#validators)
     - [MDN Example](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Express_Nodejs/forms#Using_express-validator)
   - Add `novalidate` attribute to `<form>` elements to disable the front-end validation. Remove it after you have tested the server-side validation.
   - Validate the same properties on the server side as with the forms above:
     - Add user
       - name: minimum length 3 characters, required
       - email: valid email address
       - password: minimum length 8 characters
     - Add cat
       - name: required
       - birthdate: date, required
       - weight: number, required
       - select owner: required
       - file: required, accept only images (jpg, gif, png)
         - file needs to be validated with Multer's [fileFilter](https://github.com/expressjs/multer#filefilter)
     - Modify cat:
       - same as Add cat
1. Server side data sanitization
   - Study [express-validator sanitization](https://express-validator.github.io/docs/sanitization.html)
   - Some of the fields could be still used to perform [XSS and SQL injections](https://keirstenbrager.tech/sql-vs-xxs-injection-attacks-explained/). Think which they could be and sanitize those fields.

## Creating a remote server

- Option 1 (recommended): [Create a virtual server on Azure cloud environment](week3-virtual-server-azure.md) (you need to activate a student account for this)
- (Option 2: no teacher's example/support available for this) [Install Educloud virtual computer](week3-virtual-server-educloud.md)
