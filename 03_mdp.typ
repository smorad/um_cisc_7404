#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.4": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.4" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#show: university-theme.with(
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

= Markov Processes

==
Decisions must make some change in the world #pause

If they make no change, they do not matter, and are not decisions! #pause

Before we look at decision making, let us think about how we model change in the world #pause

*Markov processes* are a popular way to model the world #pause

Some things we can model using Markov processes: #pause
- Music #pause
- DNA sequences #pause
- Cryptography #pause
- History

==
We can model almost anything as a Markov process #pause

So what is a Markov process? #pause

It is a probabilistic model of dynamical systems, where the *future depends on the present* #pause

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
Of course, we can model many other systems as Markov processes #pause

#cimage("fig/03/finance-chain.png", height: 85%)
==

#cimage("fig/03/grad-chain.png", width: 100%)

==

Why is it called a *Markov* process? #pause

It follows the *Markov* property: #pause

The next state only depends on the current state #pause

$ Pr(s_(t+1) | s_(t)) = Pr(s_(t+1) | s_(t), s_(t-1), dots, s_0)  $ #pause

*This is a very important condition we must always satisfy* #pause

If we cannot satisfy it, then the process is *not* Markov #pause

#side-by-side[$ Pr("sun" | s_t="rain", s_(t-1)="sun") = 0.4 $ #pause][
$ 
Pr("sun" | s_t="rain" ) = 0.3
$
]

$0.3 != 0.4$, process is *not* Markov

==

#side-by-side[
We can visualize the Markov property too #pause

To compute the next node, we only look at the current node #pause
][
  #weather_mdp
]

==
Using the Markov property, we can chain state transitions together #pause

We can estimate the state distribution at a specific time #pause

$ Pr(s_1 | s_0 = s) $ #pause

$ Pr(s_2 | s_0 = s) = sum_(#pin(1)s_1 in S#pin(2)) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

#pinit-point-from((1,2), pin-dx: 0pt, offset-dx: 0pt)[Paths from all possible $s_1$ to $s_2$]
#v(2em) #pause

$ Pr(s_3 | s_0 = s) = sum_(s_2 in S) Pr(s_3 | s_2) sum_(s_1 in S) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $

==
$ Pr(s_3 | s_0 = s) = sum_(s_2 in S) Pr(s_3 | s_2) sum_(s_1 in S) Pr(s_2 | s_1)  Pr(s_1 | s_0 = s) $ #pause

Move the sums

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

This expression tells us how the Markov process evolves over time 




==

*Question:* When does a Markov process end? #pause

*Answer:* Technically, never. You transition between states forever #pause

However, many processes we like to model eventually end #pause
- Dying in a video game #pause
- Reaching your destination #pause
- Running out of money #pause

*Question:* How can we model a Markov process that ends? #pause

*Answer:* We create a *terminal state* that we cannot leave

==

#side-by-side[
  #driving_mdp #pause
][
Upon reaching a terminal state, we get stuck #pause

Once we crash our car, we cannot drive or park any more #pause

The only transition from a terminal state is back to itself

$ Pr(s_"terminal" | s_"terminal") = 1.0 $
]

= Exercise
==
Design an MDP about a problem you care about #pause
- 4 states #pause
- State transition function $Tr = Pr(s_(t+1) | s_t)$ for all $s_t, s_(t+1)$ #pause
- Create a terminal state #pause
- Given a starting state $s_0$, what will your state distribution be for $s_2$?

= Markov Control Processes
==

*Question:* How can we model decision making in a Markov process? #pause

*Answer:* We can't (yet) #pause

Markov processes follow the state transition function $Tr$, there are no decisions for us to make #pause

We will modify the Markov process for decision making

// env agent first?

==
A Markov process models the predetermined evolution of some system #pause

We call this system the *environment*, because we cannot control it #pause

For decisions to matter, they must change the environment #pause

We introduce the *agent* to make decisions that change the environment

==

The agent takes *actions* $a in A$ that change the environment #pause

The action space $A$ defines what our agent can do #pause

#side-by-side(align: center)[
  Markov process
  $ (S, T) \
  T : S |-> Delta S $ #pause
][
  Markov control process
  $ (S, A, T) \
  T : S times A |-> Delta S $
] #pause

In a Markov process, the future follows a predefined evolution #pause

In a Markov control process, we can control the evolution! #pause

Let us see an example

==

