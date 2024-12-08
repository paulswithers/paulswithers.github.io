---
slug: unit-tests-mocks
date: 
  created: 2020-02-03
category: Vert.x
tags: 
  - Vert.x
  - Java
comments: true
---
# Unit Tests and Mocks

In the pursuit of [optimal code coverage](https://dzone.com/articles/reporting-code-coverage-using-maven-and-jacoco-plu) with JUnit tests, there will inevitably be code that interacts with environments that are not available at the time of compiling the code. The solution here is **mocking**.

<!-- more -->

Sometimes this can just be done by creating a separate class that extends an existing class, overriding specific methods. Stephan Wissel blogged about this recently in his blog post about [Unit Tests and Singletons](https://wissel.net/blog/2020/01/unit-tests-and-singletons.html). But more often you need to intercept and change the behaviour of specific code within a method your unit test is calling. This is where [Mockito](https://site.mockito.org/) comes in. This allows you to instantiate a call to mock an object and intercept specific methods of that object.

Creating the object is done with the static method `Mockito.mock()`, so:

```java
final Session s = Mockito.mock(Session.class);
final NotesDatabase db = Mockito.mock(NotesDatabase.class);
final NotesNote fakeNote = Mockito.mock(NotesNote.class);
final NotesItem fakeItem = Mockito.mock(NotesItem.class);
```

The static method `Mockito.when()` allows you then to intercept the call. For methods that take no parameters or ones where you are looking for a specific input, that's straightforward.

```java
when(fakeNote.getUnid()).thenReturn("ABCDEF1234567890ABCDEF12345678");
when(fakeNote.getFirstItem("Form")).thenReturn(fakeItem);
when(fakeNote.getItemValueString("Form").thenReturn("Customer"));
```

But it's more likely that you're calling a method that requires parameters and you don't want to specify them. This is where the static methods of `ArgumentMatchers` come in - e.g. `ArgumentMatchers.anyString()`, `ArgumentMatchers.anyInt()`, and most useful of all `ArgumentMatchers.any()` to match an object of any class.

```java
final NotesDbQueryResult result = mock(NotesDbQueryResult.class);
when(db.query(anyString(), any(), anyInt(), anyInt())).thenReturn(result);
when(db.openNoteById(any())).thenReturn(fakeNote);
```

But how do you then handle a Document containing fields and values? One option here is to redirect the calls to return the corresponding value in a JSON object. Instead of `thenReturn()` we use `then()`. Then takes as its parameter an `Answer` which says what to do to find what it should return. Because Java 8 is available, it makes sense to use a lambda. So the code is like this:

```java
JsonObject doc = new JsonObject();
// Load your JsonObject from a resource
final Document mockDoc = mock(Document.class);
when(mockDoc.getItemValueString(anyString())).then(invocation -> doc.getString(invocation.getArgument(0)));
```

So what's happening here is that `getItemValueString()` will be redirected to `JsonObject.getString()`. But `getItemValueString()` takes a parameter, which we need to get the corresponding value from the JsonObject. This array of parameters or arguments are what's passed into the `then` part. So we can retrieve it with `invocation.getArgument(0)`. If the method we were mocking had more arguments, we could access them as `invocation.getArgument(1)`, `invocation.getArgument(2)` etc.

Things get more complicated though when the code you're mocking is iterating over a collection. You could use a single JsonObject, but you may want to return different JsonObjects each time. So you need a way to get the relevant JsonObject depending on which loop you're in. But if you try to just use an Integer and increment it, you'll find it doesn't compile. There's a solution here - [`AtomicInteger`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicInteger.html). This allows you to increment it from one mock method and access it from another. You can now use code like this:

```java
JsonArray docs = new JsonArray();
// Load your JsonArray or JsonObjects from a resource
AtomicInteger ordinal = new AtomicInteger(0);
final Document mockDoc = mock(Document.class);
// If nextDoc() is called before processing this document, use ordinal.intValue() - 1, because ordinal will already be the NEXT document
when(mockDoc.getItemValueString(anyString())).then(invocation -> docs.getJsonObject(ordinal.intValue()).getString(invocation.getArgument(0)));

final DocumentCollection dc = mock(DocumentCollection.class);
when(dc.getFirstDocument()).thenReturn(mockDoc);
when(dc.getNextDocument(any())).then(invocation -> {
    ordinal.getAndIncrement();
    if (ordinal.intValue == docs.size()){
        return null;
    } else {
        return mockDoc;
    }
})
```

The `mockDoc` mock object is used regardless of which document we're getting from the loop. We just use the AtomicInteger `ordinal` to make sure we're pointing to the relevant element of the JsonArray. Because for the first document we want the first element of the array, in `dc.getFirstDocument()` we just return `mockDoc`. For `getNextDocument()`, we don't care about the parameter passed in so we don't need to use `invocation.getArgument(0)`. But we do need to specify the method that should run, so we need the lambda. We need to increment `ordinal` each time and then either return a document or null, depending on whether or not we've reached the end of the JsonArray.

So we can now perform unit tests on more methods and get more code coverage.