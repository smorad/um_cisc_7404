#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.0": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

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

#let traj_opt_tree_pruned = diagram({
  node((0mm, 0mm), $s_a$, stroke: 0.1em, shape: "circle", name: "root")

  node((75mm, -25mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aj")


  node((50mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsi")
  node((100mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0ajsj")

  node((125mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0ajsjaj")

  node((-100mm, -75mm), $dots$)
  node((25mm, -75mm), $dots$)

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)
  node((-125mm, -100mm), $t=2$)
  node((-125mm, -125mm), $dots.v$)


  edge(label("root"), label("0aj"), "->")


  edge(label("0aj"), label("0ajsi"), "->", label: $Tr(s_a | s_a, a_b)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $Tr(s_b | s_a, a_b)$)


  edge(label("0ajsj"), label("0ajsjaj"), "->")
})

#let q_opt_tree = diagram({
  node((0mm, 0mm), $s_a$, stroke: 0.1em, shape: "circle", name: "root")

  node((-75mm, -25mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ai")
  node((75mm, -25mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aj")

  node((-100mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0aisi")
  node((-50mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0aisj")

  node((50mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsi")
  node((100mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0ajsj")

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)

  edge(label("root"), label("0ai"), "->", label: $Q(s_a, a_a, theta_pi)$)
  edge(label("root"), label("0aj"), "->",  label: $Q(s_a, a_b, theta_pi)$)

  edge(label("0ai"), label("0aisi"), "->", label: $V(s_a, theta_pi)$, )
  edge(label("0ai"), label("0aisj"), "->", label: $V(s_b, theta_pi)$, )

  edge(label("0aj"), label("0ajsi"), "->", label: $V(s_a, theta_pi)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $V(s_a, theta_pi)$)

})


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Value],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)


// Problems with MPC, cannot do infinite
// What if I told you we could build an infinitely deep tree?
// Start with original E[G]
// Introduce a policy into E[G], write out big equation
// Introduce value function
// Call this a value function
// Value of a state
// Examples of valuable states
    // Studying no reward, but valuable because of return
// Value functions
// Value iteration (still needs model)
// Value function objectives (MC)
// Infinite step hard to determine
// Derive TD
// Value iteration with TD
// What if we don't know the model?
// Introduce TD learning
// Introduce SARSA 
// Introduce Q learning
// Q learning exercise (frozenlake)
// Training loop

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Review

= Policy-Conditioned Returns

==
Trajectory optimization is model-based algorithm #pause

Guaranteed optimal policy, given infinite compute  #pause

We must make approximations to implement trajectory optimization #pause

These approximations break optimality guarantees #pause

Today, we will look at new algorithms based on the notion of *value* #pause

Uses fewer approximations but can achieve optimal policy #pause

Can model infinitely long returns  #pause

Expensive to train, but very cheap to use

==

Recall the return from trajectory optimization #pause

$ [cal(G)(bold(tau)) | s_0, #pin(1)a_0, a_1, dots#pin(2)] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, #pin(3)a_0, a_1, dots#pin(4)] $ #pause

This is an *action-conditioned* discounted return #pinit-highlight(1,2) #pinit-highlight(3,4) #pause

Conditioned/dependent on a sequence of actions  #pause

There is no structure to the actions #pause
- Random #pause
- Picked by humans #pause
- Maximize $cal(G)$

==

$ bb(E) [cal(G)(bold(tau)) | s_0, #pin(1)a_0, a_1, dots#pin(2)] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, #pin(3)a_0, a_1, dots#pin(4)] $ #pause

Last time, we introduced the policy #pause

$ pi: S times Theta |-> Delta A $ #pause

Example policy, greedy policy #pause

$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots], 
  0 "otherwise"
) $ #pause

==

$ [cal(G)(bold(tau)) | s_0, #pin(1)a_0, a_1, dots#pin(2)] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, #pin(3)a_0, a_1, dots#pin(4)] $ #pause

$ pi: S times Theta |-> Delta A $ #pause

Conditioning the return on actions is annoying #pause

Must compute infinitely many actions and outcomes for the return #pause

What if we condition on a policy, instead of specific actions?

==

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] $ 

$ a_0 tilde pi (dot | s_0; theta_pi), quad a_1 tilde pi (dot | s_1; theta_pi), quad a_2 tilde pi (dot | s_2; theta_pi), quad dots $ #pause

Condition on a function parameterized by $theta_pi$ instead of many actions #pause

$ bb(E) [cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, theta_pi] $ #pause

The function outputs a distribution over the action space $pi (a | s; theta_pi)$

==

$ 
bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] &= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] \ #pause

bb(E) [cal(G)(bold(tau)) | s_0; theta_pi] &= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, theta_pi] #pause
$

Now conditioned on the policy #pause

But remember, $cal(R)(s_(t+1))$ hides much of the magic #pause

How does $bb(E)[cal(R)(s_(t+1))]$ change when we condition on $theta_pi$?

==

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] =  sum_(t=0)^oo gamma^t cal(R)(s_(t+ 1)) sum_(s_(t+1) in S) #pin(1)Pr(s_(t+1) | s_0, a_0, dots, a_t)#pin(2) $ #pause

*Question:* What changes when we condition on $theta_pi$? #pause

$ Pr (s_(t+1) | s_0; theta_pi) $ #pause

Maybe we can use $Pr(s_(t+1) | s_t, a_t)$ to figure this out #pause

*Question:* What was $Pr(s_(t+1) | s_t, a_t)$? #pause

*Answer:* State transition function  

$ Tr(s_(t+1) | s_t, a_t) $

==

$ Tr(s_(t+1) | s_t, a_t) $ #pause

*Issue:* State transition function needs an action $a_t$ #pause

Policy $pi$ outputs a distribution over the action space #pause

*Question:* What is $Pr(s_(t+1) | s_t, theta_pi)$? #pause Hint: Consider all possible actions #pause

$ Pr (s_(t+1) | s_t; theta_pi) = sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) $ #pause

Combine the policy distribution with next state distribution

==

$ Pr (s_(t+1) | s_t; theta_pi) = sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) $ #pause

Write out the first few timesteps #pause

$ Pr (s_1 | s_0; theta_pi) &= sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi) \ #pause

Pr (s_2 | s_0; theta_pi) &= sum_(s_1 in S) sum_(a_1 in A) Tr(s_2 | s_1, a_1) dot pi (a_1 | s_1; theta_pi) \ 
& quad quad dot sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi)
$

==

$ Pr (s_1 | s_0; theta_pi) &= sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi) \

Pr (s_2 | s_0; theta_pi) &= sum_(s_1 in S) sum_(a_1 in A) Tr(s_2 | s_1, a_1) dot pi (a_1 | s_1; theta_pi) \ 
& quad quad dot sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi)
$ #pause

Derive a general form for $Pr (s_(n+1) | s_0; theta_pi)$ #pause

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

==

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $ #pause

Plug back into our expected reward #pause

$ bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Pr (s_(t+1) | s_0; theta_pi) $

==
$ bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Pr (s_(t+1) | s_0; theta_pi) $ #pause

Discounted return is discounted sum of rewards #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =& #pause sum_(s_1 in S) cal(R)(s_1) dot Pr (s_1 | s_0; theta_pi) \ #pause
+ gamma & sum_(s_2 in S) cal(R)(s_2) dot Pr (s_2 | s_0; theta_pi) \ #pause
+ gamma^2 & sum_(s_3 in S) cal(R)(s_3) dot Pr (s_3 | s_0; theta_pi)  \ #pause
dots $

==
*Definition:* General form of policy-conditioned discounted return #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr(s_(n + 1) | s_n, a_n)
$ #pause

Where the state distribution is #pause

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

= Value Functions




==

$ Pr (s_(n+1) | s_0; theta_pi) &= sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) \ #pause
 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi) #pause
