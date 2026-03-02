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

// TODO: Optimal policy derivation from Q doesn't make sense
// TODO: Derivation of max Q as value function doesn't make sense
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

We can write it in Monte Carlo form or Temporal Difference form #pause

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

= Q Learning
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
$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, pi] $ #pause

The Q function tells us the *value of an action* #pause
- In state $s_0$ #pause
- If we follow $pi ( a | s)$ afterwards #pause

// TODO HIGHLIGHT

*Question:* How can we create a policy from the Q function? #pause

Hint: Evaluate $Q$ for every action: $Q(s_0, a_A, pi), Q(s_0, a_B, pi), dots$ #pause

$ pi(a | s) = cases(
    1 "if" a = argmax_(a_0 in A) Q(s, a_0, pi),
    0 "otherwise"
) $ #pause

This is an optimal greedy policy

==

$ argmax_(a_0 in A) Q(s_0, a_0, pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, pi) ) $ #pause

This is a very powerful equation #pause
- Compute $Q(s_0, a_0)$ for all $a_0$ #pause
- Pick the $a_0$ that maximizes $Q(s_0, a_0)$ #pause
- This $a_0$ is *guaranteed* to be the optimal action #pause

This considers the effect of $a_0$ on the *infinite* future #pause

We collapsed the infinite decision tree into a single level

==

#text(size: 22pt)[#traj_opt_tree]

==

#text(size: 22pt)[#q_opt_tree]

/*
==

//$ V(s_0, pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; pi) $
$ V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

==
$ V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

Pull first term out of sum 

$ V(s_0, pi) = gamma^0 bb(E)[R(s_1) | s_0; pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

Provide $a_0$ and condition on it

$ V(s_0, pi, a_0) = gamma^0 bb(E)[R(s_1) | s_0, a_0] + sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

$ Q(s_0, pi, a_0) = gamma^0 bb(E)[R(s_1) | s_0, a_0] + sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $


$ Q(s_0, a_0, pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Tr (s_( 1) | s_0, a_0) \ + sum_(s_1) Pr (s_(1) | s_0; pi) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); pi) $
*/

//= SARSA

= Q Learning

==
// Intro of Q learning (model-free, etc)
// Found q equation, but not clear how to train it
// Furthermore, relies on value function which we don't know
// Bellman equation
// off-policy depends on which value function

Q learning is a *model-free* algorithm first discovered in the 1980s #pause

#side-by-side[
  *Model-based* #pause

  We know $Tr(s_(t+1) | s_t, a_t)$ #pause

  Cheap to train, expensive to use #pause

  Closer to traditional control theory #pause
][
  *Model-free* #pause
  
  We do not know $Tr(s_(t+1) | s_t, a_t)$  #pause

  Expensive to train, cheap to use #pause

  Closer to deep learning #pause
]
==

Q learning is still popular today #pause

Works well with deep neural networks #pause

Researchers are still improving it#footnote[_Simplifying Deep Temporal Difference Learning._ ICLR. 2024.] #footnote[_Exclusively Penalized Q-Learning for Offline Reinforcement Learning._ NeurIPS. 2025.] #pause

In fact, our lab is using it in our research right now #pause

We now have all the information we need to implement Q learning

==

Our Q function relies on the value function for some $pi$ #pause

Right now, it is not clear what the policy is #pause

So how can we use the Q function without knowing the policy? #pause

Let us find out

==
Start with the Q function #pause

$ Q(s_0, a_0, pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, pi) $ #pause

We want to take the action that maximizes Q #pause

$ argmax_(a_0 in A) Q(s_0, a_0, pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, pi) ) $ #pause

Recall Monte Carlo value function #pause

$ V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

==
// TODO: Rewrite below using MC return
// See that all previous actions are the same for E[r_1], E[r_2], ...

$ argmax_(a_0 in A) Q(s_0, a_0, pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, pi) ) $

$ V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $ #pause

Take optimal action $a_0$, now must find optimal $a_1$ #pause

$ argmax_(a_1 in A) Q(s_1, a_1, pi) = argmax_(a_1 in A) ( bb(E)[cal(R)(s_2) | s_1, a_1] + gamma V(s_2, pi) ) $ #pause

Take optimal action $a_1$, now must find optimal $a_2$ #pause

$ argmax_(a_2 in A) Q(s_2, a_2, pi) = argmax_(a_2 in A) ( bb(E)[cal(R)(s_3) | s_2, a_2] + gamma V(s_3, pi) ) $

==

$ argmax_(a_0 in A) Q(s_0, a_0, pi) = argmax_(a_0 in A) ( bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, pi) ) $

$ argmax_(a_1 in A) Q(s_1, a_1, pi) = argmax_(a_1 in A) ( bb(E)[cal(R)(s_2) | s_1, a_1] + gamma V(s_2, pi) ) $

