# Week 1
1. Install tools
    * [Webstorm](https://www.jetbrains.com/student/) or
    * [VSCode](https://code.visualstudio.com/) or without Microsoft telemetry [VSCodium](https://vscodium.com/) (or Atom, Brackets, Vim, Emacs, etc...)
       * Install extensions for VSCode:
          * Press ctrl-shift-x or click extensions icon on the left panel.
          * Search and install:
             * EditorConfig for VS Code
             * ESLint
             * JavaScript (ES6) Code Snippets
             * Prettier
    * Some file transfer app like WinSCP, FileZilla or Cyberduck
    * App for testing REST API: [Postman](https://www.postman.com/downloads/) or [Insomnia](https://insomnia.rest/download)
    * [Node.js](https://nodejs.org/en/) LTS version
       * MacOS no sudo for Mac users!!
         - [instructions](https://johnpapa.net/node-and-npm-without-sudo/)
    * [Git](https://git-scm.com/downloads) for Windows users (or from [git for windows](https://gitforwindows.org/) which comes with git bash)
    * [Metropolia VPN](https://wiki.metropolia.fi/pages/viewpage.action?pageId=149652071)

2. [Command line intro](https://guide.freecodecamp.org/linux/the-command-prompt/)
3. [GIT](https://git-scm.com/about)
   * Study [GIT material](https://github.com/mattpe/git-intro/blob/master/git-basics.md)
     * Exercises are recommended but not compulsory.
   * [What files to include in repo?](git.md)
   * Common git commands:
      * Creating new local repo (first create remote repo in [GitLab](https://gitlab.metropolia.fi/) or GitHub etc.)
          * `git init` and `git remote add origin https://gitlab.metropolia.fi/user/repo-name.git`
          * Or `git clone https://gitlab.metropolia.fi/user/repo-name.git` (make sure to not be in a folder that is already under version control!)
          * `git add .` (this adds all files, to make sure what will be added check with `git status` first)
          * `git commit -m 'some message'`
          * `git push -u origin master`

      * Push new changes:
         * `git add .`
         * `git commit -m 'some message'`
         * `git push`

      Remember to make README.md, license and especially .gitignore _before_ first commit
   * Create folder `week1` for the following exercises

4. [Node.js](https://nodejs.org/en/)
   * Study the [material](node.md) and do the exercises

5. [Express.js](https://expressjs.com/)
   * Create `server-one` folder to `week1`
   * Create package.json (`npm init`) in `server-one` folder
   * Install express `npm install express --save`
   * Do the [Hello world example](https://expressjs.com/en/starter/hello-world.html) to `server-one` folder
     * Clean code (`'use strict';`, end lines with semicolon `;`, etc.)
   * Add `public` folder to `server-one` and copy the content of this [zip](public.zip) there.
   * Serve the [static content](https://expressjs.com/en/starter/static-files.html) of `public` folder
   * Add endpoint 'catinfo' to app.js:
   ```javascript
   app.get('/catinfo', (req, res) => {
     const cat = {
       name: 'Frank',
       birthdate: '2010-12-25',
       weight: 5,
     };
     res.json(cat);
   });
   ```
   * test in browser: `localhost:3000`

6. [Different Rendering Strategies](https://blog.alexandrudanpop.dev/posts/fe-jargon-you-should-know-ssg-ssr-csr-vdom-22b0/)
   1. Note: The project needs to be done using CSR strategy. Some UI parts can be done with SSR, but check this from teacher before starting to code the project.
7. [Pug](https://expressjs.com/en/guide/using-template-engines.html)
   * Note: Using a template engine such as Pug or [EJS](https://ejs.co/) follows SSR strategy.
   * Duplicate `server-one` folder and rename it to `server-two`
   * Create `views` folder to `server-two`
   * Make a [pug](https://pugjs.org/api/getting-started.html) template which generates the same HTML as index.html. Rename index.html to index_old.html
   * test in browser: `localhost:3000`
