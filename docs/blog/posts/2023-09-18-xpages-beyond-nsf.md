---
slug: xpages-beyond-nsf
date: 2023-09-18
categories:
  - XPages
tags: 
  - Domino
  - XPages
comments: true
---
# XPages Elements Beyond the NSF

I do very little XPages these days, I have one application for personal usage that rarely gets updated. But it's when applications rarely get touched that changes elsewhere on the server can have a big impact. I'm going to cover two here, the first raised by a discussion on Discord last week.

<!-- more -->

## OSGi Plugins

One big element is with OSGi plugins. Although it is possible to install OSGi plugins as feature and plugin files directly on the server, the recommended approach from the start has been to use an Update Site database. The skills required to build OSGi plugins were always advanced, requiring strong Java skills, typically Eclipse, an understanding of extension points and the code required to load them. Nathan Freeman's [XSP Starter Kit project](https://openntf.org/main.nsf/project.xsp?r=project/XSP%20Starter%20Kit) was extremely useful for giving sample code to contribute OSGi plugins - or "extension libraries" as they became known - to particular areas of the XPages runtime. And without Nathan's great work and commitment to open source, the most prevalent community extension library, OpenNTF Domino API, would probably not have flourished. But before this, there was the first extension library, the XPages Extension Library, and its companion incubator project, ExtLibX.

Since Domino 9.0.1 FP10 ExtLib has come installed on the server, reducing use of the Update Site database to heavy-duty XPages customers, with applications probably supported by very knowledgeable Domino developers. But there are probably still some customers who implemented XPages applications in the days when ExtLib was only installed via Update Site database. And here there is a risk.

We know with agents and XPages, signer of the design elements is important. But it's also important for Update Site database as well. Just as a design element will not work if the signer is not authorised to run code, so too the OSGi plugin will not be loaded if the signer of the relevant documents in the Update Site database is not authorised to run code. This can result in unusual behaviour, particularly as the signer might tend to be an admin who could leave the company and not be expected to have dealt with code. Remove the rights of the ID and ExtLib will not be loaded. And if an older version of ExtLib was signed by someone else, that will suddenly take precedence.

The best way to troubleshoot is `tell http osgi ss` + relevant library, e.g. "com.ibmxsp.extlib" ([#TheresABlogPost](https://www.intec.co.uk/osgi-plugin-troubleshooting/)). Then cross-reference the versions against the Update Site database. As that blog post highlights, "ACTIVE" is the key. And to resolve the problem, you can use the "Sign All Content" button.

## Themes etc

Another advanced XPages approach was using themes. This allowed the developer to set styling for specific components across the whole application, by adding a Theme design element to the NSF. But what if you wanted the same styling across the whole server? Well then the theme could be added to <Domino>/data/domino/html directory. Older servers may still have "lotus" and various "oneui" folders there. But you could create your own theme and upload it directly to the server.

However, like some other areas of the Domino server directories, the theme files can also get deleted during an upgrade. So it's important to have a backup and copy it back after an upgrade. On more than one occasion I've had a call saying that styling has changed on an application, and the culprit was a server upgrade without being aware of these directories. The pro admin will no doubt be aware of what should or should not exist for a standard Domino server install, and check before any upgrade. But with customers who are not as committed to the product, this may not happen.
