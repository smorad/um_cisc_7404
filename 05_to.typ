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

/*
From brunskill
Recall we are trying to find the best return
Only thing we can control is our actions
Derive E[R], E[R+1], ...
It gets very messy
Derive the value function E[G] = E[R | s0 = s] + E[R+1 | s0 = s] + ...

Optimization problem E[G(tau) | s_0, a_0, a_1, dots]
RL backup diagram/tree search
Given that we have to find infinitely many a's we run into issues
We introduce a horizon T, E[G(tau_t) | s_0, a_0, a_1, dots a_t]
Introduce policy
Introduce value
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
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

==
Quiz results on moodle #pause

If you have no score, come see me #pause

Mean score is $3.37 / 4 approx 84%$ #pause

You did better than expected! #pause

If mean course score is $>80%$ but you understand the material it is ok #pause

I will not decrease total score #pause

Do not forget individual participation grade!

= Review

==

Diffusion models #pause

https://arxiv.org/pdf/2006.11239


= Algorithms

==
// https://www.youtube.com/watch?v=3FNPSld6Lrg // Do after the algorithm


==
Our goal is to maximize the discounted return #pause

Take actions in the MDP to maximize the discounted return #pause

We introduce a *policy* to select actions #pause

$ pi: S times Theta |-> Delta A $ #pause

The policy is the "brain" of the agent #pause

It makes decisions for the agent 

==

Policies can be good, bad, or even human! #pause

#cimage("fig/05/policy-car.jpeg")


==

We use *algorithms* to find good policies #pause

*Question:* What makes a policy good? #pause

*Answer:* It achieves a large discounted return #pause

Almost all the algorithms we learn in this course have guarantees #pause

That is, if you train long enough, your policy will become optimal #pause

The policy is guaranteed to maximize the discounted return
==

Today, we will derive the *trajectory optimization* algorithm  #pause

This algorithm is old, and does not require deep learning #pause

These ideas appear in classical robotics and control theory #pause

https://www.youtube.com/watch?v=6qj3EfRTtkE 
/*
These methods are expensive in terms of compute #pause

We usually only use these methods for simple problems 
==

"Simple" problems have low dimensional and actions spaces $ |S|, |A| = "small" $ #pause

One example is position and velocity control #pause

$ S in bb(R)^6, A in bb(R)^3 $

==


With modern GPUs, researchers are revisiting these methods #pause

They are applying them to more difficult tasks with high dimensional $|S|, |A|$ #pause

https://youtu.be/_e3BKzK6xD0?si=Kr-KOccTDypgRjgJ&t=194

*/
/*
==
There are two axes for decision making algorithms #pause

An algorithm is either *on-policy* or *off-policy* #pause

An algorithm is either *model-based* or *model-free* #pause

What do these mean?

==

#side-by-side[
  *On-policy* #pause

  An algorithm is limited in 

  Algorithm can only use data collected 
]

*/

==
There are two classes of algorithms #pause

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

Today, we will cover a model-based algorithm called trajectory optimization #pause

Critical part of Alpha-\* methods (AlphaGo, AlphaStar, AlphaZero)


==
Recall the discounted return, our objective for the rest of this course #pause

#side-by-side[$ G(bold(tau)) = sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause][
  $ tau = mat(s_0, a_0; s_1, a_1; dots.v, dots.v) $ #pause
]

We want to maximize the discounted return 

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s_1, s_2, dots in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause

We want to find $tau$ that provides the greatest discounted return

==

$ argmax_(bold(tau)) G(bold(tau)) = argmax_(s_1, s_2, dots in S) sum_(t=0)^oo gamma^t R(s_(t+1)) $#pause

This objective looks simple, but $R(s_(t+1))$ hides much of the process #pause

To understand what is hiding, let us examine the reward function

= Reward Optimization
==

Consider the reward function

$ R(s_(t+1)) $ #pause

Perhaps we want to maximize the reward

$ argmax_(s_(t+1) in S) R(s_(t+1)) $ #pause

*Question:* In state $s_t$, take action $a_t$, what is $R(s_(t+1))$ ? #pause

*Answer:* Not sure. $R(s_(t+1))$ depends on $Tr(s_(t+1) | s_t, a_t)$ #pause

