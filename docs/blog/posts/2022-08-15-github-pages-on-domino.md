---
slug: github-pages-on-domino
date: 2022-08-15
categories:
  - Domino
tags: 
  - Domino
  - Markdown
  - Documentation
links:
  - blog/2022-08-16-github-pages-on-domino-2.md
  - blog/2022-08-17-github-pages-on-domino-3.md
comments: true
---
# GitHub Pages Sites on Domino 1: Why

Source control is a topic that periodically crops up around Domino. And if source control is important, there is only one choice for documentation - **Jekyll**. It's not hard to justify why. I'll come onto more detailed coverage of the technologies involved in the next blog post. But suffice to say, for now, that some key reasons are:

<!-- more -->

- Very widely used, so plenty of answers already to many of the questions you don't know you want to ask.
- Separation of content from display, _the_ holy grail for portability of content.
- Light-weight coding to create sophisticated layouts and passing variables into HTML files.
- GitHub Pages can generate and host the sites for you.
- Everything is text, so perfect for source control.
- Local generation creates an **_site** directory that contains your generated website, which can then be passed to anything that can host HTML, CSS and JavaScript.

If you're building a blog or documentation for an open source project that's already on GitHub, GitHub Pages makes the most sense. GitHub Pages still provides an intuitive URL linked to your profile or project. But you can also choose a different domain name for the GitHub Pages site.

If that doesn't provide what you want, taken as a whole, these points provide a compelling and unbeatable set of options.

## Hosting on GitHub Pages

If you're building a personal blog or documentation for an open source project that will itself be delivered on GitHub, GitHub Pages makes most sense. Particularly with blogs, content should be as free to use as the design, so there is no reason not to use GitHub Pages for both. If your documentation is only for use internally but you host your source control on an internal GitHub server, it also makes sense. But if you want limited access and you're using free GitHub, a private repository cannot have a GitHub Pages site.

## Hosting on Domino Server

If you already have Domino, and are willing to run the HTTP task (not all customers are), then it offers a ready-made web server where the site can be hosted. You could just put the content in the /domino/html directory and host directly from the server. This requires access to that directory on the Domino server, which might be problematic. But you can also host within an NSF.

## Hosting in NSF

An NSF provides a variety of benefits for hosting documentation content. There are a variety of ways this can be done, and when we get to that point, I will cover the one that makes most sense for me. But let me list some benefits the NSF provides out-of-the-box.

- Rapid deployment, just paste the site contents into the NSF and you're ready to go.
- Replication to other servers is not always relevant, but is a huge benefit where required.
- When upgrading a server, I have seen some customers where content in /domino/html directory is forgotten about and lost. This won't happen if the content is in an NSF.
- Authentication can be controlled by Domino, ensuring the site is only accessible to authorised individuals.
- The site can be hosted without needing to worry about challenges of licensing conflict between framework and content.

There are limitations. The Domino HTTP server has not kept pace with other HTTP servers, so there may be caching options that are less straightforward to leverage for those who are not seasoned Domino admins. But whatever your choice, there are always going to be compromises. It's just a question of which compromises you're willing to accept.

But if you're hosting in an NSF, why not write your content in an NSF? I've tried going that route before. I built a website builder tool on XPages where content was written as Domino Rich Text and configuration on documents provided some flexibility of layout. But modernising the look and feel was far from straightforward, even though the content was separate from the overall website. [XPages Help Application](https://xhelp.openntf.org/) was another project I created for documentation, but again updating the look and feel was not a trivial task. And neither provided source control of the content. And although the XPages Help Application was intended to allow business users to manage content, in reality I found business users were not interested in taking ownership of training materials. (Ironically, that was a key step on me becoming a citizen developer and eventually a full-time Notes developer. But maybe that is not a route IT departments or business users are interested in today.)

## Content

I've also moved well away from rich text, whether that be Domino Rich Text or rich text as the wider web development world consider it - which incidentally does not include Domino Rich Text, but is reproducing a lot of what has become painful with Domino Rich Text.

Content writing should always focus on content, rendering should always be handled separately. Content editors should not be defining which font is used or even font size, that should be standard across the site and managed separately. And if you want any kind of source control, it _has_ to be stored as text only. For me, that means **Markdown**.

HTML, even when provided by web editors, creates inconsistent results. And that is why so many web editors, particularly those that wish to focus on co-editing, manage and store content not as HTML but as JSON. If they could standardise on the schemas they manage and store the content with, maybe the output of web editors could be a valid content format for source control. But we are years away from that, probably more than a decade.

The other point when it comes to source control is that images and attachments - binary content - _has_ to be separate from the textual content. Most web renderers separate them for display purposes. But for source control purposes, packaging them together is a convenience that makes reconciling differences messy, difficult or plain impossible.

Source control has been a key part of my life for many years now, it's saved me on more than one occasion, and I have adapted my development on occasion to work around limitations. There may be some who will not use source control on Domino until it fully supports all possible code they have or may have in their application, and I'm not interested in getting into those discussions. For the purpose for which I'm writing this blog series, source control of the content is important to me and I will adapt accordingly.

Developing a site as a GitHub Pages site, managing it as a standard GitHub repo, and deploying to Domino is a compromise I'm willing to make. The NSF - and its content - becomes deployment only. The source is in files in Git.

In the next blog post I'll give some background on the technologies behind GitHub Pages sites, because this is probably unfamiliar to many Domino developers.

## Table of Contents

Jekyll - Why<br/>
[Jekyll - What](./2022-08-16-github-pages-on-domino-2.md)<br/>
[Jekyll - How](./2022-08-17-github-pages-on-domino-3.md)