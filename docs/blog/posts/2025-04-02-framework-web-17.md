---
slug: framework-web-17
date: 2025-04-02
categories:
  - Web
tags: 
  - Web
  - Domino
  - HTML
  - CSS
  - JavaScript
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
  - blog/2025-02-07-framework-web-14.md
  - blog/2025-02-08-framework-web-15.md
  - blog/2025-02-11-framework-web-16.md
  - blog/2025-04-19-framework-web-18.md
  - blog/2025-04-22-framework-web-19.md
comments: true
---
# XPages App to Web App: Part Seventeen - Lessons Learned

Now the application is built and has been in use for many months. It's time to review experiences and lessons learned.

<!-- more -->

## Domino REST API

### Mock Data

Right from the start the application was designed to work with mock data and real data. There may be questions over the benefits of this. After all, in this scenario the REST API was being configured by the same developer who was coding the web application. But it provided several benefits:

1. Bruno requests could be included in the repo. This allowed JavaScript code to be cross-checked from a REST client. Whenever things do not work as expected, the ability to cross-check a process by changing one aspect helps quickly troubleshoot and avoid mistaken assumptions.
1. It allowed the UI to be tested without polluting the database with bad data. This not only avoids false errors, it also speeds up development because I didn't need to keep switching to Notes Client to delete data.
1. Domino REST API calls provided starting data as JSON in a matter of seconds. JSON data is easy to store in a file and load from JavaScript. And the JSON data was the same format as the initial calls. There was no need to business logic or intermediary classes to hold collections of objects, which was done in the original XPages application. If you prefer to just use `dominoView` and `dominoDocument` datasources, this is still not much slower.

Yes, there are places where bugs are in non-mock branches of code. But if mock testing doesn't reproduce the error, this means small chunks of code to look at, and problems have been easy to diagnose.

### Validation and Data Quality Management

From the very start of Domino REST API, enforcing data quality by configuration was a core principal. That's because there is no lingua franca for coding REST services on Domino, which means configuration - a no-code approach - was the only option.

This means adding the validation is quick to implement, and can be tested before even opening up an IDE to code the web application. It also improves security, because even if a malicious party finds a way around the web application, the validation and data quality is ensured on the server, not in the client.

### DRAPI, dates and times

For the first few months of use, the application tracked Trips, which had a start and end date. This functionality had also been available in the XPages application. But this highlighted a problem with the redevelopment of the UI. Because even though trips just had a start date and end date, the XPages interface stored them as a start *date-time* and end *date-time*.

It's not easy in XPages to store only as a date, you need to handle it with code, create a `DateTime` object and call `.setAnyTime()`. But DRAPI makes it easy to ensure something that only needs to be a date *is* only a date. Early on, the contrast between existing data being a date-time and new data being date only bit me. It's worth being aware of.

## Coding

### Imperative vs Reactive

There is a major difference between XPages and framework-less web development or even Volt MX: the new application's coding is imperative, whereas XPages is reactive. Consider the scenario where you want to hide a div when a user clicks a button.

In XPages, the visibility of the div (`xp:div` or `xp:panel`) will be computed on the component itself. It may be tied to a Java bean property, but it will still be managed on the component, and a partial refresh will allow the component to *react* to the change when the user clicks the button. Getting a component programmatically in XPages is rarely done.

There may be web development frameworks that work similarly. EmberJS  tracks properties to know when the UI should be updated - should *react* to a change. AngularJS uses things like `ng-if` or `ng-unless` to *react* to property changes in a controller.

But this framework-less web development is imperative and action-driven, same as Volt MX is. JavaScript code on a button gets HTML elements via `getElementById()` or queries, and changes attributes of it. This requires a change of mindset. It still requires an ability to think fourth-dimensionally, being aware of what current states are and what you need to change. But it *can* mean it's easier to work out what happens when you click a button. It's may make coding more verbose if you have a large web pages, but large web pages will create other challenges.

But as we've also seen Custom Events can be triggered, so there is some concept of reactive programming. This is different to getting a button and calling its `click` eventHandler. In this case, you're publishing an event and letting the event listener capture it. Still, the IDE can help track through the code and work out where to add breakpoints.

### Learning Curve

There is definitely a learning curve. XPages encourages creating a UI by dragging and dropping components and filling in property boxes.  As with any framework, developers are likely to stay within the box of what's provided by the framework. But this required a lot of learning - some was done before I started coding, when developing last year's Engage session; some was done "on-the-job" and will feed into this year's Engage session. I'm convinced it's increased my skill-set significantly, I've progressed more in one year than more cautious developers would in five or even ten. But it requires a certain mindset to embrace stepping outside of your comfort zone.

### Framework vs No Frameworks

Timing is key, and the timing is right to code a framework-less vanilla JavaScript application. Modern CSS means there is little need for CSS preprocessors like SCSS, SASS and LESS. CSS variables and `light-dark()` remove the need for proprietary approaches from frameworks. FlexBox and CSS Grid and their sophisticated layout options remove the need to add Bootstrap as your first dependency. Web components are becoming widespread and are not hard to create. But if you want something off-the-shelf, there are plenty and even the UI components of the Java framework Vaadin have been available as web components for a while. But the are also advances in standard HTML elements that will improve applications.

