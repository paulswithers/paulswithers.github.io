---
slug: postman-importance
date: 2023-07-15
categories:
  - Domino
tags: 
  - Domino
  - Domino REST API
  - LotusScript
  - VoltScript
  - REST Clients
comments: true
---
# Postman: The Crucial Tool for Any Microservice Developer

My history with REST development is long. In 2018, before I joined HCL, I delivered a session "Domino and JavaScript Development Masterclass" at IBM Think. When I posted about [my development tools in 2017](./2017-05-26-my-dev-tools-2.md), Postman - then just a Chrome plugin - was key amongst them. Then in 2020 I posted an [overview of Postman](./2020-07-05-postman.md). And just as both John and I used Postman as a crucial tool when building the application we showed at our session at IBM Think, it's the tool that should be used by anyone doing anything with microservices - which is what every scope your create for Domino REST API is.

<!-- more -->

What does the following code do?

```vbscript
Dim session as New NotesSession
Dim db as NotesDatabase
Set db = session.currentDatabase
```

Any Domino developer knows what this does. The more knowledgeable Domino developer may know that it calls C APIs to get the currently open Domino database. And for most Domino developers, this is a black box.

But what does the following code do?

```vbscript
Dim session as New NotesSession
Dim httpReq as NotesHTTPRequest

Set httpReq = session.CreateHTTPRequest()
Call httpReq.get("https://httpstat.us/200")
```

Some may think this calls a URL. The more knowledgeable Domino developer may know it triggers a process that uses C APIs to create a Domino object to store settings which will then be passed to libcurl to call a URL. Why is this important? Because although the first part is a black box, the second part most definitely is not.

When doing *anything* that makes HTTP calls, there's a part that's never a black box.

And that is crucial.

## Postman Use 1: Postman Console

The key with any HTTP request is understanding full details of headers and body of the HTTP request and response. There are different ways of finding those details for a successful request.

If you've got a web application, the browser's developer console can show you those details. This should never be under-estimated or neglected, for working out what a successful HTTP request should look like (if the application is working as expected) or cross-referencing (if the application is *not* working as expected).

For the hardcore developer, making curl requests via command line can give verbose details. Those who have seen Stephan's sessions on Domino REST API will be familiar with his command line example.

Postman is a low-code IDE where authentication, headers and body can all be defined by filling in fields. But this is where it's good to use the menu option View > Show Postman Console (or the shortcut code Alt + Ctrl + C on Windows, ⌘+Option+C on Mac).

## Postman Use 2: Cross Reference

If you have a working Postman request and are coding programmatic access, Postman is still extremely useful to cross-reference if the code does not work. This is something I've used for coding Domino Online Meeting Integration, configuring integration services in Foundry, coding Node.js integration with GitHub, and coding dependency management in VoltScript.

Many APIs, including Domino REST API, provide a Postman collection and environment, as I showed in the [April's OpenNTF webinar](https://openntf.org/webinars). But the **Import** button in Postman allows you to pass a variety of content, including [an OpenAPI 3.0 spec](https://learning.postman.com/docs/integrations/available-integrations/working-with-openAPI/) from either a downloaded file or a URL link. For Domino REST API, if the Domino developer is configuring a schema and scope for a third party, the OpenAPI page allows the third party to retrieve the OpenAPI specification for the specific scope.

## Postman Use 3: Generate Code

But what if you're coding the application yourself? This is the third use of Postman. From a Postman request, you can g[generate a code snippet](https://learning.postman.com/docs/sending-requests/generate-code-snippets/#generating-code-snippets-in-postman) for a variety of languages and frameworks, including C#, Java, JavaScript, Node.js, C, PHP, Python and Swift. It's worth bearing in mind that frameworks evolve, and the standard JavaScript `fetch` now seems pervasive and the preferred option for Node.js as well.

### JavaScript, Fetch and Chunked Processing

While mentioning `fetch`, it's worth drawing attention to [Stephan's recent blog post about handling chunked responses](https://wissel.net/blog/2023/07/handle-http-chunked-responses.html). Domino REST API uses these for certain endpoints like views. At this point, the choice of front-end technology affects the code that is needed for specific endpoints. And being able to test in something like Postman is important to understand headers involved.

But of course when you get to this point, it's just standard JavaScript / Java / fooLanguage for processing any REST service, nothing specific to the platform of the REST API. And if you're using a popular framework with a vibrant community of blogged and open sourcers, it's likely that it will be easy to find the answers.
