---
slug: framework-web-18
date: 2025-04-19
categories:
  - Web
tags: 
  - Web
  - Domino
  - HTML
  - CSS
  - JavaScript
links: 
  - blog/2024-08-15-xpages-web-1.md
  - blog/2024-08-20-xpages-web-2.md
  - blog/2024-08-24-framework-web-3.md
  - blog/2024-08-26-framework-web-4.md
  - blog/2024-09-03-framework-web-5.md
  - blog/2024-09-16-framework-web-6.md
  - blog/2024-10-07-framework-web-7.md
  - blog/2024-10-21-framework-web-8.md
  - blog/2024-10-23-framework-web-9.md
  - blog/2024-10-30-framework-web-10.md
  - blog/2024-12-14-framework-web-11.md
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
  - blog/2025-02-07-framework-web-14.md
  - blog/2025-02-08-framework-web-15.md
  - blog/2025-02-11-framework-web-16.md
  - blog/2025-04-02-framework-web-17.md
  - blog/2025-04-22-framework-web-19.md
comments: true
---
# XPages App to Web App: Part Eighteen: CSP Enhancement

In my [last blog post](./2025-04-07-css-export.md) I talked about CSP and inline CSS. I mentioned that I had not addressed these issues with this Ship Spotter app. In this blog post we'll start to fix that.

<!-- more -->

## Inline CSP Issues

Firstly, there are two inline violations for CSP that are common: inline JavaScript and inline CSS. Because the application always uses Event Listeners (e.g. `element.addEventListener("click", function () {...}`), we have no inline JavaScript. So there's no remedial work to do. All we have to deal with - and it's no small task - is inline CSS.

Secondly, bad practice happens and needs enhancement work to fix it. "App modernization" will constitute its own blog post. As a developer, you should expect it and should manage your customers' expectations accordingly.

## `style=display:none`

Probably the most common inline CSS is `display:none`. One of the biggest places this was used in my application was in the `toggleSPA()` method, used to show / hide sections.

```js
const toggleSPA = (showme, how) => {
spaSections.forEach((s) => {
    const display = showme === s ? how : "none";
    document.getElementById(s).style.display = display;
});
```

Thankfully, this didn't take too long to solve, because I have seen a simple solution in other frameworks and because I used a single function for changing visibility of functions. The approach is to use a class (e.g. `.hidden`) and add / remove the class as required.

Then it's a case of modifying the code. The code here iterates all sections and sets style to `display:none` or the required style, which is the application was always "block", the default display style. We could do something similar here - apply the class `hidden` to all sections, then remove it from the one we want to show. But I took the opportunity to improve the application.

Currently, I call `toggleSPA()` when the application loads to only show the login section. But this means there's a flash of the other sections when the application first loads, before they are then hidden. So I've changed the index.html to set `.hidden` class on all sections except the login one by default. So I no longer need to call `toggleSPA()` on load.

In the `toggleSPA()` function itself, I decided to just add the `hidden` class to the currently-displayed section and remove `hidden` class from the section to display. But this means I need to track which section to display. That's done by adding this to the index.js:

```js
let currentDisplayedSection = "credentials";
```

The `toggleSPA()` function can then be streamlined to:

```js
const toggleSPA = (showme) => {
	document.getElementById(currentDisplayedSection).classList.add("hidden");
	document.getElementById(showme).classList.remove("hidden");
	currentDisplayedSection = showme;
};
```

## Removing Inline Style from Web Components

That leaves all the web components as the next place to remove inline style from. As a reminder, this is the landing.js web component:

```js
const template = document.createElement("template");
template.innerHTML = `
    <style>
        .landing-container {
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            justify-content: center;
        }
        .landing-tile {
            margin: 5px;
            font-weight: bold;
            font-size: 30px;
            color: light-dark(var(--primary-color-dark), var(--primary-color));
            background-image: radial-gradient(circle at center, light-dark(var(--landing-tile-start),var(--landing-tile-start-dark)) 15%, light-dark(var(--landing-tile-end),var(--landing-tile-end-dark)) 100%);
            height: 200px;
            width: 200px;
            box-shadow: inset 0 0 2px 2px light-dark(var(--border-color-primary),var(--border-color-primary-dark));
            border-radius: 10px;
            flex-grow: 1;
            text-align: center;
            align-content: center;
            cursor: pointer;
        }
    </style>
    <div id="landing-container" class="landing-container">
    </div>
`;
```

That style tag needs removing, because it adds inline style to the HTML. Fortunately, there's a great website that covers web components, webcomponents.guide, and it has a page and section covering [styling](https://webcomponents.guide/learn/components/styling/#how-to-include-default-styles-for-a-web-component). There are four options:

- `<style>` tag, which I'm trying to avoid.
- `<link rel-"stylesheet" />` using an external stylesheet.
- Constructable stylesheets.
- CSS Module scripts to load external stylesheets.