$

These two equations form the basis of all reinforcement learning #pause

*Goal:* find the $theta_pi$ (policy parameters) to maximize the expected return

==
$ Pr (s_(n+1) | s_0; theta_pi) &= sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) \
 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ #pause

We have another name for $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ #pause

We call it the *value function* $V: S times Theta |-> bb(R)$ #pause

$ V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =  sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi) $

==
$ V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =  sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi) $ #pause

Value function takes any state $s_0$, and tells us how valuable $s_0$ is #pause

Valuable states lead to good returns *under the current policy* #pause

#side-by-side[
    $s = 240 "km/h"$ #pause   
][
    $theta_pi =$ Race car driver #pause
][
    $V(s, theta_pi) = "good"$ #pause
]

#side-by-side[
    $s = 240 "km/h"$  #pause
][
    $theta_pi =$ Grandpa #pause
][
    $V(s, theta_pi) = "not good"$ #pause
]

We use the value function to direct the policy to good states #pause

It is a critical part of decision making

==
With the value function, we can use any state as a starting state #pause

The state does not need to be the start of a trajectory #pause

*Example:* Consider the sequence of states 

$ s_a, s_b, s_c $ #pause

We can compute 

$ V(s_a, theta_pi), V(s_b, theta_pi), V(s_c, theta_pi) $

