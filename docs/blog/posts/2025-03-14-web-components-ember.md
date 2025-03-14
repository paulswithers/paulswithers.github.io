---
slug: web-components-ember
date: 
  created: 2025-03-14
categories:
  - Web Components
tags: 
  - Web
  - Web Components
comments: true
---
# Lessons Learned from Including Web Components in an Ember.js Application

One of the key skills when working in IT research is the ability to work out how something works, either by looking at the code or being able to see the process behind a button or API call on your screen. The inevitable consequence then is that you understand how things work, you see comparisons between technologies or frameworks, and you begin to identify whether or why something will work or fail. You also gain understanding of various possible approaches and which is the right one. That results in a "lessons learned" blog post like this one.

<!-- more -->

Over the past few months I've been doing some work on-and-off on the [HCL DIgital Solutions Community](https://developer.ds.hcl-software.com/). But obviously this has included some development, with associated learning. As part of that, I had to dynamically add repeated chunks of HTML to part of a page. It's a good use case for Web Components, as I've talked about in [my recent tutorial series](./2024-10-21-framework-web-8.md). For XPages developers, this use case is like a chunk of XML markup inside a Repeat Control's tag. Think of moving that markup to a Custom Control that's so self-contained you can copy it into any database, and you get an idea of their power.

But the framework I was integrating into was Ember.js. A quick search led me to this [discussion on using Web Components in Ember.js](https://discuss.emberjs.com/t/web-component-support/14880). But this was research, and I'm able to quickly create a web component, I went that route.

First, a bit of background on Ember.js and this application. This is what I've learned and inferred, so if it's not canonically correct, forgive me. It's a Single Page Application, which inserts components on the web page. Modern components in EmberJS use GlimmerJS. So the component is a JavaScript class which, like React, can define the HTML to insert or can map to a Handlebars template. In the HTML, a `did-insert` attribute is used to map to a JavaScript function in the component whenever it's inserted into the UI. The JavaScript Glimmer component's class has properties, and adding the `@tracked` annotation to the properties ensures the UI is repainted whenever those properties change. And `@service` annotations in the Glimmer component map to Ember.js services and routes.

There are a lot of similarities here to Web Components, but some additional power. There's a lot of custom HTML attributes for mapping to JavaScript functions. Also Web Components aren't part of a framework, so there's no convention for integrating with other JavaScript files in specific directories like "services". A framework has a specific structure to its applications, so builds those conventions. This provides specific challenges:

1. Web components have a specific lifecycle, Ember.js components have a separate distinct one.
1. You don't have easy direct access to the Ember.js objects.
1. You can't use annotations to access Ember.js services.

The first point meant just adding the HTML markup for the web component didn't work. The lifecycle methods of the component didn't trigger when moving from page to page, because it wasn't recreating the component, it was just re-rendering the HTML with new information for the Ember.js route provided. The solution - easy enough - required taking a programmatic approach. The flow was:

- From the `did-insert` call the JavaScript function to build the UI, passing the current HTML element.
- Call the Ember.js service to get the JSON either remotely or from local storage.
- Programmatically create the web component.
- Append it to the passed HTML element.

Another challenge (although it's no longer needed) was to call the Ember.js router from a `click` event in HTML elements in the web component. The eventHandler is defined in the web component, but that knows nothing about Ember.js and its router. The solution is one standard in web components - **CustomEvents**.

- The code creating the web component also registered an EventListener on the current HTML element, into which the web component was appended.
- The `click` event in the web component created a CustomEvent, passing details.
- The CustomEvent was dispatched.
- The EventListener's function (in the Ember.js component) caught the CustomEvent and used the data to pass to the Ember.js router.

## Summary

Is it easier to create a GlimmerJS component and insert that instead? Possibly, especially if something more sophisticated is needed, where greater access to the Ember.js framework is required. But that's a challenge to be addressed if there's the need, and possibly refactor this code for consistency, again if required.