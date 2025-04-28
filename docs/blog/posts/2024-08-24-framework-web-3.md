---
slug: framework-web-3
date: 2024-08-24
categories:
  - Domino
tags: 
  - Domino
  - Domino REST API
  - Web
  - HTML
  - CSS
  - JavaScript
  - Web Components
comments: true
---
# Framework App to Web App: Part Three - Frameworks and the Internet

## A Brief History of Web Development

Until now, the series has focused on XPages. That's understandable considering [my previous series](https://www.intec.co.uk/from-xpages-to-web-app-part-one-the-application/) that this is inspired by. However, recently it's become apparent that much of this series is relevant to a much wider audience than just XPages developers. Most web developers are used to developing with a specific framework. That's understandable considering the history of the last 20+ years. But that means this series is relevant to a much wider audience than HCL Domino developers using the JSF-based XPages framework.

<!-- more -->

### The Rise of Corporate IT

In the 1990s the internet started to become more prominent. Home computers were still mainly focused around gaming, but desktop computers began to become more prominent in companies. By the time I started my first office jobs in the late 1990s, desktop computers and email were starting to gain prominence. But a main use of word processing products was for generating paper letters that were mailed to other companies and customers. Emailing documents or spreadsheets was not a common task. The internet was used mainly for websites, applications were in desktop platforms like Lotus Notes, Microsoft Access or Excel.

Slowly web applications started to spring up and exploded in the 2000s. Developers learned hacks to work around differences in how Internet Explorer, Firefox and (later) Google Chrome implemented or ignored the slowly-evolving web standards. In UK, Safari and Mac computers were a rare occurrence outside graphic designers. As a result, and because Internet Explorer came pre-installed on Windows devices, Internet Explorer - and specifically IE6 - became the de facto standard corporate browser.

### The Rise of Frameworks

Then in the second half of the decade, frameworks started to appear. Dojo and jQuery came out around the same time. The differences were that Dojo covered a broad array of web development needs, not only libraries for browser and web-page manipulation but also "dijit" Dojo widgets. jQuery,on the other hand, focused only on browser and web-page manipulation and AJAX. This initially gave Dojo a major advantage. The Java world were slower to the party, with JSP and JSF coming in around the turn of the decade.

Around that same time AngularJS was also released. This also provided components, but also brought the MVC (Model-View-Controller) approach to prominence amongst JavaScript developers. Dojo lost some favour, not least when they changed the way components were coded. React came along a few years later and, after a few years of competition with AngularJS, took over when AngularJS also changed their whole API. Other frameworks like Vue, EmberJS, Svelte and NextJS have their proponents and prominent applications.But frameworks were still the way to go...because we still had to fight with Internet Explorer 6!

### Browser Companies Playing Nice(r)

Microsoft Edge was a major game-changer. Not because it was a better browser than the competition, but because it finally killed off Internet Explorer 6. The other key was that Edge was the last browser that auto-updated. This means no longer do developers have to wait for reluctant IT departments to update all their end users' laptops. Now business users are likely to be on a modern browser. End users are often on a mobile device or a reasonably modern browser. And the browser companies are often collaborating together on web standards.

There are also key advances in web development, which will be used throughout this series. Rather than spoil the fun, I'll leave them for when it becomes relevant.

### Frameworks vs Browsers

Now we're in an era where frameworks still exist. Indeed there are probably a lot of applications built on old versions of frameworks like Dojo or AngularJS, stuck with technical debt, supported by frustrated developers working for IT companies that are unwilling to justify the ROI of rewriting the application. Some applications will even be using multiple frameworks in a single application.

But whether it's one or many, the problem still exists: frameworks have a specific way of working. There's a whole website arisen to try to break developers out of the knee-jerk use of jQuery called [You Might Not Need jQuery](https://youmightnotneedjquery.com/). But there are frameworks and components out there almost inextricably tied into the technical debt of jQuery. Sooner or later the developers will move on and it's not advisable to be one of those left struggling. Combining jQuery with native `document.selector()` or `fetch` calls is not too difficult.

But frameworks have their own way to do things like light and dark mode or components. And as I've found, trying to integrate native options into a framework is far from straightforward. Indeed, it's probably not worth it. So what does the future hold? Well, as we saw with Internet Explorer 6, it will take a long long time for companies to move their applications to options browsers natively support. And developers will be stuck with technical debt for probably over a decade. Developers may also be reluctant to adopt those options too. Despite the one constant in IT being change, humans are inherently resistant to change.

But it's easier than ever to develop a web application without using a framework. And that's the focus of this series, and why the name is changing.

## Table of Contents

1. [Introduction](./2024-08-15-xpages-web-1.md)
1. [Dev Tools](./2024-08-20-xpages-web-2.md)
1. **Frameworks**
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
1. [Spots](./2025-02-11-framework-web-16.md)
1. [Lessons Learned](./2025-04-02-framework-web-17.md)
1. [CSP Enhancement](./2025-04-19-framework-web-18.md)
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)