To find the value of any state

==

*Question:* Why does Prof. Steven keep showing stupid equations? How is the value function useful? #pause

We can use the value of a state to make decisions #pause

$ s_a = "Live in Macau", s_b = "Live in Beijing" $ #pause

Given all your preferences ($cal(R)$) and thoughts ($theta_pi$), we can determine which life is better for you #pause

$V(s, theta_pi)$ considers your future friends, income, wife/husband, etc #pause

Combines all this info into one value, a single number of "goodness" #pause

#side-by-side[
$ V(s_a, theta_pi) = 1032 $ #pause
][
$ V(s_b, theta_pi) = 945 $ #pause
]

==
$ s_a = "Live in Macau", s_b = "Live in Beijing" $ #pause

#side-by-side[
$ V(s_a, theta_pi) = 1032 $ 

][
$ V(s_b, theta_pi) = 945 $ #pause
]

This value leads us to the right decisions #pause

Some optimal decisions are hard for humans to make #pause

With value, we can be sure we make the right decision

= Exercise
==
- Think of two places you want to live after graduation $s_a, s_b$ #pause
- Consider your behavior ($theta_pi$) and what is important to you ($cal(R)$) #pause
- Top 3 life goals as states $s_x, s_y, s_z in G$ (e.g., friends, money, hobby, etc) #pause
- Assign a reward $cal(R)$ for each goal, and choose discount factor $gamma$ #pause

For each location $s_0 in { s_a, s_b }$: #pause
- Estimate probability of reaching each goal $Pr(s_g | s_0); s_g in {s_x, s_y, s_z} $ 
- Estimate time to accomplish each goal $t = ...$ 

$ V(s_0, theta_pi) =  sum_(s_g in {s_x, s_y, s_z}) gamma^t cal(R)(s_g) dot Pr (s_g | s_0; theta_pi) $

= TD Value Functions
==

*Note:* We define the value function in many different ways #pause

It always approximates the expected discounted return from $s_0$ #pause

We call the following equation the *Monte Carlo* value function 

$ V(s_0, theta_pi) =  sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi) $ #pause

Difficult to compute the Monte Carlo value function #pause
- Must either have a terminal states #pause
- Or build the infinite decision tree

==

$ V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $ #pause

Infinite sums are icky #pause

They make everything difficult and intractable #pause

Let us try to delete the infinite sum

==

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $ #pause

Factor out initial timestep $t=0$ out of the outer sum #pause

$ V(s_0, theta_pi) = gamma^0 sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=1)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $

==

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=1)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $ #pause

Rewrite sum starting from $t=0$ #pause

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=0)^oo gamma^(t+1) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; theta_pi) $

==

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=0)^oo gamma^(t+1) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; theta_pi) $ #pause

Factor out $gamma$ #pause

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; theta_pi) $

==

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; theta_pi) $ #pause

Split $Pr$ using Markov property #pause

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) sum_(s_1) Pr (s_(t + 2) | s_(t+1); theta_pi) Pr (s_(1) | s_0; theta_pi) $

==
$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) sum_(s_1) Pr (s_(t + 2) | s_(t+1); theta_pi) Pr (s_(1) | s_0; theta_pi) $ #pause

