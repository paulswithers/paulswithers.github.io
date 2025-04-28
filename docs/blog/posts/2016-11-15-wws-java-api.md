---
slug: wws-java-api
date: 2016-11-15
comments: true
categories:
  - Java
tags:
  - Java
  - Watson Work Services
  - GraphQL
---
# Creating a Java API to Access Watson Work Services

A few weeks ago, IBM announced Watson Workspace, the final name for Project Toscana, and its API Watson Work Services. The product itself has similarities to Slack or Microsoft Teams, but this post is not about discussing a comparison of the products. It's about the API backing it.

Watson Work Services is a REST API that uses [GraphQL](http://graphql.org/learn), a method of querying and posting via REST that focuses on configurability. Whereas traditional REST services have fixed endpoints that take fixed parameters and return fixed data objects, GraphQL is a sort of "API-as-a-service". You call an endpoint, pass a JSON object determining what elements of which data you want to return, include any dynamic variable values. The queries are passed to an engine at a REST service endpoint which parses the JSON passed, replaces any variables with the dynamically passed values, and returns just what the application or user asks for. This may include data from what, in a traditional REST API application, would be from different REST endpoints. For example, to get members and messages from a space, you might need to make a REST call to get the space ID, then another REST call to get its members, and a third to get the messages.

<!-- more -->

Before Watson Work Services I had not heard of GraphQL and mistakenly related it to Graph databases. But since investigating it, I'm a convert. It's the future of REST services, in my opinion.

Earlier this year, I had looked at a Java API to create REST service calls to Stash ([Slack Java API](https://github.com/allbegray/slack-api) and [slack-api](https://github.com/estebanwasinger/slack-sdk)). Thankfully a fellow community member had begun the work of converting resulting JSON into Java objects. But it was the posting and query side of it that interested me most of all.

While looking at various Graph database options earlier this year, I saw a number of Java APIs that used REST or JDBC to connect to backend databases, going beyond REST options and similar to what I would need, where the content of the query or stored procedure was more flexible. That left me firmly convinced of what is best practice and what is casual implementation. The strength of Java is that it is a strongly-typed language: where possible errors are caught at compile time rather than deferred to runtime. Some of those APIs had Java methods  to build up the query as a Java object, which the API converted to a string to pass to the underlying database. Others required queries to be stored as strings which were then passed to be parsed at runtime. Maybe others trust themselves to avoid typos and other easy mistakes, but I don't. In mine and in others code, I've often seen issues caused by unidentified typos. That's why I have for some time preferred Java over JavaScript. So when it came to writing an API, I determined early on that creating the queries would be done via Java methods, not storing them as strings. I was under no illusion that this meant a lot more work from me. But I was convinced it was the better approach and one that would be welcomed as generating more readable queries and fewer errors.

Going back to those REST service examples for Slack, the second example uses a Java method that takes all parameters required by the REST service call and then adds them as arguments to the REST service call. That's easy in a standard REST service because the parameters are fixed. The second creates an object that then gets parsed to build the parameters for the REST API. That was more the kind of thing I needed.

There were a few aborted attempts as I fumbled my way via trial-and-error. But I've got something that works now for queries. Mutations may change what's required, but I have a starting point. For the query itself, I have a `DataSender` object that has `addAttribute()` to pass what appears in brackets after the object name in the JSON, `addField()` to pass scalar fields to return and `addChild()` to add other objects to return, each of which could have their own attributes, fields, and children. There also seems to be a standard PageInfo object that can be returned, with standard values, so the object also has an `addPageInfo()` method. This results in some long queries - below is the current full code for a request for spaces, their members and messages. But it's much more readable than the string JSON query that results.

    	// Basic createdBy ObjectDataBringer - same label for all
		ObjectDataSender createdBy = new ObjectDataSender(SpaceChildren.UPDATED_BY.getLabel());
		createdBy.addField(PersonFields.ID.getLabel());
		createdBy.addField(PersonFields.DISPLAY_NAME.getLabel());
		createdBy.addField(PersonFields.PHOTO_URL.getLabel());
		createdBy.addField(PersonFields.EMAIL.getLabel());

		// Basic updatedBy ObjectDataBringer - same label for all
		ObjectDataSender updatedBy = new ObjectDataSender(SpaceChildren.UPDATED_BY.getLabel());
		updatedBy.addField(PersonFields.ID.getLabel());
		updatedBy.addField(PersonFields.DISPLAY_NAME.getLabel());
		updatedBy.addField(PersonFields.PHOTO_URL.getLabel());
		updatedBy.addField(PersonFields.EMAIL.getLabel());

		ObjectDataSender spaces = new ObjectDataSender("spaces", true);
		spaces.addAttribute(BasicPaginationEnum.FIRST.getLabel(), 100);
		spaces.addPageInfo();
		spaces.addField(SpaceFields.ID.getLabel());
		spaces.addField(SpaceFields.TITLE.getLabel());
		spaces.addField(SpaceFields.DESCRIPTION.getLabel());
		spaces.addField(SpaceFields.UPDATED.getLabel());
		spaces.addChild(updatedBy);
		spaces.addField(SpaceFields.CREATED.getLabel());
		spaces.addChild(createdBy);
		ObjectDataSender members = new ObjectDataSender(SpaceChildren.MEMBERS.getLabel(), SpaceChildren.MEMBERS.getEnumClass(), true, false);
		members.addAttribute(BasicPaginationEnum.FIRST.getLabel(), 100);
		members.addField(PersonFields.ID.getLabel());
		members.addField(PersonFields.PHOTO_URL.getLabel());
		members.addField(PersonFields.EMAIL.getLabel());
		members.addField(PersonFields.DISPLAY_NAME.getLabel());
		spaces.addChild(members);
		ObjectDataSender conversation = new ObjectDataSender(SpaceChildren.CONVERSATION.getLabel());
		conversation.addField(ConversationFields.ID.getLabel());
		conversation.addField(ConversationFields.CREATED.getLabel());
		conversation.addChild(createdBy);
		conversation.addField(ConversationFields.UPDATED.getLabel());
		conversation.addChild(updatedBy);
		ObjectDataSender messages = new ObjectDataSender(ConversationChildren.MESSAGES.getLabel(), true);
		messages.addAttribute(BasicPaginationEnum.FIRST.getLabel(), 200);
		messages.addPageInfo();
		messages.addField(MessageFields.CONTENT_TYPE.getLabel());
		messages.addField(MessageFields.CONTENT.getLabel());
		messages.addField(MessageFields.CREATED.getLabel());
		messages.addField(MessageFields.UPDATED.getLabel());
		messages.addChild(createdBy);
		messages.addChild(updatedBy);
		conversation.addChild(messages);
		spaces.addChild(conversation);
		GraphQLRequest req = new GraphQLRequest(spaces, "getSpaces");
		return req.getQuery();

I'm still some way from completion, but I have working queries  and something I feel is more developer-friendly and error-proof.