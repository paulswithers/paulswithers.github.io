---
slug: effective-ai-4
date: 2025-10-26
categories: 
    - AI
tags:
    - AI
    - Editorial
    - GitHub Copilot
comments: true
---
# Effective AI Usage: Managing Hallucination

One of the biggest challenges when working with AI is hallucination. I've encountered and fought against it. It's worth discussing what can and can't be done to solve the problem.

<!-- more -->

## Know When You're Dumb

One problem of hallucination you can control is being aware when you might be asking the AI program to do something impossible. The AI program will assume that what you're asking is possible and sometimes it's not. It can also get caught in a loop of trying alternative approaches. Unless you're very conservative in your use or AI and IT, you will try to achieve something that's not possible.

Including AI in the planning process and asking targeted questions about potential options early on may identify before you start coding whether something is possible or not. But there may be times you need to just dive into code. Ensuring you've got a good source code commit prior to trying something impossible is important, to create a clean rollback position. And if you're using AI in an agentic manner, when you're unsure if something's possible, you'll want to keep a closer eye on what it's doing.

## Changed APIs

If you're working with a more unstable code base, APIs may change. I've encountered that recently and it can get frustrating trying to use AI to peer code when it's constantly using the wrong APIs or out-dated syntaxes. Specific prompts can help, telling the AI program to check APIs before writing code, or pointing it towards dependency files that define the version being used. But even in conversational chats, you might need to repeat the instructions.

Using an up-to-date model is important. But this may also be where paid-for models provide better results. It's not obvious why, whether they use more up-to-date sources or don't use out-dated sources. But I have definitely found times when the choice of model makes big differences in whether the AI hallucinates about APIs.

Having existing code available that uses the right APIs can definitely help. I've used GitHub Copilot a lot on [VoltScript Testing Framework](https://github.com/HCL-TECH-SOFTWARE/voltscript-testing) which it doesn't know. It starts off guessing incorrect APIs. But as I write more tests, it knows the correct syntax based if APIs have been used already.

Similarly, if source code is available and accessible, it can avoid some hallucination.

## Consumer Responsibility

Of course changed APIs becomes a problem when, like me, you're working at the bleeding edge. However, there's the same problem for consumers and customers that are ultra-conservative or use edge-case functionality that gets broken. AI gets trained on what's latest at the time of training, not what most of the customer base uses. So you may get incorrect results if you're working on out-of-date versions of software, languages, or frameworks. Where languages widely publish a Long Term Support version, these may get preference. But if you're on an older LTS, you might get bad results.

It will be interesting if this encouraged customers to stay more up-to-date with non-cloud software. Or whether IT partners or consultants will start charging customers more if they choose not to remain on outdated versions. Because I believe it will have a bigger impact than ever before, as I'll cover in a future blog post.

### Tailored Content

AI programs have also evolved to add ways to provide specific information to help. GitHub Copilot uses **prompt files** and I've been able to generate prompt files that, at least with brief results, improve the outcomes. That's fine if you want to generate those prompt files yourself, and are willing to invest the time. But what about proprietary content?

Another option that might be worth experimenting with is MCP. This was not an option for me at a time when I needed it. But it might be a good option to allow the AI program to read API docs.

Whether prompt files, MCP, or something else, the format is probably important for the LLM to process it in the most efficient manner and minimise problems with context window sizes.

## Quantity and Quality of Content

Beyond API hallucination, a major cause of hallucination is not enough quantity and quality of content. This is where open source with a vibrant community has an advantage. Not only is documentation available. But also the code, tests, issues, and examples are available to be cross-referenced, as well as any community content - tutorials, blog posts, and open source projects that use the content.

Proprietary products and frameworks will have documentation available for LLMs, which may include some examples. But the code and tests are not available. A custom RAG database may be an option. With a proprietary IDE, there is the advantage that can easily be integrated into the tooling. And it will be interesting if that becomes only available with paid support. But it's not immediately obvious how that would integrate with standard AI programs like GitHub Copilot or Claude.

