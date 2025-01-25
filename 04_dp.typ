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
    title: [Dynamic Programming],
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

$ R(s_(t+1)) $

What are all possible rewards?

$ {R(s_(t+1)) | s_(t+1) in S} $

We do not consider our current state $s_t$ or an action $a_t$!


But we care about the rewards we can get with the current state/action $s_t, a_t$

How can we write this? Use the state transition function

//But we said that the reward depends on $s_t, a_t$, this reward function does not depend on anything


==
Given $s_t, a_t$, how do we get $s_(t+1)$?

$ s_(t+1) tilde T(s_t, a_t) = Pr(s_()) $




==

How do we get $s_(t+1)$ ?

$ Pr(s_(t+1) | s_t, a_t) $

Combine

$ { R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) | s_(t+1) in S } $ 

The *reward* we get

==
$ R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

Type signature?

$ R: S |-> bb(R), quad T: S times A |-> Delta S $

$ S times A |-> R times Delta S $

Each possible next state $s_(t+1) in S$ has some reward associated with it

$ P(S_a) dot R(s_a), P(S_b) dot R(S_b), dots $

TODO: Make this an expectation by summing

==
What is $R()$? A random variable $Omega |-> bb(R)$

$ bb(E)_(s_(t+1) ~ Pr(dot | s_t, a_t )) [R(s_(t+1))] $



==
Return is a distribution, not a scalar 

Return distribution
$ sum_(t=0)^oo gamma^t R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

$ sum_(t=0)^oo sum_(s_(t+1) in S) gamma^t R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $


TODO: Describe r=scalar, Pr = distribution

Show types $ A^* times S |-> bb(R) times Delta S $

Where have we seen this before? Expectation of a random variable

==

// $ argmax_(a_0, a_1, dots in A) sum_(t=0)^oo gamma^t R(s_(t+1)) dot Pr(s_(t+1) | s_t, a_t) $

TODO: Visualization

TODO: What is the state transition function

= Policies

//= Conditional Returns 

= Value Functions