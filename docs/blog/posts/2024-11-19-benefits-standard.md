---
slug: benefits-standard
date: 
  created: 2024-11-19
category: VoltScript
tags: 
  - LotusScript
  - VoltScript
  - Volt MX Go
comments: true
---
# Reaping the Benefits of Standard

More than three years ago we began work on VoltScript. A little over a year ago we released our first Early Access code drop. There were certain core principles to which we developed. Two of these were **a modern developer experience** and adoption of **standard development practices**.

Over recent weeks I received ample evidence of the benefits as I improved and extended [Archipelago](https://help.hcl-software.com/docs/voltscript/early-access/howto/writing/archipelago.html), the build management engine of VoltScript.

<!-- more -->

## IDE Choice

We were never going to use Domino Designer as an IDE, because we were never going to be working with design elements in an NSF. And the LotusScript editor doesn't work with files and folders. So we needed to choose a development IDE.

The IDE we targeted for developers was Visual Studio Code, with extensions for the language server and build management. On a recent webinar we were asked if we would be building extensions for the JetBrains IDE WebStorm. The extensions require a considerable amount of development. One of the main reasons for choosing VS Code, apart from its widespread use, was that it uses the Monaco editor, which can also be embedded into any web application. After that choice and before we got to integrating with Volt MX Go's Foundry server, work had already and independently been done to integrate the Monaco editor for JavaScript. The choice to target VS Code, a standard and open IDE, was already bearing fruit.

More recently, I remembered that VS Code extensions also work in [Eclipse Theia](https://theia-ide.org/), which has its own desktop install and can also be used via a browser. It requires spinning up a separate Docker container for each developer, which is likely to be a barrier to many environments. But with a customised Docker image that included the VoltScript runtime and the VS Code extensions, I had a fully functional browser-based development environment within a few hours.

And with multiple AI-first IDEs like [Cursor](https://www.cursor.com/) and [Windsurf](https://codeium.com/windsurf), all of which are using forks of VS Code's IDE and can run VS Code extensions, the options are many. And all because we chose a standard IDE that had open source code.

## AI Integration

Another advantage of choosing a standard IDE was that there is a wide community of developers writing extensions. GitHub and JIRA integration for the workspace folder? Provided before we started the project. Integration with task management for TODOs, FIXMEs and more? Again, already built. A modern terminal to integrate with, which supported console colours? Again, already there.

And with the rise of AI and GitHub Copilot, we (and anyone using an early access code drop) had AI integration free with no additional effort. No need for people to wait for a new IDE release from us. No need for additional development by us to integrate AI functions into the IDE. Everything was there with absolute zero effort. Because we used a standard IDE.

I've been using GitHub Copilot for VoltScript coding for many months now. Although it understandably doesn't know some APIs - GitHub Copilot's training set is dated from October 2023 - it understands a lot of syntax. (I'm not sure if that's because it's working from LotusScript or Visual Basic.)

But it provides some functionality that would otherwise need coding, like code formatting, refactoring code out into its own function, checking case, checking cyclomatic and cognitive complexity.

In the most recent development, I had calls to a function that passed a platform name and the platform label to use in a config file. I was refactoring this to a `for` loop and moving the mapping of platform name to label into a `Select Case` statement inside the function. I removed the parameter from the function, but did not yet update the function calls. As I typed the `Select Case` statement, it correctly completed each `Case` statement.

## JSON Validation

Our archipelago build management system requires a configuration file alone the lines of Maven's pom.xml, NodeJS's package.json or XPages' Xsp Properties.

In an NSF, the Xsp Properties is a properties file, but with a graphical user interface with checkboxes, drop-downs and input boxes. Because we're using Visual Studio Code, which does not have graphical interfaces, it would be a poor decision to create a graphical user interface. Instead, we chose JSON (well, actually JSONC, JSON with Comments) because it's easy to contribute a schema and samples via the VS Code extension.

As one of the improvements, I needed to add validation to prevent "latest" as a version for VoltScript Extensions. Again, because we were using JSON, with a JSON schema, it was easy to find a solution...because it was standard.

## Coding

Because we were making changes to the underlying runtime engine, regression testing was important. With the absence of any LotusScript testing framework, creating one was a crucial step early on. This was out first VoltScript Library Module, was open sourced before we did our first Early Access code drop, and has also been ported to LotusScript as [bali-unit](https://github.com/openntf/bali-unit).

Writing unit tests is standard in most coding languages. So obviously Archipelago has unit tests throughout for various functions, as well as integration tests for external REST calls and writing files. So throughout the recent development, I was identifying functions that needed updating, running the unit tests before and after, as well as updating them for additional tests that were required. And because it can be integrated into build pipelines, when I created the pull request for my changes, the unit tests ran as well.

And coming back to GitHub Copilot, writing unit tests is something I've found Copilot particularly good at speeding up development.

## JSON Validation in Code

I covered using a JSON schema earlier to show validation errors in VS Code. But that doesn't stop the developer actually saving the invalid file in VS Code - or using another IDE. So when we run dependency management, we need to validate the JSON file as well, before converting it from JSON to a VoltScript object.

Unit testing frameworks are pervasive. But when I was writing VoltScript, I found a use for unit testing that I've not seen in any other language: validation. If a test suite runs tests and they pass, the thing being tested is valid; if a test suite runs tests and they fail, it's not valid. So if the output is suppressed, you can use a unit testing framework for validation. So we do. And archipelago was the first place where I did that, for validating the JSON configuration file.

So I needed to add validation for a new "runtimePlatforms" property and to ensure "latest" was not used as the version for a VoltScript Extension. To do this now proved very quick to write - just creating a few additional tests.

## JSON Conversion

But handling JSON objects throughout the code does not make for readable and easily supportable code. So converting JSON to VoltScript objects makes things much clearer. However, that can be verbose if the conversion is manually coded.

Again, we have taken a leaf out of other languages. And we have [VoltScript JSON Converter](https://github.com/HCL-TECH-SOFTWARE/voltscript-json-converter), which work in some ways similar to Google GSON with converters and automated mapping to object properties.

As a result, the changes needed to handle converting the `runtimePlatforms` property was literally two lines of changes. First, adding a property to the `Atlas` object - we don't need getters and setters, an `Execute` statement sets the property value. Secondly, a mapping to use a StringCollectionConverter for the `runtimePlatforms` property.

## Conclusion

I've always preferred a standard approach where possible. While some Domino developers use custom design element for Java classes and JARs, I only ever used the standard Eclipse functionality, editors and right-click menus. So whereas others have hit problems, I never did. And as an added benefit, when I needed to code normal Java projects, I was already familiar with everything.

So when it came to VoltScript, I again wanted to choose standardisation. The benefit came that I was able to complete what had been designated as seven JIRA points (at least two days' work) in less than a day.