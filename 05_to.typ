#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

// TODO: Move policy conditioned return and MCTS from lecture 6 into this lecture

// TODO: Should always factorize into P(s_n | s_0, a_0, ...) and R(s_n)
// much easier for students and less writing (also done in future lectures)
// TODO: Rename policy as pi (not theta_pi)
// Later, just introduce pi_theta as needed, say pi_theta = (pi, theta)
// Important for Q learning to depend on policy
// Because often we don't have parameters for max Q


/*
TODO: Equations are confusing

Rewrite as two parts, ie

$ Pr (s_(n+1) | s_0; pi, theta_pi) = sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) $

$ 
bb(E)[cal(G)(bold(tau)) | s_0; pi, theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr(s_(n + 1) | s_n, a_n)
$
*/


#let traj_opt_mdp = diagram({

    node((-30mm, 0mm), $s_a$, stroke: 0.1em, shape: "circle", name: "si", width: 3em)
    node((30mm, 0mm), $s_b$, stroke: 0.1em, shape: "circle", name: "sj", width: 3em)

    node((-30mm, -6em), $cal(R)(s_a) = 0$)
    node((30mm, -6em), $cal(R)(s_b) = 1$)

    edge(label("si"), label("si"), "->", bend: -130deg, loop-angle: 270deg)
    edge(label("sj"), label("sj"), "->", bend: -130deg, loop-angle: 270deg)

    edge(label("si"), label("sj"), "->", bend: 30deg, )
    edge(label("sj"), label("si"), "->", bend: 30deg)
})

