---
slug: framework-web-9
date: 
  created: 2024-10-23
categories:
  - Web
tags: 
  - Web
  - HTML
  - CSS
  - JavaScript
  - Web Components
links: 
  - blog/2024-08-15-xpages-web-1.md
  - blog/2024-08-20-xpages-web-2.md
  - blog/2024-08-24-framework-web-3.md
  - blog/2024-08-26-framework-web-4.md
  - blog/2024-09-03-framework-web-5.md
  - blog/2024-09-16-framework-web-6.md
  - blog/2024-10-07-framework-web-7.md
  - blog/2024-10-21-framework-web-8.md
  - blog/2024-10-30-framework-web-10.md
  - blog/2024-12-14-framework-web-11.md
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
  - blog/2025-02-07-framework-web-14.md
  - blog/2025-02-08-framework-web-15.md
  - blog/2025-02-11-framework-web-16.md
  - blog/2025-04-02-framework-web-17.md
  - blog/2025-04-19-framework-web-18.md
  - blog/2025-04-22-framework-web-19.md
comments: true
---
# XPages App to Web App: Part Nine - Services

We've got a login and a landing page, we're ready to start building the bulk of the application now. But we need the data. In [part six](./2024-09-16-framework-web-6.md) we handled the login, both for a mock session and the actual authentication to Domino REST API. But that format is going to quickly get messy as we build out the rest of the application. We can do better.

<!-- more -->

As with the landing page web component, we're going to write JavaScript classes for the mock services and the actual services. But some of the functionality we need will be common. So we will also create a base class as well. Our three classes will be:

- BaseService.
- MockService, extending BaseService.
- DominoService, extending BaseService.

Again we'll be doing `export default class BaseService`, `export default class MockService as BaseService` and `export default class DominoService as BaseService`. In each file we'll import the relevant class from the JavaScript file, e.g. `import BaseService from "./baseService.js";`

## Login Process

Revisiting the login process in part six, it goes through a few steps:

1. Check username to verify if we're in a mock session.
1. Log in.
1. Load some session data.

The important point to note here is that the login logic will differ for the two services. So both classes will have a `login()` function, but with different code. And even though the URLs will differ, the code for loading the session data will be the same. If we architect the code well, we can have single `loadSessionData()` function in the BaseService class.

## Constructor

So we will need the URLs available in the BaseService class. In JavaScript, we can just put them in a JavaScript object, e.g. for our mock class it's:

``` js
const mockUrls = {
	countries: "data/countries.json",
	ports: "data/ports.json",
	shipTypes: "data/shipTypes.json",
	shipLines: "data/shipLines.json",
	ships: "data/ships.json",
	trips: "data/trips.json",
	spotsByShip: "data/spotsByShip.json",
	spotsByDate: "data/spotsByDate.json"
};
```

For those with less experience of JavaScript, note this is a JavaScript object, not a JSON object. JSON object keys must be strings, in JavaScript objects they are properties.

For the mock service, we can just use these URLs to retrieve the data, because the files are in a data subdirectory of our web application. But for the Domino REST API we'll have a base URL, the Domino REST API server + "/api/v1". We could put this in each URL. Instead, we can have a base URL and just pass an empty string for the mock services.

So we'll have a constructor in the BaseService with this code:

``` js
constructor(baseUrl, urls) {
    this._baseUrl = baseUrl;
    this._urls = urls;
    this._token = "";
}
```

This means we'll have the base URL and URLs in the BaseService and both derived classes. We also instantiate the token to an empty string. These could be variables in the class. But my preference is to use getters and a setter for `token`. This means the base URL and URLs can only be set by passing them to the constructor, but the token can be set from outside the class.

The good news is that the constructors of the derived class, MockService and DominoService, don't need arguments. They can just pick up private variables in the relevant classes. So our MockService's constructor is `super("", mockUrls);` and our DominoService's constructor is `super(baseUrl, urls);`.

## Login

First of, we'll modify the login function in index.js and replace it with this:

``` js
const login = async (user, pwd) => {
	// Set as mocking only
	if (user === "John Doe") {
		window.dataService = new MockService();
	} else {
		window.dataService = new DominoService();
	}
	const result = await window.dataService.login(user, pwd);
	if (result === "success") {
		const landing = document.querySelector("#landing");
		const landingContainer = document.createElement("landing-elem");
		landingContainer.allTiles = JSON.stringify(allTiles);
		landing.append(landingContainer);
		toggleSPA("landing", "block");
	} else {
		statusError(result);
	}
};
```

