#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot, chart
#import "@preview/pinit:0.2.2": *
#import "@preview/mannot:0.3.1": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let handout = true

#show: university-theme.with(
  config-common(handout: handout),
  aspect-ratio: "16-9",
  config-info(
    title: [Bandits],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

// TODO: Instead of cal(X), we should use cal(R) as the reward so this
// fits better with trajectory optimization and RL
// TODO: Maybe also introduce policy, but not as a function of state, just as a way to pick actions
// TODO: Call finding the expectation monte carlo, since this is a much simpler form we use later

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Review
==
In this course, we will focus primarily on reinforcement learning #pause

But reinforcement learning is a method, not a problem #pause

The problem is *decision making*

==
#cimage("fig/01/chess.png", height: 85%) 

==
We will focus on *optimal* decision making #pause

Make the best possible decision, given the information we have #pause

We will find methods that *guarantee* optimal decision making #pause

With these methods, we can create optimal decision making machines #pause

With an optimal decision making machine, you can create: #pause
- Best possible doctor (which medicine to give?) #pause
- Best possible lawyer (what to argue?) #pause
- Best possible scientist (what to research?)

= Set Notation

==
Let us review some notation I will use in the course #pause

If you ever get confused, come back to these slides #pause

#side-by-side(align: horizon)[
  Vectors
][
  $ bold(x) = vec(x_1, x_2, dots.v, x_n) $
] #pause

#side-by-side(align: horizon)[
  Matrices
][
  $ bold(X) = mat(
    x_(1,1), x_(1,2), dots, x_(1,n); 
    x_(2,1), x_(2,2), dots, x_(2,n); 
    dots.v, dots.v, dots.down, dots.v;
    x_(m,1), x_(m,2), dots, x_(m,n); 
  ) $
]

==
We will represent *tensors* as nested vectors or matrices #pause

#side-by-side(align: horizon)[
  Tensor
][
  $ bold(x) = vec(bold(x)_1, bold(x)_2, dots.v, bold(x)_n) $
] #pause

Each $bold(x)_i$ is a vector 

==
Same for matrices

#side-by-side(align: horizon)[
  Tensor of matrices
][
  $ bold(X) = mat(
    bold(x)_(1,1), bold(x)_(1,2), dots, bold(x)_(1,n); 
    bold(x)_(2,1), bold(x)_(2,2), dots, bold(x)_(2,n); 
    dots.v, dots.v, dots.down, dots.v;
    bold(x)_(m,1), bold(x)_(m,2), dots, bold(x)_(m,n); 
  ) $
]

==
*Question:* What is the difference between the following?

$ bold(X) = mat(
  x_(1,1), x_(1,2), dots, x_(1,n); 
  x_(2,1), x_(2,2), dots, x_(2,n); 
  dots.v, dots.v, dots.down, dots.v;
  x_(m,1), x_(m,2), dots, x_(m,n); 
) $

$ bold(X) = mat(
  bold(x)_(1,1), bold(x)_(1,2), dots, bold(x)_(1,n); 
  bold(x)_(2,1), bold(x)_(2,2), dots, bold(x)_(2,n); 
  dots.v, dots.v, dots.down, dots.v;
  bold(x)_(m,1), bold(x)_(m,2), dots, bold(x)_(m,n); 
) $

==
Capital letters will often refer to *sets* #pause

$ X = {1, 2, 3, 4} $ #pause

We will represent important sets with blackboard font #pause

#side-by-side[$ bb(R) $][Set of all real numbers ${1, 2.03, pi, dots}$] #pause
#side-by-side[$ bb(Z) $][Set of all integers ${-2, -1, 0, 1, 2, dots}$] #pause
#side-by-side[$ bb(Z)_+ $][Set of all *positive* integers ${1, 2, dots}$]

==
#side-by-side[
  $ [0, 1] $
][
  Closed interval $0.0, 0.01, 0.00 dots 1, 0.99, 1.0$
] #pause
#side-by-side[
  $ (0, 1) $
][
  Open interval $0.01, 0.00 dots 1, 0.99$
] #pause
#side-by-side[
  $ {0, 1} $
][
  Set of two numbers (boolean)
] #pause

#side-by-side[
  $ [0, 1]^k $
][
  A vector of $k$ numbers between 0 and 1
] #pause

#side-by-side[
  $ {0, 1}^(k times k) $
][
  A matrix of boolean values of shape $k$ by $k$
]

