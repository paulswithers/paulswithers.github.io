---
slug: framework-web-5
date: 
  created: 2024-09-03
category: Web
tags: 
  - Domino
  - Domino REST API
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
  - blog/2024-09-16-framework-web-6.md
  - blog/2024-10-07-framework-web-7.md
  - blog/2024-10-21-framework-web-8.md
  - blog/2024-10-23-framework-web-9.md
  - blog/2024-10-30-framework-web-10.md
  - blog/2024-12-14-framework-web-11.md
comments: true
---
# Framework App to Web App: Part Five - Home Page

So it's time to start with the application. Any development - team or individual - should use source control. My usual approach is to create the repository in GitHub (or your preferred repository), then clone it locally. A README is best practice of course. And I'll be creating two subfolders, "webapp" and "bruno" - because bruno allows me to store the REST service collection and environment in the github repo.

<!-- more -->

We'll start off in the webapp directory with three files - index.html, index.js and style.css. This is a small web application, so I'm doing a single page application (SPA), so this will be the only HTML file. There will be other JavaScript files and another CSS file. But to get started, this is all we need.

## HTML File Basics

First off, with the index.html file. This is modern web development, so HTML5. This means the main declaration is very easy `<!DOCTYPE html>`. Referencing the stylesheet and JavaScript file are (for now) the same as we've always done. Things will change later on, but we're starting simple. Everything is in a `div` with the class "container" (a common name). I'm just styling this with a border and border-radius, so it's not so "box-y". I've got a `header` element for my header area with a heading.

Above this is a `section` with a fixed height, and the ID "status-message" in which I'll post messages. This takes up space, but is designed to ensure no "jumping" UI. The section just includes a div with the ID "message". To manage the content, I'll use three functions:

``` javascript
const statusMsg = (statusText) => {
    document.getElementById("message").innerText = statusText;
    document.getElementById("status-message").style = "background-color:#008800";
    setTimeout(clearMsg, 3000);
};

const statusError = (err) => {
    document.getElementById("message").innerText = err;
    document.getElementById("status-message").style = "background-color:#880000";
    setTimeout(clearMsg, 3000);
};

const clearMsg = () => {
    document.getElementById('message').innerText = "";
    document.getElementById('status-message').removeAttribute("style");
}
```

Things will get more sophisticated, but this allows us to pass a successful message to `statusMsg()` and an error message to `statusError()`. After a few seconds, the message will clear. The styling is basic at this point - this is about getting it working at this point. But we add the style attribute when adding a message, remove the style attribute when clearing the message. This allows us to reuse the same HTML element and change the use.

Below the header tag we use a `main` tag. This is the main area of the application. Beneath the `main` tag we'll add `footer` tag, in which we'll have a span with the copyright details.

For developers who have primarily used a framework, `header`, `main`, `section`, and `footer` may be tags they have not come across. But they help semantically group content in a way that `div` cannot.

### Main Area

Again, we use `section` tags for each of the "pages" of the single page application. The first section is for the login form. This looks pretty simple:

``` html
<form id="credentials-form">
    <p>
        <input type="text" id="username-input" placeholder="User Name"
        aria-label="User Name" autofocus />
    </p>
    <p>
        <input type="password" id="password-input" placeholder="Password"
        aria-label="Password" />
        <button id="login-btn" aria-label="Login" type="button">Login</button>
    </p>
</form>
```

Here we just want two fields in a single column, so we just use paragraph tags. We'll get more sophisticated with other forms later. And in the second paragraph, we have the login button. Rather than labels, we're just using placeholder text. This is easy for an `input` HTML element, we'll handle other HTML elements later on. Two other attributes are worth highlighting.

`autofocus` is set on the "User Name" field. As someone who prefers to use the keyboard, I find it frustrating when a web developer creates a form and does not set a field with initial focus. It's easy, it speeds up use of the page. And for an application primarily used on mobile, speed of input is key here, so autofocus just makes sense. There can only be one element per page with `autofocus`, it's the element that the cursor is put in when the page is loaded. It can't be used to set the element of focus when an area is *displayed*, only when the page is *loaded*. So we'll need a different approach for the other sections. But the login form should be the first one displayed, so it makes sense here.

The second is `type="password"` on the "Password" field. This means that whatever is entered is not visible. It just makes sense to do this for a password.