Move sum and $Pr$ outside #pause

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi) $


==
$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma #pin(1)sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi)#pin(2) $ #pause

*Question:* What is this term? #pinit-highlight(1,2) #pause

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $ #pause

$ V(s_1, theta_pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_1; theta_pi) $

==

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi) $ #pause

$ V(s_0, theta_pi) = (sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi)) + gamma V(s_1, theta_pi) $ #pause

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi) $ #pause

This is a huge finding!

==

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi) $ #pause

Value function has a recursive definition #pause

Represent policy-conditioned discounted return without an infinite sum #pause

We call this the *Temporal Difference* (TD) value function #pause

Compute the return with a single transition $s_0 -> s_1$ #pause

Evaluate infinite-depth decision tree with a single function call

==
To summarize, we can represent the value function in two ways: #pause

The Monte Carlo value function #pause

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi)
$ #pause 

The Temporal Difference value function #pause

$
V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, theta_pi] 
$


= Q Functions

==

We saw two forms of the value function #pause

The value function relies on a policy #pause

But it does not tell us the policy #pause

How can we use the value function to find an optimal policy?

==

Consider the value function

$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]
= bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi) 
$

With trajectory optimization we conditioned on actions

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $

We conditioned the value function on policy parameters

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] $

What if we wanted a mix of both?

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] $

==

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] $

We call this the *Q function*

$ Q(s, a, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] $

We can derive the Q function from the value function

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi) $

First, introduce the action $a_0$

$ V(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi) $

==
$ V(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0; theta_pi] + gamma V(s_1, theta_pi) $

Condition the initial reward on the action

$ V(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

Call it the Q function

$ Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

==
$ Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

The Q function tells us:
- The value of an action $a_0$
- In state $s_0$
- If we follow $pi ( a_t | s_t;theta_pi)$ afterwards

*Question:* How can we use the Q function for decision making?

Hint: We can evaluate $Q$ for every possible action

$ argmax_(a_0 in A) Q(s_0, a_0, theta_pi) = argmax_(a_0 in A) bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

==

$ argmax_(a_0 in A) Q(s_0, a_0, theta_pi) = argmax_(a_0 in A) bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

This is a very powerful equation
- Compute $Q(s_0, a_0)$ for all $a_0$
- Pick the $a_0$ that maximizes $Q(s_0, a_0)$

This $a_0$ is *guaranteed* to be the optimal action for the *infinite* future

We collapsed the infinite decision tree into a single level

==

#text(size: 22pt)[#traj_opt_tree]

==

#text(size: 22pt)[#q_opt_tree]

==
$ argmax_(a_0 in A) Q(s_0, a_0, theta_pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) ) $

==
$ Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

We will use either $Q$ or $V$ in every other algorithm in the course!

It is the core of decision making

/*
==

//$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $
$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

==
$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

Pull first term out of sum 

$ V(s_0, theta_pi) = gamma^0 bb(E)[R(s_1) | s_0; theta_pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

Provide $a_0$ and condition on it

$ V(s_0, theta_pi, a_0) = gamma^0 bb(E)[R(s_1) | s_0, a_0] + sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

$ Q(s_0, theta_pi, a_0) = gamma^0 bb(E)[R(s_1) | s_0, a_0] + sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $


$ Q(s_0, a_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Tr (s_( 1) | s_0, a_0) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi) $
*/

//= SARSA

= Q Learning

==
// Intro of Q learning (model-free, etc)
// Found q equation, but not clear how to train it
// Furthermore, relies on value function which we don't know
// Bellman equation
// off-policy depends on which value function

Q learning is a model-free algorithm first invented in the 1980s

It is still used heavily today

In fact, I am using it in our research right now 

We now have all the information we need to implement Q learning

==

Our Q function relies on the value function for some $theta_pi$

Right now, it is not clear what the policy is

So how can we use the Q function without knowing the policy?

==
Start with the Q function

$  Q(s_0, a_0, theta_pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi)  $

We want to take the action that maximizes Q

$ argmax_(a_0 in A) Q(s_0, a_0, theta_pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) ) $