==
We will use various set operations #pause

#side-by-side[$ A subset.eq B $][$A$ is a subset of $B$] #pause
#side-by-side[$ A subset B $][$A$ is a strict subset of $B$] #pause
#side-by-side[$ a in A $][$a$ is an element of $A$] #pause
#side-by-side[$ b in.not A $][$b$ is not an element of $A$] #pause
#side-by-side[$ A union B $][The union of sets $A$ and $B$] #pause
#side-by-side[$ A inter B $][The intersection of sets $A$ and $B$] 

==
We will often use *set builder* notation #pause

$ { #pin(1) x + 1 #pin(2) | #pin(3) x in Z #pin(4) } $ #pause

#pinit-highlight(1, 2)
#pinit-point-from((1,2), pin-dx: 0pt, offset-dx: 0pt)[Function]

#pinit-highlight(3, 4, fill: blue.transparentize(80%))
#pinit-point-from((3,4),)[Domain] #pause

#v(2em)

You can think of this as a for loop 

```python
  output = {} # Set
  for x in Z:
    output.insert(x + 1)
```  #pause


#v(2em)

```python
  output = {x + 1 for x in Z}
```

= Function Notation

==
We define *functions* or *maps* between sets

$ #pin(1) f #pin(2) : #pin(3) bb(R) #pin(4) |-> #pin(5) bb(Z) #pin(6) $ #pause

#pinit-highlight(1, 2)
#pinit-point-from((1,2), pin-dx: 0pt, offset-dx: 0pt)[Name] #pause

#pinit-highlight(3, 4, fill: blue.transparentize(80%))
#pinit-point-from((3,4),)[Input] #pause

#pinit-highlight(5, 6, fill: green.transparentize(80%))
#pinit-point-from((5,6),)[Output] #pause

#v(2em)

A function $f$ maps a real number to an integer #pause

*Question:* What functions could $f$ be? #pause

$ "round": bb(R) |-> bb(Z) $ 

==

Functions can have multiple inputs

$ f: X times Theta |-> Y  $ #pause

The function $f$ maps elements from sets $X$ and $Theta$ to set $Y$ #pause

I will define variables when possible 

#side-by-side[$ X in bb(R)^n; Theta in bb(R)^(m times n); Y in [0, 1]^(n times m) $] #pause

==
Finally, functions can have a function as input or output #pause

*Question:* Any examples? #pause

$ dif / (dif x): underbrace((f: bb(R) |-> bb(R)), "Input function") |-> underbrace((f': bb(R) |-> bb(R)), "Output function") $ #pause

$ dif / (dif x) x^2 = 2x $

== // 15:00
The $max$ function returns the maximum of a function over a domain #pause

$ max: (f: X |-> Y) times (Z subset.eq X) |-> Y $ #pause

$ max_(x in Z) f(x) $ #pause


The $argmax$ operator returns the input that maximizes a function #pause

$ argmax: (f: X |-> Y) times (Z subset.eq X) |-> Z $ #pause

$ argmax_(x in Z) f(x) $ 

==

We also have the $min$ and $argmin$ operators, which minimize $f$ 

$ min: (f: X |-> Y) times (Z subset.eq X) |-> Y $ #pause

$ min_(x in Z) f(x) $ #pause

$ argmin: (f: X |-> Y) times (Z subset.eq X) |-> Z $ #pause

$ argmin_(x in Z) f(x) $ #pause

We want to make optimal decisions, so we will often take the minimum or maximum of functions



= Exercises
== // 20:00 + 2

#side-by-side[$ bb(R)^n $ #pause][Set of all vectors containing $n$ real numbers #pause]
#side-by-side[$ {3, 4, dots, 31} $ #pause][Set of all integers between 3 and 31 #pause]
#side-by-side[$ [0, 1]^n $ #pause][Set of all vectors of length $n$ with values between 0 and 1 #pause] 
#side-by-side[$ {0, 1}^n $ #pause][Set of all boolean vectors of length $n$]

==
#side-by-side[
$ f(x) = -(x + 1)^2 $ #pause
][
    #align(center)[
        #cetz.canvas(length: 1cm, {
        plot.plot(size: (8, 6),
            x-tick-step: 1,
            y-tick-step: 1,
            y-min: -4,
            y-max: 1,
            y-label: $ f(x) $,
            {
            plot.add(
                domain: (-3, 3), 
                style: (stroke: (thickness: 5pt, paint: red)),
                x => -calc.pow(x + 1, 2)
            )
            })
        })
    ] #pause
]
#side-by-side[
  $ max_(x in bb(R)) f(x) ? $ #pause
][
  $ argmax_(x in bb(R)) f(x) ? $ #pause
][
  $ argmax_(x in bb(Z)_+) f(x) ? $ #pause
]