#side-by-side[
#diagram({
  node((0mm, 0mm), "Healthy", stroke: 0.1em, shape: "circle", width: 3.5em, name: "drive")
  node((100mm, 0mm), "Sick", stroke: 0.1em, shape: "circle", width: 3.5em, name: "park", fill: orange)
  node((50mm, -50mm), "Dead", stroke: 0.1em, shape: "circle", width: 3.5em, name: "crash")

  edge(label("drive"), label("drive"), "->", label: 0.9, bend: -130deg, loop-angle: -90deg)
  edge(label("park"), label("park"), "->", label: text(fill:orange)[Nothing 0.9], bend: -130deg, loop-angle: -90deg)
  edge(label("crash"), label("crash"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)

  edge(label("drive"), label("park"), "->", label: 0.09, bend: 40deg)
  edge(label("park"), label("drive"), "->", label: text(fill:orange)[Nothing 0.09], bend: 0deg)
  edge(label("park"), label("crash"), "->", label: 0.01, bend: 30deg)
})
][
#diagram({
  node((0mm, 0mm), "Healthy", stroke: 0.1em, shape: "circle", width: 3.5em, name: "drive")
  node((100mm, 0mm), "Sick", stroke: 0.1em, shape: "circle", width: 3.5em, name: "park", fill: orange)
  node((50mm, -50mm), "Dead", stroke: 0.1em, shape: "circle", width: 3.5em, name: "crash")

  edge(label("drive"), label("drive"), "->", label: 0.9, bend: -130deg, loop-angle: -90deg)
  edge(label("park"), label("park"), "->", label: text(fill:orange)[Medicine 0.19], bend: -130deg, loop-angle: -90deg)
  edge(label("crash"), label("crash"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)

  edge(label("drive"), label("park"), "->", label: 0.09, bend: 40deg)
  edge(label("park"), label("drive"), "->", label: text(fill:orange)[Medicine 0.8], bend: 0deg)
  edge(label("park"), label("crash"), "->", label: 0.01, bend: 30deg)
})
]

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
  The *trajectory* contains the states and actions until a terminal state #pause

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
    "Dead", "Nothing";
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

They do not tell us which states are good to visit #pause

How can we make optimal decisions if we cannot tell how good a decision is? #pause

We need something to tell us how good it is to be in a state!

= Markov Decision Processes

==
Markov decision processes (MDPs) add a measure of "goodness" to Markov control processes #pause

We use a *reward function* $R$ to measure the goodness of being in a specific state #pause

#side-by-side(align: center)[
  Sutton and Barto:
  $ R: S times A |-> bb(R) $ #pause
][
  Other books:
  $ R: S times A times S |-> bb(R) $ #pause
][
  This course:
  $ R: S |-> bb(R) $ 
]

For now, I will use the simplest one #pause

You can always make these equivalent by modifying the MDP


==
#side-by-side(align: center)[
  Markov process
  $ (S, T) \
  T : S |-> Delta S $ #pause
][
  Markov control process
  $ (S, A, T) \
  T : S times A |-> Delta S $ #pause
][
  Markov decision process
  $ (S, A, T, R, gamma) \
  T : S times A |-> Delta S \ 
  R: S |-> bb(R)
  $ 
] 


==
An *episode* contains the states, actions, and rewards until termination #pause

$ bold(E) = mat(s_0, a_0, r_0; s_1, a_1, r_1; dots.v, dots.v, dots.v; s_(n-1), a_(n-1), r_(n-1); s_n, emptyset, emptyset) = 
mat(bold(tau), bold(r))
$


==
We want to maximize the reward #pause

The reward function determines the agent behavior #pause

#side-by-side[$ s_d = "Dumpling" $][$ s_n = "Noodle" $] #pause

#side-by-side[$ R(s_d) = 10 $][$ R(s_n) = 15 $ #pause][*Result:* Eat noodle] #pause

#side-by-side[$ R(s_d) = 5 $][$ R(s_n) = -3 $ #pause][*Result:* Eat dumpling] #pause

//We can pick the action that maximizes the reward function #pause

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
  node((100mm, 30mm), $R("trap") \ = -1$)

  edge(label("trap"), label("trap"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)
  edge(label("walk"), label("walk"), "->", bend: -130deg, loop-angle: 90deg)

  edge(label("food"), label("walk"), "<-", bend: 0deg)
  edge(label("food"), label("trap"), "->", label: 1.0, bend: 0deg)
})
] #pause

$ argmax_(s in S) R(s)  #pause = "food" $

