# Week 1 - Setup, Node.js basics

## Getting ready for software development

1. Install tools

   - [Webstorm](https://www.jetbrains.com/student/) or
   - [VSCode](https://code.visualstudio.com/) (or the totally Open Source version [VSCodium](https://vscodium.com/))
     - Install extensions for VSCode:
       - Choose _extensions_ icon on the left panel.
       - Search and install:
         - Live Server
         - JavaScript (ES6) Code Snippets
         - Prettier
   - or Atom, Brackets, Vim, Emacs, etc...
   - Some file transfer app like WinSCP, FileZilla or Cyberduck (optional)
   - Consider mapping your metropolia [Z: drive](https://webdisk.metropolia.fi/): &bull;&bull;&bull;more &rarr; Map web folder.

     - Linux users, in terminal (substitute `metropolia-username` with your metropolia account):

       ```bash
       ssh metropolia-username@shell.metropolia.fi
       ```

       Then, in your file explorer open location `ssh://shell.metropolia.fi/homeX-Y/Z/metropolia-username` (where `/homeX-Y/Z/metropolia-username` is the result of `pwd`)

   - App for testing REST API: [Postman](https://www.postman.com/downloads/) or [Insomnia](https://insomnia.rest/download)
     - thre is also a [VSCode Plugin](https://blog.bitsrc.io/vs-codes-rest-client-plugin-is-all-you-need-to-make-api-calls-e9e95fcfd85a)
   - [Node.js](https://nodejs.org/en/) LTS version

     - MacOS no sudo for Mac users!!

       - Older MacOS (bash terminal)

       ```bash
       mkdir ~/.npm-packages
       npm config set prefix ~/.npm-packages
       echo NPM_PACKAGES="${HOME}/.npm-packages" >> ${HOME}/.bashrc
       echo prefix=${HOME}/.npm-packages >> ${HOME}/.npmrc
       echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> ${HOME}/.bashrc
       echo PATH=\"\$NPM_PACKAGES/bin:\$PATH\" >> ${HOME}/.bashrc
       echo source "~/.bashrc" >> ${HOME}/.bash_profile
       source ~/.bashrc
       ```

       - Newer MacOS (zsh terminal)

       ```zsh
       mkdir ~/.npm-packages
       npm config set prefix ~/.npm-packages
       echo NPM_PACKAGES="${HOME}/.npm-packages" >> ${HOME}/.zshrc
       echo prefix=${HOME}/.npm-packages >> ${HOME}/.npmrc
       echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> ${HOME}/.zshrc
       echo PATH=\"\$NPM_PACKAGES/bin:\$PATH\" >> ${HOME}/.zshrc
       echo source "~/.zshrc" >> ${HOME}/.zsh_profile
       source ~/.zshrc
       ```

   - [Git](https://git-scm.com/downloads) for Windows users (or from [git for windows](https://gitforwindows.org/) which comes with git bash)
   - [Metropolia VPN](https://wiki.metropolia.fi/display/itservices/VPN+Remote+Connections)

2. [Command line intro](https://guide.freecodecamp.org/linux/the-command-prompt/)

   - **NOTE**: _When executing commands in command line always make sure you are in the right folder. Especially when running_ `git init`

3. [Get familiar with Git](https://git-scm.com/about)

   - Study [GIT material](https://github.com/mattpe/git-intro/blob/main/git-basics.md)
     - Exercises are recommended but not compulsory.
   - [What files to include in repo?](<[week1-git.md](https://github.com/mattpe/git-intro/blob/main/git-basics.md#git-ignore)>)
   - Common git commands:
     - Creating new local repo: `git init`
     - For sharing your code with teacher and team members you need to setup a remote repository in GitHub too and link it to your local repository
       - `git remote add origin <YOUR-REPO-URL>`
       - Or `git clone <YOUR-REPO-URL>` (make sure to not be in a folder that is already under version control!)
     - Choose files to commit: `git add .` (this adds all files, to make sure what will be added check with `git status` first)
       - if you already added files you should not, you can undo that with `git reset`  
     - Create a new revision: `git commit -m 'some message'`
     - Pushing your local changes to the remote repo: `git push -u origin main`

4. Create a folder `bcwt-assignments` or similar for all the course's JavaScript coding assignments

   - Create a Git repo inside the assignments folder (`git init`)
   - Create `README.md` and `.gitignore` files _before_ the first commit
   - Choose files for the commit: `git add .` (`.` means all files in current folder recursively)
   - Check always with `git status` that your are not going to commit anything unnecessary. Fix your `.gitignore` if needed
   - Create an initial commit: `git commit -m "Initial, add readme & .gitignore template"` (a good commit message always describes what changes you have done after the previous commit)
   - Create a new project in GitHub and push your local repo there: `git remote add origin <YOUR_URL>`, `git push -u origin [main/master]`
   - if having problems with GitHub authentication on command line:
     - <https://ginnyfahs.medium.com/github-error-authentication-failed-from-command-line-3a545bfd0ca8>
     - <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github>
     - <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token> 
   - if you made your GitHub repo private, add teacher as a collaborator

5. [Node.js](https://nodejs.org/en/)

   1. Study the [material](week1-nodejs.md) and do the exercises
   2. Add, commit & push your new files to GitHub. **Make sure** your `.gitignore` is working correctly and you don't add e.g. any `node_modules` folder accidentally to your repo.

6. [Express.js](https://expressjs.com/)

   - Create a `server-one` folder into your course assignments folder.
   - Create a `package.json` file (`npm init`) in `server-one` folder
   - Install express `npm install express --save`
   - Do the [Hello world example](https://expressjs.com/en/starter/hello-world.html) to `server-one` folder
     - Clean code (`'use strict';`, end lines with semicolon `;`, etc.)
   - Add `public` folder to `server-one` and copy the content of this [zip file](week1-public.zip) there.
   - Serve the [static content](https://expressjs.com/en/starter/static-files.html) of `public` folder
   - Add endpoint _catinfo_ to `app.js`:

   ```javascript
   app.get("/catinfo", (req, res) => {
     const cat = {
       name: "Frank",
       birthdate: "2010-12-25",
       weight: 5,
     };
     res.json(cat);
   });
   ```

   - Test in a web browser: <http://localhost:3000>
   - Remember to open browser's development tools always when testing your code in browser!

7. Study [Different Rendering Strategies](https://blog.alexandrudanpop.dev/posts/fe-jargon-you-should-know-ssg-ssr-csr-vdom-22b0/)
   1. Note: The project needs to be done using the CSR strategy. Some UI parts can be done with SSR, but check this from teacher before starting to code the project.
8. [Pug](https://expressjs.com/en/guide/using-template-engines.html)
   - Note: Using a template engine such as Pug or [EJS](https://ejs.co/) follows SSR strategy.
   - Duplicate `server-one` folder and rename it to `server-two` (or make a git branch)
   - Create a `views` folder to into `server-two`
   - Make a [pug](https://pugjs.org/api/getting-started.html) template which generates the same HTML as index.html. Delete index.html (or rename it to index_old.html)
   - Test in the browser: <http://localhost:3000>

Finally, return your assignment as instructed in Oma.
