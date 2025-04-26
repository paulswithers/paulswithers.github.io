---
slug: using-ai
date:
  created: 2025-04-26
categories: 
  - AI
tags:
  - AI
  - GitHub Copilot
comments: true
---
# Using AI

As a researcher, I'm always looking to learn, to expand the toolbag I have, and find innovative ways to improve outcomes. Even when AI is not at the heart of the project I'm working on, I'm constantly looking for ways it can make my life easier and life easier for developers using what I create. And the fact that we targeted a standard IDE means the effort required to integrate AI is reduced. But as with any new tool, it's important to learn what it can do and what it can't. And work this week has shown me that this requires a diligent approach.

<!-- more -->

## How We Learn

First, it's important to review how we learn new technologies, as developers. Because the way we will learn to use AI is very different. It's also much more sophisticated than any technology we've ever used before. And unless you're using it in a very basic way, the way you need to interact with it is much more black and white than any language, framework, or IDE we're used to working with.

Let's think about how we learned languages or frameworks. We look for a tutorial, follow the tutorial, and get a predefined, pre-canned outcome. The same is true of an IDE. Of course any tutorial will not cover anything, so we use cheatsheets of menu options, keyboard shortcuts, settings etc. And with a framework, we look for linters and validators to build best practice.

The bottom line is that the language, framework, or IDE has been designed for a specific use, a specific set of outcomes. And someone has usually come before us, there's someone who's used it the way we want to. And *someone* understands how it works at a microscopic level, even if the language, framework, or IDE is not open source and allows us to look at how it works.

## A Whole New World

Hopefully now I've made this explicit, you realise that AI doesn't work that way. If it's designed for narrow specific use cases, it's just not scalable. The whole point is to scale quickly and effectively, in what AI can understand and the outcomes it can generate. It's not *coded* to work with Java, or JavaScript, or Python code. It's not *taught* individual frameworks like React, Vue.js, Dojo, or others. So there's no developer who can *inspect* code to see the answers it would give for a specific question on a specific framework.

Agentic AI looks to be designed to provide that kind of narrow answer to a specific question. But not in the way chatbots used to work, where you loaded a variety of ways of asking a question, so it could cross-reference and give a static response - or a static response with variables inserted. If my understanding is correct, the AI model will parse the natural language of the question, formulate content for an AI agent in a specific way (e.g. one of multiple APIs to get a customer or a location), and work out how to use the response - either to pass directly to the user, or to other agents.

But whereas these AI agents can be *inspected* to understand what they do, the developer of the agent can't inspect how the rest of the **AI process flow** acts around the specific call to the agent.

## Basic Usage

Of course there's a very simplistic usage of AI: asking a question against a knowledgebase of information, whether it be a set of APIs or a dataset. This has already become available in search engines. When I ask something in Google, it gives me an AI response, with a handful of links from which it got the answer. If it's API - or combinations of APIs to generate code - it either compiles or it doesn't, it either runs or it doesn't, and it's usually simplistic enough for you to understand that it will do what you want or won't. It's how Copilot's code completion works, filling in subsequent lines of code. It's black and white, right or wrong, useful or not.

## More Sophisticated Usage

But if you go beyond the basic usage, there can be more sophisticated ways that AI can be used, more extensive processing of code. The answers may still be black or white, but the whole reason for using AI may be to speed up a process that would be too time-intensive if done manually. That was the way I used Copilot's chat recently, and it demonstrated to me some lessons.

### The Troubleshooting Approach

Some years ago I wrote a blog post on [troubleshooting support](./2019-10-28-troubleshooting-support.md). It's probably one of the most important blog posts I've written, and it's also very relevant to using AI for more sophisticated purposes.

In that blog post I talked about having hypotheses (plural), some idea of the likelihood of each, and identifying ways to prove *and disprove* them. Likewise, with AI, it's important to have an idea of the answer you're going to get. Even more important, you need a baseline, a way to cross-reference that the answer is correct. This can be modifying the dataset and asking the same question, to see if you get the correct answer.

But there's a problem.

You *know* you've modified the data. You saw yourself do it. And so you *assume* your AI also knows you modified the data. But does it?

**It's important to explicitly tell Copilot when you need it to re-read the dataset.**

You may find out that it doesn't give the answer you expect from your baseline. At this point, you can just ignore AI. Or you can try to work out why it's getting the wrong answer. In my case, I was asking it to compare method signatures in two files, and I tried to get a baseline by modifying a method signature. But the code had comments as well.

**It became apparent that we were looking at the files differently.**

I was focusing on the code, Copilot was looking at the comments. It's important to have hypotheses about how AI is generating answers. There are questions you can ask to verify this. But again, it's down to making intelligent hypotheses (plural), avoiding assumptions, and gathering the information needed to verify the answers you're getting.

**It requires an intelligent user to perform sophisticated processing with accurate outcomes.**

### Some Key Thoughts

Passing multiple files to a Copilot chat is possible. But if you want to pass a number of files, it may be easier to pass a folder using `#folderName`, even it means temporarily moving files into the same folder. According to Copilot's answer, you may need to pass a file again if you need to clarify something specific.

By default, it also uses what it can see in VS Code's active editor. You may not want it to do that, so it's important to exclude it.

There is also useful information in the results, Copilot will include a twistie with the references it used as the basis for its response. It's worth looking at that to make sure it's using the right content. And it may be useful to start a new chat, to clear the context.

And remember, you can always ask Copilot to help verify your assumptions of how it's coming to conclusions. That is something that is very easy to forget.