#side-by-side[$ 0 $ #pause][$ -1 $ #pause][$ 1 $]

==

$ {x^(1/2) | x in bb(R)_+} $ #pause

*Question:* What is this? #pause

*Answer:* #pause
- An infinitely large set #pause
- The results of evaluating $f(x) = sqrt(x)$ for all positive real numbers


// 25:00




= Bandits

==
The textbook reviews bandits before introducing reinforcement learning #pause
- Bandits are a simplified version of reinforcement learning #pause
- Provides a "taste" of reinforcement learning in a single lecture #pause
  - It will give you an idea if you will like the course #pause
- Today's lecture may be difficult #pause
  - Do not worry, we have the entire course to learn RL #pause
  - If you understand it, learning RL will be very easy for you

==

#side-by-side[
    *Bandits* are the simplest decision making problem #pause

    *Question:* What is a bandit? #pause
][
    #cimage("fig/02/western-bandit.jpg", height: 80%) #pause
]

A bandit steals your money

==
Here is the bandit we will focus on in this course #pause

#cimage("fig/02/bandit.jpeg") #pause

This is a *one-armed* bandit

==

#side-by-side[
#cimage("fig/02/bandit.jpeg") #pause
][
*Question:* How does a one-armed bandit steal your money? #pause

*Answer:* You win less money than you put in #pause

*Example:* Costs 10 MOP to play, you can win 1000 MOP each spin #pause

Your chance of winning is $1 / 200$ #pause

Let us see if we can make money playing this game
]

==
#side-by-side[
  We will use *probability* to understand how much money we will make #pause
  - First, we should briefly review probability theory #pause
  - Our world is based on random *outcomes* #pause
][
  #cimage("fig/02/electron.jpg")
]


==

For our bandit, we have two possible outcomes 

$ Omega = {"win", "lose"} $ #pause

An *event* is a subset of the outcomes

$ E subset.eq Omega $ #pause

$ E_"win" = {"win"}; quad E_"lose" = {"lose"}; quad E_"any" = {"win", "lose"} $ 

==

We define the probabilites over the outcome and event spaces #pause