Cannot know $s_(t+1)$ with certainty, only know the distribution!

==

$s_(t+1)$ is the *outcome* of a random process #pause 

$ s_(t+1) tilde Tr(dot | s_t, a_t), quad s_t, s_(t+1) in S $ #pause

*Question:* What is $S$? #pause

*Answer:* State space, also the outcome space $Omega$ of $Tr$ #pause

$ s_(t+1) in S equiv omega in Omega $ #pause

*Question:* Ok, now what is the definition of $R$?

//And the reward function is a scalar function of an outcome #pause

*Answer:*

$ R: S |-> bb(R) $

==
$ s_(t+1) tilde Tr(dot | s_t, a_t), quad s_t, s_(t+1) in S $ #pause

$ R: S |-> bb(R) $ #pause

If you can answer the following question, you understand the course #pause

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

*Answer:* It maps random processes to something we can maximize 

==
$ cal(R) (s_(t+1)), quad s_(t+1) tilde Tr(dot | s_t, a_t) $ #pause

We cannot know for certain which reward we get in the next timestep #pause

But we can know the *average* reward using the expectation #pause

$ bb(E)[cal(X)] = sum_(omega in Omega) cal(X)(omega) dot Pr(omega) $ #pause

$ bb(E)[#pin(1)cal(R)(s_(t+1)) | s_t, a_t#pin(2)] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom)[Random variable conditioned on $s_t, a_t$] 
==

$ bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

As an agent, we have partial control of the future reward #pause

We can choose an action $a_t$ to maximize the expected reward #pause

$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = argmax_(a_t in A) sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

*Note:* Cannot directly maximize $cal(R)$ because $s_(t+1)$ is random #pause

We can maximize the expected reward


//All we can do is choose our own action $a_t$ #pause



==

$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = #pin(9)argmax_(a_t in A)#pin(10) sum_(#pin(1)s_(t+1) in S#pin(2)) #pin(5)cal(R)(s_(t+1))#pin(6) #pin(7)dot#pin(8) #pin(3)Tr(s_(t+1) | s_t, a_t)#pin(4) $ #pause

How to code this: #pause
  + #text(fill: red.transparentize(50%))[`probs = [[Tr(next_s, s, a) for next_s in S] for a in A]`] #pinit-highlight(3,4) #pause
  + #text(fill: blue.transparentize(50%))[`rewards = [R(next_s) for next_s in S]`] #pinit-highlight(5,6, fill: blue.transparentize(80%)) #pause
  + #text(fill: purple.transparentize(50%))[`expected_reward = [sum([p * rewards]) for p in probs]`]  #pinit-highlight(7,8, fill: purple.transparentize(80%)) #pinit-highlight(1,2, fill: purple.transparentize(80%)) #pause
  + #text(fill: olive.transparentize(50%))[`a = argmax(expected_reward)`] #pinit-highlight(9,10, fill: olive.transparentize(80%)) #pause

*Question:* Have we seen something similar before? #pause

#side-by-side[*Answer:* Bandits! #pause][
  $ argmax_(a in {1 dots k}) bb(E)[cal(X)_a] $ 
]

==
$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = argmax_(a_t in A) sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

Earlier, we said that algorithms provide a policy $pi: S times Theta |-> Delta A$ #pause

But this equation is not yet a policy! #pause

Let us turn this equation into a policy

==
$ argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t] = argmax_(a_t in A) sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

$ pi: S times Theta |-> Delta A $ #pause

*Question:* How to make equation into policy? (Hint: Greedy policy) #pause

$ pi (a_t | s_t; theta) = Pr (a_t | s_t ; theta) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause


#side-by-side[Policy maximizes the reward at each timestep #pause][
$ underbrace(pi(a_0 | s_0), cal(R)(s_1)), underbrace(pi(a_1 | s_1), cal(R)(s_2)), dots $

]

==

$ pi (a_t | s_t; theta) = Pr (a_t | s_t ; theta) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause

$ underbrace(pi(a_0 | s_0), cal(R)(s_1)), underbrace(pi(a_1 | s_1), cal(R)(s_2)), dots $ #pause

This policy is *optimal* with respect to the expected reward #pause

It will always act to maximize the expected reward 

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

