---
slug: framework-web-14
date: 
  created: 2025-02-07
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
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
  - blog/2025-02-08-framework-web-15.md
comments: true
---
# XPages App to Web App: Part Fourteen - Fields and Save

In the last part I covered [CSS Grid](https://www.w3schools.com/css/css_grid.asp) and its use for the layout of the Ship Spot form. In this part I'm going to cover the additional form functionality and save functionality.

<!-- more -->

## Field Settings

When building the original XPages application, I dragged and dropped fields onto the XPage and thought little about the settings. As a result, I created what on reflection was a suboptimal user experience. When redeveloping the application, I had the experience of having used the application for several years and experience of the data I was dealing with. So I put in a little more effort and investigation to ensure quicker, easier and more accurate data entry.

### Date Built and Ship Size

The date the ship built is already being [validated in DRAPI](./2024-08-26-framework-web-4.md#validation-rules) to ensure it's a four-digit year after 1800. So we know it needs to be numeric. We also split the size into two numeric fields that will be combined [at save](./2024-12-14-framework-web-11.md#save). So it makes sense to enforce this on the browser and ensure a numeric keyboard is displayed for the user.

Not surprisingly, this is very easy: `<input type="number" inputmode="numeric"`. The `inputmode` attribute here ensures the correct keyboard is displayed.

For the size, this can be numeric and decimal, to two decimal places. The `step` attribute can be used to define legal values, in this case we add `step="0.01"`.

### Ship Call Settings

The ship call sign is alphanumeric, but the alpha characters are always upper case. Again, we can make this easier for the user. Adding the attribute setting `<input type="text" autocapitalize="characters"` ensures the keyboard automatically displays only with upper case letters on mobile devices.

When it comes to the Country dialog, the country code is also upper case, so we do the same there.

### Summary

After implementing these usability enhancements and using them for a short period of time, it's surprising and disappointing to encounter websites on mobile that don't take the time to adapt their user experiences.

## Validation

We set up a lot of validation rules in our [DRAPI schema](./2024-08-26-framework-web-4.md#validation-rules). This was one of the driving principles for me when working on Domino REST API in its research days. That's because there's a big difference when moving from XPages to a REST-based web access. If access is via REST services, the web application is just one interface for that REST service. It may be the one the developer creates and the one the developer focuses on. But it's never the **only** interface, unless access to the REST service is locked down in some way at the server. Domino REST API provides ways to do that by restricting access to a schema to only server-based applications. But where that is not the case, validation needs to be enforced at the REST API.

But there are errors that can and should also be caught in the web application. This is less about ensuring data integrity, but more about notifying the user as quickly as possible about errors they might have made.

### Required Fields

The first step is ensuring all required fields have been completed. To handle this, we add an array of required fields as a property to the Spot class:

``` js
requiredFields = ["spot-location","ship-name","ship-call-sign","ship-type","ship-flag"]
```

And we add an `isValid()` function to iterate the array and apply a class if they are empty.

``` js linenums=1
isValid() {
    let uncompletedFields = [];
    this.requiredFields.forEach(field => {
        const fieldName = `#${this.prefix}${field}`;
        const input = this.querySelector(fieldName);
        input.classList.remove("required");
        if (input.value === "") {
            uncompletedFields.push(field);
            input.classList.add("required");
        }
    });
    return uncompletedFields.length === 0;
}
```

Line 2 creates an empty array to hold uncompleted fields. We then iterate each of the required fields and get the relevant HTML input, not forgetting that we added a prefix to ensure they were always unique. At line 6 we remove the required class, in case a previous call to the method resulted in failed validation. On lines 7 - 10 we check the field was completed and, if not, add it to the array and add the required class. Finally, we return a boolean for whether or not there are uncompleted fields. This decides whether or not we should progress saving.

### Save Functionality

The Ship class had a `doSave()` function and we override that function.

``` js
doSave = () => {
    this.dispatchEvent(new CustomEvent("mask", { bubbles: true, detail: {show: true}}));
    if (!this.isValid()) {
        this.dispatchEvent(new CustomEvent("sendUserMessage", { bubbles: true, detail: {type: "error", message: "The fields marked are required"}}));
        this.dispatchEvent(new CustomEvent("mask", { bubbles: true, detail: {show: false}}));
        return;
    }
    if (!this.shipObj.hasOwnProperty("@meta")) {
        this.shipObj.Form = "Ship";
    }
    this.checkNoChange() ? this.saveShip = false : this.saveShip = true;
    this.updateShipObj();
    if (!this.spotObj.hasOwnProperty("@meta")) {
        this.spotObj.Form = "Spot";
    }
    this.checkNoSpotChange() ? this.saveSpot = false : this.saveSpot = true;
    // Update JSON object
    this.spotObj.Location = this.querySelector(`#${this.prefix}spot-location`).value;
    this.spotObj.PortFrom = this.querySelector(`#${this.prefix}spot-port-from`).value;
    this.spotObj.PortTo = this.querySelector(`#${this.prefix}spot-port-to`).value;
    this.dispatchEvent(new CustomEvent("saveShipSpot", { bubbles: true, detail: {spotElem: this}}));
}
```

We've already covered the `isValid()` check which, if it fails, we notify the user and clear the mask using the now familiar approach of CustomEvents. The next part is very similar to the code in the base method in the Ship class: if the `shipObj` has no metadata, if it's a new ship, we need to pass the Form to DRAPI. But the next part is slightly different: we still check if there's a change, but this time we just update the `saveShip` property and call `updateShipObj()` to pass values from the inputs to the JSON object.

Then we perform additional processing on the `spotObj` - checking whether there's a change and updating the `spotObj`. Finally we trigger the CustomEvent `saveShipSpot`, which calls `saveShipSpotObj()`.

Back in [part 11](./2024-12-14-framework-web-11.md#save-flow) we covered the save flow. But we've now added the Spot class to that, so let's expand that diagram further.

``` mermaid
classDiagram
    index.js <-- ship
    index.js <-- spot
    ship <|-- spot
    index.js <-- dominoService
    class index.js{
        +saveShip
        +saveSpotShipObj
    }
    class ship["scripts/ship.js"]{
        +JsonObject shipObj
        +doSave()
        +checkNoChange()
        +reset()
        +populate()
    }
    class spot["scripts/spot.js"] {
        +JsonObject spotObj
        +isValid()
        +doSave()
        +checkNoSpotChange()
        +reset()
        +populateSpot()
    }
    class dominoService["scripts/services/dominoService"]{
        +saveDoc()
    }
```

We're also adding to the business logic in `saveSpotShipObj()`, so let's also expand on the sequence diagram from the save flow in part 11. The logic is the same as it was before, the only difference is that the object being passed includes a boolean property `saveSpot`.

``` mermaid
sequenceDiagram
    spot->>index: CustomEvent "saveShipSpot",<br/>pass web component
    index->>index: await saveSpotShipObj()
    index->>index: Check if ship name or call sign found<br/>only if shipSpotObj.saveShip
    alt if shipSpotObj.saveShip
      index->>dominoService: await saveDoc(shipObj)
      dominoService->>dominoService: POST / PUT to DRAPI
      dominoService->>index: Return JSON document
      index->>index: Update localStorage
      opt if shipSpotObj.saveSpot
        index->>dominoService: await saveDoc(spotObj)
        dominoService->>dominoService: POST / PUT to DRAPI
        dominoService->>index: Return JSON document
      end
    else
      opt if shipSpotObj.saveSpot
        index->>dominoService: await saveDoc(spotObj)
        dominoService->>dominoService: POST / PUT to DRAPI
        dominoService->>index: Return JSON document
      end
    end
    index->>spot: Set actionbutton="Save" and call reset()
```

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
1. [Dialogs](./2025-02-08-framework-web-15.md)