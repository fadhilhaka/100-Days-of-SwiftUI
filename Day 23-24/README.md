# Project 3

March 31<sup>st</sup> 2021

## [Project 3, Part One](https://www.hackingwithswift.com/100/swiftui/23)

* [Views and modifiers: Introduction](https://www.hackingwithswift.com/books/ios-swiftui/views-and-modifiers-introduction)
* [Why does SwiftUI use structs for views?](https://www.hackingwithswift.com/books/ios-swiftui/why-does-swiftui-use-structs-for-views)
* [What is behind the main SwiftUI view?](https://www.hackingwithswift.com/books/ios-swiftui/what-is-behind-the-main-swiftui-view)
* [Why modifier order matters](https://www.hackingwithswift.com/books/ios-swiftui/why-modifier-order-matters)
* [Why does SwiftUI use “some View” for its view type?](https://www.hackingwithswift.com/books/ios-swiftui/why-does-swiftui-use-some-view-for-its-view-type)
* [Conditional modifiers](https://www.hackingwithswift.com/books/ios-swiftui/conditional-modifiers)
* [Environment modifiers](https://www.hackingwithswift.com/books/ios-swiftui/environment-modifiers)
* [Views as properties](https://www.hackingwithswift.com/books/ios-swiftui/views-as-properties)
* [View composition](https://www.hackingwithswift.com/books/ios-swiftui/view-composition)
* [Custom modifiers](https://www.hackingwithswift.com/books/ios-swiftui/custom-modifiers)
* [Custom containers](https://www.hackingwithswift.com/books/ios-swiftui/custom-containers)

## Why does SwiftUI use structs for views?

There is an element of performance: structs are simpler and faster than classes.

In SwiftUI, all our views are trivial structs and are almost free to create. Think about it: if you make a struct that holds a single integer, the entire size of your struct is… that one integer. Nothing else. No surprise extra values inherited from parent classes, or grandparent classes, or great-grandparent classes, etc – they contain exactly what you can see and nothing more.

There’s something much more important about views as structs: it forces us to think about isolating state in a clean way.

By producing views that don’t mutate over time, SwiftUI encourages us to move to a more functional design approach: our views become simple, inert things that convert data into UI, rather than intelligent things that can grow out of control.

In comparison, Apple’s documentation for [UIView](https://developer.apple.com/documentation/uikit/uiview) lists about 200 properties and methods that UIView has, all of which get passed on to its subclasses whether they need them or not.

## What is behind the main SwiftUI view?

There is **nothing** behind our view. You shouldn’t try to make that white space turn red with weird hacks or workarounds, and you certainly shouldn’t try to reach outside of SwiftUI to do it.

Now, right now at least there is something behind our content view called a **UIHostingController**: it is the bridge between UIKit (Apple’s original iOS UI framework) and SwiftUI. However, if you start trying to modify that you’ll find that your code no longer works on Apple’s other platforms, and in fact might stop working entirely on iOS at some point in the future.

Instead, you should try to get into the mindset that there is nothing behind our view – that what you see is all we have.

Once you’re in that mindset, the correct solution is to make the view take up more space; to allow it to fill the screen rather than being sized precisely around its content. We can do that by using the **frame()** modifier, passing in **.infinity** for both its maximum width and maximum height.

~~~
Text("Hello World")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.red)
~~~

Using **maxWidth** and **maxHeight** is different from using width and height – we’re not saying the text view must take up all that space, only that it can. If you have other views around, SwiftUI will make sure they all get enough space.

By default your view won’t leave the safe area, but you can change that by using the edgesIgnoringSafeArea() modifier like this:

~~~
Text("Hello World")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.red)
    .edgesIgnoringSafeArea(.all)
~~~

## Why modifier order matters?

Whenever we apply a modifier to a SwiftUI view, we actually create a new view.

~~~
Button("Hello World") {
    // do nothing
}    
.background(Color.red)
.frame(width: 200, height: 200)
~~~

With this code you’ll see a 200x200 empty square, with “Hello World” in the middle and with a red rectangle directly around “Hello World”.

Each modifier creates a new struct, rather than just setting a property on the view. 
In the code above the color view is created before the frame, so the color modifier modified the button before the frame is created to modify the button.
And the result are the color modifier modified button with its initial frame not the one modified by frame modifier later.

The best way to think about it for now is to imagine that SwiftUI renders your view after every single modifier. So, as soon as you say .background(Color.red) it colors the background in red, regardless of what frame you give it. If you then later expand the frame, it won’t magically redraw the background – that was already applied.

Of course, this isn’t actually how SwiftUI works, because if it did it would be a performance nightmare, but it’s a neat mental shortcut to use while you’re learning.

An important side effect of using modifiers is that we can apply the same effect multiple times: each one simply adds to whatever was there before.

For example, SwiftUI gives us the padding() modifier, which adds a little space around a view so that it doesn’t push up against other views or the edge of the screen. If we apply padding then a background color, then more padding and a different background color, we can give a view multiple borders, like this:

~~~
Text("Hello World")
    .padding()
    .background(Color.red)
    .padding()
    .background(Color.blue)
    .padding()
    .background(Color.green)
    .padding()
    .background(Color.yellow)
~~~

[Modified Content documentation](https://developer.apple.com/documentation/swiftui/modifiedcontent)

## Why does SwiftUI use “some View” for its view type?

SwiftUI relies very heavily on a Swift power feature called “opaque return types”, which you can see in action every time you write some View. This means “one specific type that conforms to the View protocol, but we don’t want to say what.”

Returning some View has two important differences compared to just returning View:

We must always return the same type of view.
Even though we don’t know what view type is going back, the compiler does.

The View protocol has an associated type attached to it, which is Swift’s way of saying that View by itself doesn’t mean anything – we need to say exactly what kind of view it is.

So, while it’s not allowed to write a view like this:

~~~
struct ContentView: View {
    var body: View {
        Text("Hello World")
    }
}
~~~

It is perfectly legal to write a view like this:

~~~
struct ContentView: View {
    var body: Text {
        Text("Hello World")
    }
}
~~~

Returning View makes no sense, because Swift wants to know what’s inside the view – it has a big hole that must be filled. On the other hand, returning Text is fine, because we’ve filled the hole; Swift knows what the view is.

What some View lets us do is say “this will return one specific type of view, such as Button or Text, but I don’t want to say what.” So, the hole that View has will be filled by a real view, but we aren’t required to write out the exact long type.

If you create a VStack with two text views inside, SwiftUI silently creates a TupleView to contain those two views – a special type of view that holds exactly two views inside it. So, the VStack fills the “what kind of view is this?” with the answer “it’s a TupleView containing two text views.”

There is literally a version of TupleView that tracks ten different kinds of content:

~~~
TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>
~~~

And that’s why SwiftUI doesn’t allow more than 10 views inside a parent: they wrote versions of TupleView that handle 2 views through 10, but no more.

## Conditional Modifiers

It’s common to want modifiers that apply only when a certain condition is met, and in SwiftUI the easiest way to do that is with the ternary operator.

For example, if you had a property that could be either true or false, you could use that to control the foreground color of a button like this:

~~~
struct ContentView: View {
    @State private var useRedText = false

    var body: some View {
        Button("Hello World") {
            // flip the Boolean between true and false
            self.useRedText.toggle()            
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
}
~~~

This kind of code isn’t allowed:

~~~
var body: some View {
    if self.useRedText {
        return Text("Hello World")
    } else {
        return Text("Hello World")
            .background(Color.red)
    }
}
~~~

Remember, some View means “one specific type of View will be returned, but we don’t want to say what.” Because of the way SwiftUI creates new views using generic ModifiedContent wrappers, Text(…) and Text(…).background(Color.red) are different underlying types and that isn’t compatible with some View.

## Environment Modifiers

Many modifiers can be applied to containers, which allows us to apply the same modifier to many views at the same time.

For example, if we have four text views in a VStack and want to give them all the same font modifier, we could apply the modifier to the VStack directly and have that change apply to all four text views:

~~~
VStack {
    Text("Gryffindor")
    Text("Hufflepuff")
    Text("Ravenclaw")
    Text("Slytherin")
}
.font(.title)
~~~

This is called an environment modifier.

As an example, this shows our four text views with the title font, but one has a large title:

~~~
VStack {
    Text("Gryffindor")
        .font(.largeTitle)
    Text("Hufflepuff")
    Text("Ravenclaw")
    Text("Slytherin")
}
.font(.title)
~~~

There, font() is an environment modifier, which means the Gryffindor text view can override it with a custom font.

If you try using blur(), you'll know it is regular modifier:

~~~
VStack {
    Text("Gryffindor")
        .blur(radius: 0)
    Text("Hufflepuff")
    Text("Ravenclaw")
    Text("Slytherin")
}
.blur(radius: 5)
~~~

Regular modifier won't have the same effect as environment modifier.

There is no way of knowing ahead of time which modifiers are environment modifiers and which are regular modifiers – you just need to experiment.

## Views as Properties

We could create two text views like this as properties, then use them inside a VStack:

~~~
struct ContentView: View {
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")

    var body: some View {
        VStack {
            motto1
            motto2
        }
    }
}
~~~

Swift doesn’t let us create one stored property that refers to other stored properties, because it would cause problems when the object is created. This means trying to create a TextField bound to a local property will cause problems.

However, you can create computed properties if you want, like this:

~~~
var motto1: some View { Text("Draco dormiens") }
~~~

## View Composition

In this view we have a particular way of styling text views – they have a large font, some padding, foreground and background colors, plus a capsule shape:

~~~
struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("First")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())

            Text("Second")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
        }
    }
}
~~~

Because those two text views are identical apart from their text, we can wrap them up in a new custom view, like this:

~~~
struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}
~~~

We can then use that CapsuleText view inside our original view, like this:

~~~
struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText(text: "First")
            CapsuleText(text: "Second")
        }
    }
}
~~~

## Custom Modifiers

We can create a custom ViewModifier struct that does what we want:

~~~
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
~~~

We can now use that with the modifier() modifier – yes, it’s a modifier called “modifier”, but it lets us apply any sort of modifier to a view, like this:

~~~
Text("Hello World")
    .modifier(Title())
~~~

When working with custom modifiers, it’s usually a smart idea to create extensions on View that make them easier to use. For example, we might wrap the Title modifier in an extension such as this:

~~~
extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}
~~~

We can now use the modifier like this:

~~~
Text("Hello World")
    .titleStyle()
~~~

## [Custom Containers](https://www.hackingwithswift.com/books/ios-swiftui/custom-containers)

[Custom Image Modifier](https://stackoverflow.com/questions/58804696/swiftui-viewmodifier-where-content-is-an-image/59946554#59946554?newreg=c9668c4a9fbd42e9a1ca07163f4bc2a9)