Finally we have the login button. But it's just the HTML, there is no onclick event, just the markup. For developers who have not kept up-to-date with the evolution of web development, this will come as a huge shock. So the good news is after the code for the login, we'll be at the end of this blog post and you can digest it all.

Inline JavaScript on HTML elements is considered bad practice in web development, it's a security risk for cross-site scripting attacks and depending on the Content Security Policy it might get blocked, as might `<script>` tags without a nonce or hash. Even some years ago a security review of a web application required that inline JavaScript be removed from an application I had initially developed. You can investigate further or formulate arguments against it. I prefer to spend my time getting things done and learning how to handle the requirement in a modern web development approach, rather than debating or fighting political battles.

## EventListeners

For the solution, we need to step across to our JavaScript file, index.js. The modern approach is adding an **EventListener** to the relevant HTML element, in this case the button with id "login-btn". But we need to make sure the DOM is loaded, otherwise we will not be able to get a handle on the button. Certain JavaScript developers will immediately jump to using jQuery. But we don't need to, this isn't 2014, JavaScript and browsers have evolved. I'll use a function called `bootstrap()` to perform all my DOM manipulation. To ensure this triggers once the page has loaded, I'll use this JavaScript in index.js:

``` javascript
if (document.readyState != "loading") {
    bootstrap();
} else {
    document.addEventListener("DOMContentLoaded", bootstrap);
}
```

This may be overkill, a belt-and-braces approach. But it ensure the `bootstrap()` function doesn't trigger too early. [`document.readyState`](https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState) is either "loading" or the DOM is ready to interact with. [DOMContentLoaded](https://developer.mozilla.org/en-US/docs/Web/API/Document/DOMContentLoaded_event) is an event we can hook onto that will trigger after the DOM is accessible. At this point in the development, I also set `defer` when adding the JavaScript file to the page, so `<script defer src="index.js" charset="utf-8"></script>`. This means the script is loaded at the same time as the page and executed after the page has loaded. This may avoid the need for adding the eventListener to `DOMContentLoaded`.

The bootstrap function then gets the "login-btn" element by ID and adds the "click" EventListener to call `formLogin()`:

``` javascript
const bootstrap = () => {
    let login_button = document.getElementById("login-btn");
    login_button.addEventListener("click", formLogin);
    toggleSPA("credentials", "block");
};
```

There are [additional parameters](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener) that can be passed to `addEventListener()` but we won't be using them (yet!). And, not surprisingly, there is also a `removeEventListener()` function. toggleSPA()` is a function that will be used to show/hide the relevant section. This is its content:

``` javascript
const toggleSPA = (showme, how) => {
    spaSections.forEach((s) => {
      const display = showme === s ? how : "none";
      document.getElementById(s).style.display = display;
    });
  };
```

`spaSections` is a JavaScript array of the IDs of the sections. So after adding the eventListener, we set the display of the `credentials` section to block and all others to none.

### Troubleshooting EventListeners

But how do you see this EventListener when you're inspecting the element on the web page? If you view the page source you only see the HTML that was coded in the index.html. And if you open up Developer Tools in Chrome (or your preferred alternative) and inspect the button, on the Elements tab you just see the button, no event.

In Chrome Developer Tools, alongside the tabs for Styles, Computed, Layout and DOM Breakpoints, you will see another one - **Event Listeners**. This shows you all EventListeners registered for the current element and anything above it in the DOM tree, if "Ancestors" is checked. Uncheck that and you see just the EventListeners registered for this element.

## Wrap-Up

In the next section we'll come back to the `formLogin()` function, how we handle logging in, how we set that up to handle mocking and a setting we need to add to DRAPI to allow us to call JavaScript functions against it.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. [Frameworks](./2024-08-24-framework-web-3.md)
1. [DRAPI](./2024-08-26-framework-web-4.md)
1. **Home Page**
1. [Mocking, Fetch DRAPI and CORS](./2024-09-16-framework-web-6.md)
1. [CSS](./2024-10-07-framework-web-7.md)
1. [Landing Page Web Component](./2024-10-21-framework-web-8.md)
1. [Services](./2024-10-23-framework-web-9.md)
1. [Ship Form Actions](./2024-10-30-framework-web-10.md)
1. [Ship Search and Save](./2024-12-14-framework-web-11.md)