Recall the definition of value function

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

==
$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

//$V(s_0, theta_pi) = gamma^0 bb(E)[R(s_1) | s_0; theta_pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi]$

====

What should our policy be?

Well we know the following is optimal

$ argmax_(a_0 in A) Q(s_0, a_0, theta_pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) ) $

What if we say we follow a policy that maximizes Q?

$ pi (a_0 | s_0; theta_pi) = cases(
    1 "if" a_0 = argmax_(a in A) Q(s_0, a, theta_pi),
    0 "otherwise"
) $

What is the value function for this policy?

$ V(s_0, theta_pi) = max_(a in A) Q(s_0, a, theta_pi) $

So we can rewrite the Q function without V

$ Q(s_0, a_0, theta_pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_pi) $

$ Q(s_0, a_0, theta_pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma argmax_(a in A) Q(s_1, a, theta_pi) $



= Homework

==
Due in 2 weeks (Weds 12 March, 23:59)

Download and submit `.py` and `.ipynb` files

Uses turnitin for checking

https://colab.research.google.com/drive/1xtBxAaVc3ax6_j59RC3NLQQPFcIEoau-?usp=sharing



/*
= Value Objectives

==
$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi)
$

*Idea:* Instead of computing the tree, can we learn to approximate it?


$ V(s_0, theta_pi, theta_V) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]; quad bold(tau) in (S times A)^n $

*Question:* How can we learn $Theta_V$ such that it becomes the true $V$ function?

*Answer:* Mean square error

$ V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = 0 $

==

TODO: Expectation, so we can learn from samples

$ V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = 0 $

$ (V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi])^2 = 0 $

$ argmin_(theta_V) (V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi])^2 $

$ argmin_(theta_V) sum_(s_0 in S) (V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi])^2 $

We do not know $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$?

*Question:* What can we do when we do not know an expectation? (Hint: Bandits)

*Answer:* Approximate the expectation by playing!

$ argmin_(theta_V) sum_(s_0 in S) (V(s_0, theta_pi, theta_V) - hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi])^2 $


+ Run our policy in the environment
+ Collect a trajectory $bold(tau)$
// + Create subtrajectories $bold(tau)_(0:), bold(tau)_(1:), dots $
+ Compute the return of the trajectory $cal(G)(bold(tau))$
+ Now we have $hat(bb(E))_1[cal(G)(bold(tau)) | s_0, theta_pi]$
+ Repeat to improve estimate! $hat(bb(E))_k [cal(G)(bold(tau)) | s_0, theta_pi]$

==

$ argmin_(theta_V) sum_(s_0 in S) (V(s_0, theta_pi, theta_V) - hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi])^2 $


+ Run our policy in the environment
+ Collect a trajectory $bold(tau)$
// + Create subtrajectories $bold(tau)_(0:), bold(tau)_(1:), dots $
+ Compute the return of the trajectory $cal(G)(bold(tau))$
+ Now we have $hat(bb(E))_1[cal(G)(bold(tau)) | s_0, theta_pi]$
+ Repeat to improve estimate! $hat(bb(E))_k [cal(G)(bold(tau)) | s_0, theta_pi]$

TODO: All $s_0$ in $tau$

We call this the *Monte Carlo objective*

We approximate the return using monte carlo trajectories

Note that we *do not* know $Tr$!

==

1. Execute policy in environment and collect trajectory

```python
terminated = False
state = env.reset()
trajectory, rewards = [], []
while not terminated:
    action_distribution = policy(s, theta_pi)
    action = sample(action_distribution)
    next_state, reward, terminated = env.step(action)
    trajectory.append((state, action))
    rewards.append(reward)
    state = next_state
return trajectory, rewards
```

==
2. Compute the return of the trajectory
```python
def G(rewards, gamma):
    return sum(r * gamma ** t for t in range(len(rewards)))

# Approximate E_1[G] empirically
# Compute the return for s_0 in trajectory
E_1g = G(rewards, gamma)
# Inefficient! We can treat each s in trajectory as s_0
# n datapoints for each trajectory length n
E_ng = []
for i in range(len(rewards)):
    E_ng.append(G(rewards[i:]))
```
==

3. Train! Learn the value of a policy 
```python
theta_V = jnp.zeros(len(S))
def V(state, theta_pi, theta_V):
    return theta_V[state]

def update_V(states, returns, theta_pi, theta_V, alpha=0.01):
    for s, g in zip(states, returns):
        theta_V[s] +=  alpha * (g - V(s, theta_pi, theta_V))
    return theta_V

# Update_V using trajectories and returns
```
*/
/*
==


But they will *always* approximate
$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi)
$

For example

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, theta_pi] $
==

$ Pr (s_(n+1) | s_0; theta_pi) &= sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) \
 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$

We call the policy-conditioned return the *value function*

$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$

The value function tells us how valuable a state $s_0$ is for the policy
*/



/*
==

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

Factor out initial timestep

$ V(s_0, theta_pi) = gamma^0 bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

$gamma$ goes away

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

==
$ V(s_0, theta_pi) = bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

Factor out another gamma

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + gamma sum_(t=1)^oo gamma^(t-1) bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

Change sum index

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + gamma sum_(t=0)^oo gamma^(t) bb(E)[cal(R)(s_(t+2)) | s_0; theta_pi] $

==
$ V(s_0, theta_pi) = bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + gamma sum_(t=0)^oo gamma^(t) bb(E)[cal(R)(s_(t+2)) | s_0; theta_pi] $

*/



/*
= Monte Carlo Tree Search

==
*Question:* Why is Prof. Steven showing these stupid equations again?

We have already seen the expected return many times 

All you did was change the silly notation

$ 
bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] => 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]
$

We will use this silly change to improve trajectory optimization

The improved form is called *Monte-Carlo Tree Search* MCTS

AlphaGo uses the MCTS variant of trajectory optimization

==
Trajectory optimization constructs a very large tree to find

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $

Optimal policy was intractable with $O(|S| dot |A|)^n$ complexity

==


#text(size: 20pt)[#traj_opt_tree]

==
Trajectory optimization constructs a very large tree to find

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $

Optimal policy was intractable with $O(|S| dot |A|)^n$ complexity

*Question:* Does depending on policy make it better? How?

$ bb(E)[cal(G)(bold(tau)) | s_0, theta_pi] $

*Answer:* Only consider actions with support under the policy

Let us do an example to build intuition

//If policy has action with probability one, then $O(|S| dot 1)^n$

//*Question:* Can we think of any policies like this?

==
*Example:*

Imagine we found an ok policy, maybe from copying a human

$ pi (a_t | s_t; theta_pi) =  cases( 
  0.8 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, theta_pi], 
  0.2 / (|A|) "otherwise"
) $

Policy is optimal for 80% of actions, suboptimal for 20% of actions

*Question:* How could we improve trajectory optimization with $pi$? 

Hint: Think about efficiency and the size of decision tree

*Answer:* Only consider actions $pi$ would take

==

#traj_opt_tree

==
#traj_opt_tree_pruned

==
Rather than trying all $a in A$ or uniformly sampling $a in A$


==
$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, theta_pi], 
  0 "otherwise"
) $

*Intution:* Limiting the support of the policy distribution can create much smaller decision trees

Not all distributions have limited support

Human policy can be random, nonzero support everywhere

Policy is a distribution

We can sample actions from it

Given full support, approaches the true decision tree in the limit

==

Call this approach *Monte-Carlo tree search* (MCTS)

It's like gambling to approximate 

AlphaGo uses 

Reasoning LLMs (ChatGPT-o1) rumored to use MCTS

Only expands likely actions

https://vgarciasc.github.io/mcts-viz/

*/
==
$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr(s_(n + 1) | s_n, a_n)
$

//product_(t=0)^n [ sum_(s_(t+1) in S) sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) pi (a_t | s_t; theta)] $

This is a process:
+ Given the state, compute the action distribution $pi (a_t | s_t; theta)$
+ Given the action distribution, compute the next state distribution $Tr(s_(t+1) | s_t, a_t)$
+ Given the next state distribution, compute the reward distribution $R(s_(t+1))$
*/