$ pi (a_t | s_t; theta) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(R)(s_(t+1)) | s_t, a_t], 
  0 "otherwise"
) $ #pause


This will create the best ad creator possible!

==

*Question:* Are we done? Is maximizing reward enough? #pause

*Answer:* No, maximize the discounted return, not the reward! #pause

We have one more thing to do


= Trajectory Optimization

==
$ bb(E) [cal(R)(s_(t+1)) | s_t, a_t] = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ #pause

$ G(bold(tau)) = sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) $ #pause

What we want: #pause

$ bb(E) [G(bold(tau)) | ? ] = ? $ 


/*
*Question:* Why depend on future actions? #pause

*Answer:* Agent picks actions, optimize over actions to maximize $G$
*/
==
$ bb(E) [G(bold(tau)) | ?] = ? $ #pause

*Note:* $G$ is also a random variable #pause 
$ G: underbrace(S^n times A^n, "Outcome of stochastic" Tr"," pi) |-> bb(R) $ #pause

We can rewrite it curly since it is a random variable #pause
$ cal(G): underbrace(S^n times A^n, "Outcome of stochastic" Tr"," pi) |-> bb(R) $ #pause

Back to the problem... #pause

$ bb(E) [cal(G)(bold(tau)) | ?] = ? $
// What we need

// $ Pr(s_t | s_0, a_0, a_1, a_2, dots) $

==
$ cal(G)(bold(tau)) = sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) $ #pause

//Cannot maximize random variable, only expectation of random variable #pause

Take the expected value of both sides #pause

$ bb(E)[ cal(G)(bold(tau)) | ?] = bb(E)[ sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) mid(|) ? ] $

//$ bb(E)[ cal(G)(bold(tau)) | s_0, a_0, a_1, dots ] = bb(E)[ sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) mid(|) s_0, a_0, a_1, dots] $

//We want to find the best actions, so they must be in the expectation

==
//$ bb(E)[ cal(G)(bold(tau)) | s_0, a_0, a_1, dots ] = bb(E)[ sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) mid(|) s_0, a_0, a_1, dots] $ #pause

$ bb(E)[ cal(G)(bold(tau)) | ? ] = bb(E)[ sum_(t=0)^oo gamma^t cal(R)(s_(t+1)) mid(|) ?] $ #pause

The expectation is a linear function, we can move it inside the sum #pause

$ bb(E) [cal(G)(bold(tau)) |?] = sum_(t=0)^oo bb(E)[gamma^t cal(R)(s_(t+1)) | ?] $ #pause

Expectation is linear, can factor out $gamma$ #pause

$ bb(E) [cal(G)(bold(tau)) | ?] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | ?] $

==
$ bb(E) [cal(G)(bold(tau)) | ?] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | ?] $

Now, let's figure out the conditions #pause

#side-by-side[
  We know $bb(E)[cal(R)(s_(1))]$ needs $s_0, a_0$ #pause
][
  $bb(E)[cal(R)(s_(2)) | s_1, a_1]$, already have $s_1$ only need $a_1$ #pause
]

$ bb(E) [cal(G)(bold(tau)) | ?] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots, a_t] $ #pause

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots ] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots, a_t] $


==
$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] $

Unroll the sum #pause

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = \ gamma^0 #pin(1)bb(E)[cal(R)(s_(1)) | s_0, a_0]#pin(2) + gamma^1 bb(E)[cal(R)(s_(2)) | s_0, a_0, a_1] + gamma^2 bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] + dots $ #pause

We know how to compute the first term from before 

#pinit-highlight(1, 2) #pause

$ #pin(3)bb(E)[cal(R)(s_(t+1)) | s_t, a_t]#pin(4) = sum_(s_(t+1) in S) cal(R)(s_(t+1)) dot Tr(s_(t+1) | s_t, a_t) $ 

#pinit-highlight(3, 4)

==

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = \ gamma^0 bb(E)[cal(R)(s_(1)) | s_0, a_0] + gamma^1 #pin(1)bb(E)[cal(R)(s_(2)) | s_0, a_0, a_1]#pin(2) + gamma^2 bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] + dots $ #pause

*Question:* Do we know the second term? #pinit-highlight(1, 2) #pause

*Answer:* It is more tricky



