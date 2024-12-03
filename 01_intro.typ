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

= Decision Making

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

= Multiarmed Bandits


==
We can represent this information using probabilities #pause

The *random variable* $X$ represents the outcome of playing the bandit #pause

The possible values of $X$ 

#side-by-side[$ x = 1 "(win)" $][ $x = 0 "(lose)" $]

The *probability* of winning 

$ P(x = 1) = 1 / 100 \
P(x = 0) = 99 / 100 $ #pause

But this does not consider how much money we will make if we win!

==
To represent how much money we can make, we use the *expectation* or *expected value*


==
We represent this information using the expectation
The *expectation* or *expected value* is how much money we expect to make #pause

