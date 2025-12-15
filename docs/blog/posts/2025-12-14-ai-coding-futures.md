---
slug: ai-coding-futures
date: 2025-12-14
categories: 
    - AI
tags:
    - AI
    - Editorial
    - GitHub Copilot
comments: true
---
# AI Coding Thoughts

[**Vibe coding**](https://en.wikipedia.org/wiki/Vibe_coding) is probably the term of the year. Since being coined by Andrej Karpathy in a tweet in February the term has gained widespread adoption. My job is research, so I'm not one to accept code without review. But I absolutely need to be aware of new technologies and approaches, and evaluate their usefulness. And all technologies improve over time. So AI-assisted coding has been a regular part of my work for 18 months. Over recent weeks I've used it more and more, for a wide variety of purposes. And research is not just about trying things, it's about extrapolating and anticipating future usage.

<!-- more -->

## Recent Experiences

Research means using different languages, frameworks, and technologies. And at the heart of research work is creating prototypes, quickly. So being able to generate what you need quickly is important. Traditionally, this would be done by poring over documentation, looking for examples, trying to get it working, and asking questions in chats or forums. Now, the key to speed and learning in leveraging AI. And it's impressive what can be achieved.

Within a few hours, via chat AI generated a Python web UI leveraging the Dart framework. This was a fully working web UI, calling backend services, built up iteratively adding additional UI elements. The impressive thing is I never once looked at Dart documentation. I never looked at a Dart example. But AI gave me everything I needed for a powerful demo. If someone wanted an additional input box or combo box, if the combo box needed to pull from options via a REST service, I now had all the information I needed. By asking the right questions of AI, I was able to convert it into a server-side REST service and a framework-less web UI using web components.

I also had an opportunity to try developing with Go, another language I've not done before. The traditional approach is following a training course, which I did for more than a few hours, still learning the basics of the language. I could have continued, probably for several more days before I started coding a prototype for what I needed. But I decided the better approach was to use AI. GitHub Copilot and VS Code has evolved so much during the year that [custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) are now available, which allows you generate instructions for specific needs. With a custom coding agent, within an hour I had generated an initial sample in Go and, using a separate documentation sub-agent, I had generated comprehensive documentation which I augmented after going through the code line by line and asking AI questions to understand it better. And less than an hour later, with additional AI attempts and follow-up research, I had learned enough to decide that Go was not the right language to choose, because of limited support for other requirements.

Separately, I've also been working with a Rust UI framework, at different times over a number of months. I talked about problems of AI hallucination [a few months ago](./2025-08-16-ai-lessons.md), because APIs had changed. Interestingly, when I tried more recently, and with a different model, I had much better outcomes. I talked in my [last blog post](./2025-10-26-barriers-to-effective-ai-4.md) about causes of hallucination. Going back to my blog post on troubleshooting, there are two key differences - the different model and the progression of time.

A paid model is obviously going to be better than a free model, and this is something AI consumers need to be aware of. The truth has always been the same, that you get what you pay for. Some customers may be concerned about data sovereignty, but the fact is that the quality of AI from on premises models and the cost of the hardware to run the best is beyond most customers. And customers need to ensure they update the model regularly - more regularly than they would typically update software.

The second option was the passage of time. As open source versions gets closer to release, documentation gets updated. If models are updated, that means the content it's using to make its deductions gets updated. This results in better responses, especially if older materials are removed. I've no idea if that's how model training works, but I'm conscious of the effort and cost it would take. The passage of time was also what allowed me to have a better experience using custom agents and sub-agents.

So what does all this mean for the future of coding?

## Why Low Code?

Low code has been a major in-route to software development over the last 40 years. Innovations like Lotus Notes, Visual Basic, Excel formulas, Salesforce have all enabled those who were not computer scientists to build powerful applications. There are other products that offer low code options, for various purposes.

But low code has a problem. The documentation tells users where to click, which menu options to choose, what to fill into properties boxes. Under the hood there is code, but documentation and examples don't focus on this. Their focus and what they provide is for the developer and their needs, not on the code that's generated and what the AI integration needs.

There's a reason that these products tend to focus on what AI to offer the end user and not the developer. Or they offer AI-assisted functions for the developer. These are the easy wins. But the next steps from there are much more challenging, and I expect AI integration to slow.

It's a major undertaking to give AI programs the knowledge needed to convert requirements into the code AI needs to write. And it means a dual effort - developers who want to perform tasks manually need the documentation that focuses on the what the user can see, AI needs the documentation for the code.

And then there are potential problems for the IDEs. The IDEs are designed to work one way, taking user input and generate code. If changes are made in the code, will the UI pick up the changes automatically, or is additional development required in the IDE to reflect the changes for the user? And even where there is textual code, this needs a custom AI program that can integrate with the IDE's editors. The hard work that developers of other IDEs have already completed needs to be reproduced in a proprietary IDE. Even where the IDE is based on a more standard IDE but with custom editors, it is not a given that the standard AI extensions in those IDEs will automatically integrate the with custom editors.

And I am certain that developers will not expect these problems.

### The Coding Mindset

Let's be clear, I'm not saying low code is dead, for two reasons.

Firstly, human civilization has supreme adaptability, but human individuals are often resistant to change. Many developers will be reluctant to move from low code platforms to AI-enabled development in traditional coding languages. Similarly, customers will be reluctant to redevelop their existing systems, so developers will be needed to perform (frankly dead-end) support of those applications.

Secondly, the skill in using AI with traditional coding languages is knowing how to architect a solution well, knowing how to explain requirements clearly and effectively, and being able to identify which edge cases are not covered but need to be covered. Not all people have this skill. So some will still need low code platforms. The rest will no longer need to start with low code, they will jump-start their development career.

The future is clear. A shrinking ecosystem of fewer and fewer customers, admittedly some of whom will be larger organisations. And a shrinking ecosystem of people willing or capable of supporting them, often the less skilful.

## Open Source

Open source has grown over the last two decades. Even large companies have Open Source Project Offices now and are committed to developing in the open. The benefit of open source frameworks and languages is that not only is the code available for AI, but there are also potentially examples, tests, API docs, and documentation in Markdown. This is particularly important, because all are particularly suited to processing by LLMs. Indeed the format typically used for providing additional information to LLMs is Markdown.

But there are also challenges. The levels of completeness differ, as do the levels of current activity on the projects. But more significantly, the open source repositories and the published versions may vary, as may the code and the documentation.

Code developed behind firewalls avoids these challenges. But there are other challenges. The code may not be accessible or easily accessible. Tests will not be accessible. Documentation and samples may be limited. The reliance on community content is even higher, to give a suitable abundance of content for LLMs to comprehend.

It will be interesting to see how new open source libraries and frameworks evolve. But I think this ia a barrier against the adoption of new languages, whether proprietary or open source. As my colleague [Jason Gary blogged](https://www.jasongary.com/p/feeling-the-vibe), it's more likely that developers will use AI to generate machine code rather than develop a new higher-level language.

## Application Migrations

But what about where applications are stuck on out-dated or legacy platforms and languages? There is a benefit in moving existing developers with the applications, which historically gave an advantage to a language more similar. This has been a play for companies.

But when AI makes it easier to learn new languages, the strongest choice depends on different factors. If a language close to the platform is important, then languages like Rust or Go may be preferable. If the client is a browser, Node.js with frameworks like React may be preferred, or the braver developer will go with web components and vanilla JavaScript, HTML and CSS.

The strength comes from understanding the application. It comes from being able to interrogate the legacy application and understand the functionality, being able to challenge end users to identify what's actually needed, and being able to ask the right questions to architect the new solution in the right way.

For people with the right skills, the options are wider than ever before.

## Full Stack Development

Historically the main strength of a developer has been knowledge of a language, a framework, their APIs and syntaxes. Full-stack development gained prominence because it didn't need separate back-end and front-end teams, and it arose from both sides.

Node.js and frameworks like React championed full-stack development from the client-side approach, focusing on JavaScript as the language of choice, even embedding HTML in JavaScript. On the server side, the Java-based choice was JSF with proprietary extensions like XPages. More recently Rust has tried to address this with Dioxus. And Python had frameworks like Django or Dash.

But when the skill is asking the right questions of a knowledgeable AI, why do developers need to limit themselves to a single language for all their development?

I don't think full-stack development is disappearing. Some developers will still prefer to use a single language. And the vast amount of available examples for frameworks like React will allow developers to use that single language for certain scenarios.

But the problem is that certain languages are best-placed for certain tasks. JavaScript is best placed for in-browser functionality. If you want something close to the platform but accessible, Rust or Go have advantages. If you're happy within a JVM and have the skills, Java is appealing. And if you want to interact with AI, Python is way ahead ahead of everything else.

And that's the problem that developers who want to limit themselves to a single language will hit.

Because the most flexible developers will choose the best language, libraries in other languages are likely to lag further and further behind. It may be a controversial opinion that the most skilled developers will also choose the best language. But it's definitely factual that *some* of them will, which will impact the development of those libraries.

Equally it's possible that some companies may still have back-end and front-end teams. But I think it's certain that some companies will have teams of individuals that can work in both back-end-only and front-end-only languages.

## The Importance of Community

But let's address the elephant in the room. There is a key requirement for the ability to be flexible with which language you use when. That is community content. Blogs, open source projects, and *good quality* forum posts.

I emphasise "good quality" because too often forum posts have inadequate analysis of symptoms, which generate scattergun replies. Older forums don't have accepted answers, but even where answers are accepted, the thread may be insufficient for AI to properly identify why the answer worked. This can result in AI suggesting answers that are wrong, or even being distracted from better answers. With traditional searching by a knowledgeable user, they can quickly dismiss bad threads or bad answers. When your entrypoint is an AI response, it may be harder to discern bad content.

Some niche frameworks have become popular with small groups of developers. They may rely on a small handful of advocates who have generated good quality output. However, they will struggle more and more. There will still be outliers used by the person who created that framework and a few others. But their communities will be smaller than they would have been - both the community of consumers and the community of producers.

In the age of AI, the importance of a thriving community of producers cannot be understated. It's not sufficient for a vendor to be generating all or even most of the content. Any framework is dependent on a thriving community of consumers for a wealth of content on best practices or integrations. This cannot be sustained by one or two individuals, whether inside or outside the vendor. The community needs to step up, even more so if it's an older technology. Because the older the technology, the harder to identify the good quality, current information that should be used.

It becomes much easier to use AI to understand what the code does, and then migrate the application, than to support and enhance it.

## Final Thoughts

A colleague summarised recently that the output of an IT programmer was restricted by their knowledge and their speed of typing. Junior developers progressed to senior developers through the knowledge they gained. You had a team of developers mixing architects, code monkeys, QA reviewers, test engineers, automation experts. The future is IT experts who have the skills to marshal a team of IT agents who can help them architect, write code, perform QA, write tests, and build automation.

A number of technologies will disappear or become very niche. If they're open source, they may survive even if they're only used by the main developer and a handful of others. If they're proprietary, they will struggle more and more, becoming specialised software, with fewer and fewer customers. They will face the Scylla and Charybdis of being expected to add AI into the development process, but knowing that if they do, it makes it easier to gain the knowledge that allows customers to migrate the applications.

At the heart is the need for a community of providers. Those top-heavy on consumers will suffer more and more.

Because AI makes choice so much easier than it's ever been before.