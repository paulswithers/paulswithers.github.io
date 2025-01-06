---
slug: dql-explorer-domino
date: 
  created: 2020-02-04
categories:
  - Domino
tags: 
  - React
  - Domino
  - LotusScript
links:
  - blog/2020-01-21-dql-what-is-it-good-for.md
comments: true
---
# DQL Explorer and Domino

[A couple of weeks ago](./2020-01-21-dql-what-is-it-good-for.md) I explained that, even though the UI of DQL Explorer is a React app, the use of DQL is in agents. The two key agents, found within the NSF itself are **runDQLExplain** and **runDQLQuery** - the purpose of each should be apparent from the name. But the purpose of this blog post is to outline the interaction points between DQL Explorer and Domino.

<!-- more -->

## Architecture

The UI, as mentioned, is a React app. As outlined in the [README](https://github.com/icstechsales/dql-explorer), the app is packaged up (via `npm run build` command) and the contents of the resulting **build** folder copied and pasted into the NSF in the Resources > Files area. Obviously this is just one deployment option, leveraging Domino's in-built HTTP server, which makes a lot of sense because it depends on Domino's HTTP server to interact with the server.

But that's not the only deployment option, as seen during development of it. As covered in the README, for developing the application or running it in development mode, you first need to install the relevant node modules using `npm install` and then start the application using the in-built NodeJS server using `npm start`. This then makes the application available, running outside of Domino, using http://localhost:3000. However, it then needs some mechanism to know which Domino server to connect to for the agents and other interactions. This is defined in the **proxy** and **homepage** variables in the package.json file.

Now that we know the HTTP server the application is running on and how it knows the Domino server to connect to, let's dive deeper into the interaction points between the DQL Explorer app and Domino. It's beyond the scope of this blog post to detail the design of the application. All I will say is that `src\index.js` provides the entry point into the application and is built as index.html. That loads in `src\App.js`, which is the shell for the application design and incorporates other components in `src\components` as appropriate. In XPages terminology, these are like Custom Controls or like Subforms in Notes Client terminology.

## DAS

First off, it's worth noting that LotusScript agents are not the only integration point with Domino for retrieving data. As the README notes, you need to enable DAS (Domino Access Services) on the server. This is used for CRUD access to DQL Explorer itself, for supporting saved searches.

In `src\App.js` [line 347](https://github.com/icstechsales/dql-explorer/blob/master/src/App.js#L347) an AJAX GET call is made via axios to retrieve all saved queries in the "collections" view. And on line 363 another AJAX GET call is made to retrieve the selected saved query.

In `src\components\querybuilder\index.js`, the create, update and delete parts are run. [Line 131](https://github.com/icstechsales/dql-explorer/blob/master/src/components/querybuilder/index.js#L131) does a POST to create a new saved query. [Line 162](https://github.com/icstechsales/dql-explorer/blob/master/src/components/querybuilder/index.js#L162) again does a POST to update an existing saved query. And [line 193](https://github.com/icstechsales/dql-explorer/blob/master/src/components/querybuilder/index.js#L193) does a DELETE to remove the saved query.

### Agents

As mentioned, the DQL-specific agents used are "runDQLQuery" and "runDQLExplain", in [line 81](https://github.com/icstechsales/dql-explorer/blob/master/src/components/querybuilder/index.js#L81) and [line 110](https://github.com/icstechsales/dql-explorer/blob/master/src/components/querybuilder/index.js#L110) respectively of `src\components\querybuilder\index.js`. These perform the actual DQL processes. The other agents are used for retrieving options to help build the DQL query.

The first of these is in `src\components\querybuilder\DatabasesList.js` [line 143](https://github.com/icstechsales/dql-explorer/blob/master/src/components/DatabasesList.js#L143), getting the list of databases exposed for DQL Explorer. These are based on the documents in the Lookups view, "Directories to search" giving the folder names from which to retrieve databases and "File names to include" giving explicit NSFs to retrieve. It's worth noting here that the HTTP task doesn't work for NTFs, so you can only use DQL Explorer to query NSFs.

The others are in `src\App.js`. On [line 312](https://github.com/icstechsales/dql-explorer/blob/master/src/App.js#L312) the form names for a database are retrieved for the selected database.

Lines [442-453](https://github.com/icstechsales/dql-explorer/blob/master/src/App.js#L442) are a utility function when selecting a saved query. It varies the agents used depending on whether it's looking for "forms", "views" or "folders". Depending on what's selected, it gets the list of those elements and field names for forms or column names for views or folders.

[Lines 924-932](https://github.com/icstechsales/dql-explorer/blob/master/src/App.js#L924) are a utility function to retrieve a list of forms, views or folders depending on what's selected.

[Lines 982-990](https://github.com/icstechsales/dql-explorer/blob/master/src/App.js#L982) are the corresponding utility function to retrieve field name or column names, depending on whether forms, views or folders are selected.

All the agents return JSON and could be refactored with Domino 11 to use the [NotesJSONNavigator class](https://help.hcltechsw.com/dom_designer/11.0.0/appdev/builds/H_NOTESJSONNAVIGATOR_CLASS.html) for JSON generation. Currently the JSON in manually generated via print statements.