$ argmax_(a_2 in A) Q(s_2, a_2, pi) = argmax_(a_2 in A) ( bb(E)[cal(R)(s_3) | s_2, a_2] + gamma V(s_3, pi) ) $

There is a pattern. What policy causes this pattern? #pause

$ pi (a_0 | s_0; pi) = cases(
    1 "if" a_0 = argmax_(a in A) Q(s_0, a, pi),
    0 "otherwise"
) $


==
$ pi (a_0 | s_0; pi) = cases(

    1 "if" a_0 = argmax_(a in A) Q(s_0, a, pi),
    0 "otherwise"
) $ #pause

The policy uses the Q function #pause

$ Q(s_0, a_0, pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma underbrace(V(s_1, pi), "Following" pi) $ #pause

The Q function uses the policy #pause

*Question:* Can we simplify the Q function using the policy? #pause

$ V(s_0, pi) = max_(a in A) Q(s_0, a, pi) $ 

==
$ pi (a_0 | s_0; pi) = cases(

    1 "if" a_0 = argmax_(a in A) Q(s_0, a, pi),
    0 "otherwise"
) $

$ Q(s_0, a_0, pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, #pin(1)pi#pin(2)) $ 

$ V(s_0, pi) = max_(a in A) Q(s_0, a, pi) $ #pause

Replace $V$ with $Q$ #pause

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, pi) $ 

==

*Definition:* In Temporal Difference Q learning, we learn $Q$ using #pause

$ Q(s_0, a_0, pi) =  bb(E)[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, pi) $ #pause

*Definition:* In Monte Carlo Q learning, we learn $Q$ using #pause

$ Q(s_0, a_0, pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + #pin(1)sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_1; pi]#pin(2) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 1.2em)[Return following $pi$] 

==
$ Q(s_0, a_0, pi) =  #pin(1)bb(E)[cal(R)(s_1) | s_0, a_0]#pin(2) + gamma max_(a in A) Q(s_1, a, pi) $ 

$ Q(s_0, a_0, pi) = #pin(3)bb(E)[cal(R)(s_1) | s_0, a_0]#pin(4) + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_1; pi] $ #pause

If we want to learn the left hand side, we must know the right hand side #pause

*Question:* How do we find these terms? #pinit-highlight(1, 2) #pinit-highlight(3, 4)

==
$ Q(s_0, a_0, pi) =  #pin(1)hat(bb(E))[cal(R)(s_1) | s_0, a_0]#pin(2) + gamma max_(a in A) Q(s_1, a, pi) $ 

$ Q(s_0, a_0, pi) = #pin(3)hat(bb(E))[cal(R)(s_1) | s_0, a_0]#pin(4) + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_1; pi] $ 

*Question:* How do we find these terms? #pinit-highlight(1, 2) #pinit-highlight(3, 4)

*Answer:* Empirical expectation from episode data ($s_t, a_t, cal(R)(s_(t+1))$) #pause

$ bold(E) = mat(s_0, s_1, s_2, dots; a_0, a_1, a_2, dots; r_0, r_1, r_2, dots)^top $

//Take action $a_t$ in state $s_t$ and receive reward $cal(R)(s_(t+1))$

==
$ Q(s_0, a_0, pi) =  hat(bb(E))[cal(R)(s_1) | s_0, a_0]+ #pin(1)gamma max_(a in A) Q(s_1, a, pi)#pin(2) $ 

$ Q(s_0, a_0, pi) = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + #pin(3)sum_(t=1)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_1; pi]#pin(4) $ #pause

#side-by-side[*Question:* How to find these terms? #pinit-highlight(1, 2) #pinit-highlight(3, 4) #pause][
$ bold(E) = mat(s_0, s_1, s_2, dots; a_0, a_1, a_2, dots; r_0, r_1, r_2, dots)^top $ #pause
]


#side-by-side[
    *TD:* $gamma max_(a in A) Q(s_(t+1), a, pi) $ #pause
][
    *MC:* $gamma r_(t+1) + gamma^2 r_(t+2) + dots$ #pause
]

We know the right hand side, use it to learn the left hand side

==

$ Q(s_0, a_0, pi) &=  hat(bb(E))[cal(R)(s_1) | s_0, a_0]+ not d gamma max_(a in A) Q(s_1, a, pi) \

Q(s_0, a_0, pi) &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + sum_(t=1)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_1; pi] $ #pause

Assume $Q (s, a, pi)$ has error $eta$ with right hand side #pause

Use the error to update the Q function #pause

$ Q_(i + 1)(s, a, pi) = Q_i (s, a, pi) - eta $ #pause

Improve convergence with a learning rate $alpha$ #pause

