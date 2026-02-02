#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.4": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

// TODO: Students very slow, moving quickly and only finished first exercise after 1.5h
// TODO: Mario example too complex, just have them do the discounted return. Give them the four states in the return
// TODO: Mario should have zero reward for in-between states
// TODO: Terminal states should have zero reward
// TODO: Add terminated to episode

#set math.vec(delim: "[")
#set math.mat(delim: "[")

/* 
Following Brunskill's
1. Introduce expected return
2. Introduce bellman equation
3. Introduce value function
4. Use bellman equation with model
*/ 

#show: university-theme.with(
  config-common(handout: true),
  aspect-ratio: "16-9",
  config-info(
    title: [Decision Processes],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#let weather_mdp = diagram({
  node((0mm, 0mm), "Cloud", stroke: 0.1em, shape: "circle", width: 3em, name: "cloud")
  node((100mm, 0mm), "Sun", stroke: 0.1em, shape: "circle", width: 3em, name: "sun")
  node((50mm, -50mm), "Rain", stroke: 0.1em, shape: "circle", width: 3em, name: "rain")

  edge(label("cloud"), label("cloud"), "->", label: 0.4, bend: -130deg, loop-angle: -90deg)
  edge(label("sun"), label("sun"), "->", label: 0.4, bend: -130deg, loop-angle: -90deg)
  edge(label("rain"), label("rain"), "->", label: 0.3, bend: -130deg, loop-angle: 90deg)

  edge(label("cloud"), label("sun"), "->", label: 0.3, bend: 40deg)
  edge(label("sun"), label("cloud"), "->", label: 0.5, bend: 0deg)
  edge(label("cloud"), label("rain"), "->", label: 0.3, bend: -50deg)
  edge(label("sun"), label("rain"), "->", label: 0.1, bend: 50deg)
  edge(label("rain"), label("sun"), "->", label: 0.2, bend: 0deg)
  edge(label("rain"), label("cloud"), "->", label: 0.5, bend: 0deg)
})

#let driving_mdp = diagram({
  node((0mm, 0mm), "Drive", stroke: 0.1em, shape: "circle", width: 3em, name: "drive")
  node((100mm, 0mm), "Park", stroke: 0.1em, shape: "circle", width: 3em, name: "park")
  node((50mm, -50mm), "Crash", stroke: 0.1em, shape: "circle", width: 3em, name: "crash")

  edge(label("drive"), label("drive"), "->", label: 0.9, bend: -130deg, loop-angle: -90deg)
  edge(label("park"), label("park"), "->", label: 0.9, bend: -130deg, loop-angle: -90deg)
  edge(label("crash"), label("crash"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)

  edge(label("drive"), label("park"), "->", label: 0.09, bend: 30deg)
  edge(label("park"), label("drive"), "->", label: 0.09, bend: 30deg)
  edge(label("drive"), label("crash"), "->", label: 0.01, bend: -30deg)
  edge(label("park"), label("crash"), "->", label: 0.01, bend: 30deg)
})


#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)


= Review

= Admin
==
We will have the first exam in two weeks (9 Feb/二月九号) #pause
- Likely 4 questions #pause

Topics: #pause
- Probabilistic concepts (outcomes, events, expectations) #pause
- Bandits #pause
- Markov Decision Processes (today) #pause
- Trajectory optimization (next week) #pause

Early exam to ensure you understand these concepts before moving on! #pause
- Necessary to understand the rest of the course 

= Markov Processes

==
Decisions must make some change in the world #pause

If they make no change, decision making is trivial #pause
- Pick any choice, outcome does not matter #pause

*Markov processes* are the standard way to model the world #pause

Some things we can model using Markov processes: #pause
- Music #pause
- DNA sequences #pause
- Cryptography #pause
- History #pause
- Ecology

==
We can model almost anything as a Markov process #pause

So what is a Markov process? #pause
- Probabilistic model of dynamical systems that predicts the future #pause

A Markov process consists of two parts #pause

#side-by-side(align:center)[
  The *state space*

  $ S $ #pause

  Outcome space describing the state of our system #pause
][
  The *state transition function*

  $ Tr: S |-> Delta S $ #pause

  $ Tr(s_(t+1) | s_t) = Pr(s_(t+1) | s_t) \
  s_(t+1) tilde Tr(dot | s_t)

  $
] 

//Let us do an example to understand this 

==

#side-by-side[
  *Problem:* Predict the weather #pause

  $ S = {"rain", "cloud", "sun"} = {R, C, S} $ #pause
  
  $ 
  Tr(s_(t+1) | s_t) = Pr(s_(t+1) | s_t) \ #pause
