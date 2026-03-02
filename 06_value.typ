#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *


// TODO 2026 this is too long, maybe do one lecture just MC and another TD

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

  node((50mm, -65mm), $V(s_a, pi)$)
  node((100mm, -65mm), $V(s_b, pi)$)
  node((-50mm, -65mm), $V(s_b, pi)$)
  node((-100mm, -65mm), $V(s_a, pi)$)

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)

  edge(label("root"), label("0ai"), "->", label: $Q(s_a, a_a, pi)$)
  edge(label("root"), label("0aj"), "->",  label: $Q(s_a, a_b, pi)$)

  edge(label("0ai"), label("0aisi"), "->", label: $cal(R)(s_a)$, )
  edge(label("0ai"), label("0aisj"), "->", label: $cal(R)(s_b)$, )

  edge(label("0aj"), label("0ajsi"), "->", label: $cal(R)(s_a)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $cal(R)(s_a)$)

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
  //config-common(handout: true),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

// TODO: Maybe move done flag stuff to deep value

// TODO: Should change from s_0 to s_i here as its required for homework
// To train over the whole episode, not just the initial timestep -- make it clear 
// TODO: derivation error marked in value function, search for "where does P(s_1 | s_0; pi) go?"
// TODO MAYBE: Get rid of s_0, a_0 -- eventually transition to s_t, a_t?
// Required for PG later on?
// TODO: pi in the Q function doesn't make sense later
// Go ahead and look at lecture 10, even for DDPG it is confusing
// Solution: keep pi for policy gradient methods
// Use Q_(pi) for value-based methods
// TODO: In equations, introduce Q - y, where y is label instead of single equation
    // Draws parallels to supervised learning


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

Uses fewer approximations and can achieve optimal policy #pause

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

$ pi: S |-> Delta A $ #pause

Example policy, greedy policy #pause

#side-by-side(align: horizon + center)[
$ pi (a_t | s_t) =  cases( 
  1 "if" a_t = a^*_t, 
  0 "otherwise"
) quad $  #pause
][
    $ a^*_0, a^*_1, dots = argmax_(a_0, a_1, dots) bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $ #pause
]

Must construct and evaluate decision tree at each timestep!

==

$ [cal(G)(bold(tau)) | s_0, #pin(1)a_0, a_1, dots#pin(2)] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, #pin(3)a_0, a_1, dots#pin(4)] $ #pause

$ pi: S |-> Delta A $ #pause

We saw last time that this was intractable #pause
- Need to truncate sum to $n$ timesteps #pause
- Must search over infinitely many actions to predict $cal(G)(bold(tau))$ #pause

*Question:* Can we predict the infinite sum in finite time? #pause

What if we condition on a policy, instead of specific actions?

==

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] $  #pause

$ a_0 tilde pi (dot | s_0), quad a_1 tilde pi (dot | s_1), quad a_2 tilde pi (dot | s_2), quad dots $ #pause

Condition on a single $pi$ instead of many actions #pause

$ bb(E) [cal(G)(bold(tau)) | s_0; pi] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $ #pause

Remember, $pi (a | s)$ provides a distribution over the action space

==

$ 
bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] &= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] \ #pause

bb(E) [cal(G)(bold(tau)) | s_0; pi] &= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] #pause
$

Now, return is conditioned on the policy $pi$ #pause
    - The expectation is conditioned on a function #pause
    - Right now you should be confused #pause
        - I wrote $pi$ but this notation does not tell us anything #pause
    - Remember $cal(R)(s_(t+1))$ hides the magic #pause

Let us see how $bb(E)[cal(R)(s_(t+1))]$ changes when we condition on $pi$

==

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] =  sum_(t=0)^oo gamma^t cal(R)(s_(t+ 1)) sum_(s_(t+1) in S) #pin(1)Pr(s_(t+1) | s_0, a_0, dots, a_t)#pin(2) $ #pause

*Question:* Which term changes when we condition on $pi$? #pause

#pinit-highlight(1,2) #pause

$ Pr(s_(t+1) | s_0, a_0, dots, a_t) => Pr (s_(t+1) | s_0; pi) $ #pause

It is still not clear! Remember $Pr (s_(t+1) | s_0; pi)$ hides $Tr$

