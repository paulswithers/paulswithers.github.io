---
slug: framework-web-8
date: 
  created: 2024-10-21
categories:
  - Web
tags: 
  - Domino
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
  - blog/2024-10-23-framework-web-9.md
  - blog/2024-10-30-framework-web-10.md
  - blog/2024-12-14-framework-web-11.md
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
  - blog/2025-02-07-framework-web-14.md
  - blog/2025-02-08-framework-web-15.md
  - blog/2025-02-11-framework-web-16.md
comments: true
---
# XPages App to Web App: Part Eight - Landing Page Web Component

We've got a login page, we've got theming, we're handling light mode and dark mode. Now we're ready to start adding our landing page.

<!-- more -->

But this application is almost exclusively going to be used from a mobile device, doesn't have a need to show specific data from the database after login, doesn't have a user requirement to navigate directly from one page to another. In addition, this is a single page application, with all HTML, CSS and JS already deployed to the browser before the user logs in. So whereas a server-side rendered application, like XPages, would need to request HTML from the server for every page being rendered, this application's switching of pages will be completely client-side, so zero performance hit. All of this combines to make the better choice for the user experience a landing page with tiles for each subsequent page we want users to select from.

We want to make this scalable within the application, being able to easily add new tiles in the future. But we may also want to reuse it in other applications in the future. The other important point is that the CSS is not likely to be something we want to use elsewhere in the application. These are three key aspects that our implementation will leverage.

## XPages Comparisons

In XPages, a developer may instinctively use an `xe:navigator` control with tree nodes for each of the pages. This is a direct analogy for the Outline control in Notes Client / Nomad development. So it's a familiar paradigm and in use in some web applications beyond XPages.

But if they were to resist muscle memory and choose a navigation option like we have here, there would be two options.

The first would be a **custom control**, a reusable component that could be copied into another page and potentially configured by passing properties into it. The alternative would be binding to a property on a viewScoped bean or controller. But this actually makes it harder to reuse across other applications, because the developer who wants to reuse it *also* needs to use a viewScoped bean or controller and needs to add the same property with the same name. And the custom control may bind to other business logic or property binding that also needs to be reproduced, without cleanly being scoped to the custom control. Don't get me wrong, I've probably done that and put the logic in a base Java class extended by each page. But it undermines the self-contained intention of a custom control, so it's arguably not best practice.

The second option, possibly even within the custom control, would be a **repeat control**. This allows the developer to set the layout and style for each tile and pass a collection in, which may be a collection of custom Java objects. This means if you want to add another tile, you just need to add to the collection. It also makes it easier to reuse - you just change the collection you're passing into the repeat control. However, developers *should* avoid setting styling directly on each tile, so developers typically put the styling in an application-wide stylesheet, separate from the component.

## The Modern Web Way

If you use a framework like React, Vue, or EmberJS, you're used to the solution to this - components. For some years now the same approach has also been available in standard Web APIs in [**Web Components**](https://developer.mozilla.org/en-US/docs/Web/API/Web_components). Some of the frameworks can already package their components as native Web Components, and this has been done for many years by the Java framework [Vaadin](https://github.com/vaadin/web-components) - and I've been a big fan of Vaadin for many years, it's well worth considering if XPages developers wish to choose a different framework but still use Java. But [some framework developers](https://discuss.emberjs.com/t/web-component-support/14880/2) see web components as still somewhat deficient to the framework components. And I can understand the problem here. I've included a web component in EmberJS and although it works, it cannot easily interact with the rest of the EmberJS framework like services and its lifecycle may not correspond neatly to the framework's lifecycle. Integrating the two requires a good understanding of both web components and the framework, which is not impossible, but requires a certain type of developer.

But this is not a framework application. It's standard HTML, JS and CSS. So web components are a good choice.

### Custom Element

A web component comprises two parts, a JavaScript class and a mapping to an HTML tag.

As with a Custom Control or a Repeat Control, and as with React components, a web component is a custom HTML element. Just as those two extend a Java class, so the web component is a JavaScript class. Those developers who just use declarative HTML may not realise that the HTML DOM API provides a [JavaScript interface](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement), `HTMLElement`, which is the base for all HTML elements. It is this JavaScript class or another implementation that a web component class will extend. For the Landing class, we just need to extend HTMLElement. Because usually each web component is in its own JavaScript file, the code for the class will export the class too. So the code is:

``` js
export default class Landing extends HTMLElement {
    ...
}
```

The second part is the mapping to an HTML tag. In XPages too, the class maps to a tag, in this case an XML tag. For a Custom Control, the tag `xc:....` and the design element name camel-cased. For a Repeat Control, it's `xp:repeat`. For web components we use `customElements.define()`, which takes two arguments - the HTML tag name to use and the class it corresponds to. So the code we need at the end of our class is `customElements.define("landing-elem", Landing);`.

This means in an HTML file, we can import the JavaScript file as a module and use the HTML tag.

