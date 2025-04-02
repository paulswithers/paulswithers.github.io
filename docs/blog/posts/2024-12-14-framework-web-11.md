---
slug: framework-web-11
date: 
  created: 2024-12-14
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
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
  - blog/2025-02-07-framework-web-14.md
  - blog/2025-02-08-framework-web-15.md
  - blog/2025-02-11-framework-web-16.md
  - blog/2025-04-02-framework-web-17.md
comments: true
---
# XPages App to Web App: Part Eleven - Ship Search and Save

The last part focused on using `observedAttributes()` to switch what the main action button did, depending on the current document state. In this part we'll cover the functionality behind the search button and the save.

<!-- more -->

## How It Used To Work

As mentioned in the previous part, this ship component will also be used for ship details when logging spotting a ship. On the previous XPages application, finding a ship was done using a Value Picker, which used a list of ship names with a "starts with" search. This resulted in two problems.

Firstly, the Value Picker performs a partial refresh to load the options. One a number of occasions the request for this timed out - the perils of seaside locations!

Occasionally - I think a couple of occasions over the three years of use - a ship changed ownership and name. Since using the new application I've found a couple more occasions where two different Ship documents were created under slightly different names. This is a risk of using a picker, and one we can improve on.

The new approach will address both.

## Logical Flow

The problem with the picker is that it allows only one way to find the required ship. In Notes Client development, the usual approach to address this problem is a pick list (`NotesUIWorkspace.PickListCollection()` or `NotesUIWorkspace.PickListStrings()`). But this still places the onus on the end user to find the match and select it correctly.

Instead, we'll build a search. We created a JSON array of all ships when the user first logs in. The JSON array can be filtered to find the results.

``` mermaid
flowchart TD
A([Start]) --> B(Get ship name and call sign entered)
B --> C{Call sign blank?}
C -- Yes --> D(Filter on call sign)
D --> F(Check results)
C -- No --> E(Filter on name)
E --> F
F --> G{Results?}
G -- No --> H(Message user: no ships matching criteria)
H --> Z([End])
G -- Yes --> J{Single match?}
J -- Yes --> K(Populate ship)
K --> Z
J -- No --> L(Show dialog of matches)
L --> Z
```

## The Code

The code for the first part is pretty straightforward:

