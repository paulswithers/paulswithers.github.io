---
date: 
  created: 2016-07-13
slug: thoughts-on-domino
categories: 
    - Editorial
tags: 
    - Editorial
    - Domino
---
# Thoughts on Domino

The key to any relationship is periodically stepping back and appreciating the good points in contrast to the little annoyances that grate, so that you're not distracted by the first pretty young face (or muscular torso, depending on your predilection) that you encounter. When you thinking it might be time to leave the relationship, that is the most crucial (though most difficult) time to evaluate honestly and dispassionately what you have / had. Because if you don't, sooner or later you'll find different annoyances that grate; or you'll find something you took for granted and absolutely needed is missing from your new love; and before you know it that love too will turn sour and you'll be crying into your alcohol bemoaning wasted years and shattered dreams while looking at a bank account that's been wiped out by periodic divorce settlements.

<!-- more -->

So I'm taking a few moments to evaluate what Domino provides, what I use to a greater or lesser extent, particularly what I take for granted, to better identify what's important. Maybe what I provide here will also be of benefit to others. But at the very least, it will prove a useful touchstone and checklist (drawn from a review of documentation and server settings, as well as thoughts about various production applications I've been involved in), for now and for the future.

One point worth stressing, for others reading this, is that my Domino administration skills are limited to what, as a developer, I've needed to get to learn specifically for my applications. The vast majority has been off-loaded to specialists. So there are definite aspects in what follows which are not as complete as they could be.

## What Domino ISN'T

First off, let's put the rhetoric aside. Domino isn't:

- A mail platform. Sorry technology giants, it's not.
- An application development platform. Sorry developers, we may love it, but it's not.
- A NoSQL database.

If it were that simple, there would be no debate, the roadmap would always have a five-year and ten-year plan, the platform would be modern, and iNotes, Verse and all applications would be on XPages and in the process of being made available as XPages on Bluemix for cloud customers. Or conversely, Verse would not need Domino as a backend, related databases like Resource Reservations would be available on Bluemix with e.g. Cloudant backend and A.N.Other framework, migration tools would convert applications as easily as they can email. But none are true.

So let's deconstruct why that's the case.

### No SQL Database...And More

NoSQL gave Domino a flexibility over RDBMS in its early days. Then we were told that enterprise applications needed to use RDBMS. But then developers rebelled against DBAs and started using a new breed of NoSQL. Yes, there are issues with things like Domino view indices, but that was in the days when most Domino applications held all the data and all the design in the same NSF. XPages has made more developers challenge that design paradigm, to shard data across more databases and also across more documents. Meanwhile, NoSQL alternatives often focus on ease over security, choosing not to reproduce the kind of security Domino's NoSQL database has had for so long at document and database and server level, and yet data security nightmares regularly hit the headlines. There have been some proprietary extensions to NoSQL databases to simulate this, but personally that seems like paying a hefty divorce settlement to get a new girlfriend who looks like the old one. It's not a sentiment shared by all, but this is about my personal journey.

But the people who said big data meant RDBMS have since moved to graph. OpenNTF Domino API has had graph in development for over a year, I've used it on a number of occasions including semi-production applications. And the ability to combine NoSQL data and graph data, using Java interfaces for easy schema management and out-of-the-box componentization of data objects, gives a huge degree of flexibility. And all without requiring any view indices.

The NoSQL database also includes data objects that manage both architecture as well as data - the design elements. The fact that they are, effectively, Notes documents is worth considering.

### DAS

If you're developing using a JavaScript framework and all you want is very basic CRUD, DAS is available to deliver access to documents and views via simple configuration. DAS is the equivalent to the basic REST service calls for many NoSQL databases like Cloudant. Needless to say from what I covered above and for anyone who's read my blogging for Intec, DAS is not for me.

### Domino API (Java / LotusScript / C)

In terms of "design", few databases just use server-side scripting to manage CRUD events. Server-side scripting is used for business logic, workflow routing and database management. This means not just basic REST services like those exposed for mail and calendaring, but a complete API to do more than update values passed from the UI to the database layer. The API can be used to send emails (regardless of whether the user has a Domino mail database), create databases, modify view designs, manipulate folders, update indices, query servers, manage access rights, manage users, manage administration processes on the server and more.

That API has been extended in OpenNTF Domino API to allow more flexible interaction with data, more standard code structures, more readable code and some extensions around those API calls. Developers like [Karsten Lehmann](https://github.com/klehmann/domino-jna) have gone a step further and exposed lower-level C API functionality to Java.

### Directory Management

Domino can manage its own authentication, with out-of-the-box server and client authentication against one or more directories managed within Domino itself. It doesn't and cannot cover all requirements all of the time, but it's very widely used and it just works. Combine with replication (see below) and it solves a problem that has been ignored for years in large, worldwide cloud applications.

If the proper name change administration process is used, Domino can then ensure names are updated in Names, Authors and/or Readers fields in selected databases. The administration process for this can also be kicked off programmatically. Name changes, like archiving, may often be ignored in initial development either because of complexity or low impact (for example [XPages Help Application](https://xhelp.openntf.org/) on OpenNTF ignores it, so if a name change occurs, bookmarks would be lost). But they occur and they may come back to bite you with inaccurate data or more manual data fixup.

Alternatively, security could be handled within an application itself, by authenticating against other Domino data or external sources.

#### LDAP Service

Domino also has an LDAP service. I don't fully understand the administrator help about LDAP, so I don't fully understand how having or losing that impacts my application development. But I have seen servers without the LDAP task running where authentication still works. So it seems to be independent of authentication against a Domino directory. The fact is that while I'm developing on Domino, I don't have to care too much. If I'm developing on something else though, I may need to understand more about LDAP, find someone who does, or ignore it and hope it doesn't matter.

### Indexers

Views and full text indexes get built automatically with Domino. There may need to be some tuning or optimisation, both in terms of application design (for example, if @Now is used), data management (archiving) or in task administration. But in many cases, it just works. A recent fix pack added live view refresh, though it was poorly documented.

### Archiving

Automatic archiving can be enabled at application level via Database Properties, enabled based on age, lack of modification, expiration date or inclusion in a view. It may not be heavily used, but if relevant it is easily configured.

### Replication

Whether scheduled or manual, complete or partial, clustered or standard, Domino replication is a powerful strength. Domino replication can also run across domains.

### Clustering

Databases can also be clustered within a domain, whether for scalability or failover.

### Security

Domino security is flexible and powerful. It can be server-level, application-level, document-level or field-level. It can be managed via groups, user names, organisational units or roles. There is a level of flexibility that few alternatives, if any, offer (as far as I am currently aware).

### Auditing

Many servers log user activity, as Domino does. But out-of-the-box Domino also captures creation date-time and user, last modified date-time and user, as well as last modified date-time of every single field on a document. That information can be viewed in Document Properties (via Seq Num property, cross-referenced with $UpdatedBy) and programmatically (`Item.getLastModified()`).

### SMTP

Domino routes email as well. This is regularly leveraged in applications for workflow and reminder notification.

### Scheduling

Domino agents are one of the areas that have not been modernised. LotusScript is outdated and proprietary, Java agents promise a lot for developers who have embraced Java but fail to deliver (memory leaks, inability to easily re-use Java code elsewhere in the application etc). But it is a heavily leveraged area that virtually all existing Domino developers are comfortable with. If considering an alternative, they will need to get familiar with alternatives.

Under scheduling also comes scheduled admin tasks, like compacting, fixup, design updates, as well as others.

### DOTS

DOTS (Domino OSGi Tasklet Service) is an alternative for scheduling, but has never been officially supported by IBM for development so has lacked good examples from IBM, and again cannot leverage application logic. It also doesn't have access to a number of OSGi plugins the XPages core has access to. This can make development frustrating, as the only resolution is to copy the plugins across to the osgi-dots folders on the server (taking backups in case upgrades remove them again!).

### HTTP Server

In recent times Domino has been leveraged heavily as an HTTP server. There are many alternatives out there, and with XPages on Bluemix IBM are trying to use Bluemix as the HTTP server and a separate Domino server for the data. (The point of paying for another HTTP server runtime when you already need one for the data server is beyond the scope of this post and, if IBM do not deliver enough enhancements to XPages and Domino, moot.)

### OSGi

One of the most popular aspects of Domino in the last few years is OSGi. Instead of copying and pasting code between applications, OSGi plugins have been used to load code once for the whole server. With the Update Site database, these extensions are lazy loaded, untouched by upgrades and can be replicated across servers.

### Expeditor Web Container

Although this has not been used much, it's an aspect of the Domino server I've started using and planned to use more. Standard web applications, wrapped in an OSGi plugin, can then be deployed. Again, this area is out-of-date, only using the Servlet 2.5 specification. Most modern web frameworks (e.g. Vaadin) have documentation which demonstrates annotations which require Servlet 3.0 specification or higher.

### XPages Runtime

XPages has had a lot of press with Domino, because over the last seven years IBM have made it the future of Domino application development. More recently, on premises application development has been sidelined for XPages on Bluemix. But XPages is just one application development framework that can be used on Domino. There are a number of strengths - rapid development (though not as rapid as some salespeople might have you believe), component-based approach (OneUI has been replaced with Bootstrap which has been updated, all just with renderers), open sourcing that included accepting community code. But lack of understanding of the refresh lifecycle by developers and a reluctance from IBM to recommend better practice (e.g. using Java instead of SSJS) has frustrated. It has also brought into sharp focus out-dated elements (Java 6, the IDE, a draconian Java security policy that chooses to ignore Domino's own security). It has also brought more developers to other web development frameworks and, as outside ICS, there is no consistency on which other frameworks ICS developers prefer.

## Summary

So that's the stack I am currently most familiar with. Different customers may use some or all parts of it. Most applications will only use a subset. Projects will be able to compromise on some and use workarounds for others. The key is knowing what's used for a specific situation, so any future steps are well-planned without nasty surprises around the corner.

## The Present

Most Domino developers use only the full stack. For some time, some have been using Domino as just a database and web server. Others have been using Domino as middleware, using its runtime but a different backend database. More recently, I've been experimenting with Websphere Liberty as an alternate web server, Vaadin as an alternate application interface framework and Domino just as a database storing data as graph (although the server would also be of use for SMTP / scheduling / auditing etc). Removing Domino for me, someone not extremely familiar with alternatives, leaves a lot of learning, questions, pitfalls, concerns and (I suspect) painful learning. For anyone who uses the whole stack and has not pushed their learning over recent years, it must be terrifying.

But I don't have any significant issues with the NSF, whether for storing traditional NoSQL data, less traditional data like Java objects in Notes Items, or graph data objects. I also like the RAD component-based and extensible approach of XPages, although it offers no advice or opinion on best practice. The degree of understanding I've gained over the last seven years means a lot of comfort with stretching the framework, diving into Extension Library code and building my own extensions. I still believe there is untapped potential in XPages and customers are only still starting their journey with it.

This is why the recent position of IBM has frustrated me, because it leaves the app dev community in limbo, has put a halt to further empowerment of the community and has undermined a lot of community work and initiatives that were in progress to enhance the developer experience. (Many of these may not be widely known about but would be welcome to developers.)

## The Future

In terms of (any) future for Domino or ICS application development, we will have to see what IBM announce in the coming months, whether developers are engaged by it, what timeframe is stated, whether developers believe they will be met, whether developers are willing to wait, or whether developers reduce or remove their reliance.

This blog will cover the learning I gain for my own personal development, even if others do not choose to follow my path. I've long found the benefit of using Google (or books!) to index my learning and remind me of what I've learned but forgotten. So as a starting point, I'll summarise where I am with Websphere Liberty, Vaadin and graph in more detail.