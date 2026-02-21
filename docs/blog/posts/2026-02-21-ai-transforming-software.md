---
slug: ai-transforming-software
date: 2026-02-21
categories: 
    - AI
tags:
    - AI
    - Editorial
comments: true
---
# Transforming Software with AI

The ability of AI to generate software applications has taken gigantic leaps forward in just the last few months. A team of agents using Claude Opus 4.6 wrote a C compiler with minimal human interaction. In the [press release for Opus 4.6](https://www.anthropic.com/news/claude-opus-4-6) Anthropic build Claude with Claude. I personally use coding agents more and more, and I’ve seen significant rapid application development with AI.

But that becomes more challenging when you’re trying to integrate AI into existing software that!s developed over years or decade of sprawl, as [Nate B. Jones](https://youtu.be/bDcgHzCBgmQ?si=eD2ZAfLKK3A42UjV) discussed recently. But there are definite ways you can use AI more effectively, and recent experiences have taught me that even more.

## Planning

Firstly, and I’ve mentioned this [before](./2025-10-05-barriers-to-effective-ai-3.md), the problem of garbage-in-garbage-out (GIGO) has never been more important. Planning with AI is not optional. If you don’t do it, you’ll fail. Hard! Maybe not with your simple tweak to a system, but as soon as you want something beyond the very basics. And you’ll fail often.

The agent needs to understand what is and isn’t negotiable. And that’s not just a case of telling it once, it needs to be embedded in the instruction set as a hard constraint. Otherwise as soon as there’s an easy route that violates the constraints or a harder route that maintains the constraint, the constraint will be violated. And you won’t find out until you read the code or guess from something unusual in the interface or logs. At that point, many will just revert to reading every line of code. The AI native developer will identify **their** failure and learn (i.e. ask the agent) how to correct it.

You also need to understand what’s possible and what might not be possible. AI coding agents assume you know, assume an intelligent human. If you don’t, ask that. And ask about edge cases, ask about failure conditions, etc. It’s important that the plan considers those and knows what to build, and when.

## Iterative Development

I have seen too often cases where developers have a specific target functionality and try to build that, without properly understanding *how* to build it. The result is “human” context rot, “human code slop”,  and slower coding as a result. There are approaches skilled developers employ to avoid the problem, and they can be employed with agents.

My current project has been integrating two technologies and approaches that I wasn’t sure were possible or not. So I’ve prototyped outside the main application. It’s a disposable proof of concept and, yes, the models that I used at various times had challenges. This was not unexpected because I was not using the latest and greatest models. But my approach managed my expectations. And it allowed me to prove what I needed without the distraction of additional code that could confuse both of us. This was very useful because the initial approach proved unsuccessful, which again was not totally unexpected.

But the approach means integrating the code into the full code base will be easier, and I have a fully working project that I can direct a model towards to cross-reference. (And, ironically, I had also used AI to prove an existing working project of the single new technology, which I pointed the coding agent at during development.)

The iterative approach also included various sets of control gates at various phases. Getting AI to write tests that could be used after refactoring to ensure no regressions. And because it understood what would be refactored, tests were planned specifically for the refactoring, not just “do the existing tests still work?”.

## Build, Improve, Document, Refine, Repeat

I’ve also started using an approach of regular asking for code to be refactored and for out-dated code to be cleaned up. But not just code, documentation as well. Some models I’ve used generate a lot of documentation for each phase of development. Not only does that quickly become much for humans to keep on top of, but it can also mislead the coding agent. Cleaning up both code and documentation regularly improves outputs, but it’s important to point out that it will minimise the tokens passed to the LLM.

When the outcomes are not exactly what’s needed, I think it’s also important to carefully consider what needs fixing when. Some problems are going to be harder to fix than others, and some models struggle more than others with this. It takes some AI-fu to encourage the coding agent towards a more sophisticated approach, like [human troubleshooting](./2019-10-28-troubleshooting-support.md), and I’m still investigating approaches to improve this. As a result, easy, quick fixes may be better to leave until after more complex issues have been addressed.

## Disposable Code

This raises a question about how software development will be done in the future. It’s something I noticed in a recent blog post about [Gas Town by Steve Yegge](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04). Steve talks about how the current version is the fourth iteration. The first iteration failed and he *threw it out and started over* on v2. v2 failed, but produced Beads, which has gained a lot of traction in the AI community. I’m not sure of the language used, but v3 is described as “Python Gas Town”. The current version, v4, however, is written in Go.

And this is a very important point in the era of AI-written software: what’s important is **not** the code, it’s the spec. Historically a complete rewrite of software would be costly, throwing away months of person hours of effort. Now, however, it’s the *spec* that’s important and development *refines* the spec. So a complete rewrite in another language may be trivial or at worst is a small task. And crucially **it’s done by the same individual**. And tests can be written to ensure identical functionality in both languages, before you then go on and add new functionality.

A complete rewrite *can* be low risk and low effort.

## Brownfield Software

But what about brownfield software, applications that have grown up over years or decades. A colleague recently used Claude to generate detailed documentation of an existing codebase. Although it’s evolved over a few years with a reasonable development team, in my personal opinion it’s a well-constructed code base, regularly refactored in the early days for scalability. Even so, the documentation will help not only human developers but also AI-assisted development.

But it is very important to be explicit when you want output specifically for agentic systems to use. Although coding agents can use human-focused documentation, it may be more effective to generate documentation in a format optimised for the AI agent.

And yet even if a system is understandable for an agent, that should only be the start. Then it’s important to improve testing, especially for the edge cases that have been identified as crucial over the years. At that point you can get recommendations on refactoring the code. Because although the code may be understandable, there may be improvements possible to prepare the codebase for AI-first development.

Alternatively, it may be better to *rewrite* the whole codebase - either in the same language with more modern approaches and dependencies, or in a completely different language or platform.

This will horrify and terrify many of the people involved in the current IT team. But it’s more achievable at a smaller cost than ever. And it may open up opportunities that are currently impossible. I speak from experience.

Innovation and progress comes from ambition.

## Summary

The benefits of AI-first development for new developments are significant. Even though I’m only recently at stage 5 in my AI development journey, that is certain. Brownfield software is definitely harder to integrate AI into, but it’s something well worth doing.