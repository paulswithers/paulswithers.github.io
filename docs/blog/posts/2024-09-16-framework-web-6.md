---
slug: framework-web-6
date: 2024-09-16
categories:
  - Web
tags: 
  - Domino
  - Domino REST API
  - Web
  - HTML
  - CSS
  - JavaScript
  - Web Components
comments: true
---
# Framework App to Web App: Part Six - Mocking, DRAPI and CORS

In the last part, we created for login form and added an eventHandler to call `formLogin()` function. However, we didn't go into the code behind that function. That function is pretty basic, offloading the bulk of the processing:

```js
const formLogin = () => {
  let username = document.getElementById("username-input").value;
  let password = document.getElementById("password-input").value;
  login(username, password);
};
```

<!-- more -->

## Mocking

That function - at least during development - will go down two different routes, depending on the username passed.

```js
const login = (user, pwd) => {
  // Set as mocking only
  if (user === "John Doe") {
    window.isMock = true;
    statusMsg("Login successful");
	loadSessionData();
	toggleSPA("landing", "block");
  } else {
    fetch(baseUrl + urls.login, {
        method: "POST",
        headers: {
        "Content-Type": "application/json"
        },
        body: JSON.stringify({ username: user, password: pwd }),
    })
        .then((response) => response.json())
        .then((json) => {
            if (json.hasOwnProperty("status")) {
                statusError(json.message);
            } else {
                if (extractCredentials(json)) {
                    loadSessionData();
                    toggleSPA("landing", "block");
                }
            }
        })
        .catch((err) => {
            statusError(err.message);
        });
    }
  };
```

If the username is "John Doe", we set a global variable `isMock` to true and continue processing. Otherwise we log into Domino REST API, extract the JWT token and continue processing.

The purpose here is that we can develop the application offline and / or with mock data. Even if we have access to Domino REST API, using the mock data means we can update local storage with dummy data and don't need to clean up the database all the time. When we're ready we can test the Domino REST API calls from the app and we can test them from [bruno](https://usebruno.com) or Postman.

Bruno or Postman allows us to perform the relevant REST API calls to retrieve dummy data that we can test with. In this case it allows us to create local JSON files of ships, ports, countries, spots and more.

## Fetch

REST API calls, whether local or to Domino REST API, are done with **fetch**. fetch is [widely supported](https://caniuse.com/?search=fetch) by browsers meaning the days of XMLHttpRequest or framework variants like `dojo.xhr`, jQuery's `$.get()` or the more recent `Axios` are no longer required. Even if you're familiar with Axios, it's worth switching to fetch because it can handle chunked responses in a browser, which Axios cannot as Stephan Wissel showed in [our Engage session](https://github.com/stwissel/super-procode-mode).

Fetch is also readily supported in bruno and Postman code generation options, so learning how to use it is very easy. As you can see above, it takes a URL and a JSON object containing options - method, headers and body. If your code does not necessarily return a JSON object, you will need to check the [response status code](https://developer.mozilla.org/en-US/docs/Web/API/Response/status) before trying to convert to JSON. The nice thing with Domino REST API is that if some kind of error occurs, the response always contains a "status" property.

## CORS

Whenever making browser-based HTTP requests, you need to be aware of Cross-Origin Resource Sharing (CORS). Even when opening a local HTML file, the browser will block CORS requests, which is why you'll need a local HTTP server. In the list of dev tools I mentioned Visual Studio Code's Live Server extension. This is a good way round it if you don't want to install anything additional. Most developers have Node.js installed now and so my preference has become NodeJS's [http-server](https://www.npmjs.com/package/http-server) via npx.

This works fine for the mock data calls. But as soon as you call Domino REST API, you may also get hit by CORS problems. Here, Domino REST API is only allowing requests from specified hostnames. Domino REST API automatically accepts "localhost", but if you're using Live Server extension you'll be connecting from 127.0.0.1. The good news is Domino REST API's documentation covers allows you to [configure this](https://opensource.hcltechsw.com/Domino-rest-api/tutorial/walkthrough/lab-11.html?h=cors#update-cors-settings). We'll need to create `keepconfig.d` directory in Domino data directory, if it doesn't exist, and add a config.json file. In the "CORS" JSON object, we'll need to add `"127.0.0.1": true` and restart Domino REST API. Now, we can connect from our local app.

NodeJS's http-server allows you to use `http://localhost` rather than `http://127.0.0.1`. This also gives a URL on your local network (192.168.1.*), but that will not be in DRAPI's CORS setting either, so will fail. Of course this will work for testing the application in a mock session, which may cover most initial scenarios. However, using ngrok will proxy through your local machine, so will work around this problem.

The key here is understanding what CORS means, that the server we're connecting to is not accepting the request because it doesn't come from a hostname it has been configured to accept.

## LocalStorage and SessionStorage

Whether mocking or calling Domino REST API, I'm storing content locally in the browser. Again with modern browsers this can be done on desktop browsers or mobile browsers. There are two options - [**localStorage**](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) and [**sessionStorage**](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage). Most of the local data I'm storing in sessionStorage, although we'll see a specific use case for localStorage in the next part of the series.

The important differences are that sessionStorage is automatically cleared when the user closes the tab and localStorage is shared across tabs for the domain and protocol whereas sessionStorage is only shared if the user uses the browser "duplicate tab" functionality.

The key thing to bear in mind with both localStorage and sessionStorage is that both the key and the value are *always* **UTF-16 strings**. This means booleans need converting or (probably easier) compared as strings, as we'll see in the next part. More typically, the values stored will be JSON, which means calling `JSON.stringify()` before writing and `JSON.parse()` after reading.

## Wrap Up

In the next session we'll add some styling to the application, which will demonstrate how far CSS has come in recent years.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. [Frameworks](./2024-08-24-framework-web-3.md)
1. [DRAPI](./2024-08-26-framework-web-4.md)
1. [Home Page](./2024-09-03-framework-web-5.md)
1. **Mocking, Fetch, DRAPI and CORS**
1. [CSS](./2024-10-07-framework-web-7.md)
1. [Landing Page Web Component](./2024-10-21-framework-web-8.md)
1. [Services](./2024-10-23-framework-web-9.md)
1. [Ship Form Actions](./2024-10-30-framework-web-10.md)
1. [Ship Search and Save](./2024-12-14-framework-web-11.md)
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)
1. [Fields and Save](./2025-02-07-framework-web-14.md)
1. [Dialogs](./2025-02-08-framework-web-15.md)
1. [Spots](./2025-02-11-framework-web-16.md)
1. [Lessons Learned](./2025-04-02-framework-web-17.md)
1. [CSP Enhancement](./2025-04-19-framework-web-18.md)
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)
1. [Custom CSP Settings](./2025-09-14-framework-web-20.md)