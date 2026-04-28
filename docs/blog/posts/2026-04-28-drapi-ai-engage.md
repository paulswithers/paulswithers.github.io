---
slug: drapi-ai-engage
date: 2026-04-28
categories: 
    - AI
tags:
    - AI
    - Domino
    - Domino REST API
comments: true
---

# Super-Charging Your AI With Domino REST API, Engage 2026

Last week I spoke at Engage conference in KAA Arena Ghent. I’ve been attending Engage since 2010 and only missed one of the annual conferences since then. It was my first conference, so it’s always held a dear place in my heart. Although it’s many years since I developed for Domino REST API, my work over recent months gave me experience to build innovative proof of concepts using Domino REST API and experience of various models and AI agents to integrate the API with various interfaces.

<!-- more -->

The demos are not being open sourced, for good reasons: to get the best outcomes, you should build something custom and targeted to the narrow use cases you need. It will maximise your success and minimise the level of understanding of AI you need to get the best outcomes. Most importantly, it’s not difficult to achieve such targeted solutions if you are willing to leverage AI, which will also enable you to learn the skills you need for the future.

But I want to talk about the key requirements you should consider.

## MCP Server

If you’re talking to Domino REST API, you’ll need authenticated access. The 2025-11-25 specification of MCP included a number of options. Elicitations - sending a link to the client to log into DRAPI - is probably not the best option because it’s only relevant to the current query.

If you’re conversations are tightly coupled to Domino data, you want something more overarching. You want to tie the session access to the MCP into authentication for DRAPI. Most importantly, you want to check and ensure credentials are tied to MCP sessions, so there is no leakage. This is not a DRAPI-specific issue, so it’s a question you can and should ask your coding assistant to verify.

If you have an IdP, you should look at the Cross App Access SEP (Specification Enhancement Proposal) which allows you to integrate authentication to the client into your IdP to handle authorization, because your IdP trusts the MCP server.

MCP Apps (formerly MCP UI) like the one I demoed are well worth investigating if you want to provide rich experiences within your AI interface. This may or may not be relevant and I demonstrated a fairly traditional UI for searching companies and contacts. But bear in mind that it can be used to provide visual output as well, such as a graphical report.

## Bash Tools

Next I demonstrated a DRAPI CLI, which allows easy integration from a terminal. The starting point was just the “basis” OpenAPI spec from a DRAPI server, with a prompt to create a CLI that supported this. There are two benefits over just using REST API’s directly. The first is that the CLI can have help for all the various options, which the LLM can interrogate to work out what to use. The second is that you can use PKCE for authentication, which retains the token on device, can integrate with your favourite credential store, and can use the refresh token to automatically get a new access token when it expires.

PKCE is not a regular approach for Domino REST API, but it’s good for desktop applications. Although you will still need to generate a client secret for the application in the DRAPI admin console, it’s not used. Instead the client just stores the client ID and uses that with the user authentication to grant specific scoped access.

Unlike MCP, exposing a CLI requires a greater level of reasoning from the LLM or a much greater clarity of prompting. Otherwise you’re less likely to get good results.

Of course another options is to point your LLM to the OpenAPI spec and get it to write code either using curl and jq (for terminal) or fetch (for NodeJS), or another language library. You might need a skill to guide the LLM.

## HCL Leona

The third demo I built was using HCL Leona, a coding harness with a variety of skills and abilities integrated. While building the first example, I encountered a few errors the LLM made. Some may just ask the coding agent to fix the code, or worse still just manually fix it. The right approach is to ask the coding agent to write a skill based on the learning it gained from correcting its code. I built a first pass at a DRAPI skill, and this is being integrated into Leona.

The main areas it struggled with were quirks with DQL. Not surprisingly, it guessed that syntax would be like SQL. Some additional steering was needed to guide the LLM.

The other area was specific to NodeJS and will hit outside Leona as well. It used a common function for escaping content for APIs, but it doesn’t actually escape parentheses. Because parentheses are the common paradigm for hiding views, this meant APIs for accessing view data hit 404 errors.

It’s important to take the time to plan the application carefully. As most AI-native developers have identified, it’s even more important to do that planning with the coding agent, to ensure all that learning is retained when it comes to building and executing the plan.

One of the biggest lessons of AI usage is that humans are not great at understanding what they subconsciously think about and decide. And this can have a huge impact on outcomes.

## Desktop Native

The desktop native application I built was coded in Rust using the Dioxus framework. This is a fast-evolving framework, cross-platform and also mobile-native. So it’s important to ensure your LLM uses the latest release and actively looks at documentation for the right version. Fortunately links include the version number, so you can catch errors thanks to content displayed for thinking modes.

The application was built for both Mac and Windows, but would also have compiled for Linux. I also prompted the coding assistant to build a Windows installer. There are two options - MSI and NSIS. MSI may be what you’re more aware of, but it deploys to Program Files directory, which means the user may not have permission to write files. This is why NSIS installer was the right option for my use case.

Some may ask why not build a Notes Client application. There are at least four obvious reasons. Firstly, as a standalone Rust application, it’s more performant for the targeted use case of just this app. Secondly, it can be compiled for Linux. Thirdly, the application could integrate charting and graphical reporting much more easily. Fourthly, I could integrate text-to-speech. This required bundling a dictionary with the application, which increased the size, and may increase the size even more for multi-lingual. And it also required custom functionality for fields like email, combo boxes, and date fields. The model had no difficulty supporting it, but it did require additional prompts. Plus, it required the user granting permissions.

## Summary

Many commentators are advocating that adding AI into applications is less effective than adding applications into AI. Whether it’s RAG or MCP, or just integrating APIs via skills, the pattern of exposing applications to AI is pervasive. And Domino REST API empowers developers to do that. But best outcomes will come from narrow, targeted integrations. That means building custom solutions.

And with the evolution of coding agents over the last six months, in particular, using AI to help build custom solutions is easier than ever. And as the demos showed, it’s easier than ever before to work out how to provide advanced functionality. But AI also means it’s a trial task to find the answers to deployment questions that historically would have take years of expertise.