---
slug: mkdocs-on-domino
date: 
  created: 2022-10-30
categories:
  - Domino
tags: 
  - Domino
  - Markdown
  - Documentation
comments: true
---
# MKDocs Sites on Domino

In the last blog posts I covered using a Jekyll-based site on Domino. Jekyll is a popular documentation option based on Markdown, but another is [MKDocs](https://www.mkdocs.org/). MKDocs also has a number of themes - a default Bootstrap-based theme, one used by the [Read The Docs](https://readthedocs.org/) service, and the one I've used, [Material for MKDocs](https://squidfunk.github.io/mkdocs-material/).

<!-- more -->

## Technology

Firstly, it's worth bearing in mind there will be different prerequisites for developing an MKDocs site vs a Jekyll site. Whereas the technology behind Jekyll is Ruby, the technology behind MKDocs is Python, so [requires Python and its package manager, pip](https://www.mkdocs.org/user-guide/installation/). As with Ruby, Python can be installed on both Windows and Mac. Once you have Python and pip installed, if you wish to use Material for MKDocs, [installing that](https://squidfunk.github.io/mkdocs-material/getting-started/) will also install all other dependencies required.

Note that some older Python-based programs may still use Python 2, but MKDocs uses Python 3. So if you also have Python 2 installed, you will need to prefix all commands `python3` instead of `python`.

Another option is to use a Docker container to develop against, and there is one readily available for [Material for MKDocs](https://squidfunk.github.io/mkdocs-material/getting-started/#with-docker). Note particularly the instructions for adding plugins to the Docker image, which you will need to follow if you wish to use some of the [many MKDocs plugins available](https://github.com/mkdocs/mkdocs/wiki/MkDocs-Plugins). However, bear in mind that as of October 2022 the Docker image uses the Alpine Linux Docker image as a starting point (which may change the Linux package manager commands you need to use) and Python 3.9.2 (which some Python dependencies for some extensions may not yet have upgraded to).

## Writing Differences to Jekyll

The first is the configuration. Instead of a being managed by the `_config.yml` file in a Jekyll site, the configuration file here is `mkdocs.yml`.

One of the biggest differences to a Jekyll site is with frontmatter. Although frontmatter can be used, it's not required. Page titles, for example, will automatically be picked up from the level one heading on the page.

Navigation is also done in a different way in [Material for MKDocs](https://squidfunk.github.io/mkdocs-material/setup/setting-up-navigation/). If there is no specific navigation defined, all Markdown files will be picked up, in alphabetical order, with directories appearing after individual Markdown files. However, it's possible to manage navigation either with a `nav` element in the mkdocs.yml, defining all navigation for the whole site, or a `nav` element in a **.pages** file of each directory.

## Limitations

There are pros and cons to any framework, and that holds true also for MKDocs. MKDocs works great for standard Markdown documentation, and there are a host of plugins. The in-built search is particularly powerful. But the power of Liquid to create flexible dynamic layouts within the Markdown is not available with MKDocs. Similarly, the ability to integrate content from JSON files and integrate into a Markdown page is also one I've been unable to find any reference to. There do not appear to be as many people seeking to customise the layouts in MKDocs. I suspect that developers with Python experience would be able to create that functionality, but it's not something I have familiarity with nor enough need to investigate further. You can integrate HTML into the Markdown and that was the approach I chose for the limited usage I required.

## Building and Deploying to Domino

When deploying to Domino you will want to ensure to set [use_directory_urls to false](https://www.mkdocs.org/user-guide/configuration/#use_directory_urls). This means that links point to a ".html" file instead of a directory, because Domino will not automatically handle this.

But once your site is ready for publication, you can just use `mkdocs build`. If you're using a Docker container, you can just pass `build` instead of `serve` when creating the temporary container. The result will be a `site` directory containing your website. This can then just be copied and pasted into your **WebContent\WEB-INF\site** directory, as detailed in ["GitHub Pages Sites on Domino 3: How"](./2022-08-17-github-pages-on-domino-3.md).

## Summary

The benefits of using Markdown for your documentation are that migrating or re-using content is much easier. Converting a large site from a Jekyll-based format to MKDocs took just a few hours, including some re-organisation of the content. Removing frontmatter and amending links was time-consuming rather than difficult.
