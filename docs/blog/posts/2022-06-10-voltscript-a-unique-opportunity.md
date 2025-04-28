---
slug: voltscript-a-unique-opportunity
date: 2022-06-10
categories:
  - VoltScript
tags: 
  - VoltScript
  - Volt MX Go
comments: true
---
# VoltScript - A Unique Opportunity (Paul Withers and Jason Roy Gary)

At Engage 2022 Volt MX Go was announced including features like Volt Formula, a JavaScript-based fusion of Notes formula syntax and Open Formula, and VoltScript, a derivative from LotusScript, and inspired by many modern implementations of BASIC, which will run in Foundry, Volt MX Go's middleware layer. Already at Engage we demonstrated live running code of VoltScript with Try/Catch/Finally, an alternative declaration keyword "Def" for "Dim" and deprecation of GoSub; which let’s be honest is Satan’s spawn. These are the first changes to the core LotusScript language keywords in over 30 years. In addition, we showed live demos of code running triggered from Foundry as well as standalone VoltScript outside of HCL Notes or Domino, for the first time since the end of life of Lotus 1-2-3. We also showed a number of new extensions (LSXs / VSXs) that will obviously be required, as well as developer productivity tooling like unit testing, mocking and a POC of dependency management.

<!-- more -->

Already we have created more enhancements than were made when LotusScript was added into Lotus Notes from the rest of the Lotus SmartSuite family of products. But this is just the start - both for language enhancements and developer tooling. The intention to bring an additional backend language to Volt MX that will be familiar not only to Domino developers but also VB6 and VB.Net developers, modernised and enhanced for the current development landscape. We already have a wish-list of enhancements - Big Hairy Audacious Goals probably beyond what many can conceive. And of course, we have also looked at what is already on Aha. Will we achieve them all? Who knows? But we will dare to try, and perhaps even catch.

Very few software engineers in our limited but highly colourful history have had the opportunity to create a new programming language. And yet, we have that chance along with an incredible legacy of LotusScript and its millions-upon-millions of running lines of code to do something that will truly inspire our customers and partners. And just as this is a once-in-a-lifetime opportunity for the research team tasked with the project, it's also a once-in-a-lifetime opportunity for the community. This is a call-to-arms to tell us what you think we should add.

Bear in mind that the target runtime for VoltScript is not HCL Notes or Domino and the deployment target is not an NSF; VoltScript is designed to run anywhere it needs to in the HCL portfolio. From personal experience, we know this is a challenging change of mindset. For example, lsxbe (the LSX containing the Notes backend classes) will obviously not be available.

We know many of you have already asked whether everything will be ported back to LotusScript. Once the non-Domino mindset is achieved, it becomes apparent that not all the new changes we need to make will be appropriate for Domino. Some work will be necessitated because the code is being deployed to and triggered from Volt MX Go’s Foundry. That also means different tooling options, which opens up opportunities that may not be appropriate when the development IDE and target build artefact is an NSF. And some opportunities, like mocking Notes classes, are not possible when the actual Notes classes are already automatically added by the runtime. Some changes may be candidates for porting to LotusScript, but we are a research team for Volt MX Go, not a product maintenance or core engineering team. So, we are not the correct engineers to make such decisions and now is probably not the right time for such decisions.

However, it cannot be understated how incredible VoltScript will be. Today’s landscape is cluttered with low and mid-code tools and platforms that all require users, and in many cases business users, to be dropped to a text editor and expected to type working Java, JavaScript, or C#. We aim to change that just as our predecessors with Notes version 4 did with LotusScript more than 20 years ago. We will give inventive and adventurous non-developers the opportunity to create their own applications using a programming language that is easy to understand, simple to test, and painless to extend to the limit, and beyond, of their imagination.

This is not an existing product, so Aha is not the appropriate route to share your feedback. We don't intend to choose how VoltScript evolves based on the most popular requests as there are different priorities based on minimum viable product and skills required to implement.

In the coming weeks we will share here and elsewhere our current list of features we wish to implement. Contact Paul Withers through various social media or OpenNTF's Discord or Slack if you want to be a part of what will prove to be yet another adventure.