= mat(
  Pr(C | C), Pr(R | C), Pr(S | C);
  Pr(C | R),  Pr(R | R), Pr(S | R);
  Pr(C | S), Pr(R | S), Pr(S | S);
) \ #pause
= mat(
  0.4, 0.3, 0.3;
  0.5, 0.3, 0.2;
  0.5, 0.1, 0.4
)
  $ #pause
][
  #weather_mdp
]

==
We can model many other systems as Markov processes #pause

#cimage("fig/03/finance-chain.png", height: 85%)
==

#cimage("fig/03/grad-chain.png", width: 100%)

==

Why is it called a *Markov* process? #pause


Markov property: The next state only depends on the current state #pause

$ Pr(s_(t+1) | s_(t)) = Pr(s_(t+1) | s_(t), s_(t-1), dots, s_0)  $ #pause

*This is a very important condition we must always satisfy* #pause

If we cannot satisfy it, then the process is *not* Markov #pause

$ Pr(s_2 = "sun" &| s_1="rain", s_0="sun") &&= 0.4 \ #pause


Pr(s_2 = "sun" &| s_1="rain" ) && = 0.3 #pause
$

  $0.3 != 0.4, Pr(s_(t+1) | s_(t)) != Pr, (s_(t+1) | s_(t), s_(t-1), dots, s_0)$,  *not* Markov

==

#side-by-side[
We can visualize the Markov property too #pause

To compute the next node, we only look at the current node #pause
][
  #weather_mdp
]

==
We can predict the future using Markov processes #pause
- Chain transition probabilities together to estimate $s_t$ #pause

$ Pr(s_1 | s_0 = s) $ #pause

$ Pr(s_2 | s_0 = s) = sum_(#pin(1)s_1 in S#pin(2)) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

#pinit-point-from((1,2), pin-dx: 0pt, offset-dx: 0pt)[Paths from all possible $s_1$ to $s_2$]
#v(2em) #pause

$ Pr(s_3 | s_0 = s) = sum_(s_2 in S) Pr(s_3 | s_2) sum_(s_1 in S) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

Can we derive a general form for $Pr(s_n | s_0)$? 

==
$ Pr(s_3 | s_0 = s) = sum_(s_2 in S) Pr(s_3 | s_2) sum_(s_1 in S) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

Product of sum is the sum of products#pause, move the sum outside

$ Pr(s_3 | s_0 = s) = sum_(s_2 in S) sum_(s_1 in S) Pr(s_3 | s_2)  Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

Combine the sums

$ Pr(s_3 | s_0 = s) = sum_(s_1, s_2 in S) Pr(s_3 | s_2) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $

==
$ Pr(s_3 | s_0 = s) = sum_(s_1, s_2 in S) Pr(s_3 | s_2) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

Combine the products

$ Pr(s_3 | s_0 = s) = sum_(s_1, s_2 in S) product_(t=0)^(2)  Pr(s_(t+1) | s_t) $ #pause

Generalize to any timestep $n$

$ Pr(s_n | s_0) = sum_(s_1, s_2, dots s_(n-1) in S) product_(t=0)^(n-1)  Pr(s_(t+1) | s_t) $

==
$ Pr(s_n | s_0) = sum_(s_1, s_2, dots s_(n-1) in S) product_(t=0)^(n-1)  Pr(s_(t+1) | s_t) $ #pause

If you do not like this sum notation, you can also write

$ Pr(s_n | s_0) = sum_(s_1 in S) sum_(s_2 in S) dots sum_(s_(n-1) in S) product_(t=0)^(n-1)  Pr(s_(t+1) | s_t) $ #pause

This expression tells us how the Markov process evolves over time #pause
- We can predict the future, $n$ timesteps from now #pause
- If $s$ is the state of the world, you can predict the future of the world #pause
- If $s$ represents someone's mind, you can predict their future thoughts 


==

We can predict a state $s_n$, but a Markov process never ends #pause
- The future infinite, there is always a next state #pause

However, many processes we like to model do end #pause
- Dying in a video game #pause
- Completing a task #pause
- Running out of money #pause

*Question:* How can we model a Markov process that ends? #pause

*Answer:* We create a *terminal state* that we can enter but cannot leave

==

#side-by-side[
  #driving_mdp #pause
][
Upon reaching a terminal state, we get stuck #pause

Once we crash our car, we cannot drive or park any more #pause

The only transition from a terminal state is back to itself

$ Pr(s_(t+1)="term" &| s_t="term") &&= 1 \
Pr(s_(t+1) = "not term" &| s_t = "term") &&= 0 $
]