$ underbrace(Pr("win") = 1/200\, quad Pr("lose") = 199/200, #redm[Outcome $Omega$]), quad underbrace(Pr(E_"any") = 200/200, #bluem[Event]) $ #pause

#text(fill: red)[Outcome] probabilities *must be positive* and *must sum to one* #pause

$ sum_(omega in #redm[$Omega$]) Pr(omega) = 1 $ #pause

*Question:* Do #bluem[event] probabilities always sum to one? #pause

#side-by-side[
  $ #bluem[$E_"win"$] = { "win" } $
][
$ sum_(epsilon in #bluem[$E_"win"$]) Pr(epsilon) = 0.005 $ 
]


==

A *random variable* $cal(X)$ maps an outcome to a real number #pause

$ cal(X): Omega |-> bb(R) $ #pause

Our bandit has two outcomes, lose (-10) or win (1000) #pause

Since we are gambling, we can call this the *reward* $cal(R)$ #pause

$ cal(R): Omega |-> bb(R) $ #pause

*Question:* What is the random variable for the bandit? #pause

#side-by-side[$ cal(R): {"lose", "win"} |-> {-10, 1000} $ #pause][$ cal(R)("lose") = -10; quad cal(R)("win") = 1000 $]

==
We can also compute the probability over random variables #pause


#v(1em)
$ Pr(cal(R) = r) = Pr({
    markhl(cal(R)(omega), tag: #<1>, color: #red) = markhl(r, tag: #<2>, color: #blue)
    mid(|) 
    markhl(omega, tag: #<3>, color: #green) in
    markhl(Omega, tag: #<4>, color: #orange)}) $ #pause

#annot((<1>), pos: bottom, dy: 1em, annot-text-props: (size: 1em))[Random Variable] #pause

#annot((<2>), pos: top, dy: -1em, annot-text-props: (size: 1em))[Real] #pause

#annot((<3>), pos: bottom, dy: 1em, annot-text-props: (size: 1em))[Outcome] #pause

#annot((<4>), pos: right, dx: 2em, annot-text-props: (size: 1em))[Outcome Space] #pause

#v(-4.75em)

#side-by-side[$ cal(R): {"lose", "win"} |-> {-10, 1000} $ #pause][$ cal(R)("lose") = -10; quad cal(R)("win") = 1000 $] #pause

$ Pr(cal(R)) = vec(Pr(cal(R) = -10), Pr(cal(R) = 1000)) = vec(199 / 200, 1 / 200) = vec(0.995, 0.005) $

==

$ Pr(cal(R)) &= vec(Pr(cal(R) = -10), Pr(cal(R) = 1000)) = vec(199 / 200, 1 / 200) = vec(0.995, 0.005) \ #pause

Pr(cal(R) #pin(9)= 1000#pin(10)) &= vec(Pr(cal(R) = -10), #pin(11)Pr(cal(R) = 1000)#pin(12)) = vec(199 / 200, #pin(13)1 / 200#pin(14)) = vec(0.995, #pin(15)0.005#pin(16)) $ 

#pinit-highlight(9, 10, fill: orange.transparentize(80%))
#pinit-highlight(11, 12, fill: orange.transparentize(80%))
#pinit-highlight(13, 14, fill: orange.transparentize(80%))
#pinit-highlight(15, 16, fill: orange.transparentize(80%))

== 
// TODO: This doesn't make sense does it?
// Shouldn't it be Pr(w) = 1?
Like before, the probability over the random variable *must sum to one* #pause

$ sum_(omega in Omega) Pr(cal(R)(omega)) = 1 $ #pause

$ Pr(cal(R)("lose") = -10) + Pr(cal(R)("win") = 1000) = 1 $ #pause

$ 199 / 200 + 1 / 200  = 1 $

// TODO: Fix this, should x be the outcomes, or the values?

==
We defined our bandit's probabilities

$ Pr("lose") = 199 / 200; quad Pr("win") = 1 / 200 $ #pause

And the random variable

$ cal(R)("lose") = -10; quad cal(R)("win") = 1000 $ #pause

But we still do not know how much money we will make! #pause

We can combine probabilities and random variables to find out

==
The *expectation* or *expected value* $bb(E)$ is the mean of the random variable #pause

The expectation tells us how much money we make on average #pause

$ bb(E): underbrace((Omega |-> bb(R)), "random variable") |-> bb(R) $ #pause

$ bb(E)[cal(R)] = sum_(omega in Omega) cal(R)(omega) dot Pr(omega) $ #pause

==
$ Pr("lose") = 199 / 200; quad Pr("win") = 1 / 200 $ #pause
$ cal(R)("lose") = -10; quad cal(R)("win") = 1000 $ #pause 
$ bb(E)[cal(R)] = sum_(omega in Omega) Pr(omega) dot cal(R)(omega) $ #pause

*Question:* What is the expected value of the bandit? #pause

$ Pr("lose") dot cal(R)("lose") + Pr("win") dot cal(R)("win") $ #pause

$ 199 / 200 dot -10 + 1 / 200 dot 1000 = -4.95 $

==
*Question:* What does $bb(E)[cal(R)] = -4.95$ mean? #pause

Expect to lose 4.95 MOP on average each time you spin the bandit #pause

We can refer to individual samples as rewards $r_i$ #pause

$ 
  r_1 = -10 \
  r_2 = -10 \ 
  dots.v \
  r_n = -10
$ #pause

Negative reward means we lose money

==

$ 
  r_1 = -10 \
  r_2 = -10 \ 
  dots.v \
  r_n = -10
$ #pause

If play the game more, the mean reward converges to the expectation

$ lim_(n -> oo) sum_(t=1)^n r_t = n dot bb(E)[cal(R)] = -4.95 n $


==
$ lim_(n -> oo) sum_(t=1)^n r_t = -4.95 n = n bb(E)[cal(R)] $ #pause


If you play 1,000 times ($n = 1000$), expect to lose -4950 MOP #pause

*Question:* What is the best way to make money with the bandit? #pause

*Answer:* Do not play! If you must, play as little as possible #pause

The more you play, the closer you get to $n dot bb(E)[cal(R)]$

==

If you know $bb(E)[cal(R)]$, you know the result of gambling #pause

*Question:* Do gamblers know $bb(E)[cal(R)]$? #pause

*Answer:* No! This is a secret of the casino #pause

*Question:* Could a gambler find out $bb(E)[cal(R)]$?

==
Gambler only has access to the rewards

$ r_1, r_2, dots, r_n = -10, -10, dots, 1000 $ #pause

*Question:* How could a gambler find out $bb(E)[cal(R)]$? #pause

// $ lim_(n -> oo) sum_(t=1)^n r_t = -4.95 n = n bb(E)[cal(R)] $ #pause

#side-by-side(align: horizon)[
  We can sum the rewards
  ][
    $ sum_(t=1)^n r_t approx n dot bb(E)[cal(R)] $
  ] #pause

#side-by-side(align: horizon)[Divide by number of plays][
  $ 1 / n sum_(t=1)^n r_t approx bb(E)[cal(R)] $
] #pause

After playing enough, the gambler can approximate the expectation!

==

#side-by-side(align: horizon)[
  We can sum the rewards
  ][
    $ sum_(t=1)^n r_t approx n dot bb(E)[cal(R)] $
  ] 

#side-by-side(align: horizon)[Divide by number of plays][
  $ 1 / n sum_(t=1)^n r_t approx bb(E)[cal(R)] $
] #pause

We call this a *Monte Carlo* method #pause
- Monte Carlo methods approximate a function using random samples #pause
- Monte Carlo is the European version of Macau (casino city) #pause
  - Monte Carlo means you are a gambler with missing information

==

*Exercise*: You start a new casino in Macau. #pause Create a bandit with the following outcomes $Omega in {#emoji.lemon, #emoji.cherries, #emoji.bell, #emoji.crossmark}$ #pause

#cimage("fig/02/one-slot.png", height: 60%)

==

*Exercise*: You start a new casino in Macau. Create a bandit with the following outcomes $Omega in {#emoji.lemon, #emoji.cherries, #emoji.bell, #emoji.crossmark}$ #pause

Write down: #pause
- Probability for each outcome ${Pr(omega) | omega in Omega}$ #pause
- The random variable $cal(R)$ for each outcome ${cal(R)(omega)  | omega in Omega}$ #pause
- The expected value of the random variable $bb(E)[cal(R)]$ #pause
- How much money we expect to make if the gambler plays 1000 times #pause

Make sure the expected value is *negative but near zero*: #pause
- Negative: The gambler loses money and you make money #pause
- Near zero: The gambler wins sometimes and will continue to play 

= Multiarmed Bandits

// casino
// define problem
// applications
// q*/expectation
// exploration and exploitation
// epsilon greedy
// incremental exploration

== 
The bandit problem is useful for casino owners and gamblers #pause

But it is a trivial decision making problem #pause

If $bb(E)[cal(R)] > 0$ you should gamble #pause

If $bb(E)[cal(R)] < 0$ you should not gamble #pause

We will make the problem more interesting 

==
You arrive at the Londoner with 1000 MOP and want to win money #pause

#cimage("fig/02/mab-slots.jpg", height: 60%) #pause

*Question:* Which machine do you play?

==
We call this the *multi-armed bandit* problem #pause

#cimage("fig/02/mab-octo.png", height: 60%) #pause

You don't know the expected value of each arm. Which should you pull?

==
We can model many real problems as multiarmed bandits #pause

For example, we can model hospital treatment as multiarmed bandits #pause

We have new medicines, but do not know their effectiveness #pause 

#side-by-side[
    #cimage("fig/02/slot.jpg")
    #align(center)[Medicine A]
][
    #cimage("fig/02/slot.jpg")
    #align(center)[Medicine B]
][
    #cimage("fig/02/slot.jpg")
    #align(center)[Medicine C]
] #pause

We can find the best medicine while healing the most people

==
YouTube, Youku, BiliBili, TikTok, Netflix use bandits to suggest videos #pause

#side-by-side[
    #cimage("fig/02/slot.jpg")
    #align(center)[Dog videos]
][
    #cimage("fig/02/slot.jpg")
    #align(center)[Gaming videos]
][
    #cimage("fig/02/slot.jpg")
    #align(center)[Study videos]
] #pause

The "money" is your #emoji.heart #pause 

You like a specific type of video, but TikTok does not know what it is #pause

TikTok select videos to maximize your $bb(E)[#emoji.heart]$

==
*Problem:* We have $k$ bandits, and each bandit is a random variable

$ cal(R)_1, cal(R)_2, dots, cal(R)_k $ #pause

We do not know $bb(E)[cal(R)_1], bb(E)[cal(R)_2], dots, bb(E)[cal(R)_k]$ #pause

You can take an *action* to play one bandit #pause 

$ a in {1, 2, dots, k} $ #pause

Which actions make the most money in the least time? 

//*Question:* How should we approach this problem?

==

This is a hard problem! #pause

We need to estimate $bb(E)[cal(R)_1], bb(E)[cal(R)_2], dots, bb(E)[cal(R)_k]$ to find the best $cal(R)$ #pause

#side-by-side(align: horizon)[But it takes #math.oo money to find $bb(E)[cal(R)]$!][
$ bb(E)[cal(R)] = lim_(n -> oo) 1 / n sum_(t=1)^n r_t $ #pause
]

Which action $a in {1 dots k}$ do we choose? Which bandit do we play? #pause

We want to: #pause
- #side-by-side[Pick $a$ to estimate bandits][$ bb(E)[cal(R)_a | a in 1 dots k] $] #pause
- #side-by-side[Pick $a$ to make the most money][$ argmax_(a in {1 dots k}) bb(E)[cal(R)_a] $] 

==
We have names for each goal #pause

#side-by-side(align: center)[
    *Exploration:* 
    $ bb(E)[cal(R)_a | a in {1 dots k}] $ #pause

    Explore our options to improve our estimate of each random variable #pause
][
    *Exploitation:*
    $ argmax_(a in {1 dots k}) bb(E)[cal(R)_a] $ #pause

    Use our estimates to select the best bandit and make the most money #pause

] #pause

It is important to understand the difference between exploration and exploitation! Any questions? 

==
*Question:* How can we choose $a$ to achieve each goal? #pause

#side-by-side(align: center)[
    *Exploration:* 
    $ bb(E)[cal(R)_a | a in {1 dots k}] $ 

    Explore our options to improve our estimate of each expectation 
][
    *Exploitation:*
    $ argmax_(a in {1 dots k}) bb(E)[cal(R)_a] $ 

    Use our estimates to make money

] #pause


#side-by-side[
    $ a tilde "uniform"({1 dots k}) $ #pause
][
    $ a = argmax_(a in {1 dots k})(bb(E)[cal(R)_a]) $ #pause
] 

