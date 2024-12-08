---
slug: xpages-tags-renderers
date: 
  created: 2024-08-01
category: XPages
tags: 
  - Domino
  - XPages
  - Web Components
  - Vaadin
comments: true
---
# Understanding Tags and Renderers

There are a few people in software development who have shaped my career by their approaches. Three of those whom I'm particularly glad to have known are Nathan T. Freeman, Tim Tripcony and Jesse Gallagher. Although Tim and Nathan are no longer with us, I am fortunate enough to have experienced sessions by and with them, got to know the open source code and videos they created, and worked with them on open source projects. They were brilliant developers, willing to spend time with those who wanted to learn and give back. Fortunately, I'm still able to draw on the knowledge of Jesse and the XPages community should be rewarding him for his continued work. And when you encounter such clever people, it's foolish not to want to learn all you can.

<!-- more -->

In the case of Nathan, Tim and Jesse, and in the context of this blog post, three pieces of work are particularly relevant:

1. Nathan's [XPages Starter Kit](https://www.openntf.org/main.nsf/project.xsp?r=project/XSP%20Starter%20Kit)
2. Tim's [NotesIn9 video on global custom controls](https://www.youtube.com/watch?v=Y4Rn_3Bmy0M)
3. Jesse's [Notesin9 video on custom renderers](https://www.youtube.com/watch?v=cf__qwY3QVM)

## Tags

### XPages

The XPages interfaces for "tags" for developers are two-fold:

- Design pane uses no-code approach of components picked from a visual list of available components which developers drag onto a canvas and use a properties panel to hard-code values, map to Java getters and setters, or enter pseudo-code which gets stored as string values with a prefix to denote the ScriptEngine Java should process the string with. If you don't recognise this description, I'm talking about Server-Side JavaScript.
- "Source" pane uses a low-code approach of XML tags with attributes which can be manually typed into the XML or set via the properties panel.

Why "Source" pane? Because, if you understand what XPages is, you'll know the XML there is not the *actual* source code. The *actual* source code is auto-generated as Java classes and can be found in Package Explorer view, in the "Local" folder. Here you'll find Java objects for each tag where the XML attributes map to properties and the attribute values passed to Java property setters.

Of course the *actual actual* code that is run is not even this, it's the compiled byte code in .class files.

### Vaadin

Some years ago I dabbled a bit with Vaadin. Like JSF, the framework behind XPages, it's also Java code, with Java objects also mapping to components. Vaadin also has a low-code WYSIWYG editor, like the design pane in XPages. The concept is the same.

### HTML

The XML in XPages looks a lot like XHTML, which also has opening and closing tags with attributes. Indeed standard XHTML tags like `<span>` and `<div>` can be *appear to be* used in XPages.

But the truth is, you're not actually putting an HTML span or div tag on your XPage, as you'll see if you inspect that Java class that holds the actual source code. If this comes as a surprise to you, [there's a blog post for that](https://www.intec.co.uk/html-or-xpage-component/) which I wrote over ten years ago. Go read it, I'll still be here when you come back.

XHTML in standard .html files does the same kind of thing as tags in XPages. Most of the time there's not much between what you see in your source code and what you see on the web page. Think of a script tag or a span tag with style or other attributes.

But then there are other tags that don't work in such a basic way. Create an HTML page, add an input tag with type set to "date". Now preview it in a browser, inspect the element and see what happens when you click on it. What's happened with what's inside the input tag? We'll come back to that later.

### Web Components

Web components use the same concept again as XPages. You use custom tags in your HTML and define attributes on the tags. So how do those custom tags map to the content in a browser?

## Renderers

**Renderers** are the key to all this magic. This manages how the XML or XHTML gets *rendered* on the browser.

### XHTML

Everything in HTML is backed by a renderer. If browsers didn't use a renderer, you'd see the HTML text in the browser instead of a UI. There's another layer of rendering as well, UI in the browser's main area and XHTML on the Elements tab of a browser's developer tools.

A script tag, span tag or other basic HTML tag just gets rendered as is. The browser knows those specific tags and handles mapping functionality or user interface.

But let's come back to that input tag with type set to "date". The Elements tab has something that wasn't in the HTML file when you click into the field: something called a Shadow DOM with a bunch of tags. How did this get here? The browser's **renderer** converted the **tag** to a much more complicated layout, **multiple tags**. And the HTML elements get modified depending where the cursor is.

### Renderers All The Way Down

But it's not just a browser that has a renderer. The same concept is used throughout web development. XPages, Web Components, Vaadin: they all use **renderers** to convert the **tag** or Java class to HTML comprising one or more tags.

And like the browser's renderer, sometimes it's a one-to-one mapping. XPages `<xp:br>`, `<xp:hr>` or `<xp:head>` tag map to HTML `<br>`, `<hr>` or `<head>` tags. Others are more complex. `<xp:viewPanel>`, `<xp:dataView>`, `<xp:navigator>` have renderers that write out much more complex HTML.

Web components do the same thing: the tag maps to a JavaScript class that has a `render()` method, some of which adds event listeners which map back to JavaScript functions which may modify the rendered HTML even more.

### Rendering Children

And whether it's XPages, Vaadin or Web Components, sometimes the tag contains child tags. The renderer needs to handle three parts: what HTML to render at the start, rendering child tags, and what HTML to render after rendering the children.

And this is the difference between a renderer and a tag.

A **tag** has its own renderer and automatically handles converting the tag, its attributes and its children. You get what it gives, in the order it gives it.

A **custom renderer** (which you'll *have* to write for a Web Component) allows you to *choose* what HTML gets written and in what order.

And in XPages, the highest level tag is `<xp:view>` with its renderer "com.ibm.xsp.renderkit.html_basic.ViewRootRendererEx2".

But Domino developers have been writing custom renderers with web development for years.

### Domino Agents

Every time you write a Domino web agent, you're writing a custom renderer. Everything that you return using `Print` statements is your renderer. Sometimes it will be rendered as a JavaScript instruction, for example to redirect to a new page. Sometimes it may be a JSON object. Sometimes it will be HTML. Sometimes the content type might tell the browser to render an Excel spreadsheet.

It's all a custom renderer, written by the developer.

And though the technologies are different, the fundamentals of the *process* that happens under the hood are the same.
