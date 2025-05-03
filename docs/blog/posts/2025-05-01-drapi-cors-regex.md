---
slug: drapi-cors-regex
date: 2025-05-01
categories: 
  - Domino REST API
tags:
  - Domino REST API
  - XPages
  - Web
comments: true
---
# Domino REST API, CORS and Regex

Release 1.1.3.1  of Domino REST API introduces [a breaking change in CORS handling](https://opensource.hcltechsw.com/Domino-rest-api/whatsnew/v1.1.3.html#cors-is-now-using-regex). This makes configuration less straightforward, but as the documentation states, it increases the flexibility and probably makes things a lot easier for larger environments. And though regex is not something Domino developers work with regularly, there are tools close to home that can help.

<!-- more -->

## Testing Regex

The Domino REST API documentation offers one option for testing regular expressions, [regex101.com](https://regex101.com/). But there's another option...within Domino Designer, as [I've blogged about in the past](https://www.intec.co.uk/test-your-regular-expressions-in-domino-designer/). To do this:

- drag or add the XML for a **Dojo Validation Text Box** onto an XPages.
- go to its properties in the All Properties panel.
- scroll down to the **data** category and click into the `regExp` property.
- click on the icon that appears at the right side of the row with the hover help "Launch external property editor".

The dialog that appears can help you construct a regular expression, but more importantly can help you test it.

However, there are reasons to prefer the regex101 website instead:

- The quick reference on the website is comprehensive.
- The XPages dialog doesn't provide any support for start of string and end of string characters. You'll need to know those or find the help elsewhere - like the regex101 website.
- many of the radio buttons won't be relevant for constructing a regex for a url.
- "current selection" is what is highlighted in the regex box at the bottom, which may not be obvious.
- the **Test Regular Expression** page of the wizard just tells you whether it matches or not. The website provides more information.
- the help for DRAPI provides good examples that are easier to follow than manually construct.
- the XPages dialog requires you to always use Domino Designer. The website provides a standard website whatever your development framework or platform.
- the chat icon in the left-hand gutter of the website provides access to a Discord server.
- you will need to switch between `\\` for the JSON in your DRAPI configuration file and `\` for both testers, so there's no advantage to either.

The last point is important to point out. If you're copying and pasting from the code samples in the documentation to a tester, you'll need to change `\\` to `\`. And when you paste back into your JSON file, you'll need to remember to change `\` back to `\\`. That's because you're using one escape character (for regex) inside a language that also uses an escape character (JSON).

!!! note
  The CORS settings apply to any application hosted by Domino REST API, including the admin UI. Domino REST API documentation calls out the need to add the server or domain in the CORS settings. It's important to understand the regular expression you're building, and the documentation does a great job of explaining the various parts.