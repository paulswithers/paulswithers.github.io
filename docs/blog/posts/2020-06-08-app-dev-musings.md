---
slug: app-dev-musings
date: 
  created: 2020-06-08
categories:
  - Vert.x
tags: 
  - Domino
  - Vaadin
  - Leap
  - Volt MX
comments: true
---
# Application Development Musings

Since joining HCL Labs my focus for Domino development has been Domino APIs, with [Project Keep](https://frascati.projectkeep.io/). Obviously there is little point using a REST API against a Domino database in an XPages application or LotusScript agent. Consequently, application development has been almost exclusively outside of XPages. This has reinforced key differences between Domino development and other application development frameworks. Now was a good time to cover this, particularly following Chris Toohey's excellent blog post ["Was XPages a waste of time?"](http://www.dominoguru.com/page.xsp?id=POST-DOMO-BQDJ5C.html). I've always been vocal, that my experience of XPages was not a waste of time. But I'm very much one of those who took a huge step further, and took a lot of time to understand very deeply how XPages worked and how other frameworks were similar or different.

<!-- more -->

One difference is the use of asynchronous code with callbacks. I've [blogged](https://www.intec.co.uk/what-domino-makes-trivial-number-two-synchronous-asynchronous-processing/) about the virtual absence of asynchronous code in Domino before. Another difference is the clear split between back-end code and front-end code. XPages has a split between front-end and back-end code, but on a number of occasions StackOverflow questions have shown that developers have not grasped this separation, perhaps because of the use of the term Server-Side JavaScript. Both are fundamental architectural differences to web development, which would require inelegant "hacks" for any automatic conversion of Notes Client or XPages applications to another web framework.

But what I want to focus on something different here, something that became apparent when I first used Vaadin after a few years of XPages, and something that has been reinforced following exposure to other development frameworks and platforms. It's also a significant architectural difference, and one that is worth bearing in mind when looking beyond Notes Client or XPages development. The difference is how the properties of things and their current state are set.

## Notes and Simple XPages

Consider these techniques in Notes Client development:

- Computing the value for a hide-when.  
- Using Computed Text and refreshing the page.  
- Computing the options for a Dialog List and refreshing to update the options.

We do not interact with the UI or the components on it, mainly because the Notes Client doesn't really allow it. We define how fields should behave on the field itself, change a state, recalculate the page and let the code on the field decide how the UI should act.

The same was the typical approach with XPages. Indeed one of the big strengths of XPages was that almost everything could be computed. Properties of data objects and components are all computed on the relevant components. Sometimes the property value is computed directly. Consider the following code, for example:

```xml
<xp:button id="button1">
    <xp:this.value><![CDATA[#{javascript:if (document1.isEditable()) {
        return "Cancel";
    } else {
        return "Close";
    }}]]>
</xp:button>
```

This is a common approach in XPages with manipulating properties of components: set a scoped variable and compute a property based on the scoped variable.

## XPages Alternative

But sometimes in XPages a property value will be bound to a scoped variable - requestScope, viewScope, sessionScope, applicationScope - and then using that property in a button.

```xml
<xp:panel rendered="#{viewScope.showMe}">
Some content
</xp:panel>
<xp:button id="button1" value="Show Panel">
    <xp:eventHandler event="onclick" submit="true" refreshMode="partial">
        <xp:this.action><![CDATA[#{javascript:viewScope.put("showMe",true);}]]></xp:action>
    </xp:eventHandler>
</xp:panel>
```

Something like that is typically only used when the value needs to be re-used across the XPage, to avoid typing the same SSJS in multiple places.

Over the last few years my XPages development changed though, subtly, but significantly. I typically used [page controllers or some variant](http://www.notesin9.com/2016/03/02/discussion-on-using-pagecontrollers-in-xpages/). Properties were then bound to properties of the page controller, and those properties had getters and setters. So the Cancel button XPages example would be something like:

```xml
<xp:button id="button1" value="#{pageController.cancelButtonLabel}>
</xp:button>
```

In the pageController's I would then have a String property `cancelButtonLabel` with getters and setters, and in the beforePageLoad I would have code like this:

```java
if (document1.isEditable()) {
    setCancelButtonLabel("Cancel");
} else {
    setCancelButtonLabel("Close");
}
```

## So What's The Difference?

The difference really becomes most apparent when it comes to troubleshooting.

In the first set of scenarios, the component properties are declarative - they say what their property values should be. When your page doesn't behave how you expect, you look on the relevant field or component, look at the code, and try to work out the current values the code is using. Your starting point is the particular component. But your business logic is spread throughout the Form or XPages (and Subforms or Custom Controls), and you need to look at other fields or components to work out what the current values being used are.

In the second set of scenarios, your buttons are more imperative - it changes a variable's value, from which the component property retrieves its value. When your page doesn't behave how you expect, you try to work out what the page's last state was, what action has just been performed and how that has changed settings throughout the page. Your business logic is more self-contained. However, what your business logic needs to do depends on the variety of previous states the page might be in.

## So Why Is This Important?

Well, it's important because trying to convert one style of programming to another is extremely challenging, if even possible. Have a look at one of your XPages or Notes Forms, of moderate complexity. Now think about how to convert the computations on each component / field to putting all that page manipulation on the click event that triggers the update. You start to see the challenge.

It becomes more important because when we move beyond Domino, the latter is much more common than the former.

Think of basic web development. XPages sends the HTML for a whole portion of the page to the browser and overwrites that part of the DOM. Client-side JavaScript doesn't do that. It imperatively updates individual elements in the DOM. I have only done a little React, but from what I understand React works the same, changing the state of components and only updating those parts of the DOM that change.

On the front-end, that's also what Vaadin does. When it comes to backend coding, again, everything is Java objects and buttons define how components should be changed.

After playing a little with Volt, I saw some similarities with this kind of approach with Workflow Stages, where the state of the page - whether fields are visible or not etc - is defined on a particular Workflow Stage, not on the Form. The Workflow Stage seems to effectively copy the Form and allow you to change what the properties should be on the Workflow Stage, not on the original UI Form.

Moving a little further beyond Domino, I encountered a similar approach with [Temenos' Quantum Visualizer](https://www.kony.com/products/visualizer/), where again rather than setting properties on each component on the page and recalculating the whole page, actions trigger JavaScript in controllers, which updating component mappings and explicitly set component properties.

## Conclusion

I'm not saying one approach is better or worse than the other, that kind of comparison is not the focus of this blog post.

What I am saying is that the imperative approach - actions changing component properties explicitly - seems more pervasive than actions running and components implicitly changing their own properties. It requires a different mindset for architecting the solution and a different approach to troubleshooting the solution.

And any difference means trying to convert an application - automatically or manually - is not straightforward, especially if the original code is not well documented.