= Exercise
==
Design an Markov process about a problem you care about #pause
- 3 states #pause
- State transition function $Tr = Pr(s_(t+1) | s_t)$ for all $s_t, s_(t+1) in S$ #pause
- Create a terminal state #pause
- Pick a non-terminal starting state $s_0=...$ #pause
- Given starting state $s_0=...$, find the state distribution for $s_2$? #pause
  - $Pr(s_2=... | s_0=...)$ #pause

$ Pr(s_n | s_0) = sum_(s_1, s_2, dots s_(n-1) in S) product_(t=0)^(n-1)  Pr(s_(t+1) | s_t) $ 

= Markov Control Processes
==

Markov processes model complex evolving processes #pause

*Question:* This course is decision making, how can we model decision making in a Markov process? #pause

*Answer:* We can't #pause

Markov processes follow the state transition function $Tr$ #pause
- The future state distribution of the system is already determined #pause
- There is no room for decisions to change the fate of the system #pause

We will modify the Markov process for decision making #pause

The point of decision making is to choose our fate #pause
- Control how the system evolves

// env agent first?

==
A Markov process models the predetermined evolution of some system #pause
- We call this system the *environment*, because we cannot control it #pause

The *agent* lives in the environment #pause
- The agent makes decisions #pause
- The agent changes the environment with its decisions 

==

The agent takes *actions* $a in A$ that change the environment #pause
- The action space $A$ defines what our agent can do #pause

#side-by-side(align: center)[
  Markov process
  $ (S, Tr) \
  Tr : S |-> Delta S $ #pause
][
  Markov control process
  $ (S, A, Tr) \
  Tr : S times A |-> Delta S $
] #pause

In a Markov process, the future follows a predefined evolution #pause

In a Markov control process, we can control the evolution! #pause

Let us see an example

==

#side-by-side[
  $ S = {"Healthy", "Sick", "Dead"} $ #pause
][
  $ A = {"Nothing", "Medicine"} = {N, M} $ #pause
]

#align(center, diagram({
  node((0mm, 0mm), "Healthy", stroke: 0.1em, shape: "circle", width: 3.5em, name: "drive")
  node((150mm, 0mm), "Sick", stroke: 0.1em, shape: "circle", width: 3.5em, name: "park", fill: orange)
  node((75mm, -20mm), "Dead", stroke: 0.1em, shape: "circle", width: 3.5em, name: "crash")

  edge(label("drive"), label("drive"), "->", label: 0.9, bend: -130deg, loop-angle: -90deg)
  edge(label("park"), label("park"), "->", label: text(fill:blue)[$N =0.91, M = 0.18$], bend: -130deg, loop-angle: -90deg, stroke: blue)
  edge(label("crash"), label("crash"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)

  edge(label("drive"), label("park"), "->", label: 0.09, bend: 40deg)
  edge(label("park"), label("drive"), "->", label: text(fill:green)[$N = 0.09, M =0.82$], bend: 0deg, stroke: green)
  edge(label("park"), label("crash"), "->", label: 0.01, bend: 15deg)
}))
/*
#diagram({
  node((0mm, 0mm), "Healthy", stroke: 0.1em, shape: "circle", width: 3.5em, name: "drive")
  node((100mm, 0mm), "Sick", stroke: 0.1em, shape: "circle", width: 3.5em, name: "park", fill: orange)
  node((50mm, -20mm), "Dead", stroke: 0.1em, shape: "circle", width: 3.5em, name: "crash")

  edge(label("drive"), label("drive"), "->", label: 0.9, bend: -130deg, loop-angle: -90deg)
  edge(label("park"), label("park"), "->", label: text(fill:orange)[Medicine 0.19], bend: -130deg, loop-angle: -90deg)
  edge(label("crash"), label("crash"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)

  edge(label("drive"), label("park"), "->", label: 0.09, bend: 40deg)
  edge(label("park"), label("drive"), "->", label: text(fill:orange)[Medicine 0.8], bend: 0deg)
  edge(label("park"), label("crash"), "->", label: 0.01, bend: 30deg)
})
*/

==

