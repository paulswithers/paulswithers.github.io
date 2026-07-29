---
slug: mcp-new-release
date: 2026-07-29
categories: 
    - MCP
tags:
    - MCP
    - AI
    - Editorial
comments: true
---

# MCP Specification 2026-07-28

Yesterday marked the launch of the latest release of [MCP](https://modelcontextprotocol.io/), the protocol championed by Anthropic and a founding member of the [Agentic AI Foundation](https://aaif.io/) back in December 2025. MCP had been on my radar since the middle of 2025, when I integrated into a proof-of-concept project. When the last version of the spec launched in November 2025 (2025-11-25 spec) I did in-depth research on the new features. And I've been tracking the latest release for many months, particularly because of the potential of Skills over MCP. So it's great to see the launch.

<!-- more -->

If you want to get the overview of the new features released, they are covered in the [launch blog post](https://blog.modelcontextprotocol.io/posts/2026-07-28/). If you've not been tracking MCP or have been out of the loop for a while, and want to catch up and dive deeper on all the new features and what they mean for MCP server or client implementers, the best option to be brutally honest is to ask your favourite AI assistant, drilling into the sources to reinforce the perspectives provided.

But here are the aspects I consider most important in the new release.

## Stateless Protocol

The biggest change, and one that will affect all implementations is the shift from a bidirectional stateful protocol to stateless protocol. This means no persistent connection between the server and the client. Instead requests are stateless, which has also required some re-architecting for some functionality. It has also required some additional authorization hardening.

What the impact will be on updating code to the new specification will probably vary. But it's a significant change, with some handshake methods deprecated and capabilities carried in a `_meta` property of the payload.

It also means "push" notifications are no longer used, which means how lists and resources are cached changes.

For more details, I would strongly recommending reviewing the [blog post](https://blog.modelcontextprotocol.io/posts/2026-07-28/) and of course the [specification itself](https://modelcontextprotocol.io/specification/2026-07-28).

## Tasks

Tasks have also moved out of the experimental core, which enables long-running tasks to be processed async. Of course the mechanism for handling this has had to change, because of the switch to stateless protocol. But it expands the scope for what MCP servers can provide. For more details, you can see the [extensions page for Tasks](https://modelcontextprotocol.io/extensions/tasks/overview#tasks).

## Deprecations

I won't go into detail on the deprecations, because Roots, Sampling, and Logging were not functionality I've really used. But they are deprecated with a year-long offramp.

## SDKs

One of the exciting announcements I remembered hearing a few months ago was that the TypeScript and Python SDKs were being rewritten to improve usability and adoption. After various betas, it's great to see they have hit Tier 1 requirements by releasing versions supporting the 2026-07-28 spec for launch.

Around the same time, it was also great to see that the Rust SDK had a big injection of effort. I've been following the progress over the last few months in the MCP Discord, and their v3.0.0 release came out yesterday and was [announced today](https://www.linkedin.com/feed/update/urn:li:activity:7488228595593564160/). Although it's not currently a Tier 1 language, I'm sure it will be promoted to Tier 1 imminently. Rust is a language I have only been working with for a couple of years, but it's nicely structured and enjoyable to work with.

## SEPs

Of course there are other SEPs, and I hope to see [MCP Apps](https://modelcontextprotocol.io/extensions/apps/overview) flourishing over the coming months. They add a lot of potential, although implementations may vary from client to client.

Another SEP I've been following hevily is [Skills over MCP](https://modelcontextprotocol.io/community/working-groups/skills-over-mcp). The combination of skills and tools is very appealing to me. Although input and output schemas are good for helping probabilistic use of tools, it's possible for the model to "guess" wrong or make incorrect assumptions. The JSON format also means potentially verbose content being added to every session, regardless of whether it's needed. Of course agent harnesses could make a "first pass" and only send tools they think are relevant, but there is still a challenge for adding other tools subsequently identified as necessary: the basic in-built `tools` element can break the KV cache without sophisticated workarounds, impacting performance and cache size.

Skills over MCP increase the likelihood of the tools being used correctly, and even being used in combination more effectively. APIs with lots of options are great for a human developer, who has time to work out what to send to which API, and can test the result is effective. But a model is more like a *user interface*, translating a specific user requirement (e.g. get a customer and their contacts) into API calls. A skill can provide the glue - in a deterministic way - that the UI developer will code into the application for the user. The "human-in-the-loop" provides the guidance on how to turn a user requirement or user story into specific tool calls.

And there is the potential for reducing the number of tools available, making the tools more generic but with skills to give the intelligence of a "user manual".

There is a detailed [blog post from Agentic AI Foundation](https://aaif.io/blog/skills-over-mcp) with further details of how it would work. Thanks to those involved, I've already created a proof of concept, which reinforces my enthusiasm.

## Tools to Test MCP Servers

Also worth mentioning is that I also recently came across [MCPJam](https://www.mcpjam.com/) as a tool for testing your MCP servers. I haven't looked in-depth, but it looks like they've already done work to support the new protocol. This follows the [XY Problem](https://en.wikipedia.org/wiki/XY_problem)

## Summary

As with anything, there are times to use MCP and times to build an agentic harness with specific tools yourself. Pi took the approach not to support MCP out-of-the-box but use CLIs instead, and yet extensions for MCP have been created. Hermes Agent, which has gained adoption from some Pi consumers, does have MCP support. But the important aspect is understanding what it does, how it does it, and have sufficient information to decide whether or not it's the right solution for your specific requirement. And with a major specification release like this, it's important to keep your knowledge up-to-date.