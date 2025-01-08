#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.4": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.1"

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#show: university-theme.with(
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

// TOOD: Replace bandits with overview of RL vs ML vs IL etc

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

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
Capital letters will often refer to *sets* #pause

$ X = {1, 2, 3, 4} $ #pause

We will represent important sets with blackboard font

#side-by-side[$ bb(R) $][Set of all real numbers ${1, 2.03, pi, dots}$]
#side-by-side[$ bb(Z) $][Set of all integers ${-2, -1, 0, 1, 2, dots}$]
#side-by-side[$ bb(Z)_+ $][Set of all *positive* integers ${1, 2, dots}$]

==
The $max$ operator returns the maximum of a function over its domain #pause

$ max_x f(x) $

The $argmax$ operator returns the input that maximizes a function

$ argmax_x f(x) $ #pause



==
Let's quiz you on some notation #pause

#side-by-side[
$ f(x) = -(x + 1)^2 $ #pause
][
    #align(center)[
        #canvas(length: 1cm, {
        plot.plot(size: (8, 6),
            x-tick-step: 1,
            y-tick-step: 1,
            y-min: -2,
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
#side-by-side[$ max_x f(x) $ #pause][$ argmax_x f(x) $]



==
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
    The simplest form of decision making problem is the *bandit* #pause

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

$ Pr(cal(X) = x) = {underbrace(omega, "Outcome") in underbrace(Omega, "Outcomes") mid(|) underbrace(cal(X)(omega), "Outcome to real") = underbrace(x, "Real")} $ #pause

#side-by-side[$ cal(X): {"lose", "win"} |-> {-10, 1000} $ #pause][$ cal(X)("lose") = -10; quad cal(X)("win") = 1000 $]

//#side-by-side[$ Pr(cal(X) = x) $][Probability of outcome $x$ occuring] #pause

$ Pr(cal(X) = x) = vec(Pr(cal(X) = -10), Pr(cal(X) = 1000)) = #pause vec(199 / 200, 1 / 200) = vec(0.995, 0.005) $ #pause

== 
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

$ bb(E)[cal(X)] = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ 


==
$ cal(X)("lose") = -10; quad cal(X)("win") = 1000 $ #pause 
$ P(cal(X) = -10) = 199 / 200; quad P(cal(X) = 1000) = 1 / 200 $ #pause
$ bb(E)[cal(X)] = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ #pause

*Question:* What is the expected value of the bandit? #pause

$ cal(X)("lose") dot P(cal(X) = -10) + cal(X)("win") dot P(cal(X) = 1000) $ #pause

$ -10 dot 199 / 200 + 1000 dot 1 / 200 = -4.95 $

==
*Question:* What does $bb(E)[cal(X)] = -4.95$ mean? #pause

Expect to lose 4.95 MOP on average each time you spin the bandit #pause


We call the value after each spin the *reward* #pause

$ 
  r_1 = -10 \
  r_2 = -10 \ 
  dots.v \
  r_n = -10
$ #pause

==

$ 
  r_1 = -10 \
  r_2 = -10 \ 
  dots.v \
  r_n = -10
$ #pause

As we play the game more and more, we converge to the expectation

$ lim_(n -> oo) sum_(t=1)^n r_t = -4.95 n = n bb(E)[cal(X)] $


==
$ lim_(n -> oo) sum_(t=1)^n r_t = -4.95 n = n bb(E)[cal(X)] $ #pause


If you spin 1,000 times, you should expect to lose -4950 MOP #pause

*Question:* What is the best way to make money with the bandit? #pause

*Answer:* Do not play! If you must, play as little as possible

==

If you know $bb(E)[cal(X)]$, you know the result of gambling #pause

*Question:* Do gamblers know $bb(E)[cal(X)]$? #pause

*Answer:* No! This is a secret of the casino #pause

*Question:* How could a gambler find out $bb(E)[cal(X)]$?

==
*Question:* How could a gambler find out $bb(E)[cal(X)]$?

Gambler only has access to the rewards

$ r_1, r_2, dots, r_n = -10, -10, dots, 1000 $ #pause

// $ lim_(n -> oo) sum_(t=1)^n r_t = -4.95 n = n bb(E)[cal(X)] $ #pause

#side-by-side[
  We can sum the rewards
  ][
    $ sum_(t=1)^n r_t approx n bb(E)[cal(X)] $
  ] #pause

#side-by-side[Divide by number of plays][
  $ 1 / n sum_(t=1)^n r_t approx bb(E)[cal(X)] $
] #pause

After playing enough, the gambler can approximate the expectation!

==

*Exercise*: You start a new casino in Macau. #pause Create a bandit with the following outcomes $Omega in {"Win Lemon", "Win Cherry", "Win BAR", "Lose"}$ #pause

