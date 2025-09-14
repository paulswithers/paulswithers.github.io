---
slug: framework-web-20
date: 2025-09-14
categories:
  - Domino REST API
tags: 
  - Domino REST API
  - Domino
comments: true
---
# XPages App to Web App: Part 20: Custom CSP Settings

A good web server will enforce [Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP) settings. If you are using something like Express as the web server, the endpoints will set that Content Security Policy.  In the case of Single Page Applications hosted on Domino REST API, since release 1.15 by default a strict CSP is applied. But it is possible to change the CSP settings per application.

<!-- more -->

## Manifest

The web manifest is required for Progressive Web Applications, telling the browser the information it needs about your application in order to install it, and so it's not uncommon for other single page applications.

Although it can is registered to have a .webmanifest extension, it's more typical for the file to be called "manifest.json". It has its own [specification](https://w3c.github.io/manifest/). Many of the properties are standard, but there are also some experimental settings.

But Domino REST API specifically uses an additional property, "csp", for a custom Content Security Policy to use. In the case of my web application, I'm loading icons from Google's material design icons, as I mentioned in [part 7](./2024-10-07-framework-web-7.md). So I need to allow the browser to load the stylesheets, otherwise the requests get blocked and I just get the text instead of the icons.

A quick look at the headers will show that the URL is "https://fonts.googleapis.com". But this is only part of the story. They're loaded as fonts, so I also need to allow fonts loaded from "https://fonts.gstatic.com". The full CSP setting in the manifest,json is `"csp": "default-src 'self'; script-src 'self'; style-src 'self' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data:; connect-src 'self';"`

You may need to restart Domino REST API after making the change, I can't remember.

## Summary

If you're deploying a Java application on Domino REST API, custom CORS is set differently, in a config file. You can look at the [open-sourced Admin client](https://github.com/HCL-TECH-SOFTWARE/domino-rest-adminclient/blob/main/jar/config/config.json) for an example.

As ever, you can see the full application on [github](https://github.com/paulswithers/shipspotter/)

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
1. [CSP Enhancement](./2025-04-19-framework-web-18.md)
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)
1. **Custom CSP Settings**