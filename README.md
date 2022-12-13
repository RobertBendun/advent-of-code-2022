# Advent of Code 2022

Let's learn more programming languages! The goal of this year is to learn few languages that:

- have been somewhat influencial on programming today
- have interesting or unique or uncommon paradigm or features
- have not been used in my attempt at [Advent of Code 2021](https://github.com/RobertBendun/advent-of-code-2021)
- I don't use everyday (this excludes C, C++, JavaScript, Haskell, Python etc.)

## Journal

### Day 1 - Common Lisp

Main reason for using this language is to learn loop macro which is _wild_ - a whole EDSL for expressing iteration.
And from first usage it seems quite nice. Whish more functional programming language have EDSLs like that.

Used [sbcl](https://www.sbcl.org/) implementation and documentation from [Lisp Cookbook](https://lispcookbook.github.io/cl-cookbook/).

### Day 2 - R

Encoding solution as linear algebra equations is easy - the hard part is handling input and my solution definitely can be improved by some R magic that is unknown to me.

### Day 3 - Scala

It's astonishing how many of languages that I tried for this day ware hard to launch. But anyway, Scala shines in comparison both for batteries included approach and ease of use.

### Day 4 - AWK

It's to easy! AWK is glorious with it's simplicity.

### Day 5 - Python

Yeah I know Python but it's the best language for this task that has come to my mind. Tried Ada, Raku, Common Lisp and Haskell but in each I wasn't as satisified with direction that solution was going to.

### Day 6 - C++

This problem looked like designed for standard library that can with ease convert between sets and slices of strings, and C++ is one of them. Another reason is to see how C++ looks against other languages so far, and it's not a bad look despite its bad reputation.

### Day 7 - Zig (0.9.1)

"The Zig language is designed to prevent bugs by making strategic use of friction." [said creator of Zig](https://github.com/ziglang/zig/issues/3320#issuecomment-884478906) and this is the definition of the language. Cost of entry to this language is even higher then Rust beacuse toolchain is not as helpful as in Rust and documentation is not even started for most functions and types.

The preable of solution just to read file line by line is massive and I don't think that this will change soon - even Zig's _hello world_ is so noisy after all this time. Zig seems like language optimized for larger software and this kind of one time use programs are second class citizens in it's audience.

### Day 8 - Haskell

I miss rank polymorphism in every langauge that otherwise feels great. Parts like `f . concat` are annoying and I wish there would be a language with Haskell like syntax and rank polymorphism.

Someone added combinatory logic to this lambda calculus with `phi` combinator known in Haskell as `flip liftM2`. Reproduction of the same code patterns give birth to `solve` function which nicely removes code duplication with a cost of code obscuration. Haskell has this annoying property that it encourouges building opon layers of abstractions which makes algorithms hide behind the curtain made of mathematical beauty.

Next time first I shall upload simple solution and then play with combinatorial point-free toys.

If you wish to see combinators shine I recommend [Combinatory Logic and Combinators in Array Languages](https://raw.githubusercontent.com/codereport/Content/main/Publications/Combinatory_Logic_and_Combinators_in_Array_Languages.pdf) by [@codereport](https://github.com/codereport)
