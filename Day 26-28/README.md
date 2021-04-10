# Expanding your skills

April 10<sup>th</sup> 2021

<!-- |                        |                        |                        |                        |                        |
|:----------------------:|:----------------------:|:----------------------:|:----------------------:|:----------------------:|
| ![](images/img_1.png)  | ![](images/img_2.png)  | ![](images/img_3.png)  | ![](images/img_4.png)  | ![](images/img_5.png)  | -->

## Project 4, part one

* [BetterRest: Introduction](https://www.hackingwithswift.com/books/ios-swiftui/betterrest-introduction)
* [Entering numbers with Stepper](https://www.hackingwithswift.com/books/ios-swiftui/entering-numbers-with-stepper)
* [Selecting dates and times with DatePicker](https://www.hackingwithswift.com/books/ios-swiftui/selecting-dates-and-times-with-datepicker)
* [Working with dates](https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates)
* [Training a model with Create ML](https://www.hackingwithswift.com/books/ios-swiftui/training-a-model-with-create-ml)

The actual app we’re build is called BetterRest, and it’s designed to help coffee drinkers get a good night’s sleep by asking them three questions:

1. When do they want to wake up?
2. Roughly how many hours of sleep do they want?
3. How many cups of coffee do they drink per day?

Once we have those three values, we’ll feed them into Core ML to get a result telling us when they ought to go to bed.

Using a technique called regression analysis we can ask the computer to come up with an algorithm able to represent all our data. This in turn allows it to apply the algorithm to fresh data it hasn’t seen before, and get accurate results.

SwiftUI has two ways of letting users enter numbers, **Stepper** and **Slider**.

Steppers are smart enough to work with any kind of number type you like – you can bind them to Int, Double, and more, and it will automatically adapt.

By default steppers are limited only by the range of their storage. We’re using a Double in this example, which means the maximum value of the slider will be 1.7976931348623157e+308. That’s scientific notation, but it means “1.79769 times 10 to the power of 308”.

Stepper lets us limit the values we want to accept by providing an in range, like this:

~~~
Stepper(value: $sleepAmount, in: 4...12) {
    Text("\(sleepAmount) hours")
}
~~~

We can also specify the step:

~~~
Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
    Text("\(sleepAmount) hours")
}
~~~

The **“%g”** specifier on Text is useful, because it automatically removes insignificant zeroes from the end of the number.

SwiftUI gives us a dedicated picker type called DatePicker that can be bound to a date property. Swift has a dedicated type for working with dates, and it’s called **Date**.

Date pickers provide us with a couple of configuration options that control how they work. First, we can use displayedComponents to decide what kind of options users should see:

* If you don’t provide this parameter, users see a day, hour, and minute.
* If you use .date users see month, day, and year.
* If you use .hourAndMinute users see just the hour and minute components.

>Fun Fact
>> Try running cal 9 1752, it will shows you the calendar for September 1752 – you’ll notice 12 whole days are missing, thanks to the calendar moving from Julian to Gregorian.

In the project we’re making we’ll be using dates in three ways:

1. Choosing a sensible default “wake up” time.
2. Reading the hour and minute they want to wake up.
3. Showing their suggested bedtime neatly formatted.

Swift gives us Date for working with dates, and that encapsulates the year, month, date, hour, minute, second, timezone, and more. It also allow us to specifically choose the component(s), rather than the whole thing, called **DateComponents**.

~~~
var components = DateComponents()
    components.hour = 8
    components.minute = 0
let date = Calendar.current.date(from: components)
~~~

How we could read the hour user want to wake up? Remember, **DatePicker** is bound to a Date giving us lots of information, so we need to find a way to pull out just the hour and minute components.

We can ask for the hour and minute from **DateComponents**, but we’ll be handed back a DateComponents instance with optional values for all its properties. Yes, we know hour and minute will be there because those are the ones we asked for, but we still need to unwrap the optionals or provide default values.

~~~
let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
let hour = components.hour ?? 0
let minute = components.minute ?? 0
~~~

How we can format dates and times? Swift gives us a specific type to do most of the work for us. This time it’s called **DateFormatter**, and it lets us convert a date into a string in a variety of ways.

~~~
let formatter = DateFormatter()
    formatter.timeStyle = .short
let dateString = formatter.string(from: Date())
~~~