---
slug: danger-mid-code-pro-code
date: 2019-10-01
categories:
  - Coding
tags: 
  - Atom
  - Coding
comments: true
---
# Danger of Mid Code to Pro Code

People discussing Domino application development have been using a new term since early this year - "mid code". This has become necessary because of the evolution of Domino development since Domino V10.

<!-- more -->

- "low code" is a drag-and-drop web IDE being provided by HCL Leap support for HCL Domino V11, aimed at business users. The output will be a web application.
- "pro code" relates to JavaScript and Java developers, developing applications from scratch or taking the output of those low code applications and extending them. Again, this is intended for web applications or server-based processes.
- "mid code" has become a term for development for Notes Client or HCL Nomad, the mobile client. It has also been the term for XPages development. XPages is a web framework based on JSF but developed via XML markup, which a builder converts to Java classes. As with other Java web frameworks, JavaScript can be embedded in it. Server-side coding is via Java classes or "Server-Side JavaScript", a pseudo-language which the editor validates, the builder stores as strings, and the runtime parses as calls to Java methods.

Although some individuals may have the ability to progress from one level to another, some will not. So it's important to differentiate the different levels and ensure no assumptions or expectations for people to cover multiple levels. The key to moving from one level up to another is understanding what complexity is being abstracted for you by the frameworks.

When you forget what a framework does for you and move to a different level, it's easy to think something should work when it clearly won't when you step back and realise what is required. And that's something I've just found myself guilty of, losing some hours in development as a result.

The scenario is posting ATOM to a web API. As an XPages developer for nearly ten years, I've been writing XML for a long time. But for this, it was a case of manually writing XML as a string in JavaScript to post to the web. The XPages IDE is an XML editor and Properties editor. The Properties editor converts what's entered into XML in the XML editor. The XML editor validates at build time, to ensure it's valid XML. And the key here is that the Properties editor conversion and the XML editor validation ensures valid XML. Manually writing XML as a string in JavaScript in VS Code didn't do that. And the receiving web API just ignored whatever was invalid XML in my string. So I was posting HTML, something like "\<b>My title\</b> is some text" and defining the XML object's contentType as HTML, the HTML tags were just getting ignored.  The result was not an error, but a partial value posted, just "is some text". Finally I realised that ATOM is XML and XML requires escaping invalid characters. Problem finally solved and lesson learned.