---
slug: agentsmd-engineering
date: 2026-02-23
categories: 
    - AI
tags:
    - AI
    - Editorial
comments: true
---

# Is “AGENTS.md Engineering” The Next Optimisation Approach?

AGENTS.md has become the de facto standard for directing your agent. Claude Code had CLAUDE.md but with AGENTS.md becoming part of the [Agentic AI Foundation](https://aaif.io/ ) last year, even Claude Code now recognises and uses AGENTS.md. But the benefits of AGENTS.md are now being discussed and challenged in academic circles. However, maybe what’s being discussed is just the *first* iteration. And just as the AI world went through Prompt Engineering and then Context Engineering, maybe the next phase (or *a* next phase) is “AGENTS.md Engineering”.

<!-- more -->

## What is AGENTS.md

[AGENTS.md](https://agents.md/) is billed as a README for agents. The website is fairly lean on recommendations and structure. No required fields, some suggested things to include, format as Markdown, advice that it’s a living document, and the potential for multiple AGENTS.md files, where the nearest wins.

Claude code creates a CLAUDE.md file by default. But it’s possible to get your agent to write an AGENTS.md file based on your plan. It’s not rocket science and very human-readable.

At some point recently (and I can’t remember where, so apologies for not attributing the knowledge) I came across recommendations that the AGENTS.md should be lean and should reference out to external documents, so that the initial context window is kept small.

Because that’s the key thing. Theo does a great job in [this video](https://youtu.be/GcNu6wrLTJc?si=4OvpDT7DzdTtAq4f) of explaining clearly how it’s added to the context window between the system prompt and the user prompt. Hopefully this is apparent to everyone, because the impact is huge: whatever is in there needs to be as terse and bulletproof as possible, with additional information only loaded when absolutely necessary.

The article linked to from the video is an academic paper from 12th Feb 2026, [Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?](https://arxiv.org/pdf/2602.11988). Coincidentally, earlier in the day that I saw the video, I had read another article from 26th January, [On the Impact of AGENTS.md Files on the Efficiency of AI Coding Agents](https://arxiv.org/abs/2601.20404). It seems noteworthy that the more recent article, does not reference the earlier one.

However, and critically I think, both work from existing open source repositories with AGENTS.md and CLAUDE.md files.

## The Problem

**But what is the quality of those files?**

Anyone who has read documentation knows quality is key. And it’s not rocket science that any documentation designed for humans is not optimised for AI. The rule of “garbage in, garbage out” also says that the quality of the input impacts the quality of the output.

And here is the key. AI agents aim their output at **humans**. Ask it how long a coding task will take, it gives the number of hours for a human to complete it - even if the current session has been used for prior coding. Similarly AGENTS.md content that is generated is aimed at humans: it’s typically verbose paragraphs, even the default CLAUDE.md file shown in the video.

This means more tokens. More processing time. And all because the standard input format is Markdown text…for an agent optimised for coding.

A brief perusal of some of the AGENTS.md files linked from https://agents.md/ demonstrates a wide variety of styles and levels of verbosity. The [WordPress AGENTS.md](https://github.com/WPBoilerplate/wordpress-plugin-boilerplate/blob/main/agents.md?plain=1) is over 1000 lines long, a massive amount of content before the first question is asked. Some use tables and gate-checks. Some cover only the basics. In his video Theo makes a good point that structure and technology stack may not be relevant and can have minimal impact on whether the agent works well or not.

## AGENTS.md Engineering

First off, full disclaimer, I don’t have answers. I don’t think the AI-native community has evolved the format yet, and I’m sure that coding models haven’t. But I think the root of the problem is that content is typically generated to be read by humans.

The key is to break that cycle. I don’t want to read an AGENTS.md. I shouldn’t need to. The agent should be the only one that needs to read *or write* it. And even when I asked various coding agents for recommendations on optimising AGENTS.md content, I got differing results.

But here’s where I’m planning to go next.

Keep the files modular, AGENTS.md needs to be lean. This was recommended from various discussions with LLMs.
Get the agent to write the AGENTS.md *only for agent use*. A README.md is the place for how a human should run the code. That kind of content has no place in an AGENTS.md.
If repositories contain multiple languages (and AI-native coding means there’s no reason they shouldn’t), I’ll be putting technology-specific info in specific areas.
Regular cleanup by AI, as with all other areas of development.

And then there’s the language question. Initial questioning resulted in AI recommending YAML. But I’m always wary of content that depends on tabs, models can break larger content. And if it’s embedded in Markdown, I fear bad results.

So I probed deeper on other options, offering TOML and JSON. Importantly, Markdown was identified as a sub-optimal choice when I explicitly said human readability was not a requirement. (I admit in hindsight the phrase “I don’t care about humans” could be considered dangerously ambigious!)

These were the options and thoughts elicited:

TOML had advantages of strict typing and comments, but could get verbose with nested content. For nested comment, something else might be better.
JSON is faster to parse than YAML. The argument for lack of support for comments may be avoiding by JSONC, but comments might drift away from what they refer to over time. A statement that it was less forgiving when written by hand is one I’m not worried about - I don’t want to be the one writing it!
YAML with a JSON schema was recommended as the “2026 Pro” option by Gemini, but this feels painful as a choice.
TOON is specifically optimised for LLMs, but unless used for flat tabular data, the aize was likely to be larger than compact JSON. The assessment of reasoning accuracy was only a few percentage higher than JSON compact.
XML, not surprisingly, had high token consumption. But interesting feedback was that top-tier LLMs are heavily fine-tuned for XML-tagged data. It also virtually eliminates “instruction drift”. But another LLM gave token cost as prohibitive and no meaningful advantage of JSON.
MCP was suggested as an active capability, and avoids the initial context window entirely. But self-updating could be difficult, especially for general instructions.
A “pseudo-code” instruction set approach was also suggested, with logic-gated instructions, loops, case statements etc. This gave pretty good token efficiency with a high reasoning accuracy. However, self-updating was considered risky, with no structural validation.

## Summary

AGENTS.md is still fairly new and AI-native developers are still fresh from context engineering. There is plenty of scope for improving format and structure of files. I think we will see a lot more discussion over the coming months, and it will be interesting to see if https://agents.md/ evolves to add more best practices.