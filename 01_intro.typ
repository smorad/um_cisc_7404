#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.3": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.1"

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Introduction],
    subtitle: [CISC 7026 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Course information

==
Prerequisites

Lecture plan

Structure

Etc

= Decision Making

==
What is decision making? (and problem solving)

History of decision making

Applications of decision making

Difficult problems do not admit human designed algorithms

Difference to neural networks


==
I thought for a while what to call this course #pause

I thought about what I want to teach #pause

We will focus primarily on reinforcement learning in this course #pause

But reinforcement learning is a method, not a problem #pause

The problem is decision making, and so I will call this course *Decision Making*

==
How do we define decision making? #pause

It depends, each field has their own mathematical definition 

- Philosophy #pause
- Mathematics #pause
- Cognitive science #pause
- Economics #pause
- Computer science #pause
- Military science 

Let us look at the history of decision making

==

*Question:* Who was the first to apply decision making algorithms? #pause

#side-by-side(align: horizon)[#cimage("fig/01/cell.jpeg", height: 60%)][*3.5 GYA:* Single cell organism] #pause

Must decide to move away from danger and move towards food #pause

Decision making is necessary for life

==
#side-by-side[
  #cimage("fig/01/hunter.jpg", height: 80%) #pause
][
  *200 kYA:* Humanoid hunter-gatherers develop more complex decision making capabilities #pause

  Sequence of decisions to make fire #pause

  Should we apply mud to our wounds? #pause

  Do we move with the animals, or do we stay and create farms?
]

==

  #side-by-side()[
    #cimage("fig/01/tzu.jpg") 
  ][

  *500 BCE:* Humans begin to study decision making #pause

    Sun Tzu studies and writes about various forms of decision making #pause

    E.g., zero sum games: "Attack where he is unprepared; appear where you are not expected."

  ]



==
#side-by-side[
  #cimage("fig/01/aristotle.jpg", height: 100%) 
][
*400 BCE:* Aristotle, the earliest recorded framework for decision making #pause

Syllogistic logic and deductive reasoning from axioms #pause

*Axiom 1:* All philosophers prioritize knowledge over leisure #pause

*Axiom 2:* I am a philosopher #pause

*Decision:* I must attend lecture instead of the party
]

==

#side-by-side[
  #cimage("fig/01/pascal.jpg", height: 100%) 
][
*1654:* Pascal discovers multiarmed bandits in "Pascal's Wager" #pause

*Premise:* You are in bed, about to die. Should you believe in God? #pause

#table(
  columns: 3,
  [], [Believe], [Do not believe],
  [God exists], [Good], [Bad],
  [God does not exist], [Neutral], [Neutral]
) #pause

Decision making under uncertainty (my PhD topic)
]

==

#side-by-side[
  #cimage("fig/01/markov.jpeg", height: 100%) 
][
*1906:* Markov discovers Markov processes #pause 

All modern decision making systems model Markov processes
]

==

#side-by-side[
  #cimage("fig/01/bellman.jpg", height: 100%) 
][
*1953:* Bellman discovers reinforcement learning, calls it dynamic programming #pause

Discovers the *Bellman equation*, the basis for modern reinforcement learning
]

==

#side-by-side[
  #cimage("fig/01/sutton.jpg", height: 100%) 
][
*1983:* Solves the Bellman equation using a neural network #pause

Combined reinforcement learning and neural networks #pause

He is still alive and will answer your emails!

In this course, we will use his textbook _An Introduction to Reinforcement Learning_

]







= Notation

==
Let us review some notation I will use in the course #pause

If you ever get confused, come back to these slides #pause

#side-by-side[
  *Vectors*
][
  $ bold(x) = vec(x_1, x_2, dots.v, x_n) $
]

#side-by-side[
  *Matrix*
][
  $ bold(X) = mat(
    x_(1,1), x_(1,2), dots, x_(1,n); 
    x_(2,1), x_(2,2), dots, x_(2,n); 
    dots.v, dots.v, dots.down, dots.v;
    x_(m,1), x_(m,2), dots, x_(m,n); 
  ) $
]

==
We will represent vectors or matrices of *tensors* 

#side-by-side[
  Vector of tensors
][
  $ bold(x) = vec(bold(x)_1, bold(x)_2, dots.v, bold(x)_n) $
]

Each $bold(x)_i$ could be a vector, matrix, 3x3 tensor, etc #pause

==
Same for matrices

#side-by-side[
  Matrix of tensors
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
Calligraphic capital letters will often refer to *sets* #pause

$ X = {1, 2, 3, 4} $ #pause

We will represent important sets with blackboard font

#side-by-side[$ bb(R) $][Set of all real numbers ${1, 2.03, pi, dots}$]
#side-by-side[$ bb(Z) $][Set of all integers ${-2, -1, 0, 1, 2, dots}$]
#side-by-side[$ bb(Z)_+ $][Set of all *positive* integers ${1, 2, dots}$]