However, a vibrant community is key to providing additional information, with blog posts, samples, tutorials, and integrations. Vendor-only content is unlikely to be sufficient. Documentation deliberately tries to avoid duplicating content, and for a very good reason. If a topic is covered in more than one place and changes are required, you (or whoever takes over) needs to know that it needs updating in multiple places. Ensuring content exists in as few places as possible in documentation minimises the risk of it becoming out-of-date. Whether it's RAG or model-trained content, if there is a paucity of content and that content does not include a definitive answer to the question you're asking, LLMs will try to extrapolate from what is standard elsewhere. And when it makes those guesses, the LLM does not typically inform you that it has guessed because it has not found sufficient answers. Community content, especially open source code, is key to increasing the content and validating correct approaches.

## Consistency

Ensuring APIs are consistent with other, more pervasive languages is also a good step to take. It's why many IDEs copy keyboard shortcuts from other IDEs, and why developers customise an IDE's keyboard shortcuts. It's the same with languages and frameworks. Where there's consistency, it's easier to move from one to another.

But what if the consistent APIs and approaches came after your technology decided on its route? There is a trade-off to make here: the pain of requiring consumers to change their learning and code vs the benefit of making it easier for AI. Before AI existed, that quandary had a simple answer. Now there may be incentives for standardising. It depends if AI program tooling - like Copilot prompt files, or skills or projects in Claude - are a more effective solution.

## Tooling

Tooling can also play a big part in avoiding hallucinations. A lot of my Copilot usage over recent months has been with Rust. Rust's CLI means it's easy for an AI to run terminal commands and read the response. And Rust's higher quality output works particularly well for AI programs.

In some compilers, error messages are a particular error message at a line number. The problem is that LLMs may not read the line numbers the same. Indeed there are some technologies I've used where the editor hides content from the actual stored content. Rust's error messages include the actual code block that caused the problem, which means the LLM has some actual code to cross-reference against the file it's reading, avoiding mistakes. Rust also tries to advise on how the problem can be resolved, which the AI program can use to try to fix the code.

And this is where documentation alone and vendor content alone will also have a problem. Documentation lists error codes and error messages. But it doesn't explain how to best resolve the problem. Community content can help here, but not just forum posts. Forum posts are often poor on giving sufficient information for a human to work out the cause of the problem, let alone an AI that is not designed to fill in the gaps. And I've often come across forum posts that ask to solve a problem, where that problem is not the root cause that *actually* needs addressing.

Another piece of tooling Rust provides that AI can leverage is **cargo**, the dependency management solution. This means an AI program can be asked to find what dependency could perform a particular function, e.g. reading JSON or integrating with a particular third-party technology. Because cargo is a command line interface, the AI program can call it, read the output, and send it to the LLM. Not all languages and frameworks provide this kind of interaction.

## Humans vs AI

At the root of a lot of the points I've made is one very simple fact: humans and AI do not work the same. And historical content, historical tooling is often aimed at **humans**, not computers. Products, languages, and frameworks that have embraced automation have an advantage in that some of their tooling is designed for automated processing and to give a binary response - success or failure, continue or abort the build.

But documentation is specifically aimed at humans, who look at a screen, use keyboard shortcuts, select menu options, and click buttons. Documentation may not be in an appropriate format for AI to use. And if you address this, you have the added challenge of maintaining two different documentation bases - and more importantly, identifying when you've updated one but not both. That could be a lot harder than it initially sounds.

The same is true for compiler errors and community extensions. And the knowledge for filling in the gaps often comes from experience and asking in chat rooms. None of this is available to an AI program. The quality of work by AI programs comes from filling in the gaps we intuitively and subconsciously ignore on a daily basis. And the problem with subconscious action is it's hard to bring back to our conscious mind in order to educate the AI.

And the knock-on effect is potentially huge and may significantly transform the software development landscape over the coming years.