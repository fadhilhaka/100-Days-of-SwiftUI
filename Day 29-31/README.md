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

We have a string where words are separated by line breaks, so to convert that into a string array we need to split on that.

In programming – almost universally, I think – we use a special character sequence to represent line breaks: \n. So, we would write code like this:

~~~
let input = """
            a
            b
            c
            """
let letters = input.components(separatedBy: "\n")
~~~

Regardless of what string we split on, the result will be an array of strings. From there we can read individual values by indexing into the array, such as letters[0] or letters[2], but Swift gives us a useful other option: the randomElement() method returns one random item from the array.

Another useful string method is trimmingCharacters(in:), which asks Swift to remove certain kinds of characters from the start and end of a string. This uses a new type called CharacterSet, but most of the time we want one particular behavior: removing whitespace and new lines – this refers to spaces, tabs, and line breaks, all at once.

This behavior is so common it’s built right into the CharacterSet struct, so we can ask Swift to trim all whitespace at the start and end of a string like this:

~~~
let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
~~~

There’s one last piece of string functionality I’d like to cover before we dive into the main project, and that is the ability to check for misspelled words.

This functionality is provided through the class UITextChecker.

You might not realize this, but the “UI” part of that name carries two additional meanings with it:

1. This class comes from UIKit. That doesn’t mean we’re loading all the old user interface framework, though; we actually get it automatically through SwiftUI.
2. It’s written using Apple’s older language, Objective-C. We don’t need to write Objective-C to use it, but there is a slightly unwieldy API for Swift users.

Checking a string for misspelled words takes four steps in total. First, we create a word to check and an instance of UITextChecker that we can use to check that string:

~~~
let word = "swift"
let checker = UITextChecker()
~~~

Second, we need to tell the checker how much of our string we want to check. If you imagine a spellchecker in a word processing app, you might want to check only the text the user selected rather than the entire document.

However, there’s a catch: Swift uses a very clever, very advanced way of working with strings, which allows it to use complex characters such as emoji in exactly the same way that it uses the English alphabet. However, Objective-C does not use this method of storing letters, which means we need to ask Swift to create an Objective-C string range using the entire length of all our characters, like this:

~~~
let range = NSRange(location: 0, length: word.utf16.count)
~~~

UTF-16 is what’s called a character encoding – a way of storing letters in a string. We use it here so that Objective-C can understand how Swift’s strings are stored; it’s a nice bridging format for us to connect the two.

Third, we can ask our text checker to report where it found any misspellings in our word, passing in the range to check, a position to start within the range (so we can do things like “Find Next”), whether it should wrap around once it reaches the end, and what language to use for the dictionary:

~~~
let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
~~~

That sends back another Objective-C string range, telling us where the misspelling was found. Even then, there’s still one complexity here: Objective-C didn’t have any concept of optionals, so instead relied on special values to represent missing data.

In this instance, if the Objective-C range comes back as empty – i.e., if there was no spelling mistake because the string was spelled correctly – then we get back the special value NSNotFound.

So, we could check our spelling result to see whether there was a mistake or not like this:

~~~
let allGood = misspelledRange.location == NSNotFound
~~~

## [Project 5, part two](https://www.hackingwithswift.com/100/swiftui/30)

* [Adding to a list of words](https://www.hackingwithswift.com/books/ios-swiftui/adding-to-a-list-of-words)
* [Running code when our app launches](https://www.hackingwithswift.com/books/ios-swiftui/running-code-when-our-app-launches)
* [Validating words with UITextChecker](https://www.hackingwithswift.com/books/ios-swiftui/validating-words-with-uitextchecker)

The user interface for this app will be made up of three main SwiftUI views: a NavigationView showing the word they are spelling from, a TextField where they can enter one answer, and a List showing all the words they have entered previously.

For now, every time users enter a word into the text field, we’ll automatically add it to the list of used words. Later, though, we’ll add some validation to make sure the word hasn’t been used before, can actually be produced from the root word they’ve been given, and is a real word and not just some random letters.

We use Apple’s SF Symbols icons to show the length of each word next to the text. SF Symbols provides numbers in circles from 0 through 50, all named using the format “x.circle.fill” – so 1.circle.fill, 20.circle.fill.

In this program we’ll be showing eight-letter words to users, so if they rearrange all those letters to make a new word the longest it will be is also eight letters. As a result, we can use those SF Symbols number circles just fine – we know that all possible word lengths are covered.

If we use a second view inside a List row, SwiftUI will automatically create an implicit horizontal stack for us so that everything in the row sits neatly side by side. What this means is we can just add Image(systemName:) directly inside the list and we’re done:

~~~
List(usedWords, id: \.self) {
    Image(systemName: "\($0.count).circle")
    Text($0)
}
~~~

When Xcode builds an iOS project, it puts your compiled program, your Info.plist file, your asset catalog, and any other assets into a single directory called a bundle, then gives that bundle the name YourAppName.app. This “.app” extension is automatically recognized by iOS and Apple’s other platforms, which is why if you double-click something like Notes.app on macOS it knows to launch the program inside the bundle.

In our game, we’re going to include a file called “start.txt”, which includes over 10,000 eight-letter words that will be randomly selected for the player to work with. This was included in the files for this project that you should have downloaded from GitHub, so please drag start.txt into your project now.

If we can’t locate start.txt in our app bundle, or if we can locate it but we can’t load it? In that case we have a serious problem, because our app is really broken – either we forgot to include the file somehow (in which case our game won’t work), or we included it but for some reason iOS refused to let us read it (in which case our game won’t work, and our app is broken).

Regardless of what caused it, this is a situation that never ought to happen, and Swift gives us a function called fatalError() that lets us detect problems really clearly. When we call fatalError() it will – unconditionally and always – cause our app to crash. It will just die. Not “might die” or “maybe die”: it will always just terminate straight away.

I realize that sounds bad, but what it lets us do is important: for problems like this one, such as if we forget to include a file in our project, there is no point trying to make our app struggle on in a broken state. It’s much better to terminate immediately and give us a clear explanation of what went wrong so we can correct the problem, and that’s exactly what fatalError() does.

## [Project 5, part three](https://www.hackingwithswift.com/100/swiftui/31)

* [Word Scramble: Wrap up](https://www.hackingwithswift.com/books/ios-swiftui/word-scramble-wrap-up)
* [Review for Project 5: Word Scramble](https://www.hackingwithswift.com/review/ios-swiftui/word-scramble)

One thing I want to pick out before we finish is my use of fatalError(). If you read code from my own projects on GitHub, or read some of my more advanced tutorials, you’ll see that I rely on fatalError() a lot as a way of forcing code to shut down when something impossible has happened. The key to this technique – the thing that stops it from being recklessly dangerous – is knowing when a specific condition ought to be impossible. That comes with time and practice: there is no one quick list of all the places it’s a good idea to use fatalError(), and instead you’ll figure it out with experience.