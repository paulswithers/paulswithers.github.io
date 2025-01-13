---
slug: framework-web-12
date: 
  created: 2025-01-13
categories:
  - Web
tags: 
  - Web
  - Domino
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
  - blog/2024-10-23-framework-web-9.md
  - blog/2024-10-30-framework-web-10.md
  - blog/2024-12-14-framework-web-11.md
comments: true
---
# XPages App to Web App: Part Twelve - Ship Spot Component

In the last two parts we covered the ship form, but we didn't cover the HTML of the form. We'll cover that in the next part, but first we'll cover creating the class. As we do that, we'll see one of the big benefits that Web Components brings to JavaScript application development. Because here we'll start with the Ship Spot form, which not only captures data that will create or display a Ship but also creates a Spot - Location, Port From and Port To.

<!-- more -->

One of the powers of web components is that it gives you an HTML element that can be re-used across your application, with different configurations. And the initial approach I began with development of the Ship Spot form - adding another instance of the Ship form and adding a component for the Spot.

But after fighting with a few aspects, I quickly realised the *better* approach.

The Ship component is created as a JavaScript *class*. And in all languages classes can be *extended*. The right approach was the make the Spot class extend the Ship class instead of the usual HTMLElement class.

The syntax is simple and intuitive. For the Ship, it was:

``` js
export default class Ship extends HTMLElement {
```

For the Spot, it's:

```js
export default class Spot extends Ship {
```

This will be assigned to the HTML element name "spot-elem". This won't *include* a `<ship-elem>`. Instead it will include the HTML for the ship *and* additional HTML for spot fields.

## The Constructor

The constructor of the Ship class did a few things:

1. It created the component from the template. As a reminder, it did this so the component would exist before the `attributeChangedCallback` ran, so we could automatically call `updateButton()`.
1. If `showspots` attribute is true, it created a `spots-elem` element.
1. It added an eventHandler to the reset button.
1. It added a dialog for ship lines.
1. It added a dialog node for the ship options.
1. It modified element IDs if the `prefix` attribute was set.
1. It added event handlers to close the dialogs.
1. It initialised arrays for ship types, lines and flags.

As well as adding fields, the Ship Spot also needs to do a few other things:

1. It calls the `super()` method to run the constructor from the parent class.
1. It needs to add the prefix to the element IDs in the additional HTML.
1. It needs to initialise an array for ports.

We'll come back to the contents of the template and the dialogs in the next two parts.

## Element HTML

The HTML for searching for a ship was this:

``` html
<section class="ship" id="ship-search">
    <div class="actionDiv">
        <span id="ship-search-action" class="material-icons material-button md-32" title=""
        role="img" aria-label="" style="float:right"></span>
        <span id="ship-search-back" class="material-icons material-button md-32" title="Back"
        role="img" aria-label="Back" style="float:right">arrow_back</span>
        <h1>Find Ship</h1>
    </div>
    <form id="search-ship-form">
        <ship-elem actionbutton="Search" actionid="#ship-search-action"
            class="grid-container"></ship-elem>
    </form>
</section>
```

Initially, the HTML for the Ship Spot is this:

``` html
<section class="new-spot" id="new-spot">
    <div class="actionDiv">
        <span id="spot-search-action" class="material-icons material-button md-32" title="Search"
        role="img" aria-label="Search" style="float:right">search</span>
        <span id="spot-action" class="material-icons material-button md-32" title=""
        role="img" aria-label="" style="float:right"></span>
        <span id="spot-back" class="material-icons material-button md-32" title="Back"
        role="img" aria-label="Back" style="float:right">arrow_back</span>
        <h1>Spot</h1>
    </div>
    <form id="ship-spot-ship-form">
        <spot-elem actionbutton="Save" searchid="#spot-search-action" actionid="#spot-action" 
        class="grid-container" prefix="spot-" showspots="false"></spot-elem>
    </form>
</section>
```

We have some additional attributes set for the Ship Spot:

- prefix, because we want to modify the HTML IDs to ensure they're unique.
- showspots is set to false because we don't want to show spots for the ship. This is the only spot we want to show.
- searchid, the ID of the action button for searching.

On the ship form, searching was tied to the state of the "form" and the single button we re-used. If the user wanted to search, we made that button a search button; if a ship had been selected, we made it an edit button; if they were in edit mode, we made it a save button. But here, we want to search *and* save the spot. So we have a separate action button for searching.

But then we can't use the `actionbutton` attribute to add the eventHandlers. Instead, we do this in the `render()` method.

``` js
const actionButton = document.querySelector(this.searchid);
actionButton.addEventListener("click", this.doSearch);
const shipNameInput = this.querySelector(`#${this.prefix}ship-name`);
const callSignInput = this.querySelector(`#${this.prefix}ship-call-sign`);
shipNameInput.addEventListener("keydown", this.checkEnterDoSearch);
callSignInput.addEventListener("keydown", this.checkEnterDoSearch);
```

Mapping the search button's click event to `this.doSearch` will call the `doSearch()` method in the parent Ship class.

The eventHandler for saving the Spot will automatically get added in the Ship class by observing the `actionbutton` attribute, which is initialised to "Save". We just need to override the `doSave()` function in the Spot class to perform the specific functionality for saving a Ship Spot rather than just a Ship.

!!! note
    In the source code, you'll see I've also overridden the `updateButton()` function. But it looks like the only difference is that the `switch` statement doesn't include "Search" as an option. So I don't think I actually needed to override `updateButton()`.

But we also need to enable and disable additional fields. Again, this is pretty straightforward if we break it down into the steps:

``` js
enableDisable(disableType) {
    super.enableDisable(disableType);
    const disableFields = disableType === "all";
    this.querySelector(`#${this.prefix}spot-location`).disabled = disableFields;
    this.querySelector(`#${this.prefix}spot-port-from`).disabled = disableFields;
    this.querySelector(`#${this.prefix}spot-port-to`).disabled = disableFields;
}
```

We call the parent method. Here we're either disabling fields or not, depending on whether the disableType is "all". So we just set `disabled` to true or false.

## Wrap Up

In the next part we'll cover the HTML for the Ship and Spot, as well as validation.

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
1. **Ship Spot Form**