---
slug: framework-web-7
date: 
  created: 2024-10-07
categories:
  - Web
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
  - blog/2024-09-03-framework-web-5.md
  - blog/2024-09-16-framework-web-6.md
  - blog/2024-10-21-framework-web-8.md
  - blog/2024-10-23-framework-web-9.md
  - blog/2024-10-30-framework-web-10.md
  - blog/2024-12-14-framework-web-11.md
  - blog/2025-01-13-framework-web-12.md
  - blog/2025-01-18-framework-web-13.md
comments: true
---
# XPages App to Web App: Part Seven - CSS

In the last part we created the login form. In this part we're going to start adding some theming.

<!-- more -->

## Theme Colours

The power of XPages is in the out-of-the-box themes available. These provide styling for the various XPages components and some developers may even have not add their own CSS. But hopefully developers have.

Those who have been developing since the days of Domino 8.5.2 and 8.5.3 may remember the OneUIv2.1 themes which included colour variants. If you have an older Domino server, you may still find them in <domino>/Data/domino/html/oneuiv2.1/themes directory. In here are theme directories for blue, gold, green, onyx, orange, pink, purple, red, and silver. Each directory has its own CSS files. The files are virtually identical except for different colours for a handful of elements. To change colour theme for XPages' OneUI2.1 themes, we usually would change the theme of the database and rebuild the application. (If I remember correctly, the XPages demo application provided a dynamic way of switching theme colour, but I don't have an example to check.)

This was how different coloured themes was done in those days. But things have changed.

There is now a better way to handle theme colouring. Colours are no longer defined in stylesheets. Instead [CSS variables](https://www.w3schools.com/css/css3_variables.asp) are a better way. A separate stylesheet can assign colours to a variable name, and the main stylesheet can then use those variables. For example, we will have a stylesheet called "blue-theme.css":

``` css
:root {
    --primary-color: #000;
    --primary-color-dark: #FFF;
    --button-primary: #005C99;
    --button-primary-dark: #708DA0;
}
```

By assigning the variables to the root, they are global. And the syntax is "--" + variable name. The main stylesheet will not have any colours defined. Instead, the variable names will be used:

``` css
.btn-primary {
  background-color: var(--button-primary);
  color: var(--primary-color-dark);
}
```

With this approach, to change the colour of the application, we just need to load a different CSS stylesheet, switching "blue-theme.css" for "green-theme.css", for example.

The use of CSS variables can be used for more than just colours, for example for font-sizes or fonts. This provides a great amount of flexibility for UI.

It's probably not an option XPages developers have used though, even in more recent versions of Domino, because it requires the main stylesheet to use variables. However, when moving beyond XPages, it's an option that can - and should - be embraced. And with variables and native for support for `calc()`, nesting, `color-mix()`, and even trigonometric functions, if you're not supporting legacy browsers you may not even need to use SASS or LESS.

## light-dark

### Enabled with CSS

But modern websites and web applications provide something more. Users expect to choose light-mode or dark-mode - or for it to auto-adjust. The good news is that this too can also be handled with standard CSS using [light-dark()](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/light-dark). If you looked closely at the extract from "blue-theme.css" above, you'll have noticed that there is `--primary-color` and `--primary-color-dark`. I deliberately omitted something from the main CSS. The actual styling I'm using is:

``` css
.btn-primary {
  background-color: light-dark(var(--button-primary), var(--button-primary-dark));
  color: light-dark(var(--primary-color-dark), var(--primary-color));
}
```

With the use of variables this starts to get a little trickier to read. But the syntax used is to pass two colours to `light-dark()`. The first is the colour to use when in light-mode, the second is the colour to use when in dark-mode. To actually use this, we need to add something more to the main stylesheet:

``` css
:root {
  color-scheme: light dark;
}

.light-mode {
  color-scheme: only light;
}

.dark-mode {
  color-scheme: only dark;
}
```

### Light-Dark Switcher

With just this CSS, the application will pick up the light or dark mode of the operating system. It's important to understand that even though you can set light or dark mode on the browser, it's the operating system setting that `light-dark` uses.

The application I'm building is only used by me. I prefer to switch between light and dark mode at the click of an icon. So I'm not auto-switching the theme based on the operating system setting. Instead, I'm adding a switcher icon and storing the setting in localStorage, which we covered in the [last blog post](./2024-09-16-framework-web-6.md).

To switch the theme, I'm preferring an icon. There are various icon libraries out there, but I'm using [Google's material design icons](https://fonts.google.com/icons). This means I can just use a span, just with different text in the span. As in [part five](./2024-09-03-framework-web-5.md) I'll be adding the event handler and loading the relevant light/dark setting in the `bootstrap()` function:

``` js
	const themeSwitcher = document.getElementById("themeToggle");
	themeSwitcher.addEventListener("click", function () {
		switchTheme(true);
	});
	switchTheme(false);
```

The boolean parameter being passed is whether or not to change the theme. So on the eventHandler, we want to change the theme, whereas in the bootstrap we just want to set the theme. The `switchTheme()` function itself is this:

```js
const switchTheme = (switchTheme) => {
	// localStorage is only a string
	const darkMode = localStorage.getItem("shipSpotterLightDark") === "true";
	if (switchTheme) {
		darkMode = !darkMode;
		localStorage.setItem("shipSpotterLightDark", darkMode);
	}
	let toggle = document.getElementById("themeToggle");
	if (darkMode) {
		document.documentElement.classList.add("dark-mode");
		document.documentElement.classList.remove("light-mode");
		toggle.innerText = "light_mode";
	} else {
		document.documentElement.classList.add("light-mode");
		document.documentElement.classList.remove("dark-mode");
		toggle.innerText = "dark_mode";
	}
};
```

The first line of the function checks whether dark mode has been enabled. Remember localStorage values are *always* strings and may be null, so we need to handle it accordingly. From the eventHandler, we toggle the boolean and update localStorage. Then we set the relevant class (light-mode or dark-mode) on the html tag. We also put the relevant label (light_mode or dark_mode) on the `themeToggle` span to set the icon accordingly.

## Wrap up

In 2024 CSS is extremely powerful. Frustratingly powerful, at times. But extremely powerful. Because of its prevalence for many years, SASS and LESS will still be used in many applications for some years. But when targeting only modern browsers, in many scenarios CSS alone may be sufficient.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. [Frameworks](./2024-08-24-framework-web-3.md)
1. [DRAPI](./2024-08-26-framework-web-4.md)
1. [Home Page](./2024-09-03-framework-web-5.md)
1. [Mocking, Fetch, DRAPI and CORS](./2024-09-16-framework-web-6.md)
1. CSS
1. [Landing Page Web Component](./2024-10-21-framework-web-8.md)
1. [Services](./2024-10-23-framework-web-9.md)
1. [Ship Form Actions](./2024-10-30-framework-web-10.md)
1. [Ship Search and Save](./2024-12-14-framework-web-11.md)
1. [Ship Spot Component](./2025-01-13-framework-web-12.md)
1. [HTML Layouts](./2025-01-18-framework-web-13.md)