$ Q_(i + 1)(s, a, pi) = Q_i (s, a, pi) - alpha dot eta $

==
*Monte Carlo update:* #pause

$ Q_(i+1)(s_0, a_0, pi) = Q_(i)(s_0, a_0, pi) - alpha dot eta $ #pause

The error $eta$ is the difference between true and predicted value #pause

#v(1em)

$ eta = #pin(1)Q_(i)(s_0, a_0, pi)#pin(2) - #pin(3) (hat(bb(E)) #pin(5) [cal(R)(s_1) | s_0, a_0] + sum_(t=1)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_1; pi]) #pin(4) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Predicted value] #pause

#pinit-highlight-equation-from((3,4), (5), fill: blue, pos: bottom, height: 1.2em)[Empirical value] #pause

If we visit all $s, a in S times A$, guaranteed convergence to true Q function #pause

$lim_(i -> oo) eta = 0$

==
*Temporal Difference update:* #pause

$ Q_(i+1)(s_0, a_0, pi) = Q_(i)(s_0, a_0, pi) - alpha dot eta $ #pause

The error $eta$ is the difference between true and predicted value #pause

#v(1em)

$ eta = #pin(1)Q_(i)(s_0, a_0, pi)#pin(2) - #pin(3) (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + #redm[$not d$] gamma max_(a in A) Q_i (s_1, a, pi)) #pin(4) $ #pause

#text(fill: red)[小心!] If $s_1$ is a terminal state, future value is 0 ($not d="not terminated"$) #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Predicted value] #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: bottom, height: 1.2em)[Empirical value] #pause

If we visit all $s, a in S times A$, guaranteed convergence to true Q function #pause

$lim_(i -> oo) eta = 0$

==

Last thing, we must collect episodes to train Q! #pause

Can run policy in environment to create episodes #pause

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

$ pi (a_0 | s_0; pi) = cases(

    1 "if" a_0 = argmax_(a in A) Q(s_0, a, pi),
    0 "otherwise"
) $ #pause

*Question:* Any issues? #pause

*Answer:* Always sample the same action (exploit, no exploration) #pause

If Q function is wrong, always sample bad actions #pause

Without correct actions, Q function will not improve! #pause

*Question:* What can we do?

==
$ pi (a_0 | s_0; pi) = cases(

    1 "if" a_0 = argmax_(a in A) Q(s_0, a, pi),
    0 "otherwise"
) $ #pause

Epsilon greedy policy! #pause

$ pi (a_0 | s_0; pi) = cases(
    (1 - epsilon) "if" a_0 = argmax_(a in A) Q(s_0, a, pi),
    epsilon / (|A|) "for" a in A
) $ #pause

Sample random action with probability $epsilon$ #pause

In the limit, we sample all possible actions in all states

==

Can we visualize Q learning? #pause

Navigation example, reward of 1 for reaching center tile #pause

https://user-images.githubusercontent.com/1883779/113412338-97430100-93d5-11eb-856c-ef0f420d1acb.gif #pause

https://mohitmayank.com/interactive_q_learning/q_learning.html

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

Due in 2 weeks (Weds 12 March, 23:59) #pause

Download and submit `.py` and `.ipynb` files #pause

Uses turnitin for checking #pause

https://colab.research.google.com/drive/1xtBxAaVc3ax6_j59RC3NLQQPFcIEoau-?usp=sharing



