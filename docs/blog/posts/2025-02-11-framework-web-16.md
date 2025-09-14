---
slug: framework-web-16
date: 2025-02-11
categories:
  - Web
tags: 
  - Web
  - Domino
  - HTML
  - CSS
  - JavaScript
comments: true
---
# XPages App to Web App: Part Sixteen: Spots

Now that we've set up the CRUD pages for ships and spots, it's time to put them together. When we search a ship, we'll want to be able to see the spots created for that ship. Now let's set that up.

<!-- more -->

We laid the groundwork for this back in [part ten](./2024-10-30-framework-web-10.md) when we added a `showspots` attribute on the Ship component. This allowed us to determine whether to show spots (when looking at just a ship) or not (when looking at or editing a ship spot).

## Ship Form Amendments

In the constructor, we add this code:

``` js
if (this.showspots === "true") {
    const spotsElem = document.createElement("spots-elem");
    spotsElem.style = "grid-column: 1 / -1;"
    this.appendChild(spotsElem);
}
```

This adds a `spots-elem` HTML element (no prizes for guessing this will be a web component we'll create), and set it to show full width in the table by making it span from the first grid-column to the last (-1).

This handles the display. But when loading the spots we need to consider the lifecycle of the ship form.

``` mermaid
flowchart RL
A([Find Ship]) --> B([Search])
B --> C([Select Ship])
C --> D([Load Ship])
D --> E([Load Spots])
E --> F{Search Again?}
F -- Yes --> B
F -- No --> G([Reset])
G --> H([Clear Spots])
```

Both search and reset call the `populateShip` function to load the ship details. So we can extend this function to clear them. The `populateShip` function takes a JSON object that is the selected ship, or null.

``` js
populateShip(shipObj) {
    if (shipObj) {
        ...
        if (this.showspots) {
            this.dispatchEvent(new CustomEvent("loadSpots", { bubbles: true, detail: {shipElem: this, shipunid: shipObj["@meta"].unid}}));
        }
    } else {
        ...
        if (this.showspots) {
            this.dispatchEvent(new CustomEvent("clearSpots", { bubbles: true, detail: {shipElem: this}}));
        }
    }
}
```

## Loading Spots

The two functions corresponding to the custom events are pretty similar, so I'll show the code for both:

``` js
const loadSpots = async (event) => {
	const shipElem = event.detail.shipElem;
	const spotsObjs = shipElem.getElementsByTagName("spots-elem");
	if (spotsObjs.length === 1) {
		const spotsObj = spotsObjs[0];
		const json = await window.dataService.getSpotsForShip(event.detail.shipunid);
		spotsObj.populateSpots(json);
	}
}

const clearSpots = (event) => {
	const shipElem = event.detail.shipElem;
	const spotsObjs = shipElem.getElementsByTagName("spots-elem");
	if (spotsObjs.length === 1) {
		const spotsObj = spotsObjs[0];
		spotsObj.populateSpots("");
	}
}
```

In both cases the web component for the ship was passed, which allows us to query its inner HTML to find the corresponding `spots-elem` HTML element added in the constructor. It should exist and there should only ever be one, but we do the check anyway. If we're loading spots, we do an async call for spots for the ship, which was also passed into the event, which will return an array containing 0..n elements. For clearing spots, we pass an empty string.

## Spots Web Component

Let's just quickly cover the Spots web component, which is in a script file called [spotsObj.js](https://github.com/paulswithers/shipspotter/blob/main/webapp/scripts/spotsObj.js){target="_blank"}. The basics for the element are quite basic:

``` js
export default class Spots extends HTMLElement {
    /**
     * Construct and render
     */

    dateOptions = {
        dateStyle: 'full',
        timeStyle: 'long',
    };

    constructor() {
        super();
        this.root = this.attachShadow({ mode: "closed" });
        this.connected = false;
    }

    connectedCallback() {
        console.log("landing connected");
        this.render();
        this.connected = true;
    }

    render() {
        console.log("Loading spots");
        const clone = template.content.cloneNode(true);
        this.root.append(clone);
    }

}
```

You should be familiar with this by now and there are just two things to comment upon. The first is we use a shadow DOM set to closed. This prevents JavaScript outside the web component from accessing the HTML nodes within the shadow root: we don't need to, we'll be manipulating the HTML with functions of the component itself. The second point of note is a JSON object `dateOptions`, which we'll come back to.

The HTML template for the component is:

``` html
const template = document.createElement("template");
template.innerHTML = `
    <style>
        .spots-container {
            margin-top: 5px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            column-gap: 5px;
            row-gap: 5px;
        }
        .spotsCell {
            font-size: 16px;
            padding: 5px;
            flex-grow: 1;
            border: 1px solid var(--border-color-primary);
            border-radius: 5px;
            box-shadow: 1px 2px var(--border-color-primary);
        }
    </style>
    <div id="spots-container" class="spots-container">
    </div>
`;
```

This is some styling and a container div, which will display with CSS Grid, 5 pixels gap between the cells and auto-filling the space with a minimum of 200px width. Each "cell" in the grid will be the same size (`flex-grow: 1`) with some colours loaded from the external CSS. We don't have a template for the contents of a cell, they will be created programmatically.

## Populating Spots

The web component also needs a `populateSpots()` function that is called from the index.js functions:

``` js
populateSpots(value) {
    const spots_container = this.root.getElementById("spots-container");
    spots_container.innerHTML = "";
    if (!value || value.length === 0) {
        const p = document.createElement("p");
        p.innerHTML = "No spots found";
        spots_container.appendChild(p)
    } else {
        ...
    }
}
```

We'll come back to the contents of the else block shortly. We start by clearing any HTML previously in the `spots-container` div. Then, if a blank string or empty array was passed, we add a message saying "No spots found". Otherwise it will be an array of JSON objects like:

```json
{
    "ShipUNID": "BAD429566D90A8AB86258751007006F4",
    "Created": "2024-08-10T06:20:36-06:00",
    "Location": "Southampton",
    "PortFrom": "Southampton",
    "PortTo": "Cowes"
}
```

### Date Handling

When it comes to dates, [Moment.js](https://momentjs.com/) has become a go-to library to load and manipulate dates. However, for many applications it may be overkill and Moment.js themselves [highlight this](https://momentjs.com/docs/#/-project-status/), stating "Moment.js was built for the previous era of the JavaScript ecosystem", noting that Chrome Dev Tools shows recommendations for replacing Moment.js and themselves pointing to a number of posts about alternatives. In our case, we just want to format an ISO date, and JavaScript has a spec for this, [ECMA 402](https://ecma-international.org/publications-and-standards/standards/ecma-402/). For dates, the part we need is [**Intl.DateTimeFormat**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat), which has been baseline since 2017.

The code we'll use is simple:

```js
const localDate = Intl.DateTimeFormat("en-GB", this.dateOptions).format(spot.Created);
```

The constructor for `Intl.DateTimeFormat()` can take up to two arguments, a locale and options. As I've said on numerous occasions, I'm the only user of this application which means "en-GB" locale is the only one I'm interested in. The other argument is the web component's `dateOptions` property we added when we created the web component, a JSON object containing two properties: `dateStyle="full"` and `timeStyle="long"`. This returns a value like "Wednesday 27 November 2024 at 15:41:08 GMT". There are a [wide variety of options available](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat#locale_options).

!!! note
    If you need a variety of locales, you'll need to do research on how to get the "right" locale. To give you an idea of the complexity involved in a "default" locale, I recommend looking at a few GitHub issues from the discussions about the specification:

    - https://github.com/tc39/proposal-intl-locale/issues/15
    - https://github.com/tc39/proposal-intl-locale/issues/84
    - https://github.com/tc39/ecma402/issues/68
    - https://github.com/tc39/ecma402/issues/883

### Loading the Spot HTML

The else block is:

``` js
value.forEach((spot, index) => {
    const div = document.createElement("div");
    div.id = `spot-div-${index}`;
    div.classList.add("spotsCell");
    spots_container.appendChild(div);
    const createdDate = new Date(spot.Created);
    const localDate = Intl.DateTimeFormat("en-GB", this.dateOptions).format(createdDate);
    const created = document.createElement("p");
    created.id = `spots-created-${index}`;
    created.innerHTML = `Created: ${localDate}`;
    div.appendChild(created);
    const details = document.createElement("p");
    this.createDetails(details, index, spot)
    div.appendChild(details);
});
```

We loop through the spots and, for each, create a div with a unique ID. In that div, we add a paragraph for the created date/time and the details. The details varies depending if port details are known, so for simplicity I moved it into its own function:

``` js
createDetails(details, index, spot) {
    details.id = `spots-details-${index}`;
    if (spot.PortFrom != "" && spot.PortTo != "") {
        details.innerHTML = `From ${spot.PortFrom} to ${spot.PortTo}`;
    } else if (spot.PortFrom != "") {
        details.innerHTML = `From ${spot.PortFrom}, destination port not known`;
    } else if (spot.PortTo != "") {
        details.innerHTML = `Going to ${spot.PortTo}, origin port not known`;
    }
}
```

If we have both from and to ports, we list them. If we are missing from or to port, we give an appropriate message.

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
1. [Ship Search and Save](./2024-12-14-framework-web-11.md)
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)
1. [Fields and Save](./2025-02-07-framework-web-14.md)
1. [Dialogs](./2025-02-08-framework-web-15.md)
1. **Spots**
1. [Lessons Learned](./2025-04-02-framework-web-17.md)
1. [CSP Enhancement](./2025-04-19-framework-web-18.md)
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)
1. [Custom CSP Settings](./2025-09-14-framework-web-20.md)