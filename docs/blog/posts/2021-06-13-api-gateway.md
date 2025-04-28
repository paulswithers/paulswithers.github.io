---
slug: api-gateway
date: 2021-06-13
categories:
  - Domino
tags: 
  - Domino
  - LotusScript
comments: true
---
# REST API Gateways

Three years ago I presented at IBM Think I presented a session called [Domino and JavaScript Development Masterclass](https://www.slideshare.net/paulswithers1/ibm-think-session-8598-domino-and-javascript-development-masterclass) with John Jardin. In that session I talked about the various REST options for Domino and used the term "API gateway". Particularly at this time it makes sense to expand more on what was in the slides.

<!-- more -->

## Domino as An Application Server

The usual approach with REST for NoSQL databases is direct CRUD access. And that has been done for Domino in the past with thing like Domino Data Services. But there's a crucial difference. Domino is not _just_ a NoSQL database server, it's not just a database and indexes of documents. It's an _application_ server.

Let me explain the impact of that. It means with the same authentication, access can be via a Notes Client, via HTTP (in various technologies) and via gRPC if App Dev Pack is installed. More crucially, by default the database can be accessed via all three protocols - which is why some Domino customers are reluctant to turn on the Domino HTTP task. And HTTP access could be via a web application, a custom REST service, a programmatic service via agents or even web services. Whereas a traditional NoSQL server may be locked down to certain servers or even locked down behind a firewall, that's not likely to be an option for Domino.

Even more critically, the same Domino database can often be intended to be used via user interfaces. A REST service may need to be built for an NSF that already has a Notes Client front-end. It may also have a web UI in some format as well.

But Domino isn't just a NoSQL database. It can contain business logic stored quite literally at the same level as the data. After all, agents and script libraries are stored in design notes, just as the data is stored in design notes. That _can_ be leveraged and typically _would_ be leveraged by Domino developers. To ignore that undermines what Domino is.

## API Gateway

This all means Domino needs to have a REST API gateway. Authentication is not enough. Validation is required. The use of computed and computed for display fields means some pre- and post-processing may be required. The ability to leverage some of that business logic _may_ be relevant.

This is **critical** whether or not the Domino developer is building the web application that uses the REST API, because rarely will it be possible to secure the Domino server and database so that the web application is the _only_ REST entrypoint. It may be unlikely for REST to be leveraged outside of a provided web UI, but it's not impossible. And no in-built method has given Domino developers the tools to be certain that REST access is not via e.g. Postman. It may seem unlikely, but as a developer, I was never satisfied with relying on that.

## Division of Responsibility

And this leads me onto the next critical point from my experience working for a business partner. In most cases, the Domino developer was not the one building the web application that consumed the REST service. That was also the case for IBM Think 2018 - I built the Domino REST API gateway, John Jardin built the web application.

**But who is responsible for supporting data integrity issues?** It's not the person building the web application, it's the Domino developer.

**So who should be responsible for ensuring data integrity?** The Domino developer.

And if you're wondering how important that is, think of the REST service in this way. It's basically an import agent that third parties can call. And how often has any Domino developer created an import agent with no validation in it?

## How To Code The API Gateway?

Historically, advanced XPages developers like myself may have created an OSGi plugin using Apache Wink. Although it's a dead open source project, it's the only REST API technology that comes out-of-the-box with Domino HTTP. For less experienced XPages developers, XAgents can also be done - providing developers are comfortable using Apache Wink. Domino developers who know NodeJS or Java can also use the App Dev Pack, if they have installed all the components required for authenticated access. Another option is SmartNSF, if developers are brave enough to try Groovy.

But what proportion of Domino developers fit those categories?

The Volt MX LotusScript Toolkit is an option almost all Domino developers could leverage. But it means the entry point is always agents. It's far from complete, even though some enhancements were made for DOMI.

And whichever of those options is chosen, all still require skills in writing an [OpenAPI specification](https://swagger.io/specification/) for a third-party to use it. None of the options allow auto-generation of an OpenAPI spec, which is what modern web developers will expect. The OpenAPI spec then needs hosting, although I did write a [blog post](https://www.intec.co.uk/publishing-secured-swagger-spec/) on how to achieve that.

## Don't _Code_ It!

The best answer is to allow Domino developers to _configure_ an API gateway rather than code it. Domino REST API, a.k.a Project Keep, can be used by _any_ Domino developer. If customers have hired JavaScript developers, they will also have the skills to use it. More importantly, if Domino is ready to take to non-Yellowverse conferences, it can also be used by _any_ developer of any language. It only exposes the NSFs - and parts of those NSFs - that the developer chooses. And it exposes - out-of-the-box - an OpenAPI spec. For LotusScript developers it allows agents to be leveraged.

And most importantly, it keeps control in the hands of the developers who will have to support the data.

It won't cover all scenarios, which is why extensibility is still important. And although integration with third parties is a clear use case, there is still education required on building a web application outside of HCL technologies. That is actually an easier discussion with whitespace markets.

Whether it's an effective REST API tool is unclear. But the _right_ REST API has to provide an API gateway that existing and new developers can use.