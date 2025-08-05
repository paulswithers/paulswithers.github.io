---
slug: drapi-agents
date: 2025-08-05
categories: 
  - Domino REST API
tags:
  - Domino REST API
  - LotusScript
comments: true
---
# Supercharging Input to Domino REST API Agents

One of the things I learned when building [HCL Volt MX LotusScript Toolkit](https://github.com/HCL-TECH-SOFTWARE/volt-mx-ls-toolkit) was that calling a web agent with `?OpenAgent` URL populates the `NotesSession.DocumentContext` with various fields containing useful information from the request. So when I was building agent processing functionality into the POC that became Domino REST API, I utilised the same approach to provide opportunities to pass contextual information across to an agent.

<!-- more -->

## Tester Agent

Maybe someone has tried checking what's in `NotesSession.DocumentContext`, but I've not seen anyone from the community mention it. But a simple agent will allow you to access the content passed into the agent. Just put this into a LotusScript agent:

```vb
Option Public
Option Declare
Sub Initialize
		
	Dim s As New NotesSession
	Dim doc As NotesDocument
	Dim item As NotesItem
	Dim resp As String, itmVal As String
	Dim firstDone As Boolean
	
	Set doc = s.DocumentContext
	resp = "{"
	ForAll itm In doc.Items
		If firstDone Then
			resp = resp & |, |
		Else
			firstDone = True
		End If
		Set item = itm
		resp = resp & |"| & item.Name & |": | 
		itmVal = CStr(item.Values(0))
		If (itmVal Like "{*}") Then
			resp = resp & itmVal
		Else
			resp = resp & |"| & itmVal & |"|
		End If
	End ForAll
	resp = resp & "}"
	Print resp
	
End Sub
```

This will basically get `NotesSession.DocumentContext` and iterate the items and construct a JSON object containing all items and their values.

## Testing

You can access this agent by enabling the agent in the schema and ensuring a valid trigger - certain triggers can only be used within the Notes Client, so the easiest is "Agent list selection" as the Trigger and "None" as the Target.

If the agent is called "TestAgent", you can access it with this curl command:

```bash
curl --request POST \
  --url 'https://YOUR.SERVER.COM/api/v1/run/agent?dataSource=demo' \
  --header 'authorization: Bearer YOUR-TOKEN' \
  --header 'content-type: application/json' \
  --data '{
  "agentName": "(TestAgent)"
}'
```

Alternatively, you can go to the "OpenAPI v3" tab on your Domino REST API dashboard, by selecting "basis" and then the relevant scope from the drop-down. You will then be able to test it from the Code - /run/agent request (after authenticating, of course).

## Parameterisation

Amongst other content, you will see "KEEP" in the "REQUEST_METHOD" field. This can be used to code agents or LotusScript Script Library business logic differently depending on whether it comes from Domino REST API or other clients.

You could add a check to prevent these agents being called via the `?OpenAgent` URL command, but agents are still accessible to Domino REST API even if they are hidden from the web. So you can just hide the agent from the web, unless you want it to be accessible from the web or unless the whole application is prohibited from URL open.

You will also see all sorts of fields passed into the DocumentContext that are prefixed with "HTTP_". It will be apparent that many of these are the HTTP headers passed into the request. So of course you can pass custom headers as a way of passing additional information into the agent.

But there is also another way to pass additional information into the agent. In the body, you have to pass a JSON object with the property "agentName". But you can also pass a property "payload", which needs to be a JSON object. An example JSOn body would be:

```json
{
  "agentName": "(TestAgent)",
  "payload": {
    "requestId": "test",
    "requestNo": 1234
  }
}
```

The contents of payload would then be available in the "REQUEST_CONTENT" field as a string, for you to use as you see fit.

So there are two ways to pass content to use within your agent, is you wish to do so.