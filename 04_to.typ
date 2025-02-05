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
    title: [Trajectory Optimization],
    subtitle: [CISC 7404 - Decision Making],
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

= Exam

= Review

= Trajectory Optimization

==
https://www.youtube.com/watch?v=3FNPSld6Lrg

https://www.youtube.com/watch?v=6qj3EfRTtkE

==
The goal of this course is to learn to maximize the discounted return 

Today, we will see some methods to do this 

This is my favorite lecture, because things are still simple

Some of these ideas are very old, but in the last 1-2 years we revisit them with more compute

Dreamer video

==
Want to select best decisions/actions 

Best means maximize the return 

How can we write how our actions influence the return?

Start with the reward, move on to return

==

Given a state $s_t$ and action $a_t$, what does the reward look like?

First, write the reward function

$ R(s_(t+1)) $ // TODO: Maybe define s' here

What are all possible rewards?

$ {R(s_(t+1)) | s_(t+1) in S} $

This is not true (example figure)

We do not consider our current state $s_t$ or an action $a_t$!

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
  })
][
  $ {R(s_(t+1)) | s in S} = \ {R("Healthy"), R("Sick"), R("Dead")} $

  If $s_t = "Healthy"$? Can we still have a "Dead" reward?

  No, because the state transition function does not allow this

  $ P("Dead" | "Healthy") = 0 $

  $ P("Dead" | "Sick" ) > 0 $
]

==

The reward depends on the state transition function

$ T(s_t, a_t) = Pr(s_(t+1) | s_t, a_t) $ 

$ s_(t+1) tilde T(s_t, a_t) $

$ R(s_(t+1)) $

$ { R(s_(t+1)) | s_(t+1) ~ T(s_t, a_t) } $

==


But we care about the rewards we can get with the current state/action $s_t, a_t$

How can we write this? Use the state transition function

//But we said that the reward depends on $s_t, a_t$, this reward function does not depend on anything




==

#side-by-side[
  $ Pr(s_(t+1) | s_t, a_t) $
][
  $ { R(s_(t+1)) | s_(t+1) ~ T(s_t, a_t) } $
]

How can we combine these in a meaningful way?

What if we compute the mean reward for a given action? 

*Question:* How can we do this?

*Answer:* Take the expectation

$ bb(E): underbrace((Omega |-> bb(R)), "random variable") |-> bb(R) $ #pause

$ bb(E)[cal(X)] = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ #pause

==
#side-by-side[
  $ Pr(s_(t+1) | s_t, a_t) $
][
  $ { R(s_(t+1)) | s_(t+1) ~ T(s_t, a_t) } $
]
$ bb(E)[cal(X)] = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ 

We can write the expected reward because $R$ is a random variable 

The outcome space $Omega = S$

