---
slug: java-outside-domino-eclipse
date: 2019-09-17
categories:
  - Java
tags: 
  - Domino
  - Java
  - Vert.x
comments: true
---
# Java Outside Domino in Eclipse

Recently I've been diving back into running Java outside of the Domino HTTP stack, picking up some work I did quite a few years ago playing with [Vert.x and Domino](https://github.com/paulswithers/vertx-domino) based on Stephan Wissel's blog series on [Vert.x and Domino](https://www.wissel.net/blog/2014/07/adventures-with-vertx-64bit-and-the-ibm-notes-client.html). Quite a few things have happened since I was last working on the project, not least the laptop I had at the time got rebuilt, I have got a new laptop, several version of Eclipse have been released and XPages SDK has been deployed to the Eclipse Marketplace (thanks Jesse Gallagher).

<!-- more -->

One thing I've learned with modern IDEs is that you don't just install them and go. Even with Domino Designer, if you use XPages and Java to any real extent, there are a host of plugins that need installing, there are a variety of Java preferences you set (and hopefully [backup](https://www.intec.co.uk/quick-setup-restore-of-domino-designer/)). Beyond Domino Designer, there are a host of plugins or extensions that need to be installed, configuration of things like Java JREs, related software, Maven repositories etc. It's not a five minute job to just get up and running. And you will often come across a problem you didn't find last time. The necessity to understand your development environment is crucial.

Even when I was developing with Vert.x last time, there were a lot of aspects I documented. But there were a couple of new issues I encountered, with rather vague error messages.

## Problem 1

The first was one Stephan covers in his blog series on Vert.x and one that's covered a lot elsewhere when trying to run Java code that interacts with Domino but is external to Domino:
`SEVERE: java.lang.UnsatisfiedLinkError: no lsxbe in java.library.path`. Running the Vert.x verticle from Eclipse ran fine, but as soon as I tried to hit the associated web page, it threw this error.

This usually means not being able to find the Notes / Domino runtime when running. This was confusing, because I had jars in the Project classpath. I also had old code adding it to my local Maven repository. I tried setting environment variables in and out of Eclipse, trying to add various settings to the Run Configuration, but to no avail. Importing the project into a separate Eclipse that was set up to use the Domino JRE worked fine. So it was clearly something to do with the classpath settings for the Run Configuration.

This was also where source control came in very useful, even for a project with just myself as the developer. It became much easier to roll everything back to the starting point - not just once, but twice!

It was then I looked at the classpath in detail and found several references, not only to the Domino jars but also the Notes Client Notes jars. I eventually tracked that down to settings in the global JRE, set up for another project to point to Notes in addition to the AdoptOpenJDK JRE. Removing them to ensure there was only a single set of the Domino JARs available at runtime solved that problem.

## Problem 2

That then left a second problem: `Error writing to process file pid.nbf`.

Again, it's a problem mentioned in various places on the internet and in IBM technotes. In many cases, reading the analysis I was not confident the true cause of the problem had been properly diagnosed and the solution seemed more "this was tried and it worked", without properly clarifying why it worked. I also had that niggling feeling I'd hit this problem before, but couldn't remember the cause.

I eventually found a technote that seemed to talk about permissions of the running user (on Linux, I believe). This helped me pinpoint the cause. I had installed Domino on Windows in `C:\Program Files`. Even though I was running the code from Eclipse, I wondered if it was not necessarily running "as me". Sure enough, setting permissions to the Domino folder and all subfolders solved the problem.

Problems solved, code running, and a deeper understanding gained of what's required.