/*
==
$ bb(E) [cal(G)(bold(tau)_n) | s_0, a_0, a_1, dots, a_n] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots, a_t] $

We previously found

$ bb(E) [cal(R)(s_(t+1)) | s_t, a_t] $ #pause

Since we have $s_0, a_0$, we can compute the term for $t=0$ #pause

$ bb(E) [cal(R)(s_1) | s_0, a_0 ] $ #pause

Now, let's try to find $cal(R)(s_2)$ #pause

$ bb(E) [cal(R)(s_2) | s_0, a_0, a_1 ] $

*/
==

$ bb(E) [cal(R)(s_2) | s_0, a_0, a_1 ] $ #pause

$cal(R)(s_2)$ needs $s_2$, but we only have $s_0$! #pause

For $cal(R)(s_1)$ relies on the distribution $Tr(s_1 | s_0, a_0)$ #pause

For $cal(R)(s_2)$, the reward relies on $Tr(s_2 | s_1, a_1)$ and $Tr(s_1 | s_0, a_0)$ #pause

For $cal(R)(s_(n+1))$ we need an expression for $Pr(s_(n+1) | s_0, a_0, a_1, dots)$


==

*Question:* How do we find $Pr(s_(n+1) | s_0, a_0, a_1, dots)$? #pause

*Answer:* In lecture 3 we found the probability of a future state in a Markov process #pause

$ Pr(s_(n+1) | s_0) = sum_(s_1, s_2, dots s_(n) in S) product_(t=0)^(n)  Pr(s_(t+1) | s_t) $ #pause

To extend to MDP, just need to include the actions! #pause

$ Pr(s_(n+1) | s_0, a_0, a_1, dots, a_(n-1)) = sum_(s_1, s_2, dots s_(n) in S) product_(t=0)^(n)  Pr(s_(t+1) | s_t, a_t) $ #pause

This predicts the future states of an MDP

==

/*
$ Pr(s_n | s_0, a_0, a_1, dots, a_(n-1)) = sum_(s_1, s_2, dots s_(n-1) in S) product_(t=0)^(n-1)  Pr(s_(t+1) | s_t, a_t) $ 

TODO write out expectation so we can plug in $R(s_t) Pr(s_t | s_0, a_0, dots)$

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] $

//$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, a_1, dots] $

==
*/
//*Goal:* Given an initial state and some actions, predict the expected discounted return #pause

Combine $s_(n+1)$ distribution with $cal(R)$ to predict future rewards #pause

$ bb(E) [cal(R)(s_1) | s_0, a_0] = sum_(s_(1) in S) cal(R)(s_(1)) Tr(s_(1) | s_0, a_0) $ #pause

$ bb(E) [cal(R)(s_2) | s_0, a_0, a_1] = sum_(s_(2) in S) cal(R)(s_(2)) sum_(s_(1) in S)  Tr(s_(2) | s_1, a_1) Tr(s_(1) | s_0, a_0) $ #pause

$ bb(E) [cal(R)(s_(n + 1)) | s_0, a_0, a_1, dots, a_n] = sum_(s_(n+1) in S) cal(R)(s_(n + 1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) $


==

#v(2em)

$ bb(E) [cal(R)(s_(n + 1)) | s_0, a_0, a_1, dots, a_n] = #pin(1)sum_(s_(n+1) in S) R(s_(n + 1))#pin(2) #pin(3)sum_(s_1, dots, s_n in S) product_(t=0)^n#pin(4)  Pr(s_(t+1) | s_t, a_t)#pin(5) $ #pause

#v(2em)

What does each piece mean? #pause

#pinit-highlight-equation-from((3,4,5), (3,4), fill: blue, pos: top)[$s_(n+1)$ Distribution] #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom)[Mean reward over possible $s_(n+1)$] #pause

This is only for a single reward, must plug back into discounted return #pause

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $



/*
$ bb(E) [R(s_1) | s_0, a_0] = sum_(s_(1) in S) R(s_(1)) Pr(s_(1) | s_0, a_0) $ 

$ bb(E) [R(s_2) | s_0, a_0, a_1] = sum_(s_(2) in S) R(s_(2)) Pr(s_(2) | s_1, a_1) sum_(s_(1) in S) Pr(s_(1) | s_0, a_0) $


$ bb(E) [R(s_(n + 1)) | s_0, a_0, a_1, dots a_n] = R(s_(n + 1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Pr(s_(t+1) | s_t, a_t) $
*/
==

#text(size: 24pt)[
$ bb(E)[ cal(G)(bold(tau)) | s_0, a_0, a_1, dots] &= #pause
  &&bb(E)[cal(R)(s_1) | s_0, a_0] #pause \
 &+ gamma &&bb(E)[cal(R)(s_2) | s_0, a_0, a_1] #pause \ 
 &+ gamma^2 &&bb(E)[cal(R)(s_3) | s_0, a_0, a_1, a_2] #pause \
 &+ &dots #pause \
 &=&& sum_(s_(1) in S) cal(R)(s_(1)) Tr(s_(1) | s_0, a_0) #pause \
 &+ gamma && sum_(s_(2) in S) cal(R)(s_(2)) sum_(s_(1) in S) Tr(s_(2) | s_1, a_1) Tr(s_(1) | s_0, a_0) #pause \
 &+ gamma^2 && sum_(s_(3) in S) cal(R)(s_(3)) sum_(s_(2) in S) Tr(s_(3) | s_2, a_2) sum_(s_(1) in S) Tr(s_(2) | s_1, a_1) dots \
 &+ &dots $
]
==