#side-by-side[
  #diagram({
  node((0mm, 0mm), "Healthy", stroke: 0.1em, shape: "circle", width: 3.5em, name: "drive")
  node((100mm, 0mm), "Sick", stroke: 0.1em, shape: "circle", width: 3.5em, name: "park")
  node((50mm, -50mm), "Dead", stroke: 0.1em, shape: "circle", width: 3.5em, name: "crash")

  edge(label("drive"), label("drive"), "->", bend: -130deg, loop-angle: -90deg)
  edge(label("park"), label("park"), "->", bend: -130deg, loop-angle: -90deg)
  edge(label("crash"), label("crash"), "->", bend: -130deg, loop-angle: 90deg)

  edge(label("drive"), label("park"), "->", bend: 40deg)
  edge(label("park"), label("drive"), "->", bend: 0deg)
  edge(label("park"), label("crash"), "->", bend: 30deg)
}) #pause

][
  The *trajectory* records the states and actions until a terminal state #pause

  $ bold(tau) = mat(
    s_0, a_0; 
    s_1, a_1;
    s_2, a_2;
    dots.v, dots.v;
    s_(n-1), a_(n-1);
    s_n, emptyset
  ) #pause =
  mat(
    "Healthy", "Nothing";
    "Sick", "Nothing";
    "Sick", "Medicine";
    dots.v, dots.v;
    "Sick", "Nothing";
    "Dead", emptyset 
  ) $ #pause

  If there is no terminal state, the trajectory can be infinitely long!
]

/*
==
$ bold(tau) = mat(
  s_0, a_0; 
  s_1, a_1;
  s_2, a_2;
  dots.v, dots.v;
  s_n, emptyset
) #pause
$

We can find the probability of any trajectory with actions $a_0 dots a_(n-1)$ #pause

$ Pr(bold(tau) | s_0, a_0, a_1, dots, a_n) = Pr(s_n | s_(n-1), a_(n-1)) dot dots dot Pr(s_1 | s_0, a_0) $ #pause

$ Pr(bold(tau) | s_0, a_0, a_1, dots, a_n) = product_(t=0)^n Pr(s_(t+1) | s_t, a_t) $
*/


==
Markov control processes let us control which states we visit #pause
- They do not tell us which states are good to visit, or provide a goal #pause

How can we make optimal decisions without a goal or objective? #pause
- We need a way to determine "good" and "bad" decisions

= Markov Decision Processes

==
Markov decision processes (MDPs) add a measure of "goodness" to Markov control processes #pause

We use a *reward function* $R$ to measure the how good a state is #pause

#side-by-side(align: center)[
  Sutton and Barto:
  $ R: S times A |-> bb(R) $ #pause
][
  Other books:
  $ R: S times A times S |-> bb(R) $ #pause
][
  This course:
  $ R: S |-> bb(R) $ #pause
]

You can always make these equivalent by modifying the MDP: #pause
$ S <- S times A = (s_t, a_(t-1)) $ #pause
$ S <- S times A times S = (s_t, a_(t-1), s_(t-1)) $ 


==
#side-by-side(align: center)[
  Markov process
  $ (S, Tr) \
  Tr : S |-> Delta S $ #pause
][
  Markov control process
  $ (S, A, Tr) \
  Tr : S times A |-> Delta S $ #pause
][
  Markov decision process
  $ (S, A, Tr, R, gamma) \
  Tr : S times A |-> Delta S \ 
  R: S |-> bb(R)
  $ 
] 

#side-by-side[
  In an MDP, an *episode* contains the trajectory and also the rewards #pause][
    $ bold(E) = mat(s_0, a_0, r_0; s_1, a_1, r_1; dots.v, dots.v, dots.v; s_(n-1), a_(n-1), r_(n-1); s_n, emptyset, emptyset) = 
    mat(bold(tau), bold(r)) $
  ]



==
Reward is good, we want to maximize the reward #pause

The reward function determines the agent behavior #pause

#side-by-side[$ s_d = "Dumpling" $][$ s_n = "Noodle" $] #pause

#side-by-side[$ R(s_d) = 10 $][$ R(s_n) = 15 $ #pause][*Result:* Eat noodle] #pause

#side-by-side[$ R(s_d) = 5 $][$ R(s_n) = -3 $ #pause][*Result:* Eat dumpling] #pause

We can write this mathematically as

$ argmax_(s in S) R(s) $



==
However, maximizing the reward is not always ideal #pause


