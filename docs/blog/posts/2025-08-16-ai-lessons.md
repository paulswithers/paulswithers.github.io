---
slug: ai-lessons
date: 2025-08-16
categories: 
    - AI
tags:
    - AI
    - Editorial
    - GitHub Copilot
comments: true
---
A little while ago I blogged on [developing at speed](./2025-06-30-rapid-development.md). The obvious omission from all aspects was **AI**. But AI – like an IDE – is just a tool. Unless you understand what it can and can't provide, unless you use it intelligently, you will not reap the benefits. But unlike an IDE, AI doesn't come with a set of menus that hint at what it can and can't do. AI doesn't come with a marketplace of extensions that provide functionality shared by the community. And it's so new that we're all working it out. So what are my thoughts?

<!-- more -->

[Matt White](https://mattwhite.me/2025/08/12/ai-coding-experience-of-a-senior-manager/) blogged about this recently as well, and I agree with many of his points. Most of all, I agree that it will not replace either junior or highly skilled engineers. It's just another tool, like an IDE or build systems: in the hands of the right people it can provide significant performance boosts and avoid the mind-numbing aspects like poring through documentation or hunting through a host of technical posts; in the hands of the wrong people, it can provide even more significant productivity losses and leave your skilled engineers wanting to throttle those who have forced them to spend hours trying to understand and undo the deleterious impacts of dumb code!

## Contextual Background

To give a bit of contextual background to my experience with AI, my use has predominantly (almost exclusively) been in Visual Studio Code, using a couple of models (GPT-4.1 and Claude), initially in "Ask" mode, now mostly in "Agent" mode. My use of Copilot began nearly 18 months ago and has been used in a variety of projects, a variety of languages, and multiple frameworks. I covered some of the scenarios I use it for [last year](./2024-05-01-ai.md). That work continued, including investigating how suggestion results could be improved. But it's been complemented more recently with coding in technologies and with concepts I've been less familiar with. As I've done that, my use of AI has become more sophisticated.

That's what I want to focus on here.

## Understand Limitations

My initial use of Copilot with Rust was very positive. Subsequent experiences were less positive. But there was a simple reason: the framework and more specifically the APIs from that framework that I was initially using were well-established and had not changed for some time. The later experiences were on APIs that had changed significantly and frameworks that were still evolving. This resulted in [AI hallucination](https://en.wikipedia.org/wiki/Hallucination_(artificial_intelligence)).

The AI-phobes will immediately use this as an excuse for not using AI. The skilled engineer will adapt their usage of AI to maximise performance. There are a variety of techniques that can be employed to improve outcomes, and the right combination will vary.

"Agent mode" has been helpful because unlike "Ask" mode, it doesn't stop after the initial response. This can provide code, check compilation, and adjust accordingly. One of the key aspects is informing AI of dependency versions in use, which it can identify from config files – although it may not proactively do it. I've found Claude much better than GPT-4.1, but sometimes still not right.

The key here is tolerance – anticipate where it might struggle, if you can, or at best accept it. It's not API completion, it's not designed to do that or even use it the way a developer does. AI is not a tool designed for software developers like API docs and API introspection in language servers are. Wake up and smell the coffee – you don't pay sufficient money to justify an AI specific for your framework or language or even software development in general. The only reason it expects is that investment justifies a jack-of-all-trades, which will never be the absolute expert for everything you or any other individual wants. If it fails, try to give it the information it needs to succeed. If it still fails, try to understand why it fails, fall back to "traditional" software development approaches (reading API docs and coding on your own!), but be willing to use it where it's more likely to succeed.

## Making Introductions

We call it AI, but it's really natural language processing backed by an LLM (Large Language Model) and, potentially, tools and resources. The big strength of AI is ingesting a large corpus of information previously gathered and providing a succinct analysis. And this is where it can provide big benefits.

I've gained benefits from asking AI for a high-level explanation of concepts I'm not familiar with. My traditional approach would have been to search the internet and read a variety of articles. AI can give a more succinct summary which is "probably" right. The key then is to approach it with intelligence and healthy scepticism. What "sounds" correct? Use that with the caveat that you might need to verify it later. For the rest, be willing to challenge, ask for and investigate sources, and cross-reference it with web searches. This is not rocket science, it's standard for higher education academic research.

It's also important to think about what's omitted. Are there aspects where you need more detail, more information.

I've also used AI to choose what libraries are available to provide certain functionality, or what the pros and cons are for various options. This provides quick contextual information to help make a more informed decision. It's important to highlight that AI doesn't know you, so asking for "the best" doesn't provide the key information to decide the right choice for your particular requirements. Asking for pros and cons can help you make the right decision, and might help you ask additional questions with additional contextual information.

## Getting It Right First Time

Code generation is a given for AI usage. But that's not the only benefit when writing code. I've found AI very useful to explain unfamiliar syntax or verifying assumptions about what APIs do. "If I use this API in this way, with these inputs, what will be the outcome?" Or if you want to "lead the witness", "will I get this outcome and, if not, how do I get this outcome?"

Historically I would have written code, tested it, and adjusted accordingly. Sometimes it may have required lots of additional coding to get to a position where the scenario could have been tested, and I would need to remember to test when I got to that point later. Other developers just post the question on a community chat or forum somewhere, hoping for an answer to a query that may not even have provided all key information. Asking AI can be a more effective solution, not least because the AI can actually see all the related code you've written unless those community chats.

## Improving Code

Matt White talked about his experiences of using AI and I've found significant performance benefits on writing unit tests even for VoltScript, a language for which there are limited resources available. Matt also documented the challenges in trying to improve code by a more complex refactoring. But there are more granular examples where I've used AI to refactor code.

Way back last year I pointed Copilot to code and asked summary of Voltscript code complexity, both cognitive complexity and cyclomatic complexity. More mature languages have integrations with code quality tooling, but obviously that's not possible with VoltScript in Visual Studio Code, which will not even be GA until later this year. We could build that, but it's not a quick task. AI fills that gap and can identify places where code can be improved. Maybe it could even be used to rewrite it to minimise complexity.

More recently with Rust, I've posed questions like "is this the correct way to...", "what is the best practice for doing...", "is there a more elegant way to...". This can also be used to help introduce more advanced techniques into your code, educating you on how to use them correctly and build knowledge to use them first time next time.

## Garbage In, Garbage Out

A key aspect is one Matt learned quickly and highlighted: specificity. If questions are too open-ended or not specific enough, you get bad output. Using an AI chat in-IDE can minimise some of that risk of not providing key information. It's one I've seen very often on chats and other forums - not stating which version of software is in use, not referencing key environmental or adjacent factors that are crucial to understanding your outcomes. But it's important to be able to provide the relevant information in a succinct manner, ask targeted questions, not distract the AI from what you need. This is a *skill*.

I'm constantly surprised that some IT professionals, whose day job is providing support, can be so bad at providing the information needed to support them. But it's more true with AI than anywhere else, that the quality of input directly correlates to the quality of output. That does not mean good input guarantees good output, but bad input definitely increases the chances of bad output.

## Summary

Hopefully I've provided some ideas about how to maximise your success with AI. There's a follow-up article due, at a higher level, because in many ways we've been here before. And some potential mistakes and lessons learned are ones we can identify from comparable technologies and IT approaches of the past.