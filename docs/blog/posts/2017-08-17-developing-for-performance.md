---
slug: developing-for-performance
date: 2017-08-17
categories:
  - Coding
tags: 
  - Editorial
  - Performance
  - Support
comments: true
---
# Developing for Performance

One of the themes which crops up from time to time in Domino application development and beyond is the theme of "performance". It's a topic which makes me grit my teeth because of the basic premise. Most articles start from what, for me, is a narrow terms of reference: performance optimisation being about how quick a specific amount of data can be served to a specific environment. My interpretation of the term "performance" is much wider and that is the reason for my scepticism and concern of how people may interpret or use such articles. There are important points raised, but there are also caveats that need to be borne in mind.

<!-- more -->

## Data Volume Analysis

The articles often focus on sending large numbers of entries. There are cases where that might be required, but a good business analyst should question the necessity and expectation of that. We're talking applications, not "War and Peace". I would question whether any user, regardless of what they claim, will actually scroll through a screen that has five thousand rows of data. And even it's an application to allow people to read "War and Peace", no end user would want to wait for the whole book to load or scroll down until they find where they left off.

Chunking into reasonable amounts to allow the user to quickly and effectively access what they need to will optimise user experience, and so increase the **_user's performance_**. In terms of editable forms, a wizard-style approach can be more effective and can even appear to display as a tabbed table.

A common technique on websites now is post-processing of the DOM, but it's one that I often find annoying as an end user when it's not done well. Then intention is to allow the end user to get started on whatever they want to do while everything else is loading. But as an end user, I've often identified the link I want to go onto before the page has loaded. The link is either not active or the click deferred until the post-processing has finished, at which point content has been re-ordered and the click activates a different link. Or I start scrolling down to read content but post-processing freezes the page, or the contents jump around, so my ability to read effectively is compromised. Occasionally I come across a site where an image placeholder is initially loaded that is the same size as the final image that will be loaded. This is post-processing done well, with careful forethought for the use cases of what is to be done while post-processing occurs. Unfortunately, this is the exception rather than the rule.

## Data Size Analysis

But let's be clear, I'm not saying articles about improving the speed of loading aren't useful. One of the aspects often highlighted is the **_html and data performance_**, amount of data per document or per operation. Different frameworks or platforms will handle that differently in their basic use. But any framework or platform can usually be optimised with custom coding or different components in the overall stack. Custom DOM manipulation will typically be possible, but may be overkill for some applications.

REST services have become de rigueur for data transfer to JavaScript applications. But a REST service is _provider_ driven. This means unless you're using a custom REST service design specifically for your use case, you may be receiving more data than your application actually needs, data that's not in the format you require so needs additional browser-based manipulation, or the data you need may require multiple REST service calls. This is why [GraphQL](http://graphql.org) is gaining in prominence, because it delivers only the data the _consumer_ wants, typically allowing data at multiple hierarchies in the database architecture to be delivered in a single call. It also handles versioning better than a standard REST service, by providing the flexibility for changes independently of the consumer. But it takes longer to set up - it has a negative impact on the time taken to develop the REST services, the **_coding performance_**. If performance of calls for data is an issue and you're not using custom REST services, GraphQL will probably bring benefits for **_data transfer performance_**. Also, if you're just consuming the data, not providing it, you have little control.

## Hardware / Software / Connectivity / Device Performance

But who always serves a large amount of data always across a poorly performing network, always to a poorly resourced device?

This question alone highlights that there are bigger factors to performance that just the code that's running.

If the customer demands an intensive application and some end users are using your application on an under-powered device with lack of available memory, **_device performance_** will still be slow, regardless of the effort you put in. The developer and even the business owner may not anticipate such issues. The question of who is responsible is a moot one - the end user needs to use a reasonable device, the business owner's requirements need to take into account the end users, otherwise the developer is stymied. If a small percentage of end users' connectivity is significantly sub-standard compared to other users, is this a factor those users should accept responsibility for themselves?

The variety of potential factors is considerable, it cannot - and should not - be included in such discussions on performance. But nor should it be ignored by anyone reading the article. In an enterprise environment with data and application logic in the same location as the client using it, with good hardware and software, and small data loads, the importance of coding for optimal code performance is different.

That's not saying you should code it badly. But when there is cost involved - financial or time - if it's a small application with a few users on good hardware communicating across a strong network, is it a good use of those finances for you to eke out every last millisecond when what you're gaining is **_barely perceptibly performance_**.

But questions need to be raised about an internal enterprise application being used on old browsers across a poorly performing network installed on hardware (desktop and server) that are out-dated. Upgrading one or all of those will have a bigger impact than spending time improving a single application.

## Frameworks

Most developers will use frameworks. This is not solely for application performance reasons, even if the chosen framework is better at performance than another framework. A custom framework aimed specifically at the application in question will, with a theoretically optimal experience of all platforms and framework code, get better performance. But it's going to require significantly more experience, take longer to develop, be harder to support, be less likely to cover all devices, require more effort to keep future-proofed and require an equally skilled person to replace you when you want to move on or get run over by a bus. And at the end of the day someone needs to pay for the application (even if it's only you with your time). Using a framework is a no-brainer. It improves **_coding and maintenance performance_**.