*Question:* What was $Tr(s_(t+1) | s_t, a_t)$? #pause

*Answer:* State transition function  

$ Tr(s_(t+1) | s_t, a_t) $

==

$ Tr(s_(t+1) | s_t, a_t) $ #pause

*Issue:* State transition function needs an action $a_t$ #pause

Policy $pi$ outputs a distribution over the action space #pause

*Question:* What is $Pr (s_(t+1) | s_t; pi)$? #pause Hint: Consider all possible actions #pause

$ Pr (s_(t+1) | s_t; pi) = sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; pi) $ #pause

Combines the policy distribution and the next state distribution

/*
==

$ Pr (s_(t+1) | s_t; pi) = sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; pi) $ #pause

Write out the first few timesteps #pause

$ Pr (s_1 | s_0; pi) &= sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; pi) \ #pause

Pr (s_2 | s_0; pi) &= sum_(s_1 in S) sum_(a_1 in A) Tr(s_2 | s_1, a_1) dot pi (a_1 | s_1; pi) \ 
& quad quad dot sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; pi)
$

==

$ Pr (s_1 | s_0; pi) &= sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; pi) \

Pr (s_2 | s_0; pi) &= sum_(s_1 in S) sum_(a_1 in A) Tr(s_2 | s_1, a_1) dot pi (a_1 | s_1; pi) \ 
& quad quad dot sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; pi)
$ #pause

Derive a general form for $Pr (s_(n+1) | s_0; pi)$ #pause

$ Pr (s_(n+1) | s_0; pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; pi) ) $

==

$ Pr (s_(n+1) | s_0; pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; pi) ) $ #pause

Plug back into our expected reward #pause

$ bb(E)[cal(R)(s_(t+1)) | s_0; pi] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Pr (s_(t+1) | s_0; pi) $ #pause

Need to plug expected reward back into expected discounted return

==
$ bb(E)[cal(R)(s_(t+1)) | s_0; pi] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Pr (s_(t+1) | s_0; pi) $ #pause

Discounted return is discounted sum of rewards #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; pi] =& #pause sum_(s_1 in S) cal(R)(s_1) dot Pr (s_1 | s_0; pi) \ #pause
+ gamma & sum_(s_2 in S) cal(R)(s_2) dot Pr (s_2 | s_0; pi) \ #pause
+ gamma^2 & sum_(s_3 in S) cal(R)(s_3) dot Pr (s_3 | s_0; pi)  \ #pause
dots $
*/

==
Plug this back into the Markov process model we used earlier

$ Pr (s_(n+1) | s_0, a_0, a_1, dots) &= sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) \ #pause

Pr (s_(n+1) | s_0; #redm[$pi$]) &= sum_(s_1, dots, s_n in S) product_(t=0)^n ( underbrace(#redm[$sum_(a_t in A)$] Tr(s_(t+1) | s_t, a_t) dot #redm[$pi (a_t | s_t)$], "Depends on prob. of each action under" pi) ) $ #pause

This gives us the state distribution at time $n+1$ if we follow policy $pi$ #pause
- *Marginalize* out the action by summing across all possible actions

==
$ Pr (s_(n+1) | s_0; pi) &= sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t) ) $ #pause

And we can plug this back into the expected return #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; pi] =& #pause sum_(s_1 in S) cal(R)(s_1) dot Pr (s_1 | s_0; pi) \ #pause
+ gamma & sum_(s_2 in S) cal(R)(s_2) dot Pr (s_2 | s_0; pi) \ #pause
+ gamma^2 & sum_(s_3 in S) cal(R)(s_3) dot Pr (s_3 | s_0; pi)  \ #pause
dots $


==
*Definition:* General form of policy-conditioned discounted return #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi)
$ #pause

Where the state distribution is #pause

$ Pr (s_(n+1) | s_0; pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t) ) $

= Value Functions

==

$ Pr (s_(n+1) | s_0; pi) &= sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t) ) \ #pause
 
bb(E)[cal(G)(bold(tau)) | s_0; pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi) #pause
$

These two equations form the basis of all reinforcement learning #pause
- DQN, DDPG, SAC, A3C, PPO, GRPO, etc #pause
- You must understand it! #pause

*Goal:* Find $pi$ to maximize the expected return