To maximize the return, we take the $argmax$ over possible actions #pause

$ argmax_(a_0, a_1, dots) bb(E)[ cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $ #pause

And turn it into a policy #pause

$ pi (a_t | s_t; theta) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots], 
  0 "otherwise"
) $ #pause

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

The root node of the tree corresponds to $s_0$ #pause

Each level of the tree enumerates possible outcomes

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
$ argmax_(a_0, a_1, dots in A) bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = argmax_(a_0, a_1, dots) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $

*Trick 1:* Introduce a *horizon* $n$ #pause

$ argmax_(a_0, dots, #redm[$a_n$] in A) bb(E) [cal(G)(bold(tau)_#redm[$n$]) | s_0, a_0, dots, #redm[$a_n$]] = argmax_(a_0, dots, #redm[$a_n$] in A) sum_(t=0)^#redm[$n$] gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $

Now we can limit computation to $O(|S| dot |A|)^n$ #pause

*Question:* Drawback? #pause

*Answer:* We no longer consider the infinite future, our agent may get greedy and be trapped

==

$ argmax_(a_0, dots, a_n in A) bb(E) [cal(G)(bold(tau)_n) | s_0, a_0, dots, a_n] = argmax_(a_0, dots, a_n in A) sum_(t=0)^n gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_n] $

*Trick 2:* Only simulate $j$ actions and $k$ states #pause

//Many ways to do this, the simplest one is randomly choose $k$ states and $k$ actions at each timestep #pause

#text(size: 24pt)[
  $ argmax_(a_0, dots, a_n #redm[$tilde A^j$]) bb(E) [cal(G)(bold(tau)_n) | s_0, a_0, dots, a_n] = argmax_(a_0, dots, a_n #redm[$tilde A^j$]) sum_(t=0)^n gamma^t #redm[$hat(bb(E))_(k)$] [cal(R)(s_(t+1)) | s_0, a_0, dots, a_n] $
]

Now, computation is $O(j dot k)^n$ #pause

*Question:* Drawbacks? #pause

*Answer:* Optimal action may not be sampled, results in less-optimal trajectory

==
Trajectory optimization/MPC is an "older" method #pause

Less popular in the past, limited by compute #pause

With modern GPUs, we are using MPC more and more #pause

https://www.youtube.com/watch?v=bjlT-6KVQ7U #pause

https://www.youtube.com/watch?v=Kf9WDqYKYQQ #pause

https://youtu.be/QsM9C1U0oi4?si=29BOjZ1Oo6At_iFk&t=111 #pause

We use trajectory optimization/MPC in both car racing AND chess/go bots! #pause

==
To summarize trajectory optimization/MPC: #pause
- Model-based method (we must know $Tr$ and $cal(R)$) #pause
- Results in theoretically optimal policy #pause
- In practice, make approximations that sacrifice optimality for tractability #pause
- Computationally expensive, but requires *no training data* #pause

Next time, we will see what happens when we don't know $Tr$ #pause

I plan to release assignment 1 next lecture