We create an instance of the relevant class, depending on the username. And we store it in `window.dataService` property. This means everywhere else, we can just use `window.database` and always get the relevant service. So for logging in, we can just do `window.dataservice.login()`.

### MockService Login

The MockService will run immediately, but the DominoService needs to wait for a response from DRAPI. For ease, we'll just make both `login()` functions async and await regardless. The MockService login is very straightforward:

``` js
async login(user, pwd) {
    window.isMock = true;
    this.bubbleMessage("confirm", "Login successful");
    super.loadSessionData();
    return "success";
}
```

When the code was just in index.js, we simple called a function in index.js. We can't do that from the service classes. But instead we can leverage the technique we used in the landing page web component - CustomEvents. We'll need to send a lot of messages to the user, so we'll create a method in the BaseService class, `bubbleMessage()` and call that. It will take two parameters, "confirm" or "error" for the message type and a message to display. The `bubbleMessage()` function will be:

``` js
bubbleMessage(type, message) {
    const messageObj = {
        "type": type,
        "message": message
    };
    document.dispatchEvent(new CustomEvent("sendUserMessage", { bubbles: true, detail: messageObj}));
    
}
```

We pass the type and the message to an object, put that in the CustomEvent's detail. As with the other custom events, an event listener will be registered in index.js to listen for the "sendUserMessage" event and call the `statusMsg()` or `statusError()` function there, depending on the type.

### DominoServiceLogin

The DominoService login function is more complex, but doesn't change much from what we had in part six. We perform the login, call a local `extractCredentials` function, then load the session data. The key differences are that the `extractCredentials()` method is in the DominoService class, so we call it with `this.extractCredentials()` and the `token` property is in the BaseService, so we call `this.token = bearer`.

## loadSessionData

We don't want to tie up the application while loading the session data. So we won't await the success or failure of that, but we can again use `bubbleMessage()` to notify the user of completion. From experience of running the application in production, even on a patchy network, the session data loads very quickly. Ships is the largest at about 700Kb.

The good news is that this function can be held just in the BaseService class. First off, we'll set some variables common for all fetch requests:

``` js
const headers = {
    Accept: "application/json",
};
if (this.token != "") {
    headers.Authorization = `Bearer ${this.token}`;
}
const getParams = {
    method: "GET",
    headers: headers,
};
```

Remember the MockService doesn't need any authorization. Because we instantiate the token property to an empty string in the BaseService constructor, we can check it's still not an empty string. We want to load countries, ports, ship types, ship lines, ships and trips. But we can load them all at the same time, so we create an array of Promises:

``` js
Promise.all([
    fetch(this.baseUrl + this.urls.countries, getParams)
        .then((response) => response.json())
        .catch((err) => this.bubbleMessage("error", err.message)),
    fetch(this.baseUrl + this.urls.ports, getParams)
        .then((response) => response.json())
        .catch((err) => this.bubbleMessage("error", err.message)),
....
```

We don't expect any to fail. And if one does, we won't be able to use the application. So this works for our needs. This will return an array of responses in the same order as the requests, so we can process them accordingly. Some will get loaded into sessionStorage or localStorage. But we'll do something a little more sophisticated for others, as we'll see as we get further into the application.

## Preventing Double-Clicking

As we move further through the application, we'll want to prevent double-clicking by users. Some frameworks have provided helpers to do this. Other applications don't bother. That is even more surprising considering how easy it is to do now, with just CSS. By adding this class to the main div container of the application, we can let the user see that a backend service is running and prevent double-clicking:

``` css
.container-mask {
  background-color: #DDDDDD;
  pointer-events: none;
}
```

When the backend service has completed, or we've hit an error, we can remove the class.

## Wrap Up

We're ready now to start on the first edit form, for ships. This will perform multiple purposes - searching, viewing and editing. But for all of those purposes we will need to interact with data loaded from the services.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. [Frameworks](./2024-08-24-framework-web-3.md)
1. [DRAPI](./2024-08-26-framework-web-4.md)
1. [Home Page](./2024-09-03-framework-web-5.md)
1. [Mocking, Fetch, DRAPI and CORS](./2024-09-16-framework-web-6.md)
1. [CSS](./2024-10-07-framework-web-7.md)
1. [Landing Page Web Component](./2024-10-21-framework-web-8.md)
1. **Services**
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