==
$ Pr (s_(n+1) | s_0; pi) &= sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t) ) \ 
 
bb(E)[cal(G)(bold(tau)) | s_0; pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi)
$ #pause

We have another name for $bb(E)[cal(G)(bold(tau)) | s_0; pi]$ #pause

We call it the *value function* $V: S times underbrace((S |-> A), pi) |-> bb(R)$ #pause

$ V(s_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0; pi] =  sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi) $

==
$ V(s_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0; pi] =  sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi) $ #pause

Named the value function because $V$ tells us the value of any state $s_0$ #pause
- Value $=$ expected return *under the current policy $pi$* #pause

#side-by-side[
    $s = 240 "km/h"$ #pause   
][
    $pi =$ Race car driver #pause
][
    $V(s, pi) = "good"$ #pause
]

#side-by-side[
    $s = 240 "km/h"$  #pause
][
    $pi =$ Grandma #pause
][
    $V(s, pi) = "not good"$ #pause
]

We use the value function to find the best states for our policy to visit #pause
- If we are in a high-value state, our policy will do well!

==
With the value function, we can use any state as a starting state #pause
- The state does not need to be the start of a trajectory #pause

*Example:* Consider the sequence of states 

$ s_0=S_a, s_1=S_b, s_2=S_c, dots $ #pause

We can compute 

$ V(s_0=S_a, pi), V(s_0=S_b, pi), V(s_0=S_c, pi) $

To find the value of any state $S_a, S_b, S_c, dots$

==

*Question:* Why does Prof. Steven keep showing stupid equations? He writes the return 100 different ways. How is the value function useful? #pause

*Answer:* We can use the value of a state to make decisions #pause

$ S_a = "Live in Macau", S_b = "Live in Beijing" $ #pause

Given your preferences ($cal(R)$) and behavior ($pi$), we can determine which life is better for you #pause
- $V(s, pi)$ considers your future friends, income, wife/husband, etc #pause
- Combines all this info into one value we can optimize #pause

#side-by-side[
$ V(S_a, pi) = 1032 $ #pause
][
$ V(S_b, pi) = 945 $
]

==
$ S_a = "Live in Macau", S_b = "Live in Beijing" $ #pause

#side-by-side[
$ V(S_a, pi) = 1032 $ 

][
$ V(S_b, pi) = 945 $ #pause
]

*Question:* Do you move to Macau or Beijing? #pause

If you knew your value function, you could live a perfect life #pause
- Look at two possibilities, pick the one with higher value #pause
- Maximum happiness throughout your life


= Exercise
==
- Think of two places you want to live after graduation $s_0 in {S_a, S_b}$ #pause
- Consider your behavior ($pi$) and what is important to you ($cal(R)$) #pause
- 3 life goals as states $S_x, S_y, S_z in G$ (e.g., friends, money, hobby, etc) #pause
- Assign a reward $cal(R)$ for each goal, and choose discount factor $gamma$ #pause

For each location $s_0 in { S_a, S_b }$: #pause
- Write probability of reaching goals $Pr (s_g | s_0; pi); s_g in {S_x, S_y, S_z} $ #pause
- Estimate time to accomplish each goal $t_g; g in {S_x, S_y, S_z}$  #pause

$ V(s_0, pi) =  sum_(s_g in {S_x, S_y, S_z}) gamma^(t_g) cal(R)(s_g) dot Pr (s_g | s_0; pi) $ #pause

Where should you live?

= Temporal Difference Value Functions
==

*Note:* We can write the value function in different ways #pause
- Always approximates the expected discounted return starting from $s_0$ #pause

We call the following equation the *Monte Carlo* value function 

$ V(s_0, pi) =  sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi) $ #pause

Difficult to compute the Monte Carlo value function #pause
- How can we compute an infinite sum!? #pause
    - Trajectory optimization truncated sum, creating suboptimal $pi$ #pause
    - Let's see if there is a better solution, try to rewrite infinite sum

==

$ V(s_0, pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; pi) $ #pause

Factor out initial timestep $t=0$ out of the outer sum #pause

$ V(s_0, pi) = gamma^0 sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(t=1)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; pi) $

==

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(t=1)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; pi) $ #pause

Rewrite sum starting from $t=0$ #pause

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(t=0)^oo gamma^(t+1) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; pi) $

