---
slug: mixing-webxml-and-annotations
date:
  created: 2016-10-24
comments: true
categories:
  - Vaadin
tags:
  - Vaadin
  - Java
---
# Mixing web.xml and Annotations

Over the last few months a lot of what I've had to do has come from combining frameworks. Usually one of those frameworks is [Vaadin](https://vaadin.com/home "Vaadin"). But whenever you're combining frameworks of any kind, it usually means some content is pre-configured, which may conflict with settings in another framework. If you're not familiar with the framework and the technologies in use, it's a lot like looking at hieroglyphics without a [Rosetta Stone](https://en.wikipedia.org/wiki/Rosetta_Stone)! The result is a lot of learning on the job.

<!-- more -->

Over recent releases Vaadin has moved from using a web.xml file for configuration to annotations. Some of my work still requires using the web.xml - IBM Domino currently runs the Expeditor Web Container, which uses an older servlet container that only fulfils Servlet 2.5 specification. But where possible I look to use more modern approach, and running on Websphere Liberty that's possible.

But a recent framework still used a web.xml. When I tried combining them, instead of getting a button displayed, all I got was the text. It didn't seem to be loading the Vaadin theme properly. After moving various classes around, amending various settings, trying newer versions in the pom.xml and still not getting anywhere, I decided to come at the problem from the other end. I created a standard Vaadin Maven project and tried adding the web.xml, copying and pasting the basics across from the project that was not working. Promptly it failed, which enabled me to isolate the responsible attribute of the web-app element, **metadata-complete="true"**. It made sense straightaway, and the tooltip documentation confirms this:

> Attribute : metadata-complete
The metadata-complete attribute defines whether this
 deployment descriptor and other related deployment descriptors
 for this module (e.g., web service descriptors) are complete, or
 whether the class files available to this module and packaged with
 this application should be examined for annotations that specify
 deployment information. If metadata-complete is set to "true",
 the deployment tool must ignore any annotations that specify
 deployment information, which might be present in the class files
 of the application. If metadata-complete is not specified or is set
 to "false", the deployment tool must examine the class files of the
 application for annotations, as specified by the specifications.
>
Data Type : boolean  
Enumerated Values :
	- true  
	- false

There is a [trade-off in startup performance](http://stackoverflow.com/questions/9820379/what-to-do-with-annotations-after-setting-metadata-complete-true-which-resolv) of the application - jar files need to be iterated for [servlet annotations, web fragments, injected resources etc](https://developer.jboss.org/thread/234119?_sscc=t). But if you prefer annotations over XML, it's worth bearing in mind.