``` html
<head>
    <script type="module" src="/scripts/landing.js"></script>
</head>
<body>
    ...
    <section class="landing" id="landing">
        <landing-elem></landing-elem>
    </section>
</body>
```

### Template

As with a Custom Control or a Repeat Control, and as with React components, one of the key parts of a web component is the HTML. This could be built up programmatically in JavaScript using DOM APIs. But the easier option - one familiar to XPages or React developers - will be to create an HTML fragment. This is done with the tag `<template>`, which means it's available for programmatic access but not rendered on the web page.

This could be put on the HTML page, in a similar way to how EmberJS uses Handlebars templates corresponding to the JavaScript class. But to keep a web component self-contained, it makes more sense to follow the approach of React and add it into the JavaScript file, but using the JavaScript DOM APIs, `createElement()` and the `innerHTML` property.

``` js
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

### The Shadow DOM

The obvious thing that will stand out here is the inclusion of the `<style>` tag to add inline CSS. This may initially feel like bad practice. Shouldn't the styling be in the application's stylesheet? The answer in this scenario is no, for two reasons.

Firstly, one of the reasons for a web component is reusability. Although you may have the same stylesheet everywhere, there will always be the scenario where you realise you're missing something, make a change to the CSS in a particular application and then spend ages trying to work out why it's not appearing as you expect elsewhere. Adding the style in the template means the relevant styling is packaged with the web component.

But web components can also be [published to the web component community](https://www.webcomponents.org/) for use by any developers. And if you want the web component to be reusable, you need to package your styling with the component.

yAnd in both cases you will probably want to avoid CSS bleeding through from the rest of the application and messing up the look and feel of the web component. In this particular scenario, we only need the CSS here and we're only using the component once in our application, so there's no real benefit in putting the CSS in our core spreadsheet. And we don't need to manipulate the contents of the web component from outside. So we can take advantage of the **shadow DOM**, which solves all these problems, and we can do so in the JavaScript class's constructor.

``` js
constructor() {
    super();
    this.root = this.attachShadow({ mode: "closed" });
    let clone = template.content.cloneNode(true);
    this.root.append(clone);
    this.connected = false;
}
```

`this.attachShadow()` adds the shadow DOM and we need to be able to access it in the future. So we store it in the `root` property of the class. There are two shadow DOM modes, "open" and "closed". When set to "open", JavaScript can still reach into the web component's DOM, but by `getElementById().shadowRoot`. When set to "closed", JavaScript cannot access anything in the web component. We don't need to access the contents of this component from outside, so we've set it to "closed".

### Attributes

We will use this because we want the component to be reusable, so we don't want to define the tiles for the landing page inside the web component. To do this we'll define it as an **attribute** of the web component.  Like any other HTML element attributes - `style`, `value`, `class`, `required` etc - these can be declaratively defined in the HTML or programmatically.

But there's a complication here: attributes are *always* **strings**. But our tiles need to be more complex than a single string value. There's another important point to make: attributes are *always* **lower case**. The content will be a JavaScript object:

``` js
const allTiles=[
    {id: "new-spot", label: "New Spot", "focus": "spot-ship-name"},
    {id: "spot-search", label: "Find Spot", "focus": ""},
    {id: "ship-search", label: "Find Ship", "focus": "ship-name"},
    {id: "trips", label: "Trips", "focus": ""}
];
```

That's messy to pass in declarative HTML. We'll see where that's used in the future. But for this component we're going to create the element programmatically.

``` js
const landing = document.querySelector("#landing");
const landingContainer = document.createElement("landing-elem");
landingContainer.allTiles = JSON.stringify(allTiles);
landing.append(landingContainer);
toggleSPA("landing", "block");
```

`JSON.stringify()` and `JSON.parse()` are our friends here. As with classes in other languages, we can define getters and setters to interact with the properties. In this scenario, we could just use the getters and setters, but best practice is to map to attributes, so that's what we'll do here. This code is in our JavaScript class:

``` js
get allTiles() {
    return JSON.parse(this.getAttribute("allTiles"));
}