==

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(t=0)^oo gamma^(t+1) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; pi) $ #pause

Factor out $gamma$ #pause

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; pi) $

==

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; pi) $ #pause

Split $Pr$ using Markov property #pause

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) sum_(s_1) Pr (s_(t + 2) | s_(1); pi) Pr (s_(1) | s_0; pi) $

==
$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) sum_(s_1) Pr (s_(t + 2) | s_(1); pi) Pr (s_(1) | s_0; pi) $ #pause

Exchange sums #pause

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(s_1) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(1); pi) Pr (s_(1) | s_0; pi) $

==
$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(s_1) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(1); pi) Pr (s_(1) | s_0; pi) $ #pause

Now, we can pull out $Pr$ for first state

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(s_1) Pr (s_(1) | s_0; pi) dot gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(1); pi) $

==
$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(s_1) Pr (s_(1) | s_0; pi) dot gamma #pin(1)sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(1); pi)#pin(2) $ #pause

*Question:* What is this term? Hint: #pinit-highlight(1,2) #pause

$ V(s_0, pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) Pr (s_(t + 1) | s_0; pi) $ #pause

$ V(s_1, pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 2) in S) cal(R)(s_(t+2)) Pr (s_(t + 2) | s_1; pi) $

==

// TODO: Error here, where does P(s_1 | s_0; pi) go?

// ... (Everything above this is perfectly correct!)

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; pi) \ + sum_(s_1 in S) Pr (s_(1) | s_0; pi) dot gamma underbrace(sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(1); pi), V(s_1, pi)) $ #pause

Replace infinite sum with value function #pause

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) Pr (s_( 1) | s_0; pi) + sum_(s_ 1 in S) Pr (s_( 1) | s_0; pi) dot gamma V(s_1, pi) $

==

$ V(s_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) Pr (s_( 1) | s_0; pi) + sum_(s_ 1 in S) Pr (s_( 1) | s_0; pi) dot gamma V(s_1, pi) $ #pause

Both terms share a sum, random variable, and probability #pause

*Question:* $sum_(s_ 1 in S) Pr (s_( 1) | s_0; pi)$ is special, what is it? #pause

$ bb(E)[cal(X)] = sum_(omega in Omega) Pr(omega) dot cal(X)(omega) $ #pause

$ V(s_0, pi) = bb(E)[cal(R)(s_1)| s_0; pi] + bb(E)[gamma V(s_1, pi) | s_0; pi] $ #pause

$ V(s_0, pi) = bb(E)[cal(R)(s_1)| s_0; pi] + gamma bb(E)[V(s_1, pi) | s_0; pi] $


==

$ V(s_0, pi) = bb(E)[cal(R)(s_1)| s_0; pi] + gamma bb(E)[V(s_1, pi) | s_0; pi] $ #pause

This is a huge finding! #pause
- Value function has a recursive definition #pause
- Can represent infinite sum (return) with one addition #pause

We call this the *Temporal Difference* (TD) value function #pause
- Compute the return with a single transition $s_0 -> s_1$ #pause
- Evaluate infinite-depth decision tree with one function 

==
To summarize, the value function is the policy-conditioned return #pause

$ V(s_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0; pi] $ #pause

We can write it in Monte Carlo (MC) or Temporal Difference (TD) form #pause

#side-by-side(align: horizon)[Monte Carlo][
$
V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] 
$ #pause
]

#side-by-side[Temporal Difference][
$ V(s_0, pi) = &bb(E)[cal(R)(s_1)| s_0; pi] \ + gamma &bb(E)[V(s_1, pi) | s_0; pi] $
]

They produce the same result, but we compute them differently 


= Q Functions

==

We saw two forms of the value function #pause

But our goal was to find a policy, why did we find $V$? #pause
- Special connection between an optimal policy and the value function #pause
- We can modify the value function to find an optimal policy #pause
- We call the modified value function a Q function

==

Consider the Temporal Difference value function #pause

$ V(s_0, pi) = bb(E)[cal(R)(s_1)| s_0; pi] + gamma bb(E)[V(s_1, pi) | s_0; pi] $ #pause

We conditioned the value function on the policy 

$ bb(E)[cal(G)(bold(tau)) | s_0; pi] $ #pause

