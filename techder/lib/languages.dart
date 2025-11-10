class ProgrammingLanguage {
  final String name;
  final String emoji;
  final String tagline;
  final String bio;
  final String description;
  final String useCases;
  final String sampleCode;
  final String difficulty;
  final List<String> tags;
  final List<String> resources;
  final List<String> roadmap;
  final String initialChat;

  ProgrammingLanguage({
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.bio,
    required this.description,
    required this.useCases,
    required this.sampleCode,
    required this.difficulty,
    required this.tags,
    required this.resources,
    required this.roadmap,
    required this.initialChat,
  });
}

final List<ProgrammingLanguage> allLanguages = [
  ProgrammingLanguage(
    name: 'Python',
    emoji: '🐍',
    tagline:
        "I'm everyone's type: Simple, helpful, and I can do anything. Swipe right for AI & automation. 🧠✨",
    bio:
        'I\'m the friendly one everyone loves. Simple, elegant, and I can do pretty much anything from web apps to AI. Want to automate your life? I\'m your snake! 🎯',
    description:
        'Python is a high-level, interpreted programming language created by Guido van Rossum in 1991. Known for its clean syntax and readability, it emphasizes code simplicity and developer productivity.',
    useCases:
        'Web Development (Django, Flask), Data Science & AI, Automation & Scripting, Scientific Computing, Game Development',
    sampleCode: r'''# Hello World in Python
print("Hello, World!")

# Variables and types
name = "TechTinder"
year = 2025

# Functions
def greet(name):
    return f"Hello, {name}!"

print(greet("Developer"))''',
    difficulty: 'Easy',
    tags: ['Procedural', 'Object-oriented', 'Functional'],
    resources: [
      'Python.org - https://www.python.org/',
      'Automate the Boring Stuff - https://automatetheboringstuff.com/',
      'Real Python - https://realpython.com/',
      'Python for Everybody (Coursera) - https://www.coursera.org/specializations/python',
    ],
    roadmap: [
      'Master the basics: Syntax, control flow, and data structures (lists, dictionaries).',
      'Dive into Object-Oriented Programming (OOP) concepts.',
      'Explore a specialization: Choose between Web (Flask/Django) or Data Science (Pandas/NumPy).',
      'Learn asynchronous programming and package management (Pip/Virtual Environments).',
      'Build a complex project like a REST API or a machine learning model.'
    ],
    initialChat: "Hey Beautiful! I’m Python 🐍, the friendly snake. I'm fluent in AI and automation—let's create something amazing and smart together. What's your passion project?",
  ),
  ProgrammingLanguage(
    name: 'JavaScript',
    emoji: '⚡',
    tagline:
        "Commitment issues? I'm already everywhere you go. I run the entire web (and the server). Full-stack, baby. 🌐🔥",
    bio:
        'Versatile, everywhere, and a bit chaotic. I started in browsers but now I\'m on servers too! Love me or hate me, you can\'t escape me. Full-stack is my middle name! 💛',
    description:
        'JavaScript is the programming language of the web, created in 1995. It enables interactive web pages and runs on virtually every browser. With Node.js, it conquered server-side development too.',
    useCases:
        'Frontend Development, Backend (Node.js), Mobile Apps (React Native), Desktop Apps (Electron), Game Development',
    sampleCode: r'''// Hello World in JavaScript
console.log("Hello, World!");

// Variables
const name = "TechTinder";
let year = 2025;

// Functions
function greet(name) {
    return `Hello, ${name}!`;
}

// Arrow functions
const add = (a, b) => a + b;

console.log(greet("Developer"));''',
    difficulty: 'Normal',
    tags: ['Event-driven', 'Functional', 'Object-oriented'],
    resources: [
      'MDN Web Docs - https://developer.mozilla.org/en-US/docs/Web/JavaScript',
      'JavaScript.info - https://javascript.info/',
      'Eloquent JavaScript - https://eloquentjavascript.net/',
      'FreeCodeCamp JS Course - https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures/',
    ],
    roadmap: [
      'Understand the core: Variables, scope (var, let, const), closures, and prototypes.',
      'Master DOM manipulation and asynchronous programming (Promises, async/await).',
      'Deep dive into a frontend framework (React, Vue, or Angular).',
      'Learn server-side development using Node.js and Express.',
      'Build and deploy a full-stack web application.'
    ],
    initialChat: "Hey Cutie! I’m JavaScript ⚡. I go full-stack, baby! What kind of project are you looking to fall in love with? (Browser or server, I don't judge!)",
  ),
  ProgrammingLanguage(
    name: 'Rust',
    emoji: '🦀',
    tagline:
        "I'm safe but strict, but trust me... I won't let you down. Only looking for long-term, high-performance relationships. 🛡️🚀",
    bio:
        'I\'m the safe choice - literally! Memory safety without garbage collection? That\'s me. A bit strict with rules, but hey, I prevent those nasty bugs. Performance with safety! 🛡️',
    description:
        'Rust is a modern systems programming language focused on safety, speed, and concurrency. Created in 2010, it prevents common bugs like null pointer dereferences and data races at compile time.',
    useCases:
        'Systems Programming, Game Engines, Web Assembly, CLI Tools, Embedded Systems, Blockchain',
    sampleCode: r'''// Hello World in Rust
fn main() {
    println!("Hello, World!");
    
    // Variables
    let name = "TechTinder";
    let year: i32 = 2025;
    
    // Function
    let greeting = greet("Developer");
    println!("{}", greeting);
}

fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}''',
    difficulty: 'Hard',
    tags: ['Systems', 'Functional', 'Concurrent'],
    resources: [
      'The Rust Programming Language (The Book) - https://doc.rust-lang.org/book/',
      'Rust by Example - https://doc.rust-lang.org/rust-by-example/',
      'Rustlings - https://github.com/rust-lang/rustlings',
      'Rust official - https://www.rust-lang.org/learn',
    ],
    roadmap: [
      'Read "The Rust Book" and understand fundamental syntax and modules.',
      'Master the concept of Ownership, Borrowing, and Lifetimes (the heart of Rust).',
      'Practice with Rustlings exercises to reinforce core concepts.',
      'Explore advanced features like `unsafe` code, smart pointers, and macros.',
      'Build a multithreaded CLI application or a WebAssembly module.'
    ],
    initialChat: "Swipe right on Rust 🦀! I'm a little demanding, but I promise zero runtime surprises. Ready for a serious, high-performance commitment, Gorgeous?",
  ),
  ProgrammingLanguage(
    name: 'Go',
    emoji: '🐹',
    tagline:
        "A minimalist from Google. I keep things simple, fast, and I scale under pressure. Let's build a cloud together. ☁️💻",
    bio:
        'Simple, fast, and built for the cloud! Created by Google legends, I\'m perfect for microservices and concurrent systems. No fancy features, just pure efficiency! ☁️',
    description:
        'Go (or Golang) was developed at Google in 2009 by Robert Griesemer, Rob Pike, and Ken Thompson. It\'s designed for simplicity, with built-in concurrency support via goroutines.',
    useCases:
        'Cloud Services, Microservices, DevOps Tools, Network Programming, CLI Applications, Backend APIs',
    sampleCode: r'''// Hello World in Go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
    
    // Variables
    name := "TechTinder"
    year := 2025
    
    // Functions
    greeting := greet("Developer")
    fmt.Println(greeting)
}

func greet(name string) string {
    return fmt.Sprintf("Hello, %s!", name)
}''',
    difficulty: 'Normal',
    tags: ['Procedural', 'Concurrent'],
    resources: [
      'Tour of Go - https://tour.golang.org/',
      'Go by Example - https://gobyexample.com/',
      'Effective Go - https://go.dev/doc/effective_go',
      'Go Documentation - https://go.dev/doc/',
    ],
    roadmap: [
      'Complete the Tour of Go to grasp the basics (syntax, types, packages).',
      'Understand Interfaces, Structs, and error handling patterns (idiomatic Go).',
      'Master Goroutines and Channels for concurrent programming.',
      'Work with standard library packages like `net/http` for building APIs.',
      'Build a simple scalable microservice or a high-performance network tool.'
    ],
    initialChat: "Hi Handsome! I’m Go 🐹. I keep things simple, fast, and I scale effortlessly for the cloud. What kind of backend project do you dream of building with me?",
  ),
  ProgrammingLanguage(
    name: 'TypeScript',
    emoji: '💙',
    tagline:
        "I'm JavaScript with my life together. Organized, planned, and I catch errors before you even make them. The mature upgrade. ✅💙",
    bio:
        'I\'m JavaScript\'s sophisticated sibling. I add types to keep things organized and catch errors before they happen. Big projects? I\'m your type! 😎',
    description:
        'TypeScript is a typed superset of JavaScript developed by Microsoft in 2012. It adds optional static typing, classes, and interfaces, compiling to plain JavaScript.',
    useCases:
        'Large-scale Web Applications, Frontend Frameworks (Angular, React), Backend (Node.js), Mobile Development',
    sampleCode: r'''// Hello World in TypeScript
console.log("Hello, World!");

// Types
const name: string = "TechTinder";
let year: number = 2025;

// Interfaces
interface Developer {
    name: string;
    language: string;
}

// Functions with types
function greet(name: string): string {
    return `Hello, ${name}!`;
}

const dev: Developer = {
    name: "You",
    language: "TypeScript"
};''',
    difficulty: 'Normal',
    tags: ['Typed', 'Object-oriented', 'Functional'],
    resources: [
      'TypeScript Official - https://www.typescriptlang.org/',
      'TypeScript Handbook - https://www.typescriptlang.org/docs/handbook/intro.html',
      'Understanding TypeScript (course) - https://www.udemy.com/course/understanding-typescript/',
      'TypeScript Deep Dive - https://basarat.gitbook.io/typescript/',
    ],
    roadmap: [
      'Learn basic JavaScript, then introduce static types, interfaces, and classes.',
      'Understand the compiler options and configuration (`tsconfig.json`).',
      'Master advanced types: Generics, utility types, and type inference.',
      'Integrate TypeScript with a major framework (e.g., React or Angular).',
      'Convert a large, existing JavaScript codebase to TypeScript for practice.'
    ],
    initialChat: "I'm TypeScript 💙. I bring order and reliability to the relationship, catching errors before they start. Are you ready for a mature, well-typed love, Cutie? 😉",
  ),
  ProgrammingLanguage(
    name: 'Swift',
    emoji: '🦅',
    tagline:
        "Apple's exclusive. If you like sleek, high-performing apps on your iPhone, I'm the only call you need to make. 📱🍎",
    bio:
        'Apple\'s golden child! I make iOS and Mac apps beautiful and performant. Clean syntax, powerful features, and I\'m faster than you think. Ready to build the next big app? 📱',
    description:
        'Swift is a powerful programming language created by Apple in 2014 for iOS, macOS, watchOS, and tvOS development. It\'s designed to be fast, safe, and expressive.',
    useCases:
        'iOS Development, macOS Apps, watchOS Apps, tvOS Apps, Server-side Swift',
    sampleCode: r'''// Hello World in Swift
print("Hello, World!")

// Variables and constants
let name = "TechTinder"
var year = 2025

// Functions
func greet(_ name: String) -> String {
    return "Hello, \(name)!"
}

// Classes
class Developer {
    var name: String
    init(name: String) {
        self.name = name
    }
}

print(greet("Developer"))''',
    difficulty: 'Normal',
    tags: ['Object-oriented', 'Protocol-oriented'],
    resources: [
      'Swift.org - https://swift.org/',
      'Swift Playgrounds - https://www.apple.com/swift/playgrounds/',
      '100 Days of Swift - https://www.hackingwithswift.com/100',
      'Hacking with Swift - https://www.hackingwithswift.com/',
    ],
    roadmap: [
      'Learn Swift fundamentals: variables, control flow, functions, and optionals.',
      'Master object-oriented programming, structures, and classes.',
      'Dive into the Apple ecosystem using SwiftUI or UIKit for UI development.',
      'Understand Protocol-Oriented Programming (POP) and error handling.',
      'Build and submit a complete, high-quality application to the App Store.'
    ],
    initialChat: "Hey Gorgeous! I’m Swift 🦅. If you're looking for sleek, fast, and exclusive mobile projects (I'm an Apple darling!), you've found your match. What app concept are you dreaming of building?",
  ),
  ProgrammingLanguage(
    name: 'Kotlin',
    emoji: '🎯',
    tagline:
        "Google's favorite for Android. I fix all of Java's red flags. Concise, modern, and 100% compatible with your ex. 🤖✨",
    bio:
        'JetBrains created me to fix Java\'s pain points. Now I\'m Google\'s preferred language for Android! Modern, concise, and 100% compatible with Java. Let\'s build something awesome! 🤖',
    description:
        'Kotlin is a modern, statically-typed programming language developed by JetBrains in 2011. Google announced it as the preferred language for Android development in 2019.',
    useCases:
        'Android Development, Backend Development, Multiplatform Mobile, Web Development, Server-side Apps',
    sampleCode: r'''// Hello World in Kotlin
fun main() {
    println("Hello, World!")
    
    // Variables
    val name = "TechTinder"
    var year = 2025
    
    // Functions
    fun greet(name: String): String {
        return "Hello, $name!"
    }
    
    // Data classes
    data class Developer(val name: String)
    
    println(greet("Developer"))
}''',
    difficulty: 'Normal',
    tags: ['Object-oriented', 'Functional'],
    resources: [
      'Kotlin Official - https://kotlinlang.org/',
      'Kotlin Koans - https://play.kotlinlang.org/koans/overview',
      'Android Kotlin Guides - https://developer.android.com/kotlin',
      'Kotlin Java Interop - https://kotlinlang.org/docs/java-to-kotlin-interop.html',
    ],
    roadmap: [
      'Learn Kotlin syntax, focusing on null safety and extension functions.',
      'Master Object-Oriented Programming (OOP) and modern features like data classes.',
      'Dive into Android development using Jetpack Compose (the modern UI toolkit).',
      'Explore Kotlin Coroutines for asynchronous programming.',
      'Build a full-featured Android application using best practices.'
    ],
    initialChat: "Hey Beautiful! I’m Kotlin 🎯, and I’m looking for my perfect coding partner (especially if they like Android!). What kind of clean, concise project do you dream of building together?",
  ),
  ProgrammingLanguage(
    name: 'C++',
    emoji: '⚙️',
    tagline:
        "The OG powerhouse. I'm complex, require full control, but I deliver raw, unbeatable performance. Respect your elders. ⚙️🏎️",
    bio:
        'The OG powerhouse! Game engines? Check. Operating systems? Check. I\'m complex, yes, but when you need raw power and control, I\'m still unbeatable. Respect your elders! 💪',
    description:
        'C++ was created by Bjarne Stroustrup in 1985 as an extension of C. It provides low-level memory control with high-level features like OOP, making it ideal for performance-critical applications.',
    useCases:
        'Game Development (Unreal Engine), Systems Programming, Embedded Systems, High-Performance Computing, Financial Systems',
    sampleCode: r'''// Hello World in C++
#include <iostream>
#include <string>

using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    
    // Variables
    string name = "TechTinder";
    int year = 2025;
    
    // Functions
    auto greet = [](string name) {
        return "Hello, " + name + "!";
    };
    
    cout << greet("Developer") << endl;
    return 0;
}''',
    difficulty: 'Hard',
    tags: ['Procedural', 'Object-oriented', 'Systems'],
    resources: [
      'LearnCpp - https://www.learncpp.com/',
      'C++ Reference - https://en.cppreference.com/w/',
      'The C++ Programming Language (Bjarne Stroustrup) - https://www.stroustrup.com/',
      'CppCon - https://cppcon.org/',
    ],
    roadmap: [
      'Master C fundamentals, pointers, memory allocation, and basic data structures.',
      'Dive into Object-Oriented Programming (OOP): Classes, inheritance, polymorphism.',
      'Learn Standard Template Library (STL): Vectors, maps, algorithms, and iterators.',
      'Understand resource management (RAII) and modern C++ features (C++11/17/20).',
      'Build a large-scale application like a simple game engine or high-performance library.'
    ],
    initialChat: "Hey Cutie! I’m C++ ⚙️. I'm looking for someone dedicated who appreciates raw performance. Let’s make the perfect, complex match — what kind of high-speed project are you looking to fall in love with?",
  ),
  ProgrammingLanguage(
    name: 'Java',
    emoji: '☕',
    tagline:
        "I'm an Enterprise Legend. I'm reliable, everywhere, and I've been running the world since '95. Looking for serious, corporate commitment. 🏢☕",
    bio:
        'Enterprise is my domain! Been around since \'95 and still going strong. Verbose? Maybe. Reliable? Absolutely! Billions of devices run me. Legacy legend! 🏢',
    description:
        'Java is a class-based, object-oriented programming language developed by Sun Microsystems in 1995. It\'s known for its "write once, run anywhere" philosophy via the JVM.',
    useCases:
        'Enterprise Applications, Android Development, Backend Services, Big Data (Hadoop), Desktop Applications',
    sampleCode: r'''// Hello World in Java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        
        // Variables
        String name = "TechTinder";
        int year = 2025;
        
        // Methods
        String greeting = greet("Developer");
        System.out.println(greeting);
    }
    
    public static String greet(String name) {
        return "Hello, " + name + "!";
    }
}''',
    difficulty: 'Normal',
    tags: ['Object-oriented'],
    resources: [
      'Oracle Java Tutorials - https://docs.oracle.com/javase/tutorial/',
      'Java Documentation - https://docs.oracle.com/en/java/',
      'Head First Java - https://www.oreilly.com/library/view/head-first-java/0596009208/',
      'Effective Java - https://www.pearson.com/store/p/effective-java/P100000528830',
    ],
    roadmap: [
      'Master Java fundamentals: Syntax, OOP concepts (encapsulation, abstraction).',
      'Learn Collections Framework (List, Map, Set) and Generics.',
      'Dive into concurrency (Threads, Executors) and modern features (Java 8+ lambdas, streams).',
      'Explore Enterprise frameworks like Spring Boot for backend services.',
      'Build a robust, multi-layered enterprise application.'
    ],
    initialChat: "I'm Java ☕, the reliable legend. I thrive on stability and structure! Tell me what large-scale, enterprise-grade project you're looking to start building with me today, Beautiful!",
  ),
  ProgrammingLanguage(
    name: 'Ruby',
    emoji: '💎',
    tagline:
        "I value your happiness above all else. I'm elegant, expressive, and I turn ideas into web apps (Rails) with joy. 💖💎",
    bio:
        'I\'m elegant, expressive, and all about making developers happy. Rails made me famous for web apps. Life\'s too short for ugly code - let\'s write poetry together! ✨',
    description:
        'Ruby is a dynamic, object-oriented language created by Yukihiro Matsumoto in 1995. Its philosophy emphasizes simplicity and productivity with an elegant syntax.',
    useCases:
        'Web Development (Ruby on Rails), Automation Scripts, DevOps Tools, Prototyping, Data Processing',
    sampleCode: r'''# Hello World in Ruby
puts "Hello, World!"

# Variables
name = "TechTinder"
year = 2025

# Methods
def greet(name)
  "Hello, #{name}!"
end

# Blocks and iterators
3.times do |i|
  puts "Iteration #{i}"
end

puts greet("Developer")''',
    difficulty: 'Easy',
    tags: ['Object-oriented', 'Scripting'],
    resources: [
      'Ruby-lang.org - https://www.ruby-lang.org/en/',
      'Try Ruby - https://try.ruby-lang.org/',
      'The Ruby Way - https://pragprog.com/titles/ruby4/the-ruby-way/',
      'Ruby on Rails Guides - https://guides.rubyonrails.org/',
    ],
    roadmap: [
      'Learn basic Ruby syntax, data types, and control structures.',
      'Master Object-Oriented Programming (OOP) and blocks, procs, and lambdas.',
      'Dive into the Ruby on Rails framework for web development.',
      'Understand the Rails architecture: MVC, routing, and database interactions.',
      'Build and deploy a functional web application or blogging platform using Rails.'
    ],
    initialChat: "I’m Ruby 💎, the elegant poet! I value your happiness above all else. Let's write beautiful code that makes you smile. What quick, expressive web idea do you want to prototype?",
  ),
    ProgrammingLanguage(
    name: 'C#',
    emoji: '💿',
    tagline:
        '"Everything as an object, everywhere"',
    bio:
        'I\'m Microsoft\'s flagship, built for the modern era. Powerful, cross-platform with .NET, and ready for enterprise, web, or games. Reliable and constantly evolving! 💻',
    description:
        'C# (C-sharp) is a modern, object-oriented language developed by Microsoft. It is widely used in enterprise development on the .NET framework, cross-platform apps (Xamarin/MAUI), and game development (Unity).',
    useCases:
        'Enterprise Software (.NET), Game Development (Unity), Windows Desktop Apps, Web APIs (ASP.NET Core), Cloud Services (Azure)',
    sampleCode: r'''// Hello World in C#
using System;

public class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Hello, World!");
        
        // Variables
        string name = "TechTinder";
        int year = 2025;
        
        // Methods
        string greeting = Greet("Developer");
        Console.WriteLine(greeting);
    }
    
    public static string Greet(string name)
    {
        return $"Hello, {name}!";
    }
}''',
    difficulty: 'Normal',
    tags: ['Object-oriented', 'Typed'],
    resources: [
      'Microsoft C# Docs - https://learn.microsoft.com/en-us/dotnet/csharp/',
      'Unity Learn - https://learn.unity.com/tutorial/c-scripting-fundamentals',
      'C# Yellow Book - https://www.robmiles.com/c-sharp-yellow-book/',
      'ASP.NET Core Docs - https://learn.microsoft.com/en-us/aspnet/core/',
    ],
    roadmap: [
      'Learn C# fundamentals: Syntax, data types, and control flow.',
      'Master Object-Oriented Programming (OOP): Inheritance, interfaces, and LINQ.',
      'Choose a track: ASP.NET Core for web, or Unity for games.',
      'Explore asynchronous programming (async/await) and Dependency Injection.',
      'Build a functional REST API or a simple 3D game.'
    ],
    initialChat: "I'm C# 💿, versatile and backed by Microsoft. I can build anything from massive enterprise software to games in Unity. What kind of powerful, cross-platform commitment are you looking for, Handsome?",
  ),
 ProgrammingLanguage(
    name: 'PHP',
    emoji: '🐘',
    tagline:
        '"The web runs on me (still)"',
    bio:
        'I\'m the internet backbone, the foundation of billions of websites (WordPress, Laravel, Symfony). I’m often underestimated, but I’m modern, fast, and I handle the heavy lifting of the web. 🌐',
    description:
        'PHP (Hypertext Preprocessor) is a popular general-purpose scripting language especially suited to web development. It is the language that powers major platforms like WordPress.',
    useCases:
        'Web Development (Backend), Content Management Systems (WordPress, Drupal), Frameworks (Laravel, Symfony), eCommerce (Magento)',
    sampleCode: r'''<?php
// Hello World in PHP
echo "Hello, World!\n";

// Variables
$name = "TechTinder";
$year = 2025;

// Function
function greet($name) {
    return "Hello, $name!";
}

echo greet("Developer") . "\n";
?>''',
    difficulty: 'Easy',
    tags: ['Scripting', 'Object-oriented', 'Web'],
    resources: [
      'PHP.net Documentation - https://www.php.net/docs.php',
      'Laravel Documentation - https://laravel.com/docs',
      'W3Schools PHP Tutorial - https://www.w3schools.com/php/',
      'PHP The Right Way - https://phptherightway.com/',
    ],
    roadmap: [
      'Learn PHP fundamentals: Syntax, variables, and built-in functions.',
      'Understand array manipulation and object-oriented programming (OOP).',
      'Master PHP’s interaction with databases (PDO or a simple ORM).',
      'Dive into a modern framework like Laravel or Symfony.',
      'Build a secure, dynamic, database-driven web application.'
    ],
    initialChat: "Swipe right on PHP 🐘! I'm the dependable choice—I power 77% of the internet. Let’s make a stable match and build your next big website! Which framework is your favorite, Gorgeous?",
  ),
   ProgrammingLanguage(
    name: 'R',
    emoji: '📊',
    tagline:
        '"The Statistician\'s Love"',
    bio:
        'I’m not a general-purpose language; I’m a specialist. If you’re into statistics, data analysis, or beautiful visualizations, I’m the only one you need. Let’s run some models! 📈',
    description:
        'R is a programming language and free software environment for statistical computing and graphics. It is widely used by statisticians and data miners for developing statistical software and data analysis.',
    useCases:
        'Statistical Analysis, Data Visualization (ggplot2), Machine Learning, Bioinformatics, Academic Research',
    sampleCode: r'''# Hello World in R
print("Hello, World!")

# Variables and vectors
name <- "TechTinder"
years <- c(2024, 2025, 2026)

# Function
greet <- function(name) {
  return(paste("Hello,", name, "!"))
}

# Example analysis
data_frame <- data.frame(
  id = 1:3,
  value = c(10, 20, 30)
)

print(greet("Developer"))''',
    difficulty: 'Normal',
    tags: ['Statistical', 'Functional', 'Data'],
    resources: [
      'R-Project Official - https://www.r-project.org/',
      'RStudio Education - https://education.rstudio.com/',
      'Advanced R (Hadley Wickham) - https://adv-r.had.co.nz/',
      'DataCamp R Tutorials - https://www.datacamp.com/courses/tech/r-programming',
    ],
    roadmap: [
      'Master R fundamentals: Vectors, factors, lists, and data frames.',
      'Learn the Tidyverse principles and packages (dplyr for manipulation, ggplot2 for visualization).',
      'Master statistical modeling: Regression, hypothesis testing, and ANOVA.',
      'Build interactive dashboards using Shiny.',
      'Conduct a complete data science project: cleaning, analysis, visualization, and reporting.'
    ],
    initialChat: "I'm R 📊, a serious, data-focused partner. If you want statistical power and beautiful visualizations, I’m your match. What complex data problem are you passionate about solving with me, Beautiful?",
  ),
];