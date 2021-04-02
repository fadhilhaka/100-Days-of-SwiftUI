# Consolidation II

April 2<sup>nd</sup> 2021

* [What you learned](https://www.hackingwithswift.com/guide/ios-swiftui/2/1/what-you-learned)
* [Key points](https://www.hackingwithswift.com/guide/ios-swiftui/2/2/key-points)
* [Challenge](https://www.hackingwithswift.com/guide/ios-swiftui/2/3/challenge)

## Structs vs Classes

There are five key differences between structs and classes:

1. Classes don’t come with a memberwise initializer; structs get these by default.
2. Classes can use inheritance to build up functionality; structs cannot.
3. If you copy a class, both copies point to the same data; copies of structs are always unique.
4. Classes can have deinitializers; structs cannot.
5. You can change variable properties inside constant classes; properties inside constant structs are fixed regardless of whether the properties are constants or variables.

>NOTE
>>One of the fascinating details of SwiftUI is how it completely inverts how we use structs and classes. In UIKit we would use structs for data and classes for UI, but in SwiftUI it’s completely the opposite – a good reminder of the importance of learning things, even if you think they aren’t immediately useful.

## Working with ForEach

ForEach is a view just like most other things in SwiftUI, but it allows us to create other views inside a loop. In doing so, it also allows us to bypass the ten-child limit that SwiftUI imposes – the ForEach itself becomes one of the 10, rather than the things inside it.

Now consider a string array like this:

let agents = ["Cyril", "Lana", "Pam", "Sterling"]
How could we loop over those and make text views?

One option is to use the same construction we already have:

~~~
VStack {
    ForEach(0 ..< agents.count) {
        Text(self.agents[$0])
    }
}
~~~

SwiftUI offers us a second alternative: we can loop over the array directly.

When we were using a range such as 0 ..< 5 or 0 ..< agents.count, Swift knew for sure that each item was unique because it would use the numbers from the range – each number was used only once in the loop, so it would definitely be unique.

In our array of strings that’s no longer possible, but we can clearly see that each value is unique: the values in ["Cyril", "Lana", "Pam", "Sterling"] don’t repeat. So, what we can do is tell SwiftUI that the strings themselves – “Cyril”, “Lana”, etc – are what can be used to identify each view in the loop uniquely.

In code, we’d write this:

~~~
VStack {
    ForEach(agents, id: \.self) {
        Text($0)
    }
}
~~~

## Working with Bindings

Bindings aren’t magic: @State takes away some boring boilerplate code for us, but it’s perfectly possible to create and manage bindings by hand if you want to.

Everything that SwiftUI does for us can be done by hand, and although it’s nearly always better to rely on the automatic solution it can be really helpful to take a peek behind the scenes so you understand what it’s doing on your behalf.

First let’s look at the simplest form of custom binding, which just stores the value away in another @State property and reads that back:

~~~
struct ContentView: View {
    @State var selection = 0

    var body: some View {
        let binding = Binding(
            get: { self.selection },
            set: { self.selection = $0 }
        )

        return VStack {
            Picker("Select a number", selection: binding) {
                ForEach(0 ..< 3) {
                    Text("Item \($0)")
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}
~~~

So, that binding is effectively just acting as a passthrough – it doesn’t store or calculate any data itself, but just acts as a shim between our UI and the underlying state value that is being manipulated.

However, notice that the picker is now made using selection: binding – no dollar sign required. We don’t need to explicit ask for the two-way binding here because it already is one.

## Challenge

Build Paper-Rock-Scissor Game.

App flow:

* Each turn of the game the app will randomly pick either rock, paper, or scissors.
* Each turn the app will either prompt the player to win or lose.
* The player must then tap the correct move to win or lose the game.
* If they are correct they score a point; otherwise they lose a point.
* The game ends after 10 questions, at which point their score is shown.