/*
= Value Objectives

==
$ 
V(s_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0; pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; pi)
$

*Idea:* Instead of computing the tree, can we learn to approximate it?


$ V(s_0, pi, pi_V) = bb(E)[cal(G)(bold(tau)) | s_0; pi]; quad bold(tau) in (S times A)^n $

*Question:* How can we learn $Theta_V$ such that it becomes the true $V$ function?

*Answer:* Mean square error

$ V(s_0, pi, pi_V) - bb(E)[cal(G)(bold(tau)) | s_0; pi] = 0 $

==

TODO: Expectation, so we can learn from samples

$ V(s_0, pi, pi_V) - bb(E)[cal(G)(bold(tau)) | s_0; pi] = 0 $

$ (V(s_0, pi, pi_V) - bb(E)[cal(G)(bold(tau)) | s_0; pi])^2 = 0 $

$ argmin_(pi_V) (V(s_0, pi, pi_V) - bb(E)[cal(G)(bold(tau)) | s_0; pi])^2 $

$ argmin_(pi_V) sum_(s_0 in S) (V(s_0, pi, pi_V) - bb(E)[cal(G)(bold(tau)) | s_0; pi])^2 $

We do not know $bb(E)[cal(G)(bold(tau)) | s_0; pi]$?

*Question:* What can we do when we do not know an expectation? (Hint: Bandits)

*Answer:* Approximate the expectation by playing!

$ argmin_(pi_V) sum_(s_0 in S) (V(s_0, pi, pi_V) - hat(bb(E))[cal(G)(bold(tau)) | s_0; pi])^2 $


+ Run our policy in the environment
+ Collect a trajectory $bold(tau)$
// + Create subtrajectories $bold(tau)_(0:), bold(tau)_(1:), dots $
+ Compute the return of the trajectory $cal(G)(bold(tau))$
+ Now we have $hat(bb(E))_1[cal(G)(bold(tau)) | s_0, pi]$
+ Repeat to improve estimate! $hat(bb(E))_k [cal(G)(bold(tau)) | s_0, pi]$

==

$ argmin_(pi_V) sum_(s_0 in S) (V(s_0, pi, pi_V) - hat(bb(E))[cal(G)(bold(tau)) | s_0; pi])^2 $


+ Run our policy in the environment
+ Collect a trajectory $bold(tau)$
// + Create subtrajectories $bold(tau)_(0:), bold(tau)_(1:), dots $
+ Compute the return of the trajectory $cal(G)(bold(tau))$
+ Now we have $hat(bb(E))_1[cal(G)(bold(tau)) | s_0, pi]$
+ Repeat to improve estimate! $hat(bb(E))_k [cal(G)(bold(tau)) | s_0, pi]$

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
    action_distribution = policy(s, pi)
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
pi_V = jnp.zeros(len(S))
def V(state, pi, pi_V):
    return pi_V[state]

def update_V(states, returns, pi, pi_V, alpha=0.01):
    for s, g in zip(states, returns):
        pi_V[s] +=  alpha * (g - V(s, pi, pi_V))
    return pi_V

# Update_V using trajectories and returns
```
*/
/*
==


But they will *always* approximate
$ 
V(s_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0; pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; pi)
$

For example

$ V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, pi] $
==

$ Pr (s_(n+1) | s_0; pi) &= sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; pi) \
 
bb(E)[cal(G)(bold(tau)) | s_0; pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi)
$

We call the policy-conditioned return the *value function*

$ 
V(s_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0; pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi)
$

The value function tells us how valuable a state $s_0$ is for the policy
*/



/*
==

$ V(s_0, pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

Factor out initial timestep

$ V(s_0, pi) = gamma^0 bb(E)[cal(R)(s_(1)) | s_0; pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

$gamma$ goes away

$ V(s_0, pi) = bb(E)[cal(R)(s_(1)) | s_0; pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

==
$ V(s_0, pi) = bb(E)[cal(R)(s_(1)) | s_0; pi] + sum_(t=1)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

Factor out another gamma

$ V(s_0, pi) = bb(E)[cal(R)(s_(1)) | s_0; pi] + gamma sum_(t=1)^oo gamma^(t-1) bb(E)[cal(R)(s_(t+1)) | s_0; pi] $

Change sum index

$ V(s_0, pi) = bb(E)[cal(R)(s_(1)) | s_0; pi] + gamma sum_(t=0)^oo gamma^(t) bb(E)[cal(R)(s_(t+2)) | s_0; pi] $

==
$ V(s_0, pi) = bb(E)[cal(R)(s_(1)) | s_0; pi] + gamma sum_(t=0)^oo gamma^(t) bb(E)[cal(R)(s_(t+2)) | s_0; pi] $

*/



/*
= Monte Carlo Tree Search

==
*Question:* Why is Prof. Steven showing these stupid equations again?

We have already seen the expected return many times 

All you did was change the silly notation

$ 
bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] => 
bb(E)[cal(G)(bold(tau)) | s_0; pi]
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

$ bb(E)[cal(G)(bold(tau)) | s_0, pi] $

*Answer:* Only consider actions with support under the policy

Let us do an example to build intuition

//If policy has action with probability one, then $O(|S| dot 1)^n$

//*Question:* Can we think of any policies like this?

==
*Example:*

Imagine we found an ok policy, maybe from copying a human

$ pi (a_t | s_t; pi) =  cases( 
  0.8 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, pi], 
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
$ pi (a_t | s_t; pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, pi], 
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
$ Pr (s_(n+1) | s_0; pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; pi) ) $

$ 
bb(E)[cal(G)(bold(tau)) | s_0; pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr(s_(n + 1) | s_n, a_n)
$

//product_(t=0)^n [ sum_(s_(t+1) in S) sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) pi (a_t | s_t; pi)] $

This is a process:
+ Given the state, compute the action distribution $pi (a_t | s_t; pi)$
+ Given the action distribution, compute the next state distribution $Tr(s_(t+1) | s_t, a_t)$
+ Given the next state distribution, compute the reward distribution $R(s_(t+1))$
*/