#side-by-side[
  #cimage("fig/03/trap.jpg", width: 100%) #pause
][
#diagram({
  node((0mm, 0mm), "Walk", stroke: 0.1em, shape: "circle", width: 3.5em, name: "walk")
  node((50mm, 0mm), "Food", stroke: 0.1em, shape: "circle", width: 3.5em, name: "food")
  node((100mm, 0mm), "Trap", stroke: 0.1em, shape: "circle", width: 3.5em, name: "trap")

  node((0mm, 30mm), $R("walk") \ = 0$)
  node((50mm, 30mm), $R("food") \ = 3$)
  node((100mm, 30mm), $R("trap") \ = -5$)

  edge(label("trap"), label("trap"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)
  edge(label("walk"), label("walk"), "->", bend: -130deg, loop-angle: 90deg)

  edge(label("food"), label("walk"), "<-", bend: 0deg)
  edge(label("food"), label("trap"), "->", label: 1.0, bend: 0deg)
})
] #pause

#side-by-side[
$ argmax_(a in A) R(s) = "take the food" $ #pause
][
  If we maximize the reward, we are *too greedy*
]


==
Maximizing the immediate reward can result in bad agents #pause

Instead, we maximize the *cumulative sum* of rewards #pause
- We think about how our actions now will impact reward the future #pause
- We call the cumulative sum of rewards, the *return* #pause

#side-by-side[
  $ G: bb(R)^n |-> bb(R) $ #pause
][
  $ G: S^(n) times A^(n-1) |-> bb(R) $ #pause
]

#side-by-side[

  $ G(r_0, r_1, dots) = sum_(t=0)^oo r_t $ #pause
][

  $ G(bold(tau)) &= G(s_0, a_0, s_1, a_1, dots) \ &= sum_(t=0)^oo R(s_(t+1)) $ 
]


==
#side-by-side[
#diagram({
  node((0mm, -30mm), "Walk", stroke: 0.1em, shape: "circle", width: 3em, name: "walk")
  node((40mm, -30mm), "Food", stroke: 0.1em, shape: "circle", width: 3em, name: "food")
  node((80mm, -30mm), "Trap", stroke: 0.1em, shape: "circle", width: 3em, name: "trap")

  node((0mm, 0mm), $R("walk") \ = 0$)
  node((40mm, 0mm), $R("food") \ = 3$)
  node((80mm, 0mm), $R("trap") \ = -5$)

  edge(label("trap"), label("trap"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)
  edge(label("walk"), label("walk"), "->", bend: -130deg, loop-angle: 90deg)

  edge(label("food"), label("walk"), "<-", bend: 0deg)
  edge(label("food"), label("trap"), "->", label: 1.0, bend: 0deg)
}) 
][

]

  $
  G(bold(tau)_"greedy") = R("food") + R("trap") + R("trap") + dots &= 3 - 5 - 5 - dots &&= -oo \ #pause 
  
  G(bold(tau)_"smart") = R("walk") + R("walk") + R("walk") + dots &= 0 + 0 + dots &&= 0  
  $ #pause

  By considering the future rewards, we can make optimal decisions

==
Consider one more example #pause
#side-by-side[
#diagram({
  node((0mm, -30mm), "Walk", stroke: 0.1em, shape: "circle", width: 3em, name: "walk")
  node((40mm, -30mm), "Food", stroke: 0.1em, shape: "circle", width: 3em, name: "food")
  node((80mm, -30mm), "Sleep", stroke: 0.1em, shape: "circle", width: 3em, name: "trap")

  node((0mm, 0mm), $R("walk") \ = 0$)
  node((40mm, 0mm), $R("food") \ = 3$)
  node((80mm, 0mm), $R("sleep") \ = 0$)

  edge(label("trap"), label("trap"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)
  edge(label("walk"), label("walk"), "->", bend: -130deg, loop-angle: 90deg)

  edge(label("food"), label("walk"), "<-", bend: 0deg)
  edge(label("food"), label("trap"), "->", label: 1.0, bend: 0deg)
}) #pause
][
*Question:* What is the optimal sequence of states? #pause

]


$ & "Walk" + "Food" + "Sleep" + dots && = 0 + 3 + 0 + dots &&= 3 \ #pause
& "Walk" + "Walk" + dots + "Food" + "Sleep" + dots &&= 0 + 0 + dots + 3 + 0 + dots &&= 3 \
$

==
#side-by-side[The return is a sum][
$ G(bold(tau)) = sum_(t=0)^oo R(s_(t+1)) $
] #pause


We can eat food now, or in 1000 years, the return is the same #pause

*Question:* Is this how humans make decisions? #pause

*Answer:* No, humans are a little bit greedy #pause

*Experiment:* Place a cookie in front of a child. If they do not eat the cookie for 5 minutes, they get two cookies #pause

