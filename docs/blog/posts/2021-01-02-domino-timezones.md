---
slug: domino-timezones
date: 
  created: 2021-01-02
category: Domino
tags: 
  - Domino
  - LotusScript
  - Volt MX
comments: true
---
# Domino Timezones

There are a number of challenges when it comes to two-way REST and Domino. But one of the biggest challenges for manipulation between NotesDateTime objects and JSON is timezone handling. There is an [Product Ideas request](https://domino-ideas.hcltechsw.com/ideas/DDXP-I-354) to provide serialization / deserialization between Domino objects and JSON strings, which surprisingly only has 31 votes, but it's not there yet. So for Volt MX LotusScript Toolkit, this needs handling within the toolkit itself.

<!-- more -->

The first aspect to bear in mind is that time only or date only do not have timezones. 1st January 2021 is 1st January in Australia, 1st January in UK and 1st January in east coast USA. Similarly, 12 noon is 12 noon in Australia, UK and USA - whether daylight savings is in operation or not. If you want to store a single value for 12 noon in the current timezone on any given day, a NotesDateTime is not (strictly speaking) the best storage format, unless the value is to be used only within a Notes or Domino context.

So I'm focusing here only on full date-times, which include a timezone. Interestingly, this isn't the first time I've had to approach the problem. Project Keep uses Domino JNX - a redevelopment learning from Domino JNA and OpenNTF Domino API, going via C++ API. That's actually very easy, because the DateTime objects are actually stored as UTC timestamps - and incidentally that avoids all the challenges of writing values. I also addressed conversion in Java in OpenNTF Domino API and [blogged about](https://www.intec.co.uk/converting-dates-to-iso-formats/). For ODA and Java 8, I was able to use a Temporal and a DateTimeFormatter, in combination with the internationalisation formats, although we had the same problems for writing that Volt MX LotusScript Toolkit will have.

With LotusScript and Volt MX LotusScript Toolkit, I drew upon my experience of ODA as well as some JavaScript code that Jason Roy Gary developed. For the timezone format to write to, there is a standard defined, [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339#section-5.6). This uses UTC offsets, so the only challenge is working out the UTC offset for Domino timezones. Unfortunately, that's not so straightforward.

The NotesDateTime object has a `.timezone` method which might seem to be the go-to method. But this only returns an integer, as the help text says:

> **"An integer representing the time zone of a date-time. In many cases, but not all, this integer indicates the number of hours which must be added to the time to get Greenwich Mean Time. May be positive or negative."**

An obvious example of where this is insufficient is for times in India, were the offset is three and a half hours. But with `.localTime` the timezone is appended, after a space. However, the Domino timezones don't neatly correspond to timezones as defined beyond Domino. Jason's code was a useful starting point, because it identified all the possible timezone strings that Domino could output. But it became apparent that it didn't handle the crucial element of daylight savings time. With some further digging I realised that the list - and the offsets Jason had used - came from an LDD article, thankfully reproduced online [here](http://second-ext.inttrust.ru/Lotus/NotesWeb/Today.nsf/DisplayForm/95BABDE0E05FF744852568B300590BCF?OpenDocument). For someone who lives in the UK, I can tell you categorically that GDT does not have a 0:00 offset from GMT. It is one hour ahead of GMT. Similarly, other daylight savings time abbreviations - for example EDT, CEDT - do not have the same offsets as the standard time label. "ZW" and "ZE" are just offsets, west and east of the Greenwich Meridian. "YW" is more of a challenge and I can only guess this is 1 hour in advance of the corresponding "ZW" timezone, otherwise there is no reason to have a different abbreviation. So the table in the LDD article is, unfortunately, not correct, and it doesn't appear there is a correct published table. And it's also worth bearing in mind the offset is what to **_add to_** UTC, not how to adjust the timezone to **_return_** UTC. So here's the adjusted table I've used:

|Domino Timezone|Long Name|Conversion to Return UTC|RFC 3339 Timezone|
|:---|:---|:---|:---|
|GMT|Greenwich Mean Time|Same as UTC|Z|
|YW1|Daylight savings for timezone one hour west of GMT|Same as UTC|Z|
|ZW1|Timezone one hour west of GMT|Add 1 hour|-0100|
|YW2|Daylight savings for timezones two hours west of GMT|Add 1 hour|-0100|
|ZW2|Timezone two hours west of GMT|Add 2 hours|-0200|
|YW3|Daylight savings for timezone three hours west of GMT|Add 2 hours|-0200|
|NDT|Daylight savings, Newfoundland|Add 2.5 hours|-0230|
|ZW3|Timezone three hours west of GMT|Add 3 hours|-0300|
|ADT|Atlantic Daylight Savings|Add 3 hours|-0300|
|NST|Newfoundland|Add 3.5 hours|-0330|
|AST|Atlantic Standard Time|Add 4 hours|-0400|
|EDT|Eastern Daylight Savings|Add 4 hours|-0400|
|EST|Eastern Standard Time|Add 5 hours|-0500|
|CDT|Central Daylight Savings|Add 5 hours|-0500|
|CST|Central Standard Time|Add 6 hours|-0600|
|MDT|Mountain Daylight Savings|Add 6 hours|-0600|
|MST|Mountain Standard Time|Add 7 hours|-0700|
|PDT|Pacific Daylight Savings|Add 7 hours|-0700|
|PST|Pacific Standard Time|Add 8 hours|-0800|
|YDT|Alaska Daylight Savings|Add 8 hours|-0800|
|YST|Alaska Standard Time|Add 9 hours|-0900|
|HDT|Hawaii-Aleutian Daylight Savings|Add 9 hours|-0900|
|ZW9B|Nine and a half hours west of GMT|Add 9.5 hours|-0930|
|HST|Hawaii-Aleutian Standard Time|Add 10 hours|-1000|
|BDT|Bering Daylight Savings|Add 10 hours|-1000|
|BST|Bering Standard Time|Add 11 hours|-1100|
|ZW12|Twelve hours west of GMT|Add 12 hours|-1200|
|ZE12C|Twelve and three quarters hours east of GMT|Subtract 12.75 hours|+1245|
|ZE12|Twelve hours east of GMT|Subtract 12 hours|+1200|
|ZE11B|Eleven and a half hours east of GMT|Subtract 11.5 hours|+1130|
|ZE11|Eleven hours east of GMT|Subtract 11 hours|+1100|
|ZE10B|Ten and a half hours east of GMT|Subtract 10.5 hours|+1030|
|ZE10|Ten hours east of GMT|Subtract 10 hours|+1000|
|ZE9B|Nine and a half hours east of GMT|Subtract 9.5 hours|+0930|
|ZE9|Nine hours east of GMT|Subtract 9 hours|+0900|
|ZE8|Eight hours east of GMT|Subtract 8 hours|+0800|
|ZE7|Seven hours east of GMT|Subtract 7 hours|+0700|
|ZE6B|Six and a half hours east of GMT|Subtract 6.5 hours|+0630|
|ZE6|Six hours east of GMT|Subtract 6 hours|+0600|
|ZE5C|Five and three quarter hours east of GMT|Subtract 5.75 hours|+0545|
|ZE5B|Five and a half hours east of GMT|Subtract 5.5 hours|+0530|
|ZE5|Five hours east of GMT|Subtract 5 hours|+0500|
|ZE4B|Four and a half hours east of GMT|Subtract 4.5 hours|+0430|
|ZE4|Four hours east of GMT|Subtract 4 hours|+0400|
|ZE3|Three hours east of GMT|Subtract 3 hours|+0300|
|ZE2|Two hours east of GMT|Subtract 2 hours|+0200|
|CEDT|Central European Daylight Savings|Subtract 2 hours|+0200|
|CET|Central European Time|Subtract 1 hour|+0100|
|GDT|British Summer Time|Subtract one hour|+0100|

<br/>
This is the basis of the code in Volt MX LotusScript Toolkit, so if you're aware of any errors, please let me know so all can benefit.

<style>
table{
    border-collapse: collapse;
    border-spacing: 0;
    border:1px solid #000000;
}

th{
    border:1px solid #000000;
    padding: 2px;
    font-weight: bold;
}

td{
    border:1px solid #000000;
    padding: 2px;
}
</style>