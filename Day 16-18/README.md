# Project I

March 22<sup>nd</sup> 2021

## [Project 1, Part One](https://www.hackingwithswift.com/100/swiftui/16)

* [WeSplit: Introduction](https://www.hackingwithswift.com/books/ios-swiftui/wesplit-introduction)
* [Understanding the basic structure of a SwiftUI app](https://www.hackingwithswift.com/books/ios-swiftui/understanding-the-basic-structure-of-a-swiftui-app)
* [Creating a form](https://www.hackingwithswift.com/books/ios-swiftui/creating-a-form)
* [Adding a navigation bar](https://www.hackingwithswift.com/books/ios-swiftui/adding-a-navigation-bar)
* [Modifying program state](https://www.hackingwithswift.com/books/ios-swiftui/modifying-program-state)
* [Binding state to user interface controls](https://www.hackingwithswift.com/books/ios-swiftui/binding-state-to-user-interface-controls)
* [Creating views in a loop](https://www.hackingwithswift.com/books/ios-swiftui/creating-views-in-a-loop)

~~~
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
~~~

**import SwiftUI** tells Swift that we want to use all the functionality given to us by the SwiftUI framework. Apple provides us with many frameworks for things like machine learning, audio playback, image processing, and more, so rather than assume our program wants to use everything ever we instead say which parts we want to use so they can be loaded.

**struct ContentView: View** creates a new struct called ContentView, saying that it conforms to the View protocol. View comes from SwiftUI, and is the basic protocol that must be adopted by anything you want to draw on the screen – all text, buttons, images, and more are all views, including your own layouts that combine other views.

**var body: some View** defines a new computed property called body, which has an interesting type: some View. This means it will return something that conforms to the View protocol, but that extra some keyword adds an important restriction: it must always be the same kind of view being returned – you can’t sometimes return one type of thing and other times return a different type of thing.

**struct ContentView_Previews**, which conforms to the PreviewProvider protocol. This piece of code won’t actually form part of your final app that goes to the App Store, but is instead specifically for Xcode to use so it can show a preview of your UI design alongside your code. These previews use an Xcode feature called the canvas, which is usually visible directly to the right of your code.

### Forms

Forms are scrolling lists of static controls like text and images, but can also include user interactive controls like text fields, toggle switches, buttons, and more.

~~~
var body: some View {
    Form {
        Text("Hello World")
    }
}
~~~

>NOTE
>>In case you were curious why 10 rows are allowed but 11 is not, this is a limitation in SwiftUI: it was coded to understand how to add one thing to a form, how to add two things to a form, how to add three things, four things, five things, and more, all the way up to 10, but not beyond – they needed to draw a line somewhere. This limit of 10 children inside a parent actually applies everywhere in SwiftUI.

If you wanted to have 11 things inside the form you should put some rows inside a Group:

~~~
Form {
    Group {
        Text("Hello World1")
        Text("Hello World2")
        Text("Hello World3")
        Text("Hello World5")
        Text("Hello World6")
        Text("Hello World7")
    }

    Group {
        Text("Hello World8")
        Text("Hello World9")
        Text("Hello World10")
        Text("Hello World11")
        Text("Hello World12")
    }
}
~~~

If you want your form to look different when split its items into chunks, you should use the Section view instead. This splits your form into discrete visual groups, just like the Settings app does:

~~~
Form {
    Section {
        Text("Hello World")
    }

    Section {
        Text("Hello World")
        Text("Hello World")
    }
}
~~~

### NavigationView

~~~
NavigationView {
    Form {
        Section {
            Text("Hello World")
        }
    }
    .navigationBarTitle(Text("SwiftUI"))
}
~~~

### @State 

When creating struct methods that want to change properties, we need to add the mutating keyword: mutating func doSomeWork(), for example. However, Swift doesn’t let us make mutating computed properties, which means we can’t write mutating var body: some View – it just isn’t allowed.

Fortunately, Swift gives us a special solution called a property wrapper: @State. 

@State allows us to work around the limitation of structs: we know we can’t change their properties because structs are fixed, but @State allows that value to be stored separately by SwiftUI in a place that can be modified.

~~~
struct ContentView: View {
    @State var tapCount = 0

    var body: some View {
        Button("Tap Count: \(tapCount)") {
            self.tapCount += 1
        }
    }
}
~~~

### State Binding

In Swift, we mark **two-way bindings** (the value of the property is read, and also written) with a special symbol so they stand out: we write a **dollar** sign before them. This tells Swift that it should read the value of the property but also write it back as any changes happen.

~~~
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        Form {
            TextField("Enter your name", text: $name)
            Text("Your name is \(name)")
        }
    }
}
~~~

### ForEach

~~~
Form {
    ForEach(0 ..< 100) { number in
        Text("Row \(number)")
    }
}

Form {
    ForEach(0 ..< 100) {
        Text("Row \($0)")
    }
}
~~~

ForEach doesn’t get hit by the 10-view limit that would affect us if we had typed the views by hand.

~~~
struct ContentView: View {
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = 0

    var body: some View {
        VStack {
            Picker("Select your student", selection: $selectedStudent) {
                ForEach(0 ..< students.count) {
                    Text(self.students[$0])
                }
            }
            Text("You chose: Student # \(students[selectedStudent])")
        }
    }
}
~~~

1. The students array doesn’t need to be marked with @State because it’s a constant; it isn’t going to change.
2. The selectedStudent property starts with the value 0 but can change, which is why it’s marked with @State.
3. The Picker has a label, “Select your student”, which tells users what it does and also provides something descriptive for screen readers to read aloud.
4. The Picker has a two-way binding to selectedStudent, which means it will start showing a selection of 0 but update the property as the user moves the picker.
5. Inside the ForEach we count from 0 up to (but excluding) the number of students in our array.
6. For each student we create one text view, showing that student’s name.

## [Project 1, Part Two](https://www.hackingwithswift.com/100/swiftui/17)

* [Reading text from the user with TextField](https://www.hackingwithswift.com/books/ios-swiftui/reading-text-from-the-user-with-textfield)
* [Creating pickers in a form](https://www.hackingwithswift.com/books/ios-swiftui/creating-pickers-in-a-form)
* [Adding a segmented control for tip percentages](https://www.hackingwithswift.com/books/ios-swiftui/adding-a-segmented-control-for-tip-percentages)
* [Calculating the total per person](https://www.hackingwithswift.com/books/ios-swiftui/calculating-the-total-per-person)

### Start Building SplitBill

Determining the rules, users need to be able to::

1. Enter the cost of their check.
2. Enter the number of people who shares the cost.
3. Enter the amount of tip they want give.
   
>NOTE
>>Why we’re using strings for the check amount, when clearly an **Int** or **Double** would work better. Well, the reason is that we have no choice: SwiftUI **must** use **strings** to store text field values.

When an @State property changes, SwiftUI will re-invoke the body property (i.e., reload our UI).

Text fields have a modifier that lets us force a different kind of keyboard: **keyboardType()**, i.e: **.numberPad** or **.decimalPad**.

Picker inside a Form need a view to show its list, To do that, we need to add a navigation view, which lets us slide in new views as needed.

[SwiftUI](https://developer.apple.com/xcode/swiftui/) uses a declarative syntax so you can simply state what your user interface should do.

This means we say what we want rather than say how it should be done. We said we wanted a picker with some values inside, but it was down to SwiftUI to decide whether a wheel picker or the sliding view approach is better. It’s choosing the sliding view approach because the picker is inside a form, but on other platforms and environments it could choose something else.

>NOTE
>> It’s tempting to think that modifier should be attached to the end of the **NavigationView**, but it needs to be attached to the end of the **Form** instead. The reason is that navigation views are capable of showing many views as your program runs, so by attaching the title to the thing inside the navigation view we’re allowing iOS to change titles freely.

### Segmented Control

We can change Picker style by calling **.pickerStyle()**. THis modifier will change Picker style to segmented control:

~~~
.pickerStyle(SegmentedPickerStyle())
~~~

### Header/Footer

SwiftUI lets us add views to the header and footer of a section, which in this instance we can use to add a small explanatory prompt. 

~~~
Section(header: Text("How much tip do you want to give?")) {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(0 ..< tipPercentages.count) {
            Text("\(self.tipPercentages[$0])%")
        }
    }
    .pickerStyle(SegmentedPickerStyle())
}
~~~

## [Project 1, Part Three](https://www.hackingwithswift.com/100/swiftui/18)

SwiftUI adds string interpolation feature: the ability to decide how a number ought to be formatted inside the string. This actually dates way back to the C programming language, we write a string called a specifier, giving it the value "%.2f”. That’s C’s syntax to mean “a two-digit floating-point number.”
Very roughly, “%f” means “any sort of floating-point number,” which in our case will be the entire number. 
An alternative is “%g”, which does the same thing except it removes insignificant zeroes from the end – $12.50 would be written as $12.5. Putting “.2” into the mix is what asks for two digits after the decimal point, regardless of what they are.

[C-style format specifiers](https://en.wikipedia.org/wiki/Printf_format_string)

~~~
Text("$\(totalPerPerson, specifier: "%.2f")")
~~~