For this application, I'd prefer to avoid external stylesheets. External stylesheets have the benefit of better IDE support, which is well worth considering. But a single file makes it easy to copy and paste around. Many web components are packaged as npm modules, which lets dependency management avoid the problem. Some others use CDNs, which again hides the complexity of loading related files. But I'm not using Node.js or a CDN, so keeping everything self-contained seems a benefit. And the styles are not extensive in these web components and we're already coded as embedded in JavaScript, so **constructable stylesheets** are my preferred option here.

This is similar to the approach used for the HTML templates for the web components: we create a JavaScript object and insert the content. The syntax is different, but not hugely complex:

```js
const stylesheet = new CSSStyleSheet();
stylesheet.replaceSync(`
    .landing-container {
        display: flex;
        flex-wrap: wrap;
        align-items: stretch;
        justify-content: center;
    }
    .landing-tile {
        margin: 5px;
        font-weight: bold;
        font-size: 30px;
        color: light-dark(var(--primary-color-dark), var(--primary-color));
        background-image: radial-gradient(circle at center, light-dark(var(--landing-tile-start),var(--landing-tile-start-dark)) 15%, light-dark(var(--landing-tile-end),var(--landing-tile-end-dark)) 100%);
        height: 200px;
        width: 200px;
        box-shadow: inset 0 0 2px 2px light-dark(var(--border-color-primary),var(--border-color-primary-dark));
        border-radius: 10px;
        flex-grow: 1;
        text-align: center;
        align-content: center;
        cursor: pointer;
    }
`);
```

We create a new `CSSStyleSheet` and call its `replaceSync()` method applies the CSS. `replace()` is the async option, but we're only passing a few rules in. There are methods for adding rules dynamically, but I think this is more readable.

Finally, we need to apply the stylesheet to the web component. This is done in the constructor:

```js
this.root = this.attachShadow({ mode: "closed" });
this.root.adoptedStyleSheets = [stylesheet];
```

We pass `stylesheet` JavaScript CSSStyleSheet object to the array of adopted stylesheets.

There are still more inline styles to remove, but that will be the usual way: converting them to classes.

## All Solved?

Umm, no. This works for most of the components. But the Ship and Spot components didn't use a shadow DOM. And `.adoptedStyleSheets` can only be used on a Document or Shadow DOM; it can't be added to just an HTML element. So it won't work for the Ship and Spot components.

There are two options:

1. Move the inline styles to the main stylesheet.
2. Add a shadow DOM.

Option 1 feels wrong, because the inline styles are specific to this web component. But option 2 complicates things for two reasons. Firstly, the styles on the main stylesheets will no longer be available inside the web component. Secondly, we'll be inserting a shadow DOM, which means `this.querySelector()` and similar APIs will fail, because they now need to be applied to the component's shadow DOM, not the component itself.

But we can't just indiscriminately change everything that is `this.` because the shadow DOM only applies to DOM manipulation methods, not to calls to properties or methods of the web component itself. This is where understanding the code you're writing is critical. It would also have been simplified by setting `this.root = this;` when originally developing the application, for two reasons. Firstly, the syntax for DOM manipulation would have been identical across all web components. Secondly, we would only have had to change one line of code to insert a shadow DOM.

So there are three steps:

- Add a shadow DOM with `this.root = this.attachShadow({ mode: "open" });`.
- Add a stylesheet and add it to the shadow DOM, the same way we did for other components.
- Update every DOM manipulation call in Ship and Spot. So `this.querySelector` becomes `this.root.querySelector` and `this.appendChild` becomes `this.root.appendChild`. `.getElementById()` would be another example of an API we would need to change, if it had been used.

But now we need to get the styles from the main stylesheet in. We could include all stylesheet, but that gets messy. The only styles are for forms, so we'll create a separate stylesheet. Unfortunately the styles are also used on the login form, which was not a web component. So the stylesheet also needs adding to the index.html.

For the Ship and Spot, we can just add the stylesheets to the HTML for the Ship, in the same way we would for the index.html:

```html
<link href="../forms.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
```

Now it's just a case of going through and cleaning up all the inline CSS throughout the application.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. [Frameworks](./2024-08-24-framework-web-3.md)
1. [DRAPI](./2024-08-26-framework-web-4.md)
1. [Home Page](./2024-09-03-framework-web-5.md)
1. [Mocking, Fetch, DRAPI and CORS](./2024-09-16-framework-web-6.md)
1. [CSS](./2024-10-07-framework-web-7.md)
1. [Landing Page Web Component](./2024-10-21-framework-web-8.md)
1. [Services](./2024-10-23-framework-web-9.md)
1. [Ship Form Actions](./2024-10-30-framework-web-10.md)
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)
1. [Fields and Save](./2025-02-07-framework-web-14.md)
1. [Dialogs](./2025-02-08-framework-web-15.md)
1. [Spots](./2025-02-11-framework-web-16.md)
1. [Lessons Learned](./2025-04-02-framework-web-17.md)
1. **CSP Enhancement**
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)