==
Let's quiz you on some notation #pause
#side-by-side[$ bb(R)^n $ #pause][Set of all vectors containing $n$ real numbers #pause]
#side-by-side[$ bb(Z)_(3:6) $ #pause][Set of all integers between 3 and 6 #pause]
#side-by-side[$ [0, 1]^n $ #pause][Set of all vectors of length $n$ with values between 0 and 1]
#side-by-side[$ {0, 1}^n $ #pause][Set of all boolean vectors of length $n$]

==
We define *functions* or *maps* between sets

$ f: X times Theta |-> Y $ #pause

The function $f$ takes in elements from sets $X$ and $Theta$ and outputs elements of set $Y$ #pause

*Question:* What is $X$ and $Y$? #pause

*Answer:* I did not say yet, let us define it #pause

#side-by-side[$ X in bb(R)^n, Y in [0, 1]^(n times m) $] #pause

*Question:* What does this function do?


= Bandits

==

#side-by-side[
    The simplest form of decision making is the *bandit* #pause

    *Question:* What is a bandit? #pause
][
    #cimage("fig/01/western-bandit.jpg", height: 80%) #pause
]

A bandit steals your money

==
Here is the bandit we will focus on in this course #pause

#cimage("fig/01/bandit.jpeg") #pause

This is a *one-armed* bandit

==

#side-by-side[
#cimage("fig/01/bandit.jpeg") #pause
][
*Question:* How does a one-armed bandit steal your money? #pause

*Answer:* You win less money than you put in #pause

*Example:* Costs 10 MOP to play, you can win 1000 MOP each spin #pause

Your chance of winning is $1 / 200$ #pause

Let us see if we can make money playing this game
]

==
We will use *probability* to understand how much money we will make #pause

The world is based on random *outcomes*, down to the atomic level #pause

$ Omega in {"win", "lose"} $ #pause

A *random variable* $cal(X)$ maps an outcome to a real number #pause

$ cal(X): Omega |-> bb(R) $ #pause

Our bandit has two outcomes, lose (-10) or win (1000) #pause

*Question:* What is the random variable for the bandit? #pause

#side-by-side[$ cal(X): {"lose", "win"} |-> {-10, 1000} $ #pause][$ cal(X)("lose") = -10; quad cal(X)("win") = 1000 $]

==
We can represent the chance of each outcome using probabilities #pause

//$ Pr(cal(X) = x) = {omega in Omega | cal(X)(\omega) = x} $

//#side-by-side[$ Pr(cal(X) = x) $][Probability of outcome $x$ occuring] #pause

$ Pr(cal(X) = x) = vec(Pr(cal(X) = -10), Pr(cal(X) = 1000)) = #pause vec(199 / 200, 1 / 200) = vec(0.995, 0.005) $ #pause

The probabilities over all outcomes *must always sum to one* #pause

$ sum_(omega in Omega) Pr(X(omega) = x) = 1 $ #pause

$ Pr(cal(X)("lose") = -10) + Pr(cal(X)("win") = 1000) $ #pause

$ 199 / 200 + 1 / 200  = 1 $

// TODO: Fix this, should x be the outcomes, or the values?

==
We defined the bandit random variable

$ cal(X)("lose") = -10; quad cal(X)("win") = 1000 $ #pause

And we defined the bandit probabilities

$ P(cal(X) = -10) = 199 / 200; quad P(cal(X) = 1000) = 1 / 200 $ #pause

But we still do not know how much money we will make! #pause

But we can combine them to find out

==
The *expectation* or *expected value* $bb(E)$ tells us how much money we make on average #pause

$ bb(E): underbrace((Omega |-> bb(R)), "random variable") |-> bb(R) $ #pause

$ bb(E)[cal(X)] = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ #pause


==
$ cal(X)("lose") = -10; quad cal(X)("win") = 1000 $ #pause 
$ P(cal(X) = -10) = 199 / 200; quad P(cal(X) = 1000) = 1 / 200 $ #pause
$ bb(E)(cal(X)) = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ #pause

*Question:* What is the expected value of the bandit? #pause

$ cal(X)("lose") dot P(cal(X) = -10) + cal(X)("win") dot P(cal(X) = 1000) $ #pause

$ -10 dot 199 / 200 + 1000 dot 1 / 200 = -4.95 $

==
*Question:* What does $bb(E)[cal(X)] = -4.95$ mean? #pause

You should expect to lose 4.95 MOP each time you spin the bandit #pause

This is an average, some people win money #pause

The more you spin, the closer you reach the expected value #pause

If you spin 1,000 times, you will lose close to -4950 MOP

*Question:* What is the best way to make money with the bandit?

*Answer:* Do not play! If you must, play as little as possible

==

*Exercise*: You start a new casino in Macau. 

Create a bandit with the following outcomes

$ Omega in {"Win Lemon", "Win Cherry", "Win BAR", "Lose"} $

Write down the probabilities for each outcome, and the random variable value for each outcome

Make sure the expected value is *negative but near zero*:
- Negative: The player loses money and you win money
- Near zero: The player wins sometimes and will continue to play 

= Multiarmed Bandits