With trajectory optimization we conditioned on actions

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $ #pause

What if we wanted a mix of both?

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] $

==
$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] $ #pause

This expectation means: #pause
- Take a specific action $a_0$ (trajectory optimization) #pause
- Follow $pi (dot | s_t)$ for all future actions $a_1, a_2, dots$ (value function) #pause

We call this the *Q function* #pause

$ Q(s, a, pi) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] $ #pause

We can derive the Q function from the value function

==
$ V(s_0, pi) = bb(E)[cal(R)(s_1)| s_0; pi] + gamma bb(E)[V(s_1, pi) | s_0; pi] $ #pause

First step, our new function is called $Q$

$ Q(s_0, pi) = bb(E)[cal(R)(s_1)| s_0; pi] + gamma bb(E)[V(s_1, pi) | s_0; pi] $ #pause

$Q$ conditions on action $a_0$

$ V(s_0, a_0, pi) = bb(E)[cal(R)(s_1)| s_0, a_0; pi] + gamma bb(E)[V(s_1, pi) | s_0, a_0; pi] $ #pause

==
$ V(s_0, a_0, pi) = bb(E)[cal(R)(s_1)| s_0, a_0; pi] + gamma bb(E)[V(s_1, pi) | s_0, a_0; pi] $ #pause

*Question:* Does the expected reward rely on $pi$? #pause

*Answer:* No! $pi$ has no effect because we only consider action $a_0$! #pause
- The transition function is $Tr(s_1 | s_0, a_0)$, no need for $pi$ #pause

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[V(s_1, pi) | s_0, a_0; pi] $ #pause

We still have a $pi$ dependency in the second term #pause
- Let us see if we still need it

==
$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[V(s_1, pi) | s_0, a_0; pi] $ #pause

Unpack second term expectation #pause

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma sum_(s_1 in S) V(s_1, pi) dot Pr (s_1 | s_0, a_0; pi) $ #pause

Expectation does not rely on $pi$ because we take action $a_0$

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma sum_(s_1 in S) V(s_1, pi) dot Pr (s_1 | s_0, a_0) $ #pause

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[V(s_1, pi) | s_0, a_0] $ 

==
$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[V(s_1, pi) | s_0, a_0] $ #pause

Let's look at the second term once more #pause
- It is a value function conditioned on an action #pause
    - *Question:* Is there another name for this? #pause
    - The Q function! $V(s, pi) -> Q(s, a, pi)$ #pause

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0] $ #pause

*Problem:* Second term relies on $a_1$ but we only give $a_0$ as input!

*Solution:* Choose $a_1 tilde pi(dot | s_0)$

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0, pi] $ 

==
Let's compare $V$ to $Q$ #pause

$ V(s_0, pi) &= bb(E)[cal(R)(s_1) | s_0; pi] &&+ gamma bb(E)[V(s_1, pi) | s_0; pi] \ #pause

Q(s_0, a_0, pi) &= bb(E)[cal(R)(s_1) | s_0, a_0] &&+ gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0; pi] $ #pause

// TODO HIGHLIGHT FIRST TERM

They are almost the same #pause
- In fact, as we saw earlier we can write $Q$ in terms of $V$ #pause
- The only difference is $Q$ relies on an initial action $a_0$ #pause
    - This changes the expectation of the reward (very important)

= Greedy Q
==
$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0; pi] $ #pause
// New stuff
Why did we spend all this time to find $Q$? #pause
- We still do not have a policy $pi$ #pause
    - But now we can use $Q$ to find a policy #pause

Let us return to our example of value #pause
    - This time, we use $Q$ instead of $V$


==
$ s = "MS student in Macau" $
$ a_m= "Stay in Macau", a_b = "Move to Beijing" $ #pause

#side-by-side[
$ Q(s, a_m pi) = 1032 $ 

][
$ Q(S, a_b, pi) = 945 $ #pause
]

#side-by-side[
    $V$ tells us which state is better #pause
][
    $Q$ tells us which action is better #pause
]


*Question:* Do you move to Macau or Beijing? #pause

If you know your $Q$ function, you can always take the best action #pause
- Maximum happiness throughout your life

==
$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0; pi] $ 

The Q function tells us the *value of an action $a_0$* in state $s_0$ #pause