$ bb(E) [R(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

The expectation of the random variable $R$ *conditioned* on $s_t, a_t$

==

$ bb(E) [R(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

*Question:* How can we use this to find a good action?

*Answer:* We can find the action that gives us the best reward (on average)

$ argmax_(a_t in A) space bb(E) [R(s_(t+1)) | s_t, a_t] = argmax_(a_t in A) sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $ 

But in RL, we do not maximize the reward

*Question:* What do we maximize?
*Answer:* The discounted return

==

What we have

$ bb(E) [R(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

What we want

$ bb(E) [G(bold(tau)_n) | s_0, a_0, a_1, dots, a_n] = ? $

What we need

$ Pr(s_t | s_0, a_0, a_1, a_2, dots a_(t-1)) $

==

$ Pr(s_1 | s_0, a_0) $
$ Pr(s_2 | s_0, a_0, a_1) = Pr(s_2 | s_1, a_1) Pr(s_1 | s_0, a_0) $
$ Pr(s_t | s_0, a_0, a_1, dots a_t) &= Pr(s_t | s_(t-1)) dots Pr(s_2 | s_1, a_1) Pr(s_1 | s_0, a_0) \
&= 
 $


==
$ bb(E) [G(bold(tau)_n) | s_0, a_0, a_1, dots, a_n] = ? $

Plug in definition of discounted return

$ bb(E) [G(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[R(s_(t+1))] $

==

*Goal:* Given an initial state and some actions, predict the expected discounted return #pause

Let's start with a trajectory of length 1 

$ bb(E) [R(s_1) | s_0, a_0] = sum_(s_(1) in S) R(s_(1)) Pr(s_(1) | s_0, a_0) $ 

$ bb(E) [R(s_2) | s_0, a_0, a_1] = sum_(s_(2) in S) R(s_(2)) Pr(s_(2) | s_1, a_1) sum_(s_(1) in S) Pr(s_(1) | s_0, a_0) $


$ bb(E) [R(s_(n + 1)) | s_0, a_0, a_1, dots a_n] = R(s_(n)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Pr(s_(t+1) | s_t, a_t) $

==

==

$ bb(E) [R | s_t, a_t] = sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

$ G = sum_(t=0)^oo gamma^t R(s_(t+1)) $

$ bb(E)[G | ?] = bb(E)[sum_(t=0)^oo gamma^t R(s_(t+1)) mid(|) ? ] $
The expectation is linear, so 

$ bb(E)[G | ?] = sum_(t=0)^oo gamma^t bb(E)[R | s_t, a_t] $

$ bb(E)[G | ?] = sum_(t=0)^oo gamma^t bb(E)[R | s_t, a_t] $

$ bb(E)[G | ?] = sum_(t=0)^oo gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

==
$ J(a_0, a_1, dots) = bb(E)[G | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

This expression gives us the *expected discounted return* $J$

*Question:* How can we maximize $J$?

$ argmax_(a_0, a_1, dots in A) J(a_0, a_1, dots) = argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

==

$ argmax_(a_0, a_1, dots in A) J(a_0, a_1, dots) = argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

In RL, we call this *trajectory optimization* 

*Question:* What do we need to know about the problem to use trajectory optimization? 

*Answer:*
- Must know the reward function $R$
- Must know the state transition function $T=Pr(s_(t+1) | s_t, a_t)$




==
$ argmax_(a_0, a_1, dots in A) J(a_0, a_1, dots) = argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

*Approach:* Try all possible actions sequences and pick the one with the best return

*Question:* Any problem?

*Answer:* $a_0, a_1, dots$ is infinite, how can we try infinitely many actions?

We can't

==

$ argmax_(a_0, a_1, dots in A) J(a_0, a_1, dots) = argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

In trajectory optimization, we must introduce a *horizon* $n$

$ argmax_(a_0, a_1, dots, #redm[$a_n$] in A) J(a_0, a_1, dots, #redm[$a_n$]) = \ argmax_(a_0, a_1, dots #redm[$a_n$] in A) sum_(t=0)^#redm[$n$] gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

Now, we can perform a search/optimization

==
$ argmax_(a_0, dots, a_n in A) J(a_0, dots, a_n) = argmax_(a_0, dots a_n, in A) sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

*Question:* What are the consequences of using a finite horizon $n$?

*Answer:* 
- Our model can only consider rewards $n$ steps into the future
- Actions will *not* be optimal

In certain cases, we do not care much about the distant future

==
$ argmax_(a_0, dots, a_n in A) J(a_0, dots, a_n) = argmax_(a_0, dots a_n, in A) sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

For example, we often use trajectory optimization to avoid crashes

If we can avoid any crash in 10 actions, then $n = 10$ is enough for us

One application of trajectory optimization:

https://www.youtube.com/watch?v=6qj3EfRTtkE

==
$ argmax_(a_0, dots, a_n in A) J(a_0, dots, a_n) = argmax_(a_0, dots a_n, in A) sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

How do we optimize $J$ in practice?

- Try all possible sequences $a_0, dots, a_n$, pick the best one
- Randomly pick some sequences, pick the best one
- Use gradient descent to find $a_0, dots, a_n$
  - *Note:* The state transition function and reward function must be differentiable

= Policies

==
With trajectory optimization, we plan all of our actions at once

$ argmax_(a_0, a_1, dots in A) J(a_0, a_1, dots) = argmax_(a_0, a_1, dots a_n in A) sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

It is difficult to think about many actions and states at once

==

To simplify, we introduce the *policy* $pi$ with parameters $theta in Theta$

$ pi: S times Theta |-> Delta A $

$ Pr (a | s; theta) $

It maps a current state to a distribution of actions

The policy determines the behavior of our agent, it is the "brain" 


==

$ J(a_0, a_1, dots) = sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

We can rewrite the expected return using the policy $pi$ and parameters $theta$

$ J(theta) = sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t ; theta) $

==
$ argmax_(a_0, a_1, dots in A) J(a_0, a_1, dots) = argmax_(a_0, a_1, dots a_n in A) sum_(t=0)^n gamma^t sum_(s_(t+1) in S) R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $


In controls and robotics, we call this *model-predictive control* (MPC)

Where do we use trajectory optimization/MPC?

https://www.youtube.com/watch?v=Kf9WDqYKYQQ

==
Trajectory optimization is expensive

The optimization process requires us to simulate thousands/millions of possible trajectories

However, as GPUs get faster these methods become more interesting





// $ argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

TODO: Visualization

TODO: What is the state transition function


//= Conditional Returns 

= Value Functions