A framework can give that comfort blanket, but still requires you to *understand* the framework to bend it to your will. Otherwise, simple development is easy, but anything else becomes exponentially trickier. I've witnessed that when I see developers try to combine non-Dojo code into an XPages application. The same occurs when trying to integrate React components into an AngularJS application, or web components into an EmberJS application.

But there are similar challenges trying to integrate web components from npm into a vanilla JavaScript application. It's possible, but typically not as well documented. Yet. It will be interesting to see if that changes over the next five years.

However, what is certain is that there is much less technical debt in an application that doesn't use a CSS preprocessor, doesn't rely on BootStrap and doesn't use jQuery. The approach is consistent with frugal engineering. It's not about "not invented here", it's about choosing standards-based approaches over frameworks.

### Coding Performance

So often when developers talk about performance, they focus only on how the application performs when used. That's never the only measure of performance. If it takes 2 months to make it half a second quicker, is it worth it? Coding performance is equally important.

I can't comment on speed to develop. I wasn't comparing. I also can't easily compare number of lines of code written, but the new app is probably about 2400 lines in total (including whitespace). Java provides menu options for generating getters and setters for example, but I would not be surprised if I wrote more custom code for the XPages application. Including pre-written code, it's definitely more.

### Testability

I never included testing in the application. Why? It's one user, who is also the developer, and who is happy to fix bugs when I find them. And it's not had significant development since it "went live", so regressions are low risk, low impact.

The previous application never had any unit or UI testing. But I think it would be easier to implement for the JavaScript application, and certainly easier to find reference materials on how to implement it.

### Deployment

This isn't deployed in an NSF. It's deployed to keepweb.d, which for me means I access the Domino server filesystem directly. That may be something some Domino administrators, developers and/or customers are nervous about. But is that a requirement? Certainly not, as you may see before long.

An alternate approach would be push it to the filesystem following a successful pull request and unit test running on a build system like Jenkins. That may be unfamiliar to many Domino people, but it's one an approach software houses and IT departments are used to.

## User Experience

### Framework vs No Framework

Framework-less development also ties into user experience. A framework with a predefined set of components encourages you to build something that conforms to those components. But it also means applications often look very similar, and have a similar user journey. When you consider the components provided by XPages Extension Library, you'll see many of them fit the premise of providing a "Notes Client field for XPages". The Data View significantly steps beyond the Notes View design element layout, but the other view components in the Extension Library reproduce Notes Client or iNotes view elements. The result is a user experience that prioritises familiar and quick over innovative.

In the case of my XPages application, it began from a starter application, which again prioritised familiar to try to fulfil the "rapid application development" promise. It was "development by numbers" to a large degree, the bulk of coding was Java classes for beans and utility methods.

Is it impossible to provide an innovative user experience in XPages? Definitely not. Could I have reproduced an XPages / Notes user experience in this application. Very probably. But a blank page makes it easier to think differently.

### View and Document-Driven Design

The XPages application combined two document types on a single "form" - ship and spot. It also included details from two different views in a single "view" - ship details were dynamically retrieved by performing a lookup on the ship UNID. But the approach was navigation --> view --> document.

Keyword-style documents were viewed or edited in their own form. Dialogs were used mainly for pickers, never for creating or editing one of those keyword-style documents. Is that because it's not possible in XPages? No, it's certainly possible. But because of how Dojo handles dialogs, it's an area that generates a lot of questions in the XPages world, especially around data sources in dialogs and refreshing other areas of the XPage after processing the dialog. These are problems that don't exist in vanilla JavaScript and HTML dialogs.

### Performance

Let's talk about performance when using the application. This is the area I'm happiest with.

"Time to live" is significantly quicker, even though there are things I could do to improve that.

Performance for adding a ship spot is significantly quicker:

- Checking whether a ship exists doesn't require a round-trip request to the server.
- It doesn't require scrolling through or searching ships by name. It searches based on part of the name or the call sign.
- If the ship hasn't been logged before, I've already typed the name.
- Adding a country and/or flag can be done from the same screen, with at most two calls to the server. Compare that to multiple requests to the server to navigate through and load multiple views and forms.
- Selecting ports doesn't require round-trip requests to the server. These were two mandatory fields that each required loading a picker and its options from the server. Even though the list of options was the same for them both, because it was a picker, it required two round-trip server calls. The new application requires none.
- The pickers for ships and ports often timed out loading, because of network performance. This was a frustration, and one that no longer exists.

This all means usability of the new application is much higher than the previous application. Could improvements have been made to the XPages application? Certainly. Could all the problems have been removed. **No.** That's because XPages requires more communication between device and server.

## Summary

Let me be totally blunt: this application is no less Domino than it was before.

Yes, the development was done without launching Domino Designer, because the design already existed.

Yes, it's not deployed in an NSF and it's not accessed from Domino's HTTP server. But "Domino's HTTP server" is actually "Domino's HTTP server task", like DRAPI is "Domino REST API task". So is it really that different that it's accessed from DRAPI's HTTP server?

It's still Domino. But it's probably more future-proofed than before and has no reliance on third-party enhancements or fixes for a framework. There are definitely modernisations that can be done. And of course there are always improvements that can be made, whether in look and feel or functionality.

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
1. [Spots](./2025-02-11-framework-web-16.md)
1. [Lessons Learned](./2025-04-02-framework-web-17.md)
1. [CSP Enhancement](./2025-04-19-framework-web-18.md)
1. [Spots By Date and Stats Pages](./2025-04-22-framework-web-19.md)