``` js
this.shipOptions = [];
const shipName = this.querySelector(`#${this.prefix}ship-name`).value;
const pattern = new RegExp(shipName.toLowerCase());
const callSign = this.querySelector(`#${this.prefix}ship-call-sign`).value;
const results = this.ships.filter(obj => (callsign != "") ? obj.CallSign === callSign : pattern.test(obj.Ship.toLowerCase()));
if (results.length === 0) {
    this.dispatchEvent(new CustomEvent("sendUserMessage", { bubbles: true, detail: {type: "error", message: "No ships found matching criteria"}}));
} else {
    if (results.length === 1) {
        this.populateShip(results[0]);
        this.setAttribute("search", false);
        this.setAttribute("actionbutton", (this.prefix === "") ? "Edit" : "Save");
    } else {
        this.shipOptions = results;
```

First we clear the array of ships matching the criteria. Then we get the ship name and call sign.Then we filter the ships JSON array according to the logic in the diagram.

We can match exactly on call sign - this is usually an alphanumeric string between 5 and 7 characters, so there's no point using regex. But the lower-cased ship name is passed into a [RegExp test](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/test). Passing whatever is entered will match results anywhere in the ship name - which we also force to lower case.

But what if the call sign is in the wrong case? Call signs are always alphanumeric with capital letters. We can fix that, by using the `autocapitalize` HTML attribute for the input, so `<input autocapitalize="characters"/>`. It's not something I've used often in the past, and I don't remember it being obviously offered in XPages. But since using it here, it's surprisingly how often I've noticed web applications *not* using this approach where only capital letters are relevant.

As elsewhere in the application, we use a `CustomEvent` to send the message to the user. If there's a single match, we assume that's correct, populate it and switch from search to read mode for the ship.

!!! warning
    This choice to populate the ship has an impact when creating a spot. If the ship is not the one expected, we've now set the ship details - including the UNID of the ship chosen. If the user just changes all the details, I *think* this would change the "selected" ship. Instead the user is really intending to ignore the selected ship and create a new ship.

    There are a couple of ways around that. One is rely on the user to click a "Reset" button. Because the only user is me, I can live with that. A second option would be to prompt the user to accept the matching ship. I don't like that because mostly I know the ship already exists, I know I'm matching it correctly, so I don't want to have to click to confirm. The third would be to add a link / button for "Wrong ship?", which would also perform the reset. This avoids the extra click but also prompts the user to act if the wrong ship has been shown.

    The key here is to understand what's happened, understand the user base, and choose the best approach for the current application.

## The Dialog

For the dialog, we're going to create a two-column layout, with links containing the ship and call-sign. The link will close the dialog and, using the relevant ship, perform what we did when there was an exact match - populate the ship and switch to read mode.

``` js
this.shipOptions = results;
const shipOptionsDialog = this.querySelector(`#${this.prefix}ships-options-dialog`);
const shipsColLeft = shipOptionsDialog.querySelector(`#${this.prefix}ships-dialog-col-left`);
shipsColLeft.innerHTML = "";
const shipsColRight = shipOptionsDialog.querySelector(`#${this.prefix}ships-dialog-col-right`);
shipsColRight.innerHTML = "";
results.forEach((ship, index) => {
    const col = (index % 2 === 0) ? shipsColLeft : shipsColRight;
    const a = document.createElement("a");
    a.href = "#";
    a.innerHTML = ship.Ship + " - " + ship.CallSign;
    a.addEventListener("click", (event) => {
        event.preventDefault();
        this.populateShip(ship);
        const dialog = event.target.closest(`#${this.prefix}ships-options-dialog`);
        dialog.open = false;
        dialog.close();
        this.setAttribute("search", false);
        this.setAttribute("actionbutton", (this.prefix === "") ? "Edit" : "Save");
        this.dispatchEvent(new CustomEvent("mask", { bubbles: true, detail: {show: false}}));
    });
    col.append(a);
});
this.dispatchEvent(new CustomEvent("mask", { bubbles: true, detail: {show: true}}));
shipOptionsDialog.open = true;
shipOptionsDialog.show();
```

As we've seen with other areas, the code to populate the dialog may seem more verbose than, say, passing a collection to an XPages repeat control. But it's effectively the same. Using the index, we identify whether to put the collection in the left or right column. We then create a link with the text being the ship name and call sign. Then we add an event handler to close the dialog and populate the ship.

## HTML Dialogs

The [HTML Dialog](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog) was first added in Chromium 37 in 2014. However, it only achieved widespread adoption in 2022 when Safari and Firefox adopted it. It's now standard in web development and massively simplifies web application development.

However, there are a couple of key points.

The first is the `open` property. If this is not set, the dialog will not be displayed. The code above could add and remove the attribute, as required. But setting it to true or false works and feels more similar to other paradigms in other languages.

The second is `.show()` displays the dialog non-modally, `.showModal()` shows it modally. But in this application I'm using the "mask" Custom Event to prevent clicking anywhere else on the screen. So I don't need to use `.showModal()` - I've already achieved the same functionality with the mask.

## Save

When we populate the ship, we store the relevant ship's JSON object as a component property. This means:

- we know if it's a new ship or an existing one, because we have the Domino metadata (UNID etc).
- we can copy the values to the input fields.
- we can modify it. For example, size is in the format "length x breath". But if we split that into "length" and "breadth", we can remove some data entry and make the fields numeric only.
- we can compare the values before save, to know if changes have been made.

Obviously if we reset the form, we just reset the component property to an empty JSON object.

### doSave()

The `doSave()` function is pretty simple:

``` js
doSave = () => {
    this.dispatchEvent(new CustomEvent("mask", { bubbles: true, detail: {show: true}}));
    if (!this.shipObj.hasOwnProperty("@meta")) {
        this.shipObj.Form = "Ship";
    }
    if (this.checkNoChange()) {
        this.dispatchEvent(new CustomEvent("sendUserMessage", { bubbles: true, detail: {type: "error", message: "No change to ship, cancelling save"}}));
        this.dispatchEvent(new CustomEvent("mask", { bubbles: true, detail: {show: false}}));
        return;
    }
    this.updateShipObj();
    this.saveShip = true;
    this.dispatchEvent(new CustomEvent("saveShip", { bubbles: true, detail: {shipElem: this}}));
}
```

If the `shipObj` has no metadata, it's a new ship, so we need to pass the Form to DRAPI. We then check if there's a change, update the JSON object and perform the save.

### Update Ship Object

The functions to check for a change and updating the JSON object are quite similar. One compare the object and values of the inputs, the other pushes the values of the inputs into the object:

``` js
checkNoChange() {
    return this.shipObj.Ship === this.querySelector(`#${this.prefix}ship-name`).value &&
    this.shipObj.CallSign === this.querySelector(`#${this.prefix}ship-call-sign`).value &&
    this.shipObj.Type === this.querySelector(`#${this.prefix}ship-type`).value &&
    this.shipObj.Line === this.querySelector(`#${this.prefix}ship-line`).value &&
    this.shipObj.Flag === this.querySelector(`#${this.prefix}ship-flag`).value &&
    this.shipObj.YearBuilt === this.querySelector(`#${this.prefix}ship-year-built`).value &&
    this.shipObj.Size === this.querySelector(`#${this.prefix}ship-length`).value + " x "
    + this.querySelector(`#${this.prefix}ship-breadth`).value;
}

updateShipObj() {
    this.shipObj.Ship = this.querySelector(`#${this.prefix}ship-name`).value;
    this.shipObj.CallSign = this.querySelector(`#${this.prefix}ship-call-sign`).value;
    this.shipObj.Type = this.querySelector(`#${this.prefix}ship-type`).value;
    this.shipObj.Line = this.querySelector(`#${this.prefix}ship-line`).value;
    this.shipObj.Flag = this.querySelector(`#${this.prefix}ship-flag`).value;
    this.shipObj.YearBuilt = this.querySelector(`#${this.prefix}ship-year-built`).value;
    this.shipObj.Size = this.querySelector(`#${this.prefix}ship-length`).value + " x "
        + this.querySelector(`#${this.prefix}ship-breadth`).value;
}
```

Again, the code is pretty simple.

### Save Flow

The save flow is where the code may seem more complex than other frameworks. But it's because of the hierarchy:

``` mermaid
classDiagram
    index.js <-- ship
    index.js <-- dominoService
    class index.js{
        +saveShip
        +saveSpotShipObj
    }
    class ship["scripts/ship.js"]{
        +JsonObject shipObj
        +doSave()
        +reset()
        +populate()
    }
    class dominoService["scripts/services/dominoService"]{
        +saveDoc()
    }
```

We've got a variety of variables, constants for functions in index.js and functions in other files. This seems complex and convoluted. So a sequence diagram helps clarify things. For ease of understanding, I'm omitting the scenario of mock data, and only showing the flow for data being written to Domino via Domino REST API.

``` mermaid
sequenceDiagram
    ship->>index: CustomEvent "saveShip", pass web component
    index->>index: await saveSpotShipObj()
    index->>index: Check if ship name or call sign found
    index->>dominoService: await saveDoc(shipObj)
    dominoService->>dominoService: POST / PUT to DRAPI
    dominoService->>index: Return JSON document
    index->>index: Update localStorage
    index->>ship: Set actionbutton="Edit" and call reset()
```

By passing the web component as the detail of the `saveShip` Custom Event, the code in index.js has access to the properties and methods of the web component. This makes a lot of the processing much easier, but will probably feel unusual to developers new to Web Components. Once you understand that this is possible, it brings a lot of power to the developer.

## Wrap Up

This completes the main part of the ship form, although you'll notice we've skipped the actual HTML for the form. We'll come back to that later, and in the next part we'll see why.

!!! note
    I did not deliberately delay this part of the series until after I had migrated my blog to MKDocs for Material. But because it's come now, I've been able to use [Mermaid.js](https://mermaid.js.org/) to create the flowchart, the class diagram and the sequence diagram. This certainly makes the blog post easier to understand. It also means if I've got anything wrong, the *source code* for the diagrams is in source control. So it's easy to see what's changed.

    Using a good tool and knowing its strengths makes more powerful functionality and a better user experience.

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
1. **Ship Search and Save**
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)
1. [Fields and Save](./2025-02-07-framework-web-14.md)
1. [Dialogs](./2025-02-08-framework-web-15.md)
1. [Spots](./2025-02-11-framework-web-16.md)
1. [Lessons Learned](./2025-04-02-framework-web-17.md)