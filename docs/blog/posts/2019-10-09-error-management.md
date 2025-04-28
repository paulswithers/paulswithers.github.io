---
slug: error-management
date: 2019-10-10
categories:
  - Coding
tags: 
  - Coding
  - Errors
  - Support
  - Editorial
comments: true
---
# Error Management

Over the years I've done a lot of development on a variety of platforms. Error management is something developers either bake in from the start, add in later, or never get round to! It seems a good time to review my experiences and my philosophy.

tl;dr - it varies.

<!-- more -->

## Why Should I Manage Errors?

I think this is often a question skipped by developers, but it's fundamental to **_whether_** and **_how_** you manage errors. And at this point it's important to differentiate between error management and validation. The two can overlap, because insufficient or incorrect validation can result in errors, which need managing. Validation can be minimal or exhaustive, but there's no silver bullet for where, how and to what extent validation is added. But we'll skip that part and assume validation is handled and sufficient.

The purpose of error management, in my opinion, is to aid **_development and support_**. That means:

1. Providing **quick** troubleshooting to ensure valid and correct code during the development process.
2. Avoiding support calls by notifying the user of actions they or others should already have taken.
3. **Quickly** identifying the **location** of an error when support calls are necessary.

**_Why_** an error occurs may be trickier. It may depend on data or variables beyond the code itself. Further debugging or logging may be required to pinpoint that. But it should take the minimal time possible to identify the location of an error and the route taken through your code to reach there. Using debugging to pinpoint the location of an error during development is, in my opinion, not productive. Stepping through a debugger is always slower than looking at a log. And although you can debug during development, it's harder for you and your users to do that in production. So you're either backing your skill to identify all bugs before deployment or risking problems down the line for support.

Of course there are short standalone blocks of code or functions for quick fixup that you have no doubts about or could only fail under extremely unlikely scenarios. I personally have no qualms about skipping error management for very low risk scenarios, especially because I'm usually the one supporting the code I develop.

## Error Burial / Ostriching

That prompts a bugbear of mine, something I call "error burial" or "ostriching". In LotusScript, that could be `On Error Resume Next` - basically just continue as if nothing had gone wrong. JavaScript often just hides errors away in the browser's Console, again just pretending for the user that nothing had gone wrong. I've supported environments where IT have locked down the browser so it's not possible to see if an error has occurred, which makes it extremely challenging to support. In both scenarios, you're left in blissful ignorance of an error. And if it becomes apparent there's a serious issue, you're often left guessing what went wrong.

There's an unmanageable scenario that can also result in error burial - a crash. Crashes may be the result of code or external circumstances. Managing those proactively is typically not possible, and in those circumstances I'm reminded of the sporting maxim "control the controllables". If it's not controllable, accept it and deal with it retrospectively.

## Error Logging

Many frameworks log errors at varying criticalities to one or more logs. This can be useful for support purposes, identifying where the error occurred, maybe with additional some finer logging (either always or switched on via configuration) to help identify variables. Logging allows quick support of a problem, both in production and during development. But in itself, it's not managing the error.

## Error Notification

It doesn't tell the user - or support - that an error has occurred. It only allows you to deal with the aftermath when - or if - you're notified. Because logging handles errors as well as "events", not everything needs notification. Similarly, if your process "expects" or manages failures, you might not be interested in notification. If the process retries shortly afterwards, the "error" only becomes a problem if it persists.

Similarly, the notification to a user may be different to the notification for a developer or support. A more user-friendly message may be required for users. If it's a failure to perform some broader configuration by the user, there may be no need to notify support. During development time, you might just want something more blunt, to let you just get on with fixing the error. And depending on the circumstances, notifying support may need its own management - e.g. in an application that may be used online or offline.

Whatever the process, the error notification will typically be handled - and need to be set up - separately from the error logging.

And I won't go down the rabbit hole of error management of the error notification! ;-)

## What Next?

This is the true part of error management.

Logging or reporting the error is not enough. What should be the next action? Does the code need to abort? Is the code within a loop and needs to continue with the next element of the loop? Are there subsequent actions that need to be prevented? Are there previous transactions that need rolling back? Are there additional data updates that need to be made in order to prevent other independent processes failing?

Obviously there is no single answer for all eventualities. And the correct action may require changes to the architecture of your code. Moreover, additional error management may be required elsewhere in your code, to deal with the failure. And in one of the locations you may need to suppress error logging to avoid duplication. Even more complex is working with or developing an API, because two independent error management processes are needed. Typically no one developer will be in control of both.

The "what next" question is why ostriching can be so bad. If you ignore the error, you are abrogating your responsibility for managing the impacts.

## Summary

As you can see, error management is a more complex topic than it may seem. That may be why developers skip addressing it. It's also an area that a lot of tutorials skip, leaping straight into a "hello world" application. But that ignores the one constant of working with new technologies - mistakes will be made, and making it easy to resolve them is key to enjoying working with the technology. Quick and easy is only quick and easy if you get it right first time.

Good error management is critical to a quality and easy-to-manage product. It gives reassurance to users and provides a core foundation for effective support. Ostriching may make it seem like everything's working fine, but you can't fix what you don't know. And fixing it when something more critical comes along may be a lot harder. If you have a good logging framework available before development starts, it's a strong starting point. If you have an IDE that minimises effort by boilerplating error management, that's also a strong starting point - as long as you _make_ the time to configure it as required. The "what next" can be addressed later in development. And getting the logging in from the start can speed up development, giving you the time you need at a later stage to ponder the "what next".