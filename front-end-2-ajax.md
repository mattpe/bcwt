# Fron-end JS 2: AJAX

Asynchronous JavaScript and (XML)

## Study

1. [AJAX](https://www.w3schools.com/xml/ajax_intro.asp)
2. [Promises](https://dev.to/rjitsu/the-only-guide-you-ll-ever-need-to-understand-promises-and-async-await-24cd)
3. [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch)
4. [async/await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)
5. [REST API](https://restfulapi.net/)
6. [JSON](https://www.w3schools.com/js/js_json_intro.asp)

### Example

_pics.json:_

```json
[
  {
    "name": "Sleeping  cat",
    "description": "Here we have a sleeping cat.",
    "url": "http://placekitten.com/321/241"
  },
  {
    "name": "Running cat",
    "description": "Here we have a running cat.",
    "url": "http://placekitten.com/421/251"
  }
]
```

_index.html:_

```html
<figure>
  <img />
  <figcaption></figcaption>
</figure>

<script>
  const showImages = async () => {
    try {
      const response = await fetch("pics.json");
      if (!response.ok) {
        throw new Error("something went wrong");
      }
      const images = await response.json();
      const n = images[1].name; // name property of the second item of 'images' array
      const d = images[1].description; // description property of the second item of 'images' array
      const u = images[1].url; // url property of the second item of 'images' array

      document.querySelector("img").src = u;
      document.querySelector("img").alt = n;
      document.querySelector("figcaption").innerHTML = d;
    } catch (error) {
      console.log(error);
    }
  };

  showImages();
</script>
```

```javascript
// the JavaScript above can be also executed with an IIFE
(async () => {
  try {
    const response = await fetch("pics.json");
    if (!response.ok) {
      throw new Error("something went wrong");
    }
    const images = await response.json();
    const n = images[1].name; // name property of the second item of 'images' array
    const d = images[1].description; // description property of the second item of 'images' array
    const u = images[1].url; // url property of the second item of 'images' array

    document.querySelector("img").src = u;
    document.querySelector("img").alt = n;
    document.querySelector("figcaption").innerHTML = d;
  } catch (error) {
    console.log(error);
  }
})();
```

## Task

Make a simple web app, that asks user for a name of a TV show and then fetches the information from TVMaze API and displays the results on a web page.

- API and 'show' endpoint documentation: [TVMaze API](http://www.tvmaze.com/api#show-search)
- Requirements:
  - Step 1: Log the search result to console
  - Step 2: Print the information of the first show of the result on the web page
    - print these properties: name, link to homepage (officialSite), medium size image and summary
  - Step 3: Print the information of all shows in the result on the web page
    - print these properties: name, link to homepage (officialSite), medium size image, summary and genres separated with | (<-that is a pole)

### Instructions

- First make a valid HTML-page with a form that has an input field and a button:

```html
  <form id="search-form" action="https://api.tvmaze.com/search/shows">
    <input type="text" name="search-field" />
    <button type="submit">Go</button>
  </form>
```

- Add a submit event to the form element to initiate the search.
- You need to get the value of the 'searh-field', which is then sent to the API with fetch.
- The response from the API is an array containing one or more TV shows which you need to iterate to show the results.
- Some of the properties might be missing from some shows, so you need to make your script to tolerate errors. For instance not all shows have image property or officialSite. You can use if statement to check if certain value is null and in that case you can set image.medium property to some default value (like placekitten.com). You could also use [ternary operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_Operator) to add some default value if an object property is falsy. [Optional chaining](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining) is also possible. That is the simplest, but not the most versatile solution.
  - You can test this by searching the word 'dome'. In this case API response has about nine TV shows but one of them has null as the value for image.
