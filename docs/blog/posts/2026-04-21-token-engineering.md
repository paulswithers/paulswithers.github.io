---
slug: token-engineering
date: 2026-02-23
categories: 
    - AI
tags:
    - AI
    - Editorial
comments: true
---

# Token Engineering

AI usage has evolved over the years as the power and limitations of LLMs and agents have progressed. The community has learned that they needed ways to provide additional abilities. Coding clients have adapted to provide those capabilities. Thankfully the IT ecosystem has changed dramatically since the birth of enterprise IT, so open source and standards have become the default mechanism instead of a last resort after community pushback. But we’re starting to see yet another approach, one I’ll call **Token Engineering**.

<!-- more -—>

##  History of AI Engineering

First, let’s look back at the evolution of AI usage, what problems were identified, and how the community adapted.

- **Prompt Engineering**: the early adopters of AI identified two problems. Firstly, the wording of a prompt affected results. But secondly, it was important to add additional details - an agent prompt or system prompt - to add guardrails and ensure there was no abuse of the developer’s intent from the user prompt.
- **RAG**: developers identified that they needed to provide additional information that the LLM was not trained on. But whereas searches had historically been controlled by keywords the user selected, now they were being initiated through natural language. Retrieval Augmented Generation filled this gap, with content being retrieved via similarity searches and injected into the prompt.
- **Context Engineering**: as coding agents became more pervasive and prompts became conversations, there were two more problems. Firstly, ad hoc information about a codebase was needed to steer the model more efficiently. RAG didn’t work for that. You could pass content explicitly, but developers wanted something automatic. So Anthropic came up with AGENTS.md, a standard location for additional content. But the second problem was conversations grew and models degraded as their context window filled up - the “dumb zone”. One particular technique gained great adoption to fix the problem - the “Ralph Loop” from Geoffrey Huntley.
- **Model Context Protocol**: but third parties also wanted to allow your agent to automatically integrate with their systems - GitHub, JIRA, Cloudflare etc. Building agent-specific extensions, each different for each of the various coding agents and IDEs was inefficient. So along came MCP, with standard protocols for coding and general AI clients to talk to servers. Adoption raised other needs and the 2025-11-25 spec version added significant enhancements taking the protocol towards enterprise adoption. And the upcoming spec planned for June adds even more.
- **Code-Driven Solutions and Skills**: a standalone coding harness evolved at the same time, Pi by Mario Zechner, and became more well-known because of the coding agent that built upon in, OpenClaw by Peter Steinberger. This took a different approach, one possible only because models became more powerful through the second half of 2025. It solved the need to integrate by allowing the model to write code that interacted with command line tools or REST services. It’s a technique also appropriate for MCP, as David Soria Parra has highlighted. So although it’s independent of MCP, it’s not one MCP ignores. It also embraces an approach Claude Code took to adding specific expertise, **Skills**. Whereas tools in MCP (and before MCP) empowered LLMs by giving them a list of capabilities and saying what the inputs and outputs were, Skills are a natural language collation of how-tos on a particular area of expertise. And MCP are looking at how to officially integrate skills in the upcoming release - although they can already be provided as resources.
- **Spec-Driven Development**: as coding agents were able to run for longer, providing single prompts at a time became inefficient. Planning modes became pervasive, with agents writing complex specifications broken into phases and tasks. Some developers have taken a hybrid model approach, planning the specification with one agent, reviewing with another, coding with yet another, maybe testing with yet another.

## Token Driven Development

It doesn’t matter if you’re using OpenClaw, Spec-Driven Development, Ralph Loops, or parallel agent sessions. There’s the same problem if you use MCP or Skills. That problem is you’re running way more sessions than a year ago, and you’re loading a lot more context before you even start typing your first question.

The community is starting to realise this, particularly as they start hitting token limits and model token prices increase.

Both skills and MCP have some degree of progressive disclosure. But I don’t think it’s sufficient to address the problem with the current usage patterns.

The amount of choice and the evolution of local models means agent providers would be unable to resist the pressure from the community to evolve, even if agents are tied into models by the same vendor.

But there’s a bigger problem that creates pressure from model providers: availability. The explosion in OpenClaw usage and the resulting contest to bring “claws” safely to the enterprise means frontier model providers need to scale even more than previously anticipated. Chip production was already struggling to keep up with demand. But the war in the Middle East has had a massive and long-lasting impact on helium production, crucial for building those chips.

So I think token engineering will become a prime concern both for AI consumers and frontier model providers through the rest of 2026. Other model providers will be competing even harder to create smaller models that are more and more powerful. But context size is even more important for them. So token engineering is key for sovereign AI as well.

## Summary

This shouldn’t come as a surprise. The evolution of AI has had a pattern: we find ways to give models more, so we over-abuse it, realise the excess causes problems, and learn how to be smarter with what we give it.

This is just another cycle of the same.