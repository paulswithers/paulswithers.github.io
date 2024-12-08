---
slug: github-pages-on-domino-2
date: 
  created: 2022-08-16
category: Domino
tags: 
  - Domino
  - Markdown
  - Documentation
links: 
  - blog/2022-08-15-github-pages-on-domino.md
  - blog/2022-08-17-github-pages-on-domino-3.md
comments: true
---
# GitHub Pages Sites on Domino 2: What

Hosting a GitHub Pages - or more properly, Jekyll - site on Domino may not fit everyone's requirements. But it did fit mine. The "how" is relevant for any static website, although there are other options that I'll mention. But this blog post is covering the "what", the technologies involved. There is a lot that will be unfamiliar to many Domino developers, but technologies worth getting familiar with.

<!-- more -->

## Content

The content is written in **Markdown**, without a doubt the only choice if you want formatted and portable content which can be written by a variety of people. It allows combination of text, tables, code, images and attachments. It _can_ include HTML, though there are other ways of handling that. Most importantly, it focuses on content and not presentation. This flexibility makes it great for blogs, technical documentation, or even small files of developer notes. It is also the standard for readme files in repositories, so most developers are already familiar with it.

Markdown itself has a variety of flavours, the most common being [**kramdown**](https://kramdown.gettalong.org/), because it is understood by a variety of editors and renderers, most importantly GitHub Pages. Kramdown even lets you specify the class to apply to a paragraph.

There are also a wide variety of editors that can be used, both for desktop and mobile. On Windows, I started off using [Markdown Pad 2](http://markdownpad.com/), although when I last used it (a couple of years ago) there was a problem rendering on Windows 10, resolved with an [Awesomium SDK](http://markdownpad.com/faq.html#livepreview-directx). Now my usual editor is Visual Studio Code, primarily because I use Visual Studio Code for much more than just editor of markdown files. There are extensions that allow live preview of markdown files within VS Code, but the terminal also allows easy running of GitHub Pages sites from the IDE.

## Jekyll

Editors can let you write markdown files immediately. But if you're wanting to build or preview a whole site, you're going to get into [**Jekyll**](https://jekyllrb.com/). Jekyll is not a product, but a tool-set, built on Ruby. This requires setting up your development machine with the [pre-requisites](https://jekyllrb.com/docs/installation/), for which there are detailed instructions for various operating systems. Having installed on a variety of operating systems, it is straightforward to do. There is also a [Docker image](https://hub.docker.com/r/jekyll/jekyll/), which I haven't used but - knowing what Docker does and the requirements for running the Jekyll server - makes a lot of sense.

### Ruby

Ruby may be unfamiliar to some. Ruby consists of [Gems](https://jekyllrb.com/docs/ruby-101/#gems), packages of code. Jekyll is a gem, as are many Jekyll plugins, and so is `bundler`, which installs all gems in your gemfile.

The **gemfile** is like the package.json in a Node.js project, it lists the Ruby gems to install and the versions. The important point to bear in mind is that, as with anything else that uses a dependency management tool, some dependencies require specific versions. And GitHub Pages also uses specific versions, which can limit the versions used.

#### Commands

Commands are run from the command line, so you will get used to this. If you must have an IDE that does things for you with menu options, Ruby - and Jekyll, and GitHub Pages, and Markdown - are not for you. These commands you will become very familiar with:

- `gem install` will be the most basic command used, to install a Ruby gem. `bundler` is one that you will want, because it lets you use the Gemfile, which lets you ensure the same versions installed across all environments.
- `bundle install` will install all gems specified in a Gemfile.
- `bundle exec jekyll serve` will load the local website, usually on port 4000, according to the `_config.yaml`. If you come across a site that's not using a Gemfile, `jekyll serve` will be the command to use instead.

### Config.yaml

The `_config.yaml` file holds the config to use when rendering the site. It's written in YAML and all the variables there can be referenced throughout the site. This is part of the power of Jekyll, and comes because of **Liquid**.

### Liquid

Liquid is a powerful open source templating language created by Shopify, with a wide range of functionality, as covered in the [Liquid documentation](https://shopify.github.io/liquid/). As well as referencing variables, it can create temporary variables, code flows and loops, as well as filtering. When combined with data json files and HTML include files, it can create some very sophisticated display options without needing to resort to JavaScript coding.

### Layouts and Includes

**Layouts** are templates for different types of pages. Each markdown file will define the layout it should use in the **frontmatter** of the page. They can include inheritance, if you wish to get particularly sophisticated. **Includes** are snippets of HTML to include in one or more templates. This allows you to define e.g. headers or footers once only. The layouts - and the CSS referenced - will handle the display of the headings, text, tables etc in the markdown content. Of course they can also include JavaScript files.

### Pages

Rather than focus on presentation, the pages are just markdown with YAML **frontmatter**. These are variables that the site will use to feed into the content, but most importantly the **layout** variable, to determine which layout to render the page with.

### And More

There is much more that Jekyll can do, as covered in the [docs](https://jekyllrb.com/docs/). It is also used by many developers, so there is plenty of community support.

### Themes

But the greatest power for Jekyll is the themes you can apply - and extend. There are a variety of themes that GitHub Pages offers out-of-the-box. But there are also a variety of other themes that are out on the web. One I've used in a number of places is [Just The Docs](https://just-the-docs.github.io/just-the-docs/). This is great for small documentation sites. Another more sophisticated one I've used is [I'd Rather Be Writing](https://idratherbewriting.com/).

Different themes will render the content in different ways. And once you run `bundle exec jekyll serve`, you'll see in the "_site" directory how it's actually building the website. The interesting thing is that this directory can be used for any static website hosting tool. Including an **NSF**.

However, when it comes to links to other content, you will need to take care and may need to tweak the layouts. Relative links are always best, and this can be done using `../` to navigate up a level from the current URL, or using [Liquid filters](https://jekyllrb.com/docs/liquid/filters/). But then you need to be aware of how your theme renders the pages in the static _site directory. Also, some links may omit the ".html" suffix or more. I've come across a theme that generated every page as an "index.html" page in a sub-directory relating to part of the frontmatter. Some static web servers will automatically work that out, but Domino looks for a page at the specific URL provided. TO quote Stephan Wissel, YMMV.

With this caveat, it's next time to move on to my preference on how to set up Domino and the NSF.

## Table of Contents

[Jekyll - Why](./2022-08-15-github-pages-on-domino.md)<br/>
Jekyll - What<br/>
[Jekyll - How](./2022-08-17-github-pages-on-domino-3.md)