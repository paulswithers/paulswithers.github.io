---
slug: framework-web-15
date: 2025-02-08
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
# XPages App to Web App: Part Fifteen - Dialogs

When it comes to creating Ship Spots, one of the pain points I highlighted with the previous application was when a Ship Spot required creating a new Port or a new Country. This required switching to an "admin" area to open a Port form to complete and save; and if the country hasn't been created, it requires additionally switching to a County form to complete and save, before returning to the Port and back to the Ship Spot. Options were cached server-side in `viewScope`, so launching additional browser windows wasn't an option - the page would still need to be refreshed and entered data lost. We can improve on this.

<!-- more -->

!!! note
    It should be stressed that XPages as a framework does not hinder creating multiple types of document from an XPage. However, using the Extension Library dialog component, updating server-side scopes, and updating multiple other areas of the page without losing values is far from straightforward and has been asked many times on forums. Options *have* to be part of the server-side design, updating them just client-side probably would not work.

## Dialogs Redux

We covered one dialog in [part 11](./2024-12-14-framework-web-11.md#html-dialogs). [HTML dialogs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog) are now standard in web development. Just to cover a couple of points on usage again: the `open` property needs to be set to `true`, and the show()` method is called to open it, because we're adding a mask to prevent clicking elsewhere on the screen.

## Web Component Dialogs

When we created previous dialogs, the template and the HTML were part of `ship.js`. But this time we're creating them as web components. As with previous web components, the constructor does little, `connectedCallback()` calls `render()`, and the `render()` method appends the template and adds the event listeners - a Close button and a Save button. The web components also include `show()` and `close()` methods, as well as `reset()` methods to clear the values.

With the Ship and Spot web components, we also had objects that correspond to the document in the Domino database. But this time we're not going to bother. This is because there's no intention to edit the Ports or Countries, so we'll just pass the values from the relevant inputs on-the-fly. The structure of the classes is as below:

``` mermaid
classDiagram
    index.js <-- Country
    index.js <-- Port
    index.js <-- dominoService
    class index.js {
        saveCountry()
        savePort()
    }
    class Country["scripts/country.js"] {
        constructor
        connectedCallback()
        render()
        show()
        close()
        reset()
        addEventListeners()
    }
    class Port["scripts/port.js"] {
        countries : array
        constructor()
        connectedCallback()
        render()
        show()
        close()
        reset()
        addEventListeners()
        getAbbreviation()
    }
    class dominoService["scripts/services/dominoService"]{
        +saveDoc()
    }
```

Notice that we have a `countries` property in the port. This contains the options available and also allows us to update it when a new country is saved. This is not just an array of country names, it's actually the array of country JSON objects stored in sessionStorage. This allows dual functionality. The setter can load options into a `<select>`:

``` js
set countries(value) {
    this._countries = value;
    const countrySelect = this.querySelector("#port-country");
    countrySelect.options.length = 1;
    value.forEach((value) => {
        const option = document.createElement("option");
        option.value = value.Country;
        option.innerHTML = value.Country;
        countrySelect.append(option);
    });
}
```

But also the `getAbbreviation()` method can retrieve the correct abbreviation for the selected country:

``` js
getAbbreviation = (country) => {
    const results = this._countries.filter(obj => obj.Country === country);
    return results[0].Abbreviation;
}
```

## Loading the Dialogs

The Port dialog is only needed from a Spot. But the Country dialog is needed from a Ship and a Spot. This is why we don't add it as part of the ship class - that would create two dialogs instead of just one. Instead of adding it into a specific web component, we add it onto the main web page. The code to add it is in the `bootstrap()` function which, if you remember, runs when the application has initially loaded:

``` js
const countryElem = document.createElement("country-elem");
document.querySelector('#header').append(countryElem);
captureClickEvent("ship-country-action", function() {
    countryElem.show();
})
captureClickEvent("spot-country-action", function() {
    countryElem.show();
})
const portElem = document.createElement("port-elem");
document.querySelector("#header").append(portElem);
captureClickEvent("spot-port-action", function() {
    portElem.show();
})
```

We programmatically create an instance of the country web component, which is defined with the HTML tag `country-elem`, and add it to the header. We add a click event to the "Country" button in both the ship and spot sections to show the country dialog. And we programmatically create an instance of the spot web component, which is defined with the HTML tag `port-elem` and also add it to the header. And we add a click event to the "Port" button in the spot section to show the port dialog.

!!! note
    For this application I chose a dialog for creating Ports and Countries. Dialogs may not be everyone's choice for this functionality on a mobile device. But as always, it's important to take into account the users (and potential users) of an application. In this case, it's just me and only ever likely to be me.

    An alternative might have been to have a link to open a section with a wipe animation for creating a Port and/or Country. This could probably be injected below the relevant field and removed after completion. Another thing I've learned from years of development is not to over-complicate for the sake of it. After months of use of the current application, the speed of use is very satisfactory - if a Country doesn't exist (not a common experience now), one click to close the dialog, one click to launch another dialog, fill in two fields, save, then go back to the first dialog. And because it's all client-side, no entered data has been lost. Would the alternative approach have been quicker to use? Possibly, marginally, but slower to implement, and performance is never just about use. Would it give a better user experience? Maybe.

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
1. **Dialogs**
1. [Spots](./2025-02-11-framework-web-16.md)
1. [Lessons Learned](./2025-04-02-framework-web-17.md)
1. [CSP Enhancement](./2025-04-19-framework-web-18.md)
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)
1. [Custom CSP Settings](./2025-09-14-framework-web-20.md)