Write down: #pause
- Probability for each outcome $P(omega); quad forall omega in Omega$ #pause
- The random variable for each outcome $cal(X)(omega); quad forall omega in Omega$ #pause
- The expected value $bb(E)[cal(X)]$ #pause
- How much money the gambler loses after 1000 plays #pause

Make sure the expected value is *negative but near zero*: #pause
- Negative: The player loses money and you win money #pause
- Near zero: The player wins sometimes and will continue to play #pause





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

If $bb(E)[cal(X)] > 0$ you should gamble #pause

If $bb(E)[cal(X)] < 0$ you should not gamble

We will consider a more interesting problem




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

You are the bandit! #pause 

You like a specific type of video, but YouTube does not know what it is #pause

YouTube tries to find your favorite video category

==
*Problem:* We have $k$ bandits, and each bandit is a random variable

$ cal(X)_1, cal(X)_2, dots, cal(X)_k $ #pause

We do not know $bb(E)[cal(X)_1], bb(E)[cal(X)_2], dots, bb(E)[cal(X)_k]$ #pause

You can take an *action* by pulling the arm of each bandit

$ a in {1, 2, dots, k} $ #pause

Which actions should you take to make the most money? #pause

*Question:* How should we approach this problem?

==

This is a hard problem! #pause

We need to estimate $bb(E)[cal(X)_1], bb(E)[cal(X)_2], dots, bb(E)[cal(X)_k]$ #pause

But we do not have enough money to perfectly estimate all $k$ bandits #pause

We must be careful in how we choose $a in 1 dots k$ #pause

We want to: #pause
- #side-by-side[Pick $a$ to approximate bandits][$ bb(E)[cal(X)_a | a in 1 dots k] $] #pause
- #side-by-side[Pick $a$ to make the most money][$ argmax_(a in 1 dots k) bb(E)[cal(X)_a] $] 

==
We have names for each goal #pause

#side-by-side(align: center)[
    *Exploration:* 
    $ bb(E)[cal(X)_a | a in 1 dots k] $ #pause

    Explore our options to improve our estimate of each expectation #pause
][
    *Exploitation:*
    $ argmax_(a in 1 dots k) bb(E)[cal(X)_a] $ #pause

    Use our estimates to make money

] #pause

It is important you understand this! Any questions? 


==
*Question:* How can we choose $a$ to achieve each goal? #pause

#side-by-side(align: center)[
    *Exploration:* 
    $ bb(E)[cal(X)_a | a in 1 dots k] $ 

    Explore our options to improve our estimate of each expectation 
][
    *Exploitation:*
    $ argmax_(a in 1 dots k) bb(E)[cal(X)_a] $ 

    Use our estimates to make money

] #pause


#side-by-side[
    $ a tilde "uniform"({1 dots k}) $ #pause
][
    $ a = argmax(bb(E)[cal(X)_a]) $ #pause
] 

*Question:* How can we achieve both goals at once? #pause

*Answer:* Sometimes choose $a$ to explore, sometimes choose $a$ to exploit

==
$ 
    u tilde "uniform"([0, 1]) \
    "if" u < 0.5 "then" a tilde "uniform"({1 dots k}) \
    "if" u >= 0.5 "then" a = argmax(bb(E)[cal(X)_a])
$ #pause

Half the time we explore, half the time we exploit #pause

We can change the explore/exploit ratio using a parameter $epsilon$ #pause

$ 
    u tilde "uniform"([0, 1]) \
    "if" u < epsilon "then" a tilde "uniform"({1 dots k}) \
    "if" u >= epsilon "then" a = argmax(bb(E)[cal(X)_a])
$ #pause

==

$ 
    epsilon in [0, 1] \
    u tilde "uniform"([0, 1]) \
    "if" u < epsilon "then" a tilde "uniform"({1 dots k}) \
    "if" u >= epsilon "then" a = argmax(bb(E)[cal(X)_a])
$ #pause

We call this *epsilon greedy* because we are greedy with proportion $epsilon$ #pause

*Question:* When should $epsilon approx 1$? When should $epsilon approx 0$? #pause

*Answer:* 
- $epsilon approx 1$ when we trust our estimates $bb(E)[cal(X)]$ 
- $epsilon approx 0$ when we do not trust our estimates

==
*Question:* Do we use epsilon greedy in medicine? #pause

*Answer:* Yes! #pause
- Usually give patients drug A that we know works (exploit) #pause
- Sometimes test new drug B on patients (explore) #pause

*Question:* Does TikTok or BiliBili use epsilon greedy? #pause

*Answer:* Yes! #pause
- If you watch dog videos, it usually suggests more dog videos #pause
- Sometimes it suggests study videos

==
Let us code some multiarmed bandits! #pause