// TODO HIGHLIGHT

*Question:* How can we create a policy from the Q function? #pause

Hint: Evaluate $Q$ for every action: $Q(s_0, a_A, pi), Q(s_0, a_B, pi), dots$ #pause

$ pi(a | s) = cases(
    1 "if" a = argmax_(a_0 in A) Q(s, a_0, pi),
    0 "otherwise"
) $ #pause

This is an optimal greedy policy

==
$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0; pi] $ #pause

$ pi(a | s) = cases(
    1 "if" a = argmax_(a_0 in A) Q(s, a_0, pi),
    0 "otherwise"
) $ #pause

$Q$ relies on $pi$, and $pi$ relies on $Q$ #pause
- Now that we know $pi$, we can simplify/rewrite $Q$ #pause

*Question:* How? #pause // TODO Highlight argmax above for hint

$ Q(s_0, a_0) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0] $ #pause

==

$ Q(s_0, a_0) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0] $ #pause

This is a very powerful equation #pause
- Compute $Q(s_0, a_0)$ for all $a_0$ #pause
- Pick the $a_0$ that maximizes $Q(s_0, a_0)$ #pause
- This $a_0$ is *guaranteed* to be the optimal action #pause

This considers the effect of $a_0$ on the *infinite* future #pause

= Q Learning

==
With greedy $Q$, we can introduce the $Q$ learning algorithm #pause
```python
Q = initialize()
for epoch in epochs:
    # Collect dataset from traversing MDP
    E = collect_episode(Q)
    # Update Q function to improve accuracy
    Q = update(E, Q)
```

Q learning is an iterative *model-free* algorithm #pause

#side-by-side[
  *Model-based* #pause

  We know $Tr(s_(t+1) | s_t, a_t)$ #pause

  Cheap to train, expensive to use #pause
][
  *Model-free* #pause
  
  We do not know $Tr(s_(t+1) | s_t, a_t)$  #pause

  Expensive to train, cheap to use 
]

==

Q learning is old but still popular today #pause
- Discovered in 1989 by Watkins #pause
- Works well with deep neural networks #pause
- Researchers are still improving it#footnote[_Simplifying Deep Temporal Difference Learning._ ICLR. 2024.] #footnote[_Exclusively Penalized Q-Learning for Offline Reinforcement Learning._ NeurIPS. 2025.] #pause
- Our lab is using it in our research right now 


==
$ Q(s_0, a_0) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0] $ #pause

$ pi(a | s) = cases(
    1 "if" a = argmax_(a_0 in A) Q(s, a_0, pi),
    0 "otherwise"
) $ #pause

In $Q$ learning, we focus on learning $Q$ #pause
- If we find the $Q$ function, we find an optimal policy: $argmax_(a) Q(s, a)$


==
We have an equality we can use to learn $Q$ #pause

$ Q(s_0, a_0) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0] $ #pause

Move $Q$ to the right hand side, their sum should be zero #pause

$ 0 = Q(s_0, a_0) - (bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0]) $ #pause

If the sum is nonzero, then $Q$ has error $eta$ #pause

$ eta = Q(s_0, a_0) - (bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0]) $ 

==
$ eta = Q(s_0, a_0) - (bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0]) $ #pause

We can use the error $eta$ to improve $Q$ with learning rate $alpha$ #pause

$ Q_(i+1)(s_0, a_0) = Q_(i)(s_0, a_0) - alpha dot eta $ #pause

$Q_(i+1)$ will converge to zero error #pause

$ lim_(i -> oo) eta = 0 $ #pause

Then we learned a perfect $Q$!

==
$ eta = Q(s_0, a_0) - (bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a_1 in A) Q(s_1, a_1) | s_0, a_0]) $ #pause

*Question:* There are expectations here, how do we evaluate this error? #pause

*Answer:* Approximate expectation with samples (like bandits) #pause

#side-by-side(align: horizon)[
    $ bold(E) = mat(s_0, a_0, r_0, d_0; s_1, a_1, r_1, d_1; s_2, a_2, r_2, d_2; dots.v, dots.v, dots.v, dots.v) $ #pause
][
    *Recall:* $r_t = cal(R)(s_(t+1))$, \ $d_t=1$: $s_(t+1)$ is terminal state #pause
]