#side-by-side[
  *Question:* What happens? #pause
][
*Answer:* Child eats the cookie 
]

==
Timing matters, humans prefer reward sooner rather than later #pause

$ G(bold(tau)) = sum_(t=0)^oo R(s_(t+1)) $ #pause

*Question:* How can we modify the return to prefer rewards sooner? #pause

What if we make future rewards less important? #pause

#side-by-side(align: horizon)[
  $ R(s_(t+1)) = {1 | s_(t+1) in S} $ #pause
][
$ G(bold(tau)) &= sum_(t=0)^oo 1 &&= 1 + 1 + dots \ #pause

G(bold(tau)) &= quad ? &&= 1 + 0.9 + 0.8 + dots $ #pause
]


*Question:* How?


==

We can introduce a *discount* term $gamma in [0, 1]$ to the return #pause

$ G(bold(tau)) = sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause


#side-by-side(align: center)[
  With $gamma = 0$ #pause

  $ G(bold(tau)) = 1 + 1 + 1 + dots $ #pause
][
  With $gamma = 0.9$  #pause

  $ G(bold(tau)) &= (0.9^0 dot 1) + (0.9^1 dot 1) + (0.9^2 dot 1) + \ #pause 

  G(bold(tau)) &= 1 + 0.9 + 0.81 + dots $
]

We call this the *discounted return* #pause

The discounted return lets makes us prefer rewards sooner, like humans

==

For the rest of the course, we maximize the discounted return

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $ #pause

If our agent maximizes the discounted return, then it is *optimal*

==
Let us review #pause

*Definition:* A Markov decision process (MDP) is a tuple $(S, A, T, R, gamma)$ #pause
- $S$ is the state space #pause
- $A$ is the action space #pause
- $Tr: S times A |-> Delta S$ is the state transition function #pause
- $R: S |-> bb(R)$ is the reward function #pause
- $gamma in [0, 1]$ is the discount factor #pause

==
Reinforcement learning is designed to solve MDPs #pause

In reinforcement learning, we have a single goal #pause
- Visit states that maximize the discounted return of the MDP #pause

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $ #pause

You must understand the discounted return!

==
Understanding MDPs is the *most important part* of RL #pause

Existing software can train RL agents on your MDP #pause

You can train an RL agent without understanding RL #pause

You can only train an agent if you can model your problem as an MDP #pause

Make sure you understand MDPs!


= Exercise

==
#side-by-side[
  #cimage("fig/03/mario.jpeg", width: 100%)
][
  Design a Super Mario Bros MDP #pause
  - Reward function $R$ #pause
  - Discount factor $gamma$ #pause

  Your states are: eat mushroom, collect coins, die, game over #pause

  Compute discounted return for:  #pause
    - Eat mushroom at $t = 0$ #pause
    - Collect coin at $t = 1, 2$ #pause
    - Die to bowser at $t = 3$ #pause
    - Game over screen at $t=4...oo$

]



= Coding

== 
In this course, we will implement MDPs using *gymnasium* #pause

Originally developed by OpenAI for reinforcement learning #pause

Gymnasium provides an *environment* (MDP) API #pause

Must define: #pause
  - state space ($S$) #pause
  - action space ($A$) #pause
  - step ($Tr, R, "terminated"$) #pause
  - reset ($s_0$) #pause

https://gymnasium.farama.org/api/env/


==
Gymnasium uses *observations* instead of *states* #pause

*Question:* What was the Markov condition for MDPs? #pause

The next Markov state only depends on the current Markov state #pause

$ Pr(s_(t+1) | s_(t), s_(t-1), dots, s_1) = Pr(s_(t+1) | s_(t)) $ #pause

If the Markov property is broken, $s_t in S$ is not a Markov state #pause

Then, we change $s_t in S$ to an *observation* $o_t in O$ (more later) #pause

Gymnasium uses observations, but for MDPs we treat them as states

==
```python

import gymnasium as gym

class MyMDP(gym.Env):
  def __init__(self):
    self.action_space = gym.spaces.Discrete(3) # A
    self.observation_space = gym.spaces.Discrete(5) # S

  def reset(self, seed=None) -> Tuple[Observation, Dict]

  def step(self, action) -> Tuple[
    Observation, Reward, Terminated, Truncated, Dict
  ]
```


==
https://colab.research.google.com/drive/1rDNik5oRl27si8wdtMLE7Y41U5J2bx-I#scrollTo=9pOLI5OgKvoE