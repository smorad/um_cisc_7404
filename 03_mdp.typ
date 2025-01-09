#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.4": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.4" as fletcher: diagram, node, edge

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

// TODO: Terminal states

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

==
Markov chains

How should we structure decision making problems?

Recall MAB bandit

Agent/environment interface

Chess bot example

Why is chess not MAB bandits?

Sequential decision making

Agent makes decisions/moves pieces

Env is set of rules

Input/output function

Gymnasium

= Review

==

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

It is a probabilistic model of dynamical systems, where the *future depends on the past* #pause

A Markov process consists of two parts #pause

#side-by-side(align:center)[
  The *state space*

  $ S $ #pause
][
  The *state transition function*

  $ T: S |-> Delta S $ #pause

  $ Pr(s' | s) $
] #pause

Let us do an example to understand this 

==

/*
#side-by-side[
  *Problem:* Predict the weather #pause
][
$ S = {"rain", "clouds", "sun"} $ #pause
] 

#cimage("fig/03/chain.png", height: 85%)

==
*/
#side-by-side[
  *Problem:* Predict the weather #pause

  $ S = {"rain", "cloud", "sun"} = {R, C, S} $ #pause
  
  $ 
  mat(
    Pr(C | C), Pr(R | C), Pr(S | C);
    Pr(C | R), Pr(R | R), Pr(S | R);
    Pr(C | S), Pr(R | S), Pr(S | S);
  ) \
  = mat(
    0.4, 0.3, 0.3;
    0.5, 0.3, 0.2;
    0.5, 0.1, 0.4
  )
  $ #pause
][
#diagram({
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
]

==
Of course, we can model many other systems as Markov processes #pause

#cimage("fig/03/finance-chain.png", height: 85%)
==

#cimage("fig/03/grad-chain.png", width: 100%)

==

Why is it called a *Markov* process? #pause

It follows the *Markov* property:

The next state only depends on the previous state #pause

$ Pr(s_t | s_(t-1), s_(t-2), dots, s_1) = Pr(s_t | s_(t-1)) $ #pause

*This is a very important condition we must always satisfy* #pause

If we cannot satisfy it, then the process is *not* Markov

==

*Question:* When does a Markov process end? #pause

*Answer:* Technically, they never end. You are always in a specific state #pause

However, many processes we like to model eventually end #pause
- Dying in a video game #pause
- Winning a video game #pause
- Running out of money #pause

*Question:* How can we model this? #pause

*Answer:* We create a *terminal state* that we cannot leave

==

#side-by-side[
#diagram({
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
][

  
Upon reaching a terminal state, we get stuck #pause

Once we crash our car, we cannot drive or park any more #pause

The only transition from a terminal state is back to itself

$ Pr(s' = s_"terminal" | s = s_"terminal") = 1.0 $
]

==

*Question:* How can we model decision making in a Markov process? #pause

*Answer:* We can't (yet) #pause

Markov processes follow the state transition function $T$, there are no decisions for us to make #pause

We will modify the Markov process for decision making

= Markov Control Processes
// env agent first?

==
A Markov process models the predetermined evolution of some system #pause

We call this system the *environment*, because we cannot control it #pause

To make decisions, we introduce an *agent* #pause

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

Let us see an example

==




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