set allTiles(value) {
    this.setAttribute("allTiles", value);
}
```

Yes, `get` and `set` are valid JavaScript, because we're in a **class inside a JavaScript file**, not just in the JavaScript file. Now we just need to use it.

### Web Component Lifecycle and Rendering the Component

You will notice in the constructor that we set `this.connected` to false. In the context of a web component, "connected" means connected to the DOM. Until the component is connected to the DOM, code cannot access any of its attributes. So you want to delay code. But the good news is that web components provide [callback functions for various parts of the lifecycle](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements#custom_element_lifecycle_callbacks). At this point we'll just use one lifecycle event, `connectedCallback()`, which is fired when the component has been connected to the DOM.

The code for our `connectedCallback` is:

``` js
connectedCallback() {
    console.log("landing connected");
    this.render();
    this.connected = true;
}
```

We could just render the component here, but for clarity and convention from elsewhere, we'll use a `render()` function.

``` js
render() {
    console.log("Creating tiles");

    const landing_container = this.root.getElementById("landing-container");
    this.allTiles.forEach(element => {
        const tile = document.createElement("div");
        tile.id = `tile-${element.id}`;
        tile.className = "landing-tile";
        const span = document.createElement("p");
        span.className = "landing-anchor";
        span.innerHTML = element.label;
        tile.appendChild(span);
        tile.addEventListener("click", (event) => {
            console.log("Firing event for " + element.id);
            event.preventDefault();
            this.fireClickEvent(element.id, element.focus);
        })
        landing_container.appendChild(tile);
    });
}
```

Remember that we added a shadow DOM and we need to query its DOM through that, through `this.root` which was set in the constructor. Then we create a div for each tile and add an event listener. We saw in [part three](./2024-08-24-framework-web-3.md) that event listeners are the modern approach. For ease, we call a function that we store in a property of the class.

### Custom Events

When we click on the tile, we want to change the view of the SPA, which we've coded in index.js as `toggleSPA`. That's fine in this application, but what about if we have a more complex application that isn't built as a Single Page Application? Or what if the web component is being published for wider use, we wouldn't want to require the developer to add a function with a specific name.

This is where [CustomEvents](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent) come in. Custom events allow you to trigger events with a specific name, which code can then listen for and map to a named function. They can also pass content across. `fireClickEvent` creates and triggers a CustomEvent.

``` js
fireClickEvent = (sectionId, focusField) => {
    const event = new CustomEvent("changeView", {
        bubbles: true,
        detail: {
            viewName: sectionId,
            focusField: focusField,
            style: "block"
        }
    })
    this.dispatchEvent(event);
}
```

We create a new CustomEvent with the name "changeView" and passes a JavaScript object of options. `bubbles` means that the event bubbles up out of the web component up the DOM tree. The `detail` property allows us to pass information for the event listener to use, in this case the ID of the section to display, the field to pass focus to, and the display style we wish to apply to the section.

After creating the CustomEvent, we then need to trigger the event, which is done via `this.dispatchEvent()`.

This is one side of the event, but we need to *receive* the event. This is done with an event listener, registered from the `bootstrap()` function of our application with this code: `document.addEventListener("changeView", changeView);`.

This maps to a function stored in a constant:

``` js
const changeView = (event) => {
	toggleSPA(event.detail.viewName, event.detail.style);
	if (event.detail.focusField != "") {
		const page = document.getElementById(event.detail.viewName);
		const field = page.querySelector(`#${event.detail.focusField}`);
		if (field) field.focus();
	}
}
```

You'll see this function takes the event - a CustomEvent object - that we dispatched. We can access the properties we defined in the `detail` JavaScript object to toggle display of the various sections and put focus in the relevant field.

## Wrap Up

Web components will be the core of the application we're building. We will do some things differently and use other lifecycle events throughout the rest of the application. And custom events will be the basis of passing functionality around. But this is the basis of the other "pages" in the application.

Web components are becoming a key aspect of modern web development and well worth getting to grips with. Many are built as NodeJS components, which make it less straightforward to integrate into an application like this, unless you use a tool like [Vite](https://vite.dev/) to build your web application. And that is well worth looking at, particularly if you want to use TypeScript, instant server start and easy optimized build.

But you can still integrate web components into other frameworks, as I've done recently with an EmberJS application.

So could you integrate web components into XPages? It's probably not straightforward because of the conflict of server-side and client-side processing. Web components work client-side and manage their properties in the client-side against the DOM HTML element. However, an XPages partial refresh will replace **all** HTML for its refresh area. This means it will nuke the web component that was there prior to the partial refresh and replace it with a *new* version of the web component. And that's probably not what you would want with XPages, or any other framework that replaces HTML in the DOM. But if you fully understand XPages, there may be places where it does make sense, places where you just want to handle everything client-side. Or there could be scenarios where you could pass the current component and its attributes to the server side of XPages and generate new HTML with updated attributes.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. [Frameworks](./2024-08-24-framework-web-3.md)
1. [DRAPI](./2024-08-26-framework-web-4.md)
1. [Home Page](./2024-09-03-framework-web-5.md)
1. [Mocking, Fetch, DRAPI and CORS](./2024-09-16-framework-web-6.md)
1. [CSS](./2024-10-07-framework-web-7.md)
1. **Landing Page Web Component**
1. [Services](./2024-10-23-framework-web-9.md)
1. [Ship Form Actions](./2024-10-30-framework-web-10.md)
1. [Ship Search and Save](./2024-12-14-framework-web-11.md)
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)
1. [Fields and Save](./2025-02-07-framework-web-14.md)
1. [Dialogs](./2025-02-08-framework-web-15.md)
1. [Spots](./2025-02-11-framework-web-16.md)