==
Maximizing the immediate reward can result in bad agents #pause

Instead, we maximize the *cumulative sum* of rewards #pause

We call this this cumulative sum the *return* 

#side-by-side[
  $ G: bb(R)^n |-> bb(R) $ #pause

  $ G(r_0, r_1, dots) = sum_(t=0)^oo r_t $ #pause
][
  $ G: S^(n) times A^(n-1) |-> bb(R) $ #pause

  $ G(bold(tau)) &= G(s_0, a_0, s_1, a_1, dots) \ &= sum_(t=0)^oo R(s_(t+1)) $ #pause
]


==
#side-by-side[
#diagram({
  node((0mm, -30mm), "Walk", stroke: 0.1em, shape: "circle", width: 3em, name: "walk")
  node((40mm, -30mm), "Food", stroke: 0.1em, shape: "circle", width: 3em, name: "food")
  node((80mm, -30mm), "Trap", stroke: 0.1em, shape: "circle", width: 3em, name: "trap")

  node((0mm, 0mm), $R("walk") \ = 0$)
  node((40mm, 0mm), $R("food") \ = 3$)
  node((80mm, 0mm), $R("trap") \ = -1$)

  edge(label("trap"), label("trap"), "->", label: 1.0, bend: -130deg, loop-angle: 90deg)
  edge(label("walk"), label("walk"), "->", bend: -130deg, loop-angle: 90deg)

  edge(label("food"), label("walk"), "<-", bend: 0deg)
  edge(label("food"), label("trap"), "->", label: 1.0, bend: 0deg)
}) 
][

]

  $ R("walk") + R("walk") + R("walk") + dots &= 0 + 0 + dots &&= 0 \ #pause

   R("food") + R("trap") + R("trap") + dots &= 3 - 1 - 1 - dots &&= -oo $ #pause

  Now, we make better decisions!

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


If you swap the terms $s_1$ and $s_1000$, the sum is the same #pause

We can eat food now, or in 1000 years, the return is the same #pause

*Experiment:* Place a cookie in front of a child. If they do not eat the cookie for 5 minutes, they get two cookies #pause

*Question:* What does the child do? #pause

*Answer:* The child eats the cookie immediately #pause

Order matters, humans prefer reward sooner rather than later 


==
$ G(bold(tau)) = sum_(t=0)^oo R(s_(t+1)) $

*Question:* How can we fix the return to prefer rewards sooner? #pause

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
  With $gamma = 1$ #pause

  $ G(bold(tau)) = 1 + 1 + 1 + dots $ #pause
][
  With $gamma = 0.9$  #pause

  $ G(bold(tau)) &= (0.9^0 dot 1) + (0.9^1 dot 1) + (0.9^2 dot 1) + \ #pause 

  G(bold(tau)) &= 1 + 0.9 + 0.81 + dots $
]


==
#side-by-side(align: center)[
  Without $gamma$

  $ G(bold(tau)) = 1 + 1 + 1 + dots $ 
][
  With $gamma$

  $ G(bold(tau)) &= (0.9^0 dot 1) + (0.9^1 dot 1) + (0.9^2 dot 1) + \ 
  G(bold(tau)) &= 1 + 0.9 + 0.81 + dots $
]

We call this the *discounted return* #pause

The discounted return lets makes us prefer rewards sooner, like humans #pause

For the rest of the course, we maximize the discounted return

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $

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

Maximize the discounted return of the MDP #pause

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $

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
  - State space $S$ #pause
  - Action space $A$ #pause
  - State transition function $Tr$ #pause
  - Reward function $R$ #pause
  - Discount factor $gamma$ #pause

  Compute discounted return for:  #pause
    - Eat mushroom at $t = 10$ #pause
    - Collect coins at $t = 11, 12$ #pause
    - Die to bowser at $t = 20$

]



= Coding

== 
In this course, we will implemented MDPs using *gymnasium* #pause

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

MyMDP(gym.Env):
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

= Exam Next Class

==
We will have an exam next week #pause

1 hour 15 minutes, no coding, only math #pause

No book, no notes, no calculator -- only pencil and pen #pause

Study notation, probability, bandits, and Markov processes #pause

Practice expectations, bandit problems, state transitions, and returns #pause

You must have intuition, not memorize #pause

Too many A's last term, exam will be *difficult*