But any investment in a framework is just that - an investment. No matter what the providers say, no framework can be effectively picked up and used in an an hour. You may be able to get _reasonable_ use out of it. But if it's anywhere near comprehensive, you'll need to dig a lot deeper to get the most out of it or answer the edge cases any given application may need. At this point, the quality of documentation and availability of source code, or even support, really comes to the fore. If you hit enough problems, the time lost overcoming them may outweigh the time gained by using the framework. In the case of frameworks that get a complete re-write of the framework, that could have a massive impact on a complex application. And typically you'll need to combine in code that's not based on that framework, and that may result in conflicts that need technical skill to work around. The stability, quality and interoperability of the framework you choose could have a big impact on your **_developer performance_** for years to come.

## Coding Experience

Blog posts on performance can often highlight alternative approaches to development or introduce different ways of thinking that might not have been considered.  And this is an important point. I know as I've gained years of experience of development environments, the way I've coded applications naturally has improved the performance. That performance improvement has come from investigation and experience of the platform. If I moved to a.n.other platform, I would not have the same degree of understanding that would enable me to optimise. It may be _possible_ to get better performance, but not _possible for me from day one_ to get better performance for the specific use cases of the application I'm trying to build.

The level of experience can mean the application a given developer can create may take longer to develop and have worse performance on platform or framework B, even though platform or framework B is statistically better performing. **_Application or time-to-market performance_** may vary from developer to developer. Customers need to be willing to pay for what they want.

This does not mean the developer should only ever build on platform or framework A. But it's not advisable to choose a migration of a massive application for the first project on platform or framework B. Similarly, there's little point in doing one small project on platform or framework B if there will be no chance to do another for nine months or a year. Timing, planning, training, learning time are critical to expanding horizons. Companies need to invest for what they need.

## Migration Performance

This brings me onto a common topic, where business choose to migrate between technologies or frameworks. Let's be clear here - **_performance of end users_** will suffer. If you migrate the application without the data, users have to spend time re-keying data. If there was integration with external systems, that needs re-developing or can often cease to happen. If you migrate data, end users _should_ clean the data between export and import. If not, you will have problems. And data cleaning is not a quick task, nor is it one that can be fully automated or done without specific business knowledge. If you migrate your developers as well, they need time to learn. The project manager must be willing to ensure the end user is willing to compromise as a result, because of the lack of experience. If you use new developers for a custom application, there is likely to be a loss of business knowledge, which may impact readiness for business of the application. Key questions that address edge cases users have forgotten about or key configuration rarely updated will be missed. Using an off-the-shelf application will need compromises, which may require changes in business processes. And all of the requirements will require business input into the project, time that's rarely budgeted in advance in my experience.

## The **_Right_** Performance

At the end of the day, the effort required to ensure performance is within reasonable bounds for an application will vary from project to project. Consequently the degree to which the application should be optimised for performance and the methods used will vary from situation to situation. The will not be - nor should there be - a "one size fits all" model. If there is, the majority of applications will be over-complicated and the infrastructure will be vastly more expensive than it needs to be. The more information available from those requesting the application at an early stage, the better a developer can code for **_the right performance_**. If complete and accurate information is not available for all factors covered above - and I would argue it rarely is and typically _should_ change - the best approach is to **_tune performance_**.

The developer can make a "best guess" at coding and architecture based on the best information available at the time. But everyone needs to take some responsibility: those hosting the application need to ensure wherever it's sitting remains fit for purpose; business owners have to accept that further development may be required to maintain performance; they need to be aware that new APIs and developer knowledge will improve, and leveraging this in existing applications should not be expected free of charge; they need to be aware changing requirements may impact - positively or negatively - the complexity of the application and thus its impact on performance; users have to accept that devices used need to be maintained at the appropriate specification; and developers have to keep apprised of new APIs or functionality that might improve performance and some leveraging of this may be covered if maintenance costs charged.

Performance can never be a one-off task. It needs to be something that's regularly reviewed and optimised. The worst case scenario is an application or platform where performance is never reviewed or tuned, data sizing never maintained, performance degrades and the decision is made to migrate under the premise that the application or platform cannot cope. The frustration, cost, effort and pain that arises for all parties is unforgivable. And unless the lesson is learned, the cycle of woe and perpetual migration will continue.