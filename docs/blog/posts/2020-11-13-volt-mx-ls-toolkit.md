---
slug: volt-mx-ls-toolkit
date: 
  created: 2020-11-13
categories:
  - Domino
tags: 
  - Domino
  - LotusScript
  - Volt MX
comments: true
---
# Volt MX LotusScript Toolkit

Earlier this week Jason Roy Gary announced the [Volt MX LotusScript Toolkit](https://github.com/HCL-TECH-SOFTWARE/volt-mx-ls-toolkit). It's important to put some background to manage expectations. There will be an [OpenNTF webinar on December 17th](https://openntf.org/main.nsf/page.xsp?name=Interact_With_Us&subName=Webinars) where we will explain more about our aims for the project and provide a call-to-arms to the community to join us driving this forward. I encourage everyone to attend if you're interested in using Agents outside the Notes Client or a Form's WebQueryOpen and WebQuerySave methods. But in advance, let's cover some questions I expect people to have.

<!-- more -->

## Is It Ready To Use?

At this point the script library is a functioning preview. It was designed (in less than one two-week sprint) to provide a proof of concept against a number of goals, goals which it achieved more successfully than I expected. It is certainly some way short of being fully production-ready. For example, there is nothing yet to convert date fields - in or out. But it covered enough functionality to be used for the Volt MX demos at the start of Digital Week, even though that was not the reason it was built. And more importantly, it is structured deliberately to be used beyond just Volt MX.

## But It's Called **Volt MX** LotusScript Toolkit

Yes, but that's because there's a class, VoltMXHttpHelper, which automatically extracts a specific payload.

- unid: the UNID of the document to act upon, which you can retrieve with `.getActionDocUnid()` and `getActionDoc()`.
- dbPath: the database to find that document in.
- payload: an array of fields and values to update, which is done via `updateActionDoc()`.
- returnFields: an array of fields the class can automatically return via `addReturnFieldsToResponseBody()`.

You can pass that payload from anywhere - Volt MX Foundry, Node-RED, Postman, or any web app. You don't need to pass all of that payload, and can pass additional content as well. The payload is designed for common functions that you might want to do, that's all.

If you don't need to pass any of that payload, you may be better using the parent class, `NotesHttpJsonRequestHelper`, which just expects JSON in and JSON out.

If you need something other than JSON in and out, _that class's parent class_ `NotesHttpRequestHelper` is the one you want.

## When Are You Going To Finish It?

This is not intended as an HCL product or a set of classes built into Domino and supported by HCL. This is more LotusScript than I've written in the last year at HCL. Your apps are the ones where it needs to work, you are the ones who are best positioned to drive scope and probably better skilled to do the development.

Yes it has some innovative functionality with [fluent methods](https://en.wikipedia.org/wiki/Fluent_interface) and some quite advanced use of classes. But it's by no means beyond the understanding of most LotusScript developers and I would recommend a 19-year-old article on object oriented features of LotusScript, which was a very useful resource for building classes. **UPDATE** the article in question was on IBM developerWorks and unfortunately is no longer available.

This is intended as a joint HCL and community effort. The vision is that this will be a new kind of OpenNTF project, with an approach and structure more akin to OpenNTF Domino API. We need people to develop it. We need a project team to decide on what should be in and out of scope. We need people to do documentation and write samples. We need people to test and pick up issues on GitHub, because you'll have the environments and apps to better validate bugs and test.

And if there is interest in porting the libraries back to Domino 10, where NotesJsonNavigator is read-only, the community should be able to do that.

If there's really a need, the community can port it back before any of the NotesJson classes, so it would work as far back as Domino 5!

## But I Have To Copy And Paste Libraries In

Yes. Same as you do for OpenLog. But because it's in Git you can also see what changes are made, and decide if you want to pull in updates. And Script Libraries can inherit from a different template, to make that easier.

Plus, you may not have noticed Jesse Gallagher picked up the **Import and Export for Domino Designer** project on OpenNTF, which allows you to import design elements into Domino Designer from a local filesystem or OpenNTF project. The project was designed for XPages Custom Controls, but it works for any design element. All it would need in the project is an extension.xml file defining the design elements to pull in. Then you could pull the code into your NSFs without leaving Domino Designer, if you wish.

## How Do I Get Involved?

Every good project needs a channel for discussion. Thankfully OpenNTF already has a Slack chat, and there's now a channel there.

## What About XPages?

Converting LotusScript to Java is not difficult. Creating Java classes - or SSJS Script Libraries - for XAgent XPages would certainly be feasible, if there is a desire to do that. To be honest, my personal recommendation would be:

- if you want to re-use LotusScript code, call agents.
- if you want to re-use Java / SSJS business logic, use XAgents with a small framework that extracts a payload along the lines of the one for the VoltMXHttpHelper into viewScope variables.

But that too should be open sourced.

## Want To Know More?

As mentioned, come along to the [OpenNTF webinar on December 17th](https://openntf.org/main.nsf/page.xsp?name=Interact_With_Us&subName=Webinars). We'll explain more about the decisions behind the framework and the approach, dive into the code, and hear from the legend Rocky Oliver - the only other person to date who has consumed the library.