$ eta = Q(s_t, a_t) - r_t + gamma max_(a in A) Q(s_(t+1), a) $ 

==

$ eta = Q(s_t, a_t) - r_t + gamma max_(a in A) Q(s_(t+1), a) $ #pause

We use terminal states to accelerate training #pause
- In a terminal state ($d=1$), we know the future return is zero #pause

$ eta = Q(s_t, a_t) - r_t + not d gamma max_(a in A) Q(s_(t+1), a) $

==
*Definition:* Temporal Difference Q Learning #pause

Given some training data 

$ bold(E) = mat(s_0, a_0, r_0, d_0; s_1, a_1, r_1, d_1; dots.v, dots.v, dots.v, dots.v) $ #pause

We iteratively update $Q$ via the following objective until convergence #pause 

$ Q_(i+1)(s_t, a_t) &= Q_(i)(s_t, a_t) - alpha dot eta \ #pause
eta &= Q(s_t, a_t) - r_t + not d gamma max_(a in A) Q(s_(t+1), a) $ #pause

with learning rate $alpha$

==
*Definition:* Monte Carlo Q Learning #pause

Given some training data 

$ bold(E) = mat(s_0, a_0, r_0, d_0; s_1, a_1, r_1, d_1; dots.v, dots.v, dots.v, dots.v) $ #pause

We iteratively update $Q$ via the following objective until convergence #pause 

$ Q_(i+1)(s_t, a_t) &= Q_(i)(s_t, a_t) - alpha dot eta \ #pause
eta &= Q(s_t, a_t) - sum_(k=t)^oo not d gamma^k r_k $ 

==
Last thing, we must collect episodes to train Q! #pause
- Must run policy in environment to collect episodes #pause

```python
states, next_states, rewards, terminateds = [], [], [], []
state = environment.reset()
while not terminated:
    action = policy.sample(state)
    next_state, reward, terminated = environment.step(action)

    states.append(state), next_states.append(next_state), ...
    state = next_state

episode = (states, next_states, rewards, terminateds)
```

==
What policy do we sample actions from? #pause

$ pi (a_t | s_t) = cases(
    1 "if" a_t = argmax_(a in A) Q(s_t, a_0),
    0 "otherwise"
) $ #pause

*Question:* Any issues? #pause

*Answer:* Always sample the same action (exploit, no exploration) #pause

If Q function is wrong, always sample bad actions #pause
- Without correct actions, Q function will not improve! #pause

*Question:* What can we do?

==
$ pi (a_t | s_t) = cases(
    1 "if" a_t = argmax_(a in A) Q(s_t, a_0),
    0 "otherwise"
) $ #pause

Epsilon greedy policy! #pause

$ pi (a_t | s_t) = cases(
    (1 - epsilon) "if" a_t = argmax_(a in A) Q(s_t, a),
    epsilon / (|A|) "for" a in A
) $ #pause

Sample random action with probability $epsilon$ #pause
- In the limit, we sample all possible actions in all states

==

Can we visualize Q learning? #pause

Navigation example, reward of 1 for reaching center tile #pause

https://user-images.githubusercontent.com/1883779/113412338-97430100-93d5-11eb-856c-ef0f420d1acb.gif #pause

// https://mohitmayank.com/interactive_q_learning/q_learning.html

==

So far: #pause
- Defined training objective (TD and MC updates) #pause
- Defined dataset (episodes) #pause
- Need to define model (Q function)! #pause

Next time, we will use deep neural networks #pause

Today and for homework, use a simple matrix

==
Model the Q function as a matrix #pause

Each state is a row, each action is a column in a matrix #pause

$
mat(
    Q(S_1, A_1), Q(S_1, A_2), dots;
    Q(S_2, A_1), Q(S_2, A_2), dots;
    dots.v, dots.v, dots.down, 
)
$ #pause

$Q_(i,j)$ gives Q value for state $s=S_i$ and action $a=A_j$

= Homework

==
You have everything you need to solve homework #pause

Due in 13 days (Weds 15 March, 23:59) #pause

Download and submit `.py` and `.ipynb` files #pause

Uses turnitin for checking #pause

https://colab.research.google.com/drive/1xtBxAaVc3ax6_j59RC3NLQQPFcIEoau-?usp=sharing