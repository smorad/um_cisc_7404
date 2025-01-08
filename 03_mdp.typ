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
    title: [Decision Processes],
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

==
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

= Agents and Environments

==

Multiarmed bandits is one type of decision making problem #pause

But it is a very specific type of problem #pause

In some ways, it is too simple to represent more interesting tasks #pause

Today, we will create a much more general framework for decision making problems #pause

This framework is used in imitation learning, reinforcement learning, model predictive control, and almost all modern decision making methods #pause

==
To define the problem framework, let us start with an example problem #pause

Maybe by thinking about this example problem we can figure out how to structure the problem #pause

https://www.youtube.com/watch?v=kVmp0uGtShk #pause

https://www.youtube.com/watch?v=QyJGXc9WeNo

==
*Problem:* We want to solve a Rubik's cube #pause

Start with a shuffled cube #pause

We want to end with a finished cube #pause

How can we formally define this problem? #pause

==
First, let us define some terms #pause

We should have a name for "us" #pause

We need a name for the thing that we control #pause

The thing that makes decisions and interacts with the world #pause

We call this the *agent*

==
#side-by-side[
  #cimage("fig/03/cube.jpg", height: 70%)
][
  *Question:* What is the agent? #pause

  *Answer:* The robot hand 
]

==
We have defined the *agent* #pause

Now we need a name for everything else we do not control #pause

We call this the environment 

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
In decision making, the agent changes the environment #pause



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

  $ {S, O, A, R, T, gamma,} $ #pause

  We will define 
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