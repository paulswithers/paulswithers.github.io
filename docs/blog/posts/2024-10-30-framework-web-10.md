---
slug: framework-web-10
date: 
  created: 2024-10-30
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
  - blog/2024-12-14-framework-web-11.md
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
  - blog/2025-02-07-framework-web-14.md
  - blog/2025-02-08-framework-web-15.md
comments: true
---
# XPages App to Web App: Part Ten - Ship Form Actions

In the last two parts we created our first web component and converted the login function into services we could use for all data interactions, the first use being to load data for any select controls in the application. Now it's time to create the ship form.

<!-- more -->

This will also be built as a web component. This may seem a case of using something new just for the sake of it. But it keeps all the code for our ship self-contained in a single JavaScript file, which I'm sure will make it easier to support later on - after all, knowing quickly where to find the relevant code is key to quickly supporting an application. And we'll also see some big advantages of this choice later on.

## Component Declaration and HTML

Again, we'll declare the class with `export default class Ship extends HTMLElement` and add its custom element definition with `customElements.define("ship-elem", Ship);`.

For a start the HTML will be this:

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
        <ship-elem showspots="true" actionbutton="Search" actionid="#ship-search-action"
            class="grid-container"></ship-elem>
    </form>
</section>
```

Again, we'll add an event listener on the Back button in the bootstrap function. But this won't be the last Back button in our application. So I'm going to reuse the function my friend Stephan Wissel had for our session at [Engage 2024](https://github.com/Stwissel/super-procode-mode/blob/main/samples/webcomponent/public/index.js#L126). This allows us to pass an HTML element ID and a function to perform. This allows us to do:

``` js
captureClickEvent("ship-search-back", (event) => {
    toggleSPA("landing", "block");
});
```

## Reusable Action Button

But you'll notice there's another action button here. But it's got no title or aria-label, and we're not going to add an event handler to it in the bootstrap function. Why not? Typically in a Notes Client or XPages application, we add action buttons for all actions, hiding or showing each as required. We have three specific functions - search, edit, and save. But we will only need one at any time. So rather than add all buttons and set the display property on them at an appropriate time, we're going to have a single button and give it the relevant title, icon and event handler as appropriate. And we're going to use an additional piece of functionality in web components and an additional piece of functionality in event handlers too.

In the constructor, there will be two differences from the landing web component. The first is we will not attach a shadow DOM, we'll just clone the template node and add it directly to this component. The reason is one I mentioned when covering the landing component, that the shadow DOM creates a barrier to CSS. There are ways to pass a stylesheet in without reloading it. But we don't need to force a specific CSS on our forms, so it's easier to just *not* attach a shadow DOM.

This means there's a significant difference between how we access the elements added to the DOM. When there's a shadow root, we need to do `this.root.getElementById()` and `this.root.querySelector()` to access anything, because the shadow DOM creates a barrier. But without the shadow DOM, we need to do `this.getElementById()` and `this.querySelector()`.

The second difference is that we'll create the component from the template in the constructor. Some may consider it better practice to *not* create the component in the constructor, but only after the web component is connected to the DOM. And if you're programmatically adding a component, this allows you to lazy load the HTML. But we will *always* want the component on the page and it's a small application, so there's no real impact on the "Time to Interactive". But this choice gives us a big benefit: the component will be created before attributes are observed and we want to leverage that functionality to manipulate our reusable button.

## Observing Attributes

We will add four key attributes. The first is **prefix**, because we're going to be setting HTML element IDs but we'll also need the ship form when creating a spot, where we will select a ship that we've spotted. And browsers don't like it when you add two or more elements with the same ID. Having a "prefix" attribute allows us to modify the IDs of all elements inside the web component in a logical way that our code can still find the relevant HTML element. We'll add  **showspots** to determine whether or not to display spots for the relevant ship, because we won't want to do this when we're creating a spot. And we'll add **actionid** with the ID of the reusable action button we want to manipulate and **actionbutton** for which button to show by default.

Remember the two key points for attributes:

- they're always lower case.
- the values are always strings.

This means when we're checking if `showspots` is set, we'll need to do `this.showspots === "true"`. To avoid needing to set it when we don't want it, we'll also make the getter optionally return false:

``` js
get showspots() {
    return this.getAttribute("showspots") || false;
}
```

We want to update the action button at certain points in the lifecycle. We could just run a function every time. But web components have a different way, **observed attributes**. This allows you to run code if a certain attribute changes. The attributes to watch for changes on are observed through a static getter with an array of attribute names:

``` js
static get observedAttributes() {
    return ["actionbutton"];
}
```

This registers the attributes to watch for, but the second part is running the code when they change. This is done in another standard lifecycle callback, **attributeChangedCallback**. This takes three parameters, the **name** of the attribute being changed, its **old value** and its **new value**. Typically a switch statement will control the logic:

``` js
attributeChangedCallback(name, oldValue, newValue) {
    switch (name) {
        case "actionbutton":
            if (this.defaultActionButton === "") this.defaultActionButton = newValue;
            this.updateButton();
            break;
    }
}
```

Here we're putting the first button action type in a `defaultActionButton` variable, so we know the action to set when we reset the form. Then we call the `updateButton()` function.

If we were rendering the component in a `render()` function from the `connectedCallback()` like we did for the landing component, we would need to manually call the `updateButton()` function at the end of the `render()` to trigger it. But because we're rendering the component in the constructor, we can let the `attributeChangedCallback` run it for us. Of course there are times when that would *not* be what you want. But in this scenario, it's exactly what we want.

## UpdateButton

The first thing we're going to do is clone the HTML and replace the node.

``` js
const actionButton = document.querySelector(this.actionid);
const newActionButton = actionButton.cloneNode(true);
actionButton.parentNode.replaceChild(newActionButton, actionButton);
```

This may seem strange, but there's a challenge we have to overcome. The button will have an event listener registered. And there's not an API to remove all event listeners. You need to remove an event listener *by type and listener function*. That can get fiddly. But cloning the node and replacing it removes all event listeners. Obviously that could cause problems if another developer is adding an event listener from somewhere else, suddenly their event listener gets removed and they need to handle that. But we don't have to worry about that here.

As mentioned, we're going to have three states - search, edit, and save. If the button says "Search", we'll only enable ship name and call sign and add event listeners on those fields to perform a search if the user presses enter. If the buttons says "Edit", the document is in "read mode" so we'll disable all the fields and we won't need the search event listeners. If the button says "Save", the document is in edit mode so we'll enable all fields. We'll want the ability to search for a ship. But we'll also want to add an event listener on a help icon to show shipping lines that own ships, because a new shipping line may need adding, but we want to select an pre-existing one.

This makes the code pretty straightforward:

``` js
updateButton() {
    const actionButton = document.querySelector(this.actionid);
    const newActionButton = actionButton.cloneNode(true);
    actionButton.parentNode.replaceChild(newActionButton, actionButton);
    const shipNameInput = this.querySelector(`#${this.prefix}ship-name`);
    const callSignInput = this.querySelector(`#${this.prefix}ship-call-sign`);
    const linesHelp = this.querySelector(`#${this.prefix}ship-lines-help`);
    switch(this.getAttribute("actionbutton")) {
        case "Search":
            this.enableDisable("search");
            newActionButton.title="Search";
            newActionButton.ariaLabel = "Search";
            newActionButton.innerText = "search";
            newActionButton.addEventListener("click", this.doSearch);
            shipNameInput.addEventListener("keydown", this.checkEnterDoSearch);
            callSignInput.addEventListener("keydown", this.checkEnterDoSearch);
            try {
                linesHelp.removeEventListener("click", this.showLinesHelpDialog);
            } catch (error) {
                // No eventlistener, no action
            }
            break;
        case "Edit":
            this.enableDisable("all");
            newActionButton.title = "Edit";
            newActionButton.ariaLabel = "Edit";
            newActionButton.innerText = "edit";
            newActionButton.addEventListener("click", this.doEdit, {once: true});
            try {
                shipNameInput.removeEventListener("keydown", this.checkEnterDoSearch);
                callSignInput.removeEventListener("keydown", this.checkEnterDoSearch);
                linesHelp.removeEventListener("click", this.showLinesHelpDialog);
            } catch (error) {
                // No eventlistener, no action
            }
            break;
        case "Save":
            this.enableDisable("none");
            newActionButton.title = "Save";
            newActionButton.ariaLabel = "Save";
            newActionButton.innerText = "save";
            newActionButton.addEventListener("click", this.doSave, {once: true});
            try {
                shipNameInput.addEventListener("keydown", this.checkEnterDoSearch);
                callSignInput.addEventListener("keydown", this.checkEnterDoSearch);
                linesHelp.addEventListener("click", this.showLinesHelpDialog);
                this.lines = this.lines;
            } catch (error) {
                // No eventlistener, no action
            }
    }
}
```

Comparing when we're adding the event listeners to the `newActionButton` there is a difference. For "Edit" and "Save" we pass a third argument, a JSON object. These are the **options**. There are a number of [options](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener#options) that can be passed, but the one we're passing here is `once`. This means the event handler is triggered once and then removed. If this is added, the button *cannot* be clicked twice. That makes sense for Edit and Save buttons. Obviously, we don't want that for Search though.

This makes the `doEdit` and `doSave` functions quite simple. We don't need to call `updateButton()`, we just need to change the attribute, and the `attributeChangedCallback()` handles updating the button HTML and adding event listeners:

``` js
doEdit = () => {
    this.setAttribute("actionbutton", "Save");
}
```

## Wrap Up

There's still more to do on the ship form, like the search and the save. But that's for another part.

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
1. **Ship Form Actions**
1. [Ship Search and Save](./2024-12-14-framework-web-11.md)
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)
1. [Fields and Save](./2025-02-07-framework-web-14.md)
1. [Dialogs](./2025-02-08-framework-web-15.md)