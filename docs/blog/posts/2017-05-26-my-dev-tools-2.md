---
slug: my-dev-tools-2
date: 2017-05-26
comments: true
categories:
  - Dev Tools
tags:
  - Dev Tools
  - REST Clients
  - Docker
  - Editorial
---

# My Development Tools - Part Two: Beyond Domino

Following on from my [last blog post](./2017-04-26-my-dev-tools.md) it's now time to move on beyond the tooling related to Domino and XPages.

<!-- more -->

## Eclipse

My preferred IDE for OSGi plugin development is Eclipse. Although I'm aware IntelliJ has become very popular, for me it makes sense to minimise the number of tools like it also makes sense to minimise the number of frameworks. So I stick to Eclipse. But although I started off using it for OSGi plugin development, it's now used for a lot more:  

- OSGi plugins  
- Vaadin  
- Darwino  
- Setting up and managing local development Websphere Liberty servers  
So it makes sense at this time for me to stick to Eclipse.

That also means a number of plugins installed into Eclipse:

- XPages SDK  
- Eclipse Color Theme (I've installed a version also into Domino Designer)  
- Vaadin  
- Various Maven and Tycho plugins that have automatically been added  
- Darwino studio and the dependent plugins  

I don't have all the plugins installed in the same Eclipse installation. I tend to have multiple installations. I'm still in the process of migrating them all, but I'll have separate Eclipse installations for:

- Domino OSGi development  
- Vanilla Java development  
- Vanilla Vaadin development
- CrossWorlds development with Vaadin  
- Darwino development  
That allows me to keep things pretty self-contained, and have Websphere Liberty servers where necessary and Tomcat servers for Darwino.

## Maven

As well as using Maven embedded in Eclipse, I also have Maven installed separately. Sometimes it's nicer and easier to use the command line interface (although I resisted that for some time!).

## REST Service Development

Those who follow my posts on [Intec's Blog](https://www.intec.co.uk) will know I've recently been involved in developing REST service plugins using OpenNTF Domino API's ODA Starter Servlet which I developed and then extended further as a Maven archetype. But developing the REST service is just one part.

### Postman

For testing a REST service, the Chrome plugin Postman is a very useful tool. It doesn't allow custom HTTP methods, but there are other tools for that. It does allow tests to be exported from and imported into it, which is very useful, particularly when setting up a new laptop!

### Swagger

For documentation and testing purposes, the standard tools are [Swagger Editor](http://swagger.io/docs/swagger-tools/#swagger-editor-documentation-0) and [Swagger UI](http://swagger.io/docs/swagger-tools/#swagger-ui-documentation-29) are standard tools. I've blogged about those on [Intec's Blog](http://www.intec.co.uk/tag/swagger/), and they are easy to install.

### NodeJS

If installed outside of Docker, Swagger requires NodeJS. And to be honest, if you're doing development, you're likely to run into something that needs NodeJS sooner or later, so it's worth embracing.

### Docker

But on my new laptop I can run Docker, so I've installed the Swagger Editor using the Docker image, which is much easier. Docker itself is easy to set up and once that's running, two lines of code will start the docker image of Swagger Editor.

Again, Docker is another piece of software gaining prominence and before long I'm sure most developers will be running - or packaging - at least one docker image.

## Web Services

Some older web application development requires web services, and for that I use SoapUI. This seems to be the de facto tool.

## My Blog

Although I blog heavily still on [Intec's Blog](https://www.intec.co.uk), this blog is on GitHub Pages. When I wanted to set one up, this was free and pretty easy to set up. But as a result, there are a number of tools I use. Of course SourceTree is used to push it up to GitHub for publishing, but you need to create and review the content.

### MarkdownPad 2

The blog posts etc are edited in markdown. Anyone who's used GitHub or set up a project on OpenNTF will be aware of markdown. It's a lightweight language for formatted text and makes a lot of sense for me as a replacement for "rich text" content in XPages. Yes, it's not as intuitive and doesn't have a nice editor for the web unlike something like the CK Editor. But I've come to believe that a web application should minimise contain minimal rich content like that, keeping such content in attachments.

But for editing .md files on your PC, I've found MarkdownPad 2 very nice. With Windows 10 there's a bit of a [workaround](http://markdownpad.com/faq.html#livepreview-directx) needed to get the Live Preview working, requiring installing Awesomium but that was very straightforward.

### Jekyll

It's important to see what a post looks like before submitted. For that Jekyll is the choice recommended to me by Eric McCormick (it's what GitHub pages uses anyway). That means installing **Ruby** and **Ruby Gems**. That then lets you run the ruby commands necessary to [install jekyll and bundler](https://jekyllrb.com/docs/quickstart/). Then I can go my blog folder in a command line prompt and run `bundle exec jekyll serve` and see my blog locally.

## Cmder

Following advice from Oliver Busse, instead of using the in-built Windows tooling for running from the command line, I installed Cmder. It is a significantly more powerful tool, and well worth using.

## Summary

I'm sure my toolset will only increase as time goes by. But it's significant how much it has changed during the last five years. The tools developers use are as much of a learning and training investment as the language and framework developers use. Developers and companies should focus as much on tooling as a requirement for jobs and as a focus for professional development. Many of these tools may be relatively intuitive for basic use, but some like Postman and Docker will require more than just basic skills to maximise their use.