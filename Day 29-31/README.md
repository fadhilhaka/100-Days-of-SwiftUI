# Project 5

April 15<sup>th</sup> 2021

<!-- |                        |                        |                        |
|:----------------------:|:----------------------:|:----------------------:|
| ![](images/img_1.png)  | ![](images/img_2.png)  | ![](images/img_3.png)  | -->

## [Project 5, part one](https://www.hackingwithswift.com/100/swiftui/29)

* [Word Scramble: Introduction](https://www.hackingwithswift.com/books/ios-swiftui/word-scramble-introduction)
* [Introducing List, your best friend](https://www.hackingwithswift.com/books/ios-swiftui/introducing-list-your-best-friend)
* [Loading resources from your app bundle](https://www.hackingwithswift.com/books/ios-swiftui/loading-resources-from-your-app-bundle)
* [Working with strings](https://www.hackingwithswift.com/books/ios-swiftui/working-with-strings)

### List

The equivalent of List in UIKit was UITableView. The job of List is to provide a scrolling table of data. In fact, it’s pretty much identical to Form, except it’s used for presentation of data rather than requesting user input.

~~~
List {
    Text("Static row 1")
    Text("Static row 2")

    ForEach(0..<5) {
        Text("Dynamic row \($0)")
    }

    Text("Static row 3")
    Text("Static row 4")
}
~~~

We can get a Form look and feel using the listStyle() modifier, like this:

~~~
.listStyle(GroupedListStyle())
~~~

Now, everything you’ve seen so far works fine with Form as well as List – even the dynamic content. But one thing List can do that Form can’t is to generate its rows entirely from dynamic content without needing a ForEach.

So, if your entire list is made up of dynamic rows, you can simply write this:

~~~
List(0..<5) {
    Text("Dynamic row \($0)")
}
~~~

The id parameter, in both List and ForEach, lets us tell SwiftUI exactly what makes each item in the array unique.

When working with arrays of strings and numbers, the only thing that makes those values unique is the values themselves. That is, if we had the array [2, 4, 6, 8, 10], then those numbers themselves are themselves the unique identifiers. After all, we don’t have anything else to work with!

When working with this kind of list data, we use id: \.self like this:

~~~
struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]

    var body: some View {
        List(people, id: \.self) {
            Text($0)
        }

        ForEach(people, id: \.self) {
            Text($0)
        }
    }
}
~~~

### Loading Resources from App Bundle

When Xcode builds your iOS app, it creates something called a “bundle”. This happens on all of Apple’s platforms, including macOS, and it allows the system to store all the files for a single app in one place – the binary code (the actual compiled Swift stuff we wrote), all the artwork, any extra files we need, our Info.plist file, and more, all in one place.

All this matters because it’s common to want to look in a bundle for a file you placed there. This uses a new data type called URL, which stores pretty much exactly what you think: a URL such as https://www.hackingwithswift.com. However, URLs are a bit more powerful than just storing web addresses – they can also store the locations of files, which is why they are useful here.

If we want to read the URL for a file in our main app bundle, we use Bundle.main.url(). If the file exists it will be sent back to us, otherwise we’ll get back nil, so this is an optional URL. That means we need to unwrap it like this:

~~~
if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
    // we found the file in our bundle!
}
~~~

Once we have a URL, we can load it into a string with a special initializer: String(contentsOf:). We give this a file URL, and it will send back a string containing the contents of that file if it can be loaded. If it can’t be loaded it throws an error, so you you need to call this using try or try? like this:

~~~
if let fileContents = try? String(contentsOf: fileURL) {
    // we loaded the file into a string!
}
~~~

### Working with Strings

In this app, we’re going to be loading a file from our app bundle that contains over 10,000 eight-letter words, each of which can be used to start the game. These words are stored one per line, so what we really want is to split that string up into an array of strings in order that we can pick one randomly.

Swift gives us a method called components(separatedBy:) that can converts a single string into an array of strings by breaking it up wherever another string is found. For example, this will create the array ["a", "b", "c"]:

~~~
let input = "a b c"
let letters = input.components(separatedBy: " ")
~~~

## [Project 5, part two](https://www.hackingwithswift.com/100/swiftui/30)

* [Adding to a list of words](https://www.hackingwithswift.com/books/ios-swiftui/adding-to-a-list-of-words)
* [Running code when our app launches](https://www.hackingwithswift.com/books/ios-swiftui/running-code-when-our-app-launches)
* [Validating words with UITextChecker](https://www.hackingwithswift.com/books/ios-swiftui/validating-words-with-uitextchecker)

## [Project 5, part three](https://www.hackingwithswift.com/100/swiftui/31)

* [Word Scramble: Wrap up](https://www.hackingwithswift.com/books/ios-swiftui/word-scramble-wrap-up)
* [Review for Project 5: Word Scramble](https://www.hackingwithswift.com/review/ios-swiftui/word-scramble)