*Question:* How can we achieve both goals at once? #pause

*Answer:* Sometimes choose $a$ to explore, sometimes choose $a$ to exploit

==
$ 
    u tilde "uniform"([0, 1]) \
    "if" u < 0.5 "then" a tilde "uniform"({1 dots k}) \
    "if" u >= 0.5 "then" a = argmax(bb(E)[cal(R)_a])
$ #pause

Half the time we explore, half the time we exploit #pause

We can change the explore/exploit ratio using a parameter $epsilon$ #pause

$ 
    u tilde "uniform"([0, 1]) \
    "if" u < epsilon "then" a tilde "uniform"({1 dots k}) \
    "if" u >= epsilon "then" a = argmax(bb(E)[cal(R)_a])
$

==

$ 
    epsilon in [0, 1] \
    u tilde "uniform"([0, 1]) \
    "if" u < epsilon "then" a tilde "uniform"({1 dots k}) \
    "if" u >= epsilon "then" a = argmax(bb(E)[cal(R)_a])
$ #pause

We call this *epsilon greedy* #pause

We take the greedy action (make money) with probability $1 - epsilon$ #pause


*Question:* When should $epsilon approx 1$? When should $epsilon approx 0$? #pause

#side-by-side[$epsilon approx 0$ when we trust our estimates of $bb(E)[cal(R)]$ ][
$epsilon approx 1$ when we do not trust our estimates of $bb(E)[cal(R)]$
]

==
*Question:* Do we use epsilon greedy in medicine? #pause

*Answer:* Yes! #pause
- Usually give patients drug A that we know works (exploit) #pause
- Sometimes test new drug B on patients (explore) #pause

*Question:* Does TikTok or BiliBili use epsilon greedy? #pause

*Answer:* Yes! #pause
- If you watch dog videos, it usually suggests more dog videos #pause
- Sometimes it suggests study videos, to understand if you like study videos more

= Questions?

= Coding
==
Let us code some multiarmed bandits! #pause

https://colab.research.google.com/drive/1cyNLRa-J8oe7pgy_gs2mcypZPqqaquoa