#let traj_opt_tree = diagram({
  node((0mm, 0mm), $s_a$, stroke: 0.1em, shape: "circle", name: "root")

  node((-75mm, -25mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ai")
  node((75mm, -25mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aj")

  node((-100mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0aisi")
  node((-50mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0aisj")

  node((50mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsi")
  node((100mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0ajsj")

  node((-75mm, -75mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0aisjai")
  node((-25mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aisjaj")

  node((75mm, -75mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ajsjai")
  node((125mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0ajsjaj")

  node((-100mm, -75mm), $dots$)
  node((25mm, -75mm), $dots$)

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)
  node((-125mm, -100mm), $t=2$)
  node((-125mm, -125mm), $dots.v$)


  edge(label("root"), label("0ai"), "->")
  edge(label("root"), label("0aj"), "->")

  edge(label("0ai"), label("0aisi"), "->", label: $Tr(s_a | s_a, a_a)$, )
  edge(label("0ai"), label("0aisj"), "->", label: $Tr(s_b | s_a, a_a)$, )

  edge(label("0aj"), label("0ajsi"), "->", label: $Tr(s_a | s_a, a_b)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $Tr(s_b | s_a, a_b)$)

  edge(label("0aisj"), label("0aisjaj"), "->")
  edge(label("0aisj"), label("0aisjai"), "->")

  edge(label("0ajsj"), label("0ajsjaj"), "->")
  edge(label("0ajsj"), label("0ajsjai"), "->")
})

#let traj_opt_tree_red = diagram({
  node((0mm, 0mm), $s_a$, stroke: (paint: red, thickness: 0.1em), shape: "circle", name: "root")

  node((-75mm, -25mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ai")
  node((75mm, -25mm), $a_b$, stroke: (paint: red, thickness: 0.1em), shape: "circle", name: "0aj")

  node((-100mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0aisi")
  node((-50mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0aisj")

  node((50mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsi")
  node((100mm, -50mm), $s_b$, stroke: (paint: red, thickness: 0.1em), shape: "circle", name: "0ajsj")

  node((-75mm, -75mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0aisjai")
  node((-25mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aisjaj")

  node((75mm, -75mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ajsjai")
  node((125mm, -75mm), $a_b$, stroke: (paint: red, thickness: 0.1em), shape: "circle", name: "0ajsjaj")

  node((100mm, -100mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsjajsi")
  node((125mm, -100mm), $s_b$, stroke: (paint: red, thickness: 0.1em), shape: "circle", name: "0ajsjajsj")


  node((-100mm, -75mm), $dots$)
  node((25mm, -75mm), $dots$)

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)
  node((-125mm, -100mm), $t=2$)
  node((-125mm, -125mm), $dots.v$)


  edge(label("root"), label("0ai"), "->")
  edge(label("root"), label("0aj"), "->", stroke: red)

  edge(label("0ai"), label("0aisi"), "->", label: $Tr(s_a | s_a, a_a)$, )
  edge(label("0ai"), label("0aisj"), "->", label: $Tr(s_b | s_a, a_a)$, )

  edge(label("0aj"), label("0ajsi"), "->", label: $Tr(s_a | s_a, a_b)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $Tr(s_b | s_a, a_b)$, stroke: red)

  edge(label("0aisj"), label("0aisjaj"), "->")
  edge(label("0aisj"), label("0aisjai"), "->")

  edge(label("0ajsj"), label("0ajsjaj"), "->", stroke: red)
  edge(label("0ajsj"), label("0ajsjai"), "->")

  edge(label("0ajsjaj"), label("0ajsjajsj"), "->", stroke: red)
  edge(label("0ajsjaj"), label("0ajsjajsi"), "->")
})


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Algorithms],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  //config-common(handout: true),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Admin

==
Exam next lecture #pause
- 4 questions total #pause
- 1 question expected values #pause
- 1 question bandits #pause
- 1 question discounted return #pause
- 1 question Markov process

You have the entire lecture period for the exam #pause

Questions written in both simplified Chinese and English

= Review

==
Finish coding


= Algorithms

==
Our goal is to maximize the discounted return #pause
- All we can control is our actions #pause
- Select actions that maximize the discounted return #pause

We introduce a *policy* to select actions #pause

$ pi: S |-> Delta A $ #pause

The policy is the "brain" of the agent #pause
- It tells the agent what to do #pause
- It makes all the decisions #pause

We use *algorithms* to find a policy

==

Policies can be good, bad, or even human! #pause

#cimage("fig/05/policy-car.jpeg")


==

We use *algorithms* to find good policies #pause

*Question:* What makes a policy good? #pause

*Answer:* It achieves a large discounted return #pause

*Question:* What makes a policy optimal? #pause

*Answer:* It achieves the largest possible discounted return #pause

Many algorithms we learn in this course have convergence guarantees #pause
- More compute, more data $=>$ better policy #pause
- Very large compute, very large data $=>$ optimal policy
==
There are two classes of algorithms #pause
- *Model-based* algorithms explicitly model $Tr(s_(t+1) | s_t, a_t), cal(R)(s_(t+1))$ #pause
  - $Tr, cal(R)$ Either given or learned #pause
  - Cheap to train, but expensive to use #pause
  - AlphaGo #pause
- *Model-free* algorithms do not model $Tr(s_(t+1) | s_t, a_t), cal(R)(s_(t+1))$ #pause
  - Only learn the return #pause
  - Expensive to train, but cheap to use #pause
  - GRPO (DeepSeek) #pause

Today, we learn *trajectory optimization* #pause
- Model-based algorithm


==

Trajectory optimization guarantees an optimal policy #pause
- The idea behind DeepBlue, AlphaGo, AlphaZero, etc #pause
- Does not strictly require deep learning (but can use it) #pause
- Comes from classical robotics and control #pause
- https://www.youtube.com/watch?v=6qj3EfRTtkE #pause 

==
Recall the discounted return, our objective for the rest of this course #pause

#side-by-side[$ G(bold(tau)) = sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause][
  $ bold(tau) = mat(s_0, a_0; s_1, a_1; dots.v, dots.v) $ #pause
]

We want to maximize the discounted return 

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s_1, s_2, dots in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause

We want to find $tau$ that provides the greatest discounted return

==

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s_1, s_2, dots in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause

This objective looks simple, but $R(s_(t+1))$ hides much of the process #pause
- To understand what is hiding, let us examine the reward function

= Reward Optimization
==

Consider the reward function

$ R(s_(t+1)) $ #pause

We want to maximize it #pause

$ argmax_(s_(t+1) in S) R(s_(t+1)) $ #pause

*Question:* In state $s_t$, take action $a_t$, what is $R(s_(t+1))$ ? #pause

*Answer:* Not sure. $R(s_(t+1))$ depends on $Tr(s_(t+1) | s_t, a_t)$ #pause

Cannot know $s_(t+1)$ with certainty, only know the distribution!

==

$s_(t+1)$ is the outcome of a random process #pause 

$ s_(t+1) tilde Tr(dot | s_t, a_t), quad s_t, s_(t+1) in S $ #pause

*Question:* What is $S$? #pause

*Answer:* State space, also the outcome space $Omega$ of $Tr$ #pause

$ s_(t+1) in S equiv omega in Omega $ #pause

*Question:* Ok, now what is the definition of $R$? #pause

//And the reward function is a scalar function of an outcome #pause

*Answer:*

$ R: S |-> bb(R) $

==
$ s_(t+1) tilde Tr(dot | s_t, a_t), quad s_t, s_(t+1) in S $ #pause

$ R: S |-> bb(R) $ #pause

*Question:* $R$ is a special kind of function, what is it? #pause

*Answer:* $R$ is a random variable! #pause

#side-by-side[
  $ R: S |-> bb(R)$ #pause
][
  $ S = Omega $ #pause
][
    $ R: Omega |-> bb(R) $ #pause
]

We should write it as $cal(R) : S |-> bb(R)$


==
$ cal(R) : S |-> bb(R) $ #pause

*Question:* What do we like to do with random variables? #pause

*Answer:* Take the expectation! #pause

*Question:* Why do we like to take the expectation of random variables? #pause

*Answer:* It maps a random processes to a scalar objective #pause
- We can maximize scalar objectives


==
$ cal(R) (s_(t+1)), quad s_(t+1) tilde Tr(dot | s_t, a_t) $ #pause

We cannot know for certain which reward we get in the next timestep #pause
- But we can know the *average* reward using the expectation #pause

$ bb(E)[cal(R)] = sum_(omega in Omega) cal(R)(omega) dot Pr(omega) $ #pause

$ bb(E)[#pin(1)cal(R)(s_(t+1)) | s_t, a_t#pin(2)] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | #pin(3)s_t, a_t#pin(4)) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom)[Random variable conditioned on $s_t, a_t$] 

#pinit-highlight(3,4)
==

$ bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

As an agent, all we can control is our action #pause
- Pick the action $a_t$ that maximizes the expected (average) reward #pause

$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = argmax_(a_t in A) sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

*Note:* Cannot directly maximize $cal(R)$ because $s_(t+1)$ is a distribution  #pause

Let us try and code this

==

$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = #pin(9)argmax_(a_t in A)#pin(10) #pin(1)sum_(s_(t+1) in S) #pin(2)#pin(5)cal(R)(s_(t+1))#pin(6) #pin(7)dot#pin(8) #pin(3)Tr(s_(t+1) | s_t, a_t)#pin(4) $ #pause

+ #pinit-highlight(3,4) #pause #text(fill: red.transparentize(50%))[`probs = [[Tr(next_s, s, a) for next_s in S] for a in A]`] #pause
+ #pinit-highlight(5,6, fill: blue.transparentize(80%)) #pause #text(fill: blue.transparentize(50%))[`rewards = [R(next_s) for next_s in S]`]  #pause
+ #pinit-highlight(1,2, fill: purple.transparentize(80%)) #pinit-highlight(7,8, fill: purple.transparentize(80%)) #pause #text(fill: purple.transparentize(50%))[`expected_reward = [sum([p * rewards]) for p in probs]`] #pause
+ #pinit-highlight(9,10, fill: olive.transparentize(80%)) #pause #text(fill: olive.transparentize(50%))[`a = argmax(expected_reward)`]  #pause

*Question:* Have we seen this before? #pause

#side-by-side[*Answer:* Bandits! #pause][
  $ argmax_(a in {1 dots k}) bb(E)[cal(R)_a] $ 
]

==
$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = argmax_(a_t in A) sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

Earlier, we said that algorithms produce a policy $pi: S |-> Delta A$ #pause
- But this equation is not yet a policy! #pause

*Question:* How to make equation into policy? (Hint: Greedy policy) #pause

$ pi (a_t | s_t) = Pr (a_t | s_t) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause

#side-by-side[
  *Question:* Why don't we use epsilon greedy? #pause
][
  We already know $Tr, cal(R)$, we do not need to explore, only exploit
]

==

$ pi (a_t | s_t) = Pr (a_t | s_t) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause

$ underbrace(pi(a_0 | s_0), cal(R)(s_1)), underbrace(pi(a_1 | s_1), cal(R)(s_2)), dots $ #pause

This policy is *optimal* with respect to the expected reward #pause
- It will always act to maximize the expected reward 

==
*Summary:* Reward optimization provides a policy $pi$ that maximizes the reward #pause

$ a_t tilde pi(dot | s_t) $ #pause

$ pi (a_t | s_t) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause

$ bb(E) [cal(R)(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ 
==

*Example:* Online advertising, show users ads so they buy products #pause

#side-by-side[
  $ S = {0, 1}^d times {0, 1} $
][
  Current user info, prev user buy?
] #pause

#side-by-side[
  $ A = [0, 1]^(256 times 256 times 3) $
  ][
  Pixels of advertisement image
] #pause
  

$ cal(R)(s_(t+1)) = cases(1 "if bought product", 0 "otherwise") $ #pause

$ pi (a_t | s_t) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause


This will create the best ad creator possible!

==

*Question:* Are we done? Is maximizing reward enough? #pause

*Answer:* No, maximize the discounted return, not the reward!


= Trajectory Optimization New

==
Optimal policy for reward is fairly simple #pause
- Compute reward for each possible action #pause

Optimal policy for the return is more complicated #pause
- Must *plan*, how does an action affect *all* future rewards?

#cimage("fig/03/trap.jpg", height: 50%)

==
Trajectory optimization is an algorithm #pause
- Find $bold(tau)$ that maximizes the return (optimize trajectory) #pause

#side-by-side(align: center + horizon)[
  $ bold(tau) = mat(s_0, a_0; s_1, a_1; dots.v, dots.v) $ #pause
][
  $ max_(bold(tau)) bb(E)[G(bold(tau)) | s_0] $ #pause
]

*Question:* Can we control the trajectory? What can we control? #pause

*Answer:* Can only control our actions #pause

$ max_(a_0, a_1, dots) bb(E)[G(bold(tau)) | s_0, a_0, a_1, dots] $

==
*Note:* $G$ is also a random variable #pause 
$ G: underbrace(S^(n+1) times A^n, "Outcome of stochastic" Tr"," pi) |-> bb(R) $ #pause

We can rewrite it curly since it is a random variable #pause
$ cal(G): underbrace(S^(n+1) times A^n, "Outcome of stochastic" Tr"," pi) |-> bb(R) $ #pause

Back to the problem... #pause

$ max_(a_0, a_1, dots) bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $ 

==
$ max_(a_0, a_1, dots) bb(E)[G(bold(tau)) | s_0, a_0, a_1 dots] $#pause

To design our algorithm, we must find $bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1 dots]$ #pause

*Question:* How can we rewrite the expected return using $cal(R)$? #pause

$ cal(G)(bold(tau)) = sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) $ #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = bb(E)[sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) | s_0, a_0, a_1,dots] $

==
$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = bb(E)[sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) | s_0, a_0, a_1,dots] $ #pause

First, reward at $t+1$ does not depend on future actions

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = bb(E)[sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $ #pause

Expectation is linear (sum), can do exchange of sums #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo bb(E)[gamma^t cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $ 

==

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo bb(E)[gamma^t cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $ #pause

Product is also linear, can factor out $gamma$ #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $ 

==
$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $ 

Let us unroll this sum to see how we compute the elements #pause

$ &= gamma^0 bb(E)[cal(R)(s_1) | s_0, a_0] \
  &+ gamma^1 bb(E)[cal(R)(s_2) | s_0, a_0, a_1] \
  &+ gamma^2 bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] \
  &dots.v
$

==

$ &= gamma^0 bb(E)[cal(R)(s_1) | s_0, a_0,] \
  &+ gamma^1 bb(E)[cal(R)(s_2) | s_0, a_0, a_1] \
  &+ gamma^2 bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] \
  &dots.v
$ #pause

$ bb(E)[cal(R)(s_1) | s_0, a_0] = sum_(s_1) cal(R)(s_1) Tr(s_1 | s_0, a_0) $ #pause

The next reward is more tricky because we do not have $s_1$ #pause

$ bb(E)[cal(R)(s_2) | s_0, a_0, a_1] = sum_(s_2) sum_(s_1) cal(R)(s_2) Tr(s_2 | s_1, a_1)  Tr(s_1 | s_0, a_0) $ 

==
$ &= gamma^0 bb(E)[cal(R)(s_1) | s_0, a_0,] \
  &+ gamma^1 bb(E)[cal(R)(s_2) | s_0, a_0, a_1] \
  &+ gamma^2 bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] \
  &dots.v
$ #pause

It becomes even messier for later rewards #pause

$ bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] = \ sum_(s_3) sum_(s_2) sum_(s_1) cal(R)(s_3) Tr(s_3 | s_2, a_2) Tr(s_2 | s_1, a_1) Tr(s_1 | s_0, a_0) $ 

==
$ bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] = \ sum_(s_3) sum_(s_2) sum_(s_1) cal(R)(s_3) Tr(s_3 | s_2, a_2) Tr(s_2 | s_1, a_1) Tr(s_1 | s_0, a_0) $ #pause

This is too messy. Rewrite this using notation from the Markov process lecture. #pause *Question:* How? #pause

$ sum_(s_2) sum_(s_1) Tr(s_3 | s_2) Tr(s_2 | s_1) Tr(s_1 | s_0) = Pr(s_3 | s_0) $ #pause

For MCP and MDP, we must consider actions too #pause

$ sum_(s_2) sum_(s_1) Tr(s_3 | s_2, a_2) Tr(s_2 | s_1, a_1) Tr(s_1 | s_0, a_0) = Pr(s_3 | s_0, a_0, a_1, a_2) $


==
$ bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] = \ sum_(s_3) #redm[$sum_(s_2) sum_(s_1)$] cal(R)(s_3) #redm[$Tr(s_3 | s_2, a_2) Tr(s_2 | s_1, a_1) Tr(s_1 | s_0, a_0)$] $ #pause

$ #redm[$sum_(s_2) sum_(s_1) Tr(s_3 | s_2, a_2) Tr(s_2 | s_1, a_1) Tr(s_1 | s_0, a_0)$] = #bluem[$Pr(s_3 | s_0, a_0, a_1, a_2)$] $ #pause

$ bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] = sum_(s_3) cal(R)(s_3) #bluem[$Pr(s_3 | s_0, a_0, a_1, a_2)$] $ 

==
General form for reward at time $t+1$ #pause

$ bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] = sum_(s_(t+1)) cal(R)(s_(t+1)) Pr(s_(t+1) | s_0, a_0, dots, a_t) $ #pause

Plug this back into the expected return #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] &= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] \ 
&= sum_(t=0)^oo gamma^t sum_(s_(t+1)) cal(R)(s_(t+1)) Pr(s_(t+1) | s_0, a_0, dots, a_t) $ 

==

$ &argmax_(a_0, a_1, dots) bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] \ 
= &argmax_(a_0, a_1, dots) sum_(t=0)^oo gamma^t sum_(s_(t+1)) cal(R)(s_(t+1)) && Pr(s_(t+1) | s_0, a_0, dots, a_t) \ 
= &underbrace(argmax_(a_0, a_1, dots) sum_(t=0)^oo gamma^t sum_(s_(t+1)) cal(R)(s_(t+1)), "Discounted reward at" t) && underbrace(sum_(s_1, s_2, dots in S) product_(n=0)^t  Tr(s_(n+1) | s_(n), a_(n)), "State distribution at t")
$ #pause

- All possible future states #pause
- All possible rewards #pause
- For all possible actions

==
$ &argmax_(a_0, a_1, dots) bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] 
= argmax_(a_0, a_1, dots) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] \
= &argmax_(a_0, a_1, dots) sum_(t=0)^oo gamma^t sum_(s_(t+1)) cal(R)(s_(t+1)) Pr(s_(t+1) | s_0, a_0, dots, a_t) 
$ #pause

*Question:* What is our policy $pi$? #pause

$ a^*_0, a^*_1, dots = argmax_(a_0, a_1, dots) bb(E)[cal(G)(bold(tau)) | s_0, a_1, a_2, dots] $ #pause

$ pi (a_t | s_t) =  cases( 
  1 "if" a_t = a^*_t, 
  0 "otherwise"
) $ 


==

$ a^*_0, a^*_1, dots = argmax_(a_0, a_1, dots) bb(E)[cal(G)(bold(tau)) | s_0, a_1, a_2, dots] $ 

$ pi (a_t | s_t) =  cases( 
  1 "if" a_t = a^*_t, 
  0 "otherwise"
) $  #pause

We have a name for this policy in control theory #pause

*Question:* Anyone know what we call it? #pause

*Answer:* Model Predictive Control (MPC) or Receding Horizon Control 

/*
==
MPC is arguably the best practical method for control #pause

Most robots and autonomous vehicles today use some form of MPC #pause

Example application of trajectory optimization/MPC:

https://www.youtube.com/watch?v=bjlT-6KVQ7U
*/


==

There is a lot of math behind trajectory optimization/MPC #pause

Let us do a visual example to help you understand

==

#side-by-side[
  #traj_opt_mdp #pause
][
  #text(size: 24pt)[
  $ S = {s_a, s_b} quad A = {a_a, a_b} \ #pause
  \

    Pr(s_a | s_a, a_a) = 0.8; space Pr(s_b | s_a, a_a) = 0.2 \ #pause
    Pr(s_a | s_a, a_b) = 0.7; space Pr(s_b | s_a, a_b) = 0.3 \ #pause
    \
    Pr(s_a | s_b, a_a) = 0.6; space Pr(s_b | s_a, a_a) = 0.4 \ #pause
    Pr(s_a | s_b, a_b) = 0.1; space Pr(s_b | s_a, a_b) = 0.9 \
  $
]
]

==

We can build this into a decision tree using trajectory optimization #pause
- The root node of the tree corresponds to $s_0$ #pause
- Each level of the tree enumerates all possible outcomes (states)

==

#text(size: 22pt)[
#traj_opt_tree
]

==

#text(size: 22pt)[
#traj_opt_tree_red
]

==

*Question:* How many nodes does our tree have? #pause

*Answer:* $O(|S| dot |A|)^oo$ #pause

*Question:* What does this mean? #pause

*Answer:* Do not have the memory/compute to evaluate all possibilities #pause

We have some tricks to make this tractable

==
$ argmax_(a_0, a_1, dots in A) bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] $

*Trick 1:* Introduce a *horizon* $n$ #pause

$ argmax_(a_0, dots, #redm[$a_n$] in A) bb(E) [cal(G)(bold(tau)_#redm[$n$]) | s_0, a_0, dots, #redm[$a_n$]] = argmax_(a_0, dots, #redm[$a_n$] in A) sum_(t=0)^#redm[$n$] gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $ #pause

Now we can limit computation to $O(|S| dot |A|)^n$ #pause

*Question:* Drawback? #pause

*Answer:* We no longer consider the infinite future, agent is $n$-greedy

==

$ argmax_(a_0, dots, a_n in A) bb(E) [cal(G)(bold(tau)_n) | s_0, a_0, dots, a_n] = argmax_(a_0, dots, a_n in A) sum_(t=0)^n gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_n] $

*Trick 2:* Only simulate $j$ actions and $k$ states #pause


$ argmax_(a_0, dots, a_n #redm[$tilde A_j subset A$]) bb(E) [cal(G)(bold(tau)_n) | s_0, a_0, dots, a_n] \
= argmax_(a_0, dots, a_n #redm[$tilde A_j subset A$]) sum_(t=0)^n gamma^t #redm[$hat(bb(E))_(k)$] [cal(R)(s_(t+1)) | s_0, a_0, dots, a_n] $ #pause

Now computation is $O(j dot k)^n$ #pause

#side-by-side[
  *Question:* Drawbacks? #pause
][
  Less optimal trajectory if $a^* in.not A_j$
]


==
Trajectory optimization/MPC is an "older" method #pause
- Less popular in the past, limited by compute #pause
- With modern GPUs, we are using MPC more and more #pause

https://www.youtube.com/watch?v=bjlT-6KVQ7U #pause

https://www.youtube.com/watch?v=Kf9WDqYKYQQ #pause

https://youtu.be/QsM9C1U0oi4?si=29BOjZ1Oo6At_iFk&t=111 #pause

We use trajectory optimization/MPC in car racing AND chess/go bots! 

==
To summarize trajectory optimization/MPC: #pause
- Model-based method (we must know $Tr$ and $cal(R)$) #pause
- Results in theoretically optimal policy #pause
- In practice, must make approximations #pause 
  - Less optimal guarantees, but works well in practice #pause
- Computationally expensive, but requires *no training data* #pause

Next time, we will see what happens when we don't know $Tr, cal(R)$