/*
==
A Markov process consists of $(S, T)$ #pause

A Markov control process also considers an *action* $a in A$

$ (S, T, A) $ #pause

We call $A$ the *action space* #pause

The action space defines the options/decisions we can make

==
Add action term


= Markov Decision Processes


= Agents and Environments
// Environment is the Markov process
// Agent moves us in the Markov process

==

Multiarmed bandits is one type of decision making problem #pause

But it is a very specific type of problem #pause

In some ways, it is too simple to represent more interesting tasks #pause

Today, we will create a much more general framework for decision making problems #pause

This framework is used in imitation learning, reinforcement learning, model predictive control, and almost all modern decision making methods #pause

==
First, we should define some terms #pause

We will start with the *agent* and the *environment* #pause

Let us look at an example of reinforcement learning #pause

https://www.youtube.com/watch?v=kVmp0uGtShk #pause

https://www.youtube.com/watch?v=QyJGXc9WeNo

==
In this task, we want to solve a Rubik's cube #pause

We need to define what we can control, and we what cannot control #pause

We can control the *agent* #pause

We cannot directly control the *environment*

==
#side-by-side[
  #cimage("fig/03/cube.jpg", height: 70%)
][
  *Question:* What is the agent? #pause

  *Answer:* The robot hand 
]

==
#side-by-side[
  #cimage("fig/03/cube.jpg", height: 70%)
][
  *Question:* What is the environment? #pause

  *Answer:* #pause
  - Rubik's cube #pause
  - Giraffe #pause
  - Gravity #pause
  - Friction #pause
  - And much more...
]

==
The agent lives within the environment #pause

The agent decisions affect and change the environment #pause

To solve a decision making problem, we must define the agent and environment #pause

*Question:* Other examples of problem, agent, and environment? #pause
- Drive to store; car; streets, pedestrians, etc #pause
- Play ping pong; human; racket, table, ball, etc #pause
- Play video games; main character; NPCs, enemies, etc

==
Markov Chains


==
Let us look at another problem #pause

#side-by-side[
  #cimage("fig/03/pacman.jpg", height: 85%) #pause
][
  We move PacMan to eat the dots and avoid the ghosts #pause

  *Question:* What is the agent? #pause 

  *Answer:* PacMan #pause

  *Question:* What is the environment? #pause

  *Answer:* Ghosts, dots, walls, fruits, ... 
]
==

#side-by-side[
  #cimage("fig/03/pacman.jpg", height: 85%) #pause
][
  Let us define a *decision process* for PacMan #pause

  *Definition:* A decision process is a tuple

  $ {S, O, A, R, T, gamma} $ #pause

  We will define each of these terms
]






==
In decision making, the agent selects one of many options #pause

*Question:* What can our agent do? What options does it have? #pause

*Answer:* ${arrow.t, arrow.b, arrow.l, arrow.r}$ #pause

We call this the *action space* $A$ #pause

$ A = {arrow.t, arrow.b, arrow.l, arrow.r} $ #pause

The agent can take one action $a$ at a time

$ a in A $

==


==
In almost all modern decision making processes, we have an *agent* and *environment* #pause

The agent operates within the environment #pause

Any questions so far? #pause

==
Let us go deeper #pause

The agent operates in the environment #pause

Let us define what the agent can *see* and *do*

The agent can *observe* the environment #pause

The agent can *act* to change the environment

==

#side-by-side[
  #cimage("fig/03/cube.jpg", height: 70%)
][
  *Question:* What could we observe? #pause

  *Answer:* #pause
  - The color of each tile on the Rubik's cube #pause
  - The position of our fingers #pause
  - Position of the giraffe #pause
]

==

#side-by-side[
  #cimage("fig/03/cube.jpg", height: 70%)
][
  *Question:* How could we act? #pause

  *Answer:* #pause
  - The color of each tile on the Rubik's cube #pause
  - The position of our fingers #pause
  - Position of the giraffe #pause
]


==
// Agents and environment
First, what does it mean to make a decision? #pause

We need a name for the thing that makes decisions #pause

We call this the *agent* #pause

==

Decisions only matter if they create change #pause

We need a way to represent the world and change in the world #pause

We call this the environment


==
First, let us formalize the multi-armed bandit problem #pause

*Question:* Any ideas on how we can do this? #pause

Let us start with some quantities we use in bandits #pause

$ r, a $




= Gymnasium

==
There are two interfaces we use to implement decision processes: #pause
- Gymnasium (OpenAI) #pause
- DMEnv (DeepMind) #pause

Gymnasium is more popular so we will focus on it

==
*/