#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let low_ent = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 4,
            x-label: $ a $,
            y-label: $ Pr (a | s) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(pi)) $,
                x => normal_fn(0, 0.2, x),
            ) 

            })
    }
)}

#let high_ent = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 4,
            x-label: $ a $,
            y-label: $ Pr (a | s) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(pi)) $,
                x => normal_fn(0, 0.8, x),
            ) 

            })
    }
)}


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Actor Critic II],
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
We are nearing the end of the course! #pause

You should be able to understand research papers on:
- MDPs, bandits, RL algorithms, even some control problems! #pause

Next week we will investigate active research topics
- Offline RL
- Large language models

==

- Offline RL
    - RL without exploration
    - How can we learn policies from a fixed dataset?
        - Learn surgery from surgical videos (no need to kill patients)
        - Learn driving from Xiaomi driving dataset (no need to crash cars)
    - Very new topic (2-3 years old)
        - Does not work very well (yet)

==

- Large Language Models
    - Can train LLMs using unsupervised learning
        - They only learn to predict next word
    - We use RL to teach them to interact with humans
        - Apply policy gradient to textual MDP
        - DeepSeek math/GRPO
        - RL-adjacent methods (DPO)

==
We will have the last exam in two weeks: #pause
- Actor critic #pause
- Offline RL #pause
- More information next week

==
Homeworks 2 and 3 due next week #pause
- If you did not start, you are in trouble #pause
    - 15/53 submitted homework 2 #pause
    - 12/52 submitted homework 3

==
Also think about final projects #pause
- You still have more than 1 month #pause
    - But remember RL takes longer than supervised learning!

= Review

= Actor Critic
// Two ways to do actor critic
    // Last time, actor critic was focused on policy gradient
    // We utilize the value function to get around MC returns
    // Today, we will look at the other approach to actor critic
    // In this case, we focus more on learning Q functions
    // The actor is a way to get around limitations of Q functions
// Talk about robot example again
// Cannot argmax over infinite action space
// Can we approximate argmax?
// How? Neural network
// In this case, we will learn a neural network that approximates the argmax policy
==
Alternative descriptions of actor critic algorithms
- https://lilianweng.github.io/posts/2018-04-08-policy-gradient/

==
#cimage("fig/09/algos.png")
==
There are two approaches to actor critic #pause
#side-by-side[
1. *Policy gradient based:* #pause
PG with $V$ instead of MC #pause
    - A2C #pause
    - TRPO #pause
    - PPO #pause
    - IMPALA #pause
    - ACKTR #pause
    - ACER #pause
    - PPG #pause

][
2. *Q learning based:* #pause
Learn $Q$ for a specific policy #pause
    - DDPG #pause
    - TD3 #pause
    - SAC #pause
    - Q-Prop #pause
    - QT-Opt #pause
    - NAF #pause
    - MPO
]


= Deterministic Policy Gradient
// Introduce learned argmax policy as function
// Derive policy gradient again, but starting with Q function instead of return
// Go into DDPG

// Could instead try and start from making Q learning continuous
// Factorize policy into mu and pi (pi used for exploration)
==
*Question:* Why did we introduce policy gradient methods? #pause

#cimage("fig/08/benben.png", height: 80%)
==
#side-by-side[
    #cimage("fig/08/benben.png", height: 50%) #pause
][
    *Question:* Why did Q learning fail BenBen? #pause

    $ A = [0, 2 pi]^12 $ #pause

]
$ pi (a_t | s_t; bold(theta)_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) Q(s_t, a_t, bold(theta)_pi), 
  0 "otherwise"
) $  #pause

Infinitely many $a_t$ -- compute $Q$ for each and take $argmax$ over all

==

$ pi (a_t | s_t; bold(theta)_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) Q(s_t, a_t, bold(theta)_pi), 
  0 "otherwise"
) $ #pause

The greedy policy cannot work with continuous action spaces #pause
- Can we replace $argmax$ with a different deterministic function? #pause

Remember that the Q function and greedy policy are different #pause
- We can learn Q for *any* policy, does not need to be greedy policy #pause

Let us quickly review the Q function and value function

==
Start with general form of Temporal Difference Q function  #pause

$ Q(s_0, a_0, bold(theta)_pi) = underbrace(bb(E)[cal(R)(s_1) | s_0, a_0], "Reward for taking" a_0) + gamma underbrace(V(s_1, bold(theta)_pi), cal(G) "following" bold(theta)_pi) $ #pause

#v(-0.5em)
We can replace $V$ with $Q$ if $#redm[$a$] tilde pi (dot | s_1; bold(theta)_pi)$ #pause

$ Q(s_0, a_0, bold(theta)_pi) = underbrace(bb(E)[cal(R)(s_1) | s_0, a_0], "Reward for taking" a_0) + gamma underbrace(Q(s_1, #redm[$a$], bold(theta)_pi), cal(G) "following" bold(theta)_pi) $ #pause

For the greedy policy, we can reduce $Q$ further #pause

$ Q(s_0, a_0, bold(theta)_pi) = underbrace(bb(E)[cal(R)(s_1) | s_0, a_0], "Reward for taking" a_0) + underbrace(max_(a in A) gamma Q(s_1, a, bold(theta)_pi), cal(G) "following" bold(theta)_pi) $

==
$ cancel(Q(s_0, a_0, bold(theta)_pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + max_(a in A) gamma Q(s_1, a, bold(theta)_pi))  $ #pause

Cannot use the max Q function with BenBen #pause

$
Q(s_0, a_0, bold(theta)_pi) &= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, bold(theta)_pi) \
Q(s_0, a_0, bold(theta)_pi) &= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, a, bold(theta)_pi); quad a tilde pi (dot | s_1; bold(theta)_pi) 
$ #pause

*Question:* Can we use continuous $a$ with $Q$? #pause *Answer:* Yes  #pause

Q function $=>$ no problem, policy $=>$ problem $quad #redm[$argmax_(a in A)$] Q(s, a, bold(theta)_pi)$ #pause

Greedy deterministic policy worked well for discrete actions #pause

Can we learn a different deterministic policy for continuous actions?

==
$ Q(s_0, a_0, bold(theta)_pi) &= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma underbrace(bb(E)[Q(s_1, a_1, bold(theta)_pi) | s_0, a_0; bold(theta)_pi], a_1 tilde pi (dot | s_1; bold(theta)_pi)) $ #pause

*Question:* What method can we use to learn $bold(theta)_pi$? #pause

*Answer:* Policy gradient #pause

Perhaps our solution will combine $Q$ with policy gradient #pause

// We will derive the solution like David Silver likely did #pause

The trick is to consider a *deterministic* policy #pause

#side-by-side[
    $ cancel(a tilde pi (dot | s; bold(theta)_pi)) $ #pause
][
    $ a = mu(s, bold(theta)_mu) $ #pause
][
    $ mu: S times Theta |-> A $ #pause
]

$ Q(s_0, a_0, bold(theta)_mu) &= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, #redm[$mu$] (s_1, bold(theta)_mu), bold(theta)_mu) | s_0, a_0; bold(theta)_mu] $



==
So let us learn parameters $bold(theta)_mu$ for this deterministic function #pause

Recall policy gradient, we find $bold(theta)_pi$ using gradient ascent #pause

$ bold(theta)_(pi, i + 1) = bold(theta)_(pi, i) + alpha dot nabla_bold(theta)_(pi, i) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(pi, i)] $ #pause

We need to know $nabla_bold(theta)_pi bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_pi]$ #pause
- We found this for the stochastic policy #pause
- Can we also find this for a deterministic policy? #pause

$ nabla_(#pin(1)bold(theta)_pi#pin(2)) bb(E)[cal(G)(bold(tau)) | s_0; #pin(3)bold(theta)_pi#pin(4)] => nabla_(#pin(5)bold(theta)_mu#pin(6)) bb(E)[cal(G)(bold(tau)) | s_0; #pin(7)bold(theta)_mu#pin(8)] $ #pause

#pinit-highlight(1,2)
#pinit-highlight(3,4)
#pinit-highlight(5,6, fill: blue.transparentize(85%))
#pinit-highlight(7,8, fill: blue.transparentize(85%))

==

The expected return with a *stochastic* policy #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; #pin(1)bold(theta)_pi#pin(2)) \ #pause

#pinit-highlight(1,2) #pause

Pr (s_(n+1) | s_0; #pin(3)bold(theta)_pi#pin(4)) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( #pin(7)sum_(a_t in A)#pin(8) Tr(s_(t+1) | s_t, a_t) dot #pin(5)pi (a_t | s_t; bold(theta)_pi)#pin(6) ) $ #pause

#pinit-highlight(3,4) #pause
#pinit-highlight(5,6) 
#pinit-highlight(7,8) #pause 

The state distribution with a *deterministic* policy #pause

$ Pr (s_(n+1) | s_0; bold(theta)_mu) = sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) $ 

==

Let us continue to derive policy gradient with a *deterministic* policy $mu$ #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; bold(theta)_mu) \
 
Pr (s_(n+1) | s_0; bold(theta)_mu) = sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) $ #pause

Plug state distribution into expected return #pause

$
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) 
$

==
$
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) 
$ #pause

Take gradient of both sides #pause

$
nabla_bold(theta)_mu bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu] \ = nabla_bold(theta)_mu [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) ]
$

==
$
nabla_bold(theta)_mu bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu] \ = nabla_bold(theta)_mu [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) ]
$ #pause

Gradient of sum is sum of gradient, move the gradient inside the sums #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) nabla_bold(theta)_mu [ product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) ]
$

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) nabla_bold(theta)_mu [ product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) ]
$ #pause

#side-by-side[Recall the log trick #pause][
$ nabla_x f(x)  = f(x) nabla_x log f(x) $ 
] #pause

Apply log trick to product terms #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) nabla_bold(theta)_mu [ log(product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu))) ]
$

== 
#text(size: 24pt)[
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ nabla_bold(theta)_mu [ log(product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu))) ]
$ #pause

Log of products is sum of logs #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ nabla_bold(theta)_mu [ sum_(t=0)^n log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) ]
$
]

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ nabla_bold(theta)_mu [ sum_(t=0)^n log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) ]
$ #pause

Move the gradient inside sum #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ sum_(t=0)^n nabla_bold(theta)_mu log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) 
$

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ sum_(t=0)^n nabla_bold(theta)_mu log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) 
$ #pause

#side-by-side[Use the chain rule][$ nabla_x f(g(x)) = nabla_(g) [f(g(x))] nabla_x g(x)$] #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ sum_(t=0)^n nabla_(mu)[ log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu))] dot nabla_bold(theta)_mu mu(s_t, bold(theta)_mu)
$

==
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) \ sum_(t=0)^n nabla_(mu)[ log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu))] dot nabla_bold(theta)_mu mu(s_t, bold(theta)_mu)
$ #pause

*Question:* Any problems? #pause

We must know $gradient Tr$ to find the deterministic policy gradient #pause
- In model-free RL, we do not know $gradient Tr$ 
    - $Tr$ might not be differentiable (e.g. Mario)! #pause
- Stochastic policy gradient is very special -- we do not need $nabla Tr$ #pause
    - Let me explain what I mean

==
With deterministic policy, $mu$ inside $Tr$ means chain rule #pause

$ sum_(t=0)^n nabla_bold(theta)_mu log Tr(s_(t+1) | s_t, mu(s_t, bold(theta)_mu)) 
$ #pause

With stochastic policy, $pi$ *not inside* $Tr$ (product rule) #pause

$ sum_(t=0)^n sum_(a_t in A) nabla_bold(theta)_pi [ Tr(s_(t+1) | s_t, a_t) dot log pi (a_t | s_t; bold(theta)_pi)] 
$ #pause

This is why we often use stochastic policies in RL #pause
- Approximate expectation instead of gradient (tractable)

= Deep Deterministic Policy Gradient
==
#side-by-side[
    $ 
    nabla_(bold(theta)_mu) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu]
    $  #pause
][
    $
    bold(theta)_(pi, i + 1) = bold(theta)_(pi, i) + alpha dot nabla_(bold(theta)_mu) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu]
    $ #pause
]

We failed -- a deterministic policy gradient does not seem to work #pause
- Can we try and optimize something else? #pause

*Question:* Could we replace $nabla_bold(theta)_mu bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu]$ with something else? #pause

#side-by-side[
$ nabla_(bold(theta)_mu) V(s_0, bold(theta)_mu) 
$ #pause

][
$ nabla_(bold(theta)_mu) Q(s_0, a_0, bold(theta)_mu) $ #pause
]

Let us try to derive deterministic policy gradient again #pause
- This time, take gradient of $V$ instead of gradient of $bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu]$

==
$ V(s_0, bold(theta)_mu) = bb(E)[cal(R)(s_1) | s_0; bold(theta)_mu] + gamma bb(E)[V(s_0, bold(theta)_mu) | s_0; bold(theta)_mu] $ #pause

Rewrite $V$ in terms of $Q$ #pause

$ V(s_0, bold(theta)_mu) = Q(s_0, a, bold(theta)_mu); quad a = mu(s_1, bold(theta)_mu) $ #pause

Plug in $mu$ for $a$ #pause

$ V(s_0, bold(theta)_mu) = Q(s_0, mu(s_0, bold(theta)_mu), bold(theta)_mu) $ #pause

Take the gradient of both sides #pause

$ nabla_bold(theta)_mu V(s_0, a_0, bold(theta)_mu) = nabla_bold(theta)_mu  Q(s_0, mu(s_0, bold(theta)_mu), bold(theta)_mu) $

==
$ nabla_bold(theta)_mu V(s_0, bold(theta)_mu) = nabla_bold(theta)_mu Q(s_0, mu(s_0, bold(theta)_mu), bold(theta)_mu) $ 

#side-by-side[Use the chain rule][$ nabla_x f(g(x)) = nabla_(g) [f(g(x))] nabla_x g(x)$] #pause

$ nabla_bold(theta)_mu V(s_0, bold(theta)_mu) = nabla_mu Q(s_0, mu(s_0, bold(theta)_mu), bold(theta)_mu) dot nabla_bold(theta)_mu mu(s_0, bold(theta)_mu) $ 

==

#v(1em)

$ nabla_bold(theta)_mu V(s_0, bold(theta)_mu) = #pin(1)nabla_mu Q(s_1, mu(s_1, bold(theta)_mu), bold(theta)_mu)#pin(2) dot #pin(3)nabla_bold(theta)_mu mu(s_1, bold(theta)_mu)#pin(4) $ #pause

#v(1em)

Let us inspect these terms more closely #pause

#pinit-highlight-equation-from((3,4), (3,3), fill: red, pos: top, height: 1.2em)[How $bold(theta)_mu$ changes $a$] #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[How $a$ changes $Q$] #pause

- The second term is easy to compute, gradient of deterministic policy #pause
- Analytical solution for the first term is difficult (recursive definition) #pause

But what if $Q$ is a neural network? #pause
- We can backpropagate through $Q$ without worrying about recursion

==
#v(1em)

$ nabla_bold(theta)_mu V(s_0, bold(theta)_mu) = #pin(1)nabla_mu Q(s_1, mu(s_1, bold(theta)_mu), bold(theta)_mu)#pin(2) dot #pin(3)nabla_bold(theta)_mu mu(s_1, bold(theta)_mu)#pin(4) $

#v(1em)

#pinit-highlight-equation-from((3,4), (3,3), fill: red, pos: top, height: 1.2em)[How $bold(theta)_mu$ changes $a$] 

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[How $a$ changes $Q$] #pause

Writing the code makes it look easy #pause

```python
def V(s, Q_nn, mu_nn):
    a = mu_nn(s)
    return Q_nn(s, a) # Return value

# Learn the policy that maximizes V
# Make sure to differentiate w.r.t policy parameters!
J = grad(V, argnums=2)(states, Q_nn, mu_nn)
mu_nn = optimizer.update(mu_nn, J) # Grad ascent
```
==
//This assumes we know the $Q$ function for $bold(theta)_mu$ #pause

We can learn $Q$ for any policy (before we focused on greedy) #pause

$ Q(s_0, a_0, bold(theta)_mu, bold(theta)_Q) = \ bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, mu(s_1, bold(theta)_mu), bold(theta)_mu, bold(theta)_Q) | s_0, a_0; bold(theta)_mu] $ #pause

```python 
def V(s, Q_nn, mu_nn):
    a = mu_nn(s)
    return Q_nn(s, a) # return value
def TD_loss(s, a, r, next_s, Q_nn, mu_nn):
    return (V(s, Q_nn, mu_nn) - td_label) ** 2
# Now, we learn params of Q following policy
J = grad(TD_loss, argnums=4)(s, a, r, next_s, Q_nn, mu_nn)
Q_nn = optimizer.update(Q_nn, J) # Grad descent
```
==
*Definition:* Deep Deterministic Policy Gradient (DDPG) decomposes $V$ into a deterministic policy $mu$ and $Q$, learning them jointly #pause

*Step 1:* Learn the $Q$ function for $mu$ #pause

$ eta = Q(s_0, a_0, bold(theta)_(mu), bold(theta)_(Q)) - (r_0 + gamma Q(s_1, mu(s_1, bold(theta)_mu), bold(theta)_mu, bold(theta)_Q)) \ #pause

theta_(Q, i + 1) = argmin_(theta_(Q, i)) eta^2
$ #pause

*Step 2:* Learn $mu$ that maximizes $Q$ #pause

$ bold(theta)_(mu, i+1) = argmax_(bold(theta)_(mu, i)) Q(s_0, mu(s_0, bold(theta)_mu), bold(theta)_(mu, i), bold(theta)_(Q, i+1)) $ 

//Repeat until convergence, $theta_(mu, i+1)=theta_(mu, i), quad theta_(Q, i+1)=theta_(Q, i)$

==
*Question:* Is DDPG on-policy or off-policy? #pause

*Answer:* Depends on how we train $Q$: #pause
- TD $Q$ is off-policy #pause
- MC $Q$ is on-policy #pause

Almost *all* off-policy actor-critic algorithms are based on DDPG

==

*Summary:* #pause
- Wanted to extend Q learning to continuous action spaces #pause
    - Simple greedy policy does not work! #pause
- Introduced learned deterministic policy $a = mu(s, bold(theta)_mu)$ #pause
- Failed to find deterministic policy gradient $nabla_bold(theta)_mu bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu]$ #pause
    - Must know $nabla Tr$ #pause
- Try gradient ascent on $nabla_bold(theta)_mu V$ instead of $nabla_bold(theta)_mu bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_mu]$
    - Trick: Factor $V$ in terms of $Q, mu$
    - Iterative optimization of $bold(theta)_Q$ and $bold(theta)_mu$ 

==

Another way to think of DDPG: #pause

$ max_(bold(theta)_mu) Q(s, mu(s, bold(theta)_mu), bold(theta)_mu) approx max_(a in A) Q(s, a, bold(theta)_mu) $ #pause

$mu$ is a continuous approximation of the greedy policy #pause
- Because $mu$ is a neural network, it can generalize to continuous $s, a$


==
One small problem: deterministic policy means no exploration! #pause
- We must visit other states/actions to find optimal $theta_Q, bold(theta)_mu$ #pause

With Q learning, we had epsilon greedy policy #pause

$ pi (a | s; bold(theta)_pi) =  cases( 
  1 - epsilon & : a = argmax_(a in A) Q(s, a, bold(theta)_pi), 
  epsilon & : a = "uniform"(A)
) $ #pause

*Question:* What about DDPG exploration (continuous actions)? #pause

$ pi (a | s; bold(theta)_mu) =  cases( 
  1 - epsilon & : a = mu(s, bold(theta)_mu), 
  epsilon & : a = "uniform"(A)
) $ 

==

We continuous actions, we can do something smarter #pause
- Uniform actions cover the action space, but can take a while to learn #pause
- Add noise to a good action instead of pick random actions #pause

$ pi (a | s; bold(theta)_mu) = mu(s, bold(theta)_mu) + "Normal"(0, sigma) $ #pause

This tends to learn more quickly #pause
- Normal noise (infinite support) guarantees full action space coverage #pause

*Note:* Original paper uses Ornstein–Uhlenbeck noise #pause 
- More recent papers find using normal noise produces similar results


= Coding

==
Like policy gradient, the math and code is different #pause
- Construct $mu$ and $Q$ networks #pause
- Sample actions #pause
    - Be careful that random actions are in action space! #pause
    - $A = [0, 2 pi]$, then $a = 2.1 pi$ not ok #pause
- Iteratively train $bold(theta)_Q, bold(theta)_mu$

==
First, construct deterministic policy #pause
```python
mu = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, action_dims),
])
``` #pause
Here, `action_dims` correspond to the number of continuous dimensions #pause

BenBen: $A = [0, 2 pi]^12$, so `action_dims=12`
==
Now, we need to make sure actions do not leave action space! #pause
- BenBen: $A in [0, 2 pi]^12$, `lower=[0, 0, ...]`, `upper=[2pi, 2pi, ...]` #pause

Squash actions within limits using $tanh$ #pause
- Can also use `clip(action, lower, upper)`, but this zeros gradients #pause
    - Agent can get stuck taking limiting actions (e.g., -0.01 or $2.1 pi$) #pause

```python
def bound_action(action, lower, upper): 
    return 0.5 * (upper + lower) + 0.5 * (upper - lower) 
        * tanh(action)
``` #pause

```python
def sample_action(mu, state, A_bounds, std):
    action = mu(state)
    noisy_action = action + normal(0, std) # Explore
    return bound_action(noisy_action, *A_bounds)

```

==
Now construct $Q$ #pause

```python
Q = Sequential([
    # Different from DQN network
    # Input action and state together
    Lambda(lambda s, a: concatenate(s, a)),
    Linear(state_size + action_dims, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 1), # Single value for Q(s, a)
])
```

==
```python
while not terminated:
    # Exploration: make sure actions within action space!
    action = sample_action(mu, state, bounds, std)
    transition = env.step(action)
    replay_buffer.append(transition)
    data = replay_buffer.sample()
    # Theta_pi params are in mu neural network
    # Argnums tells us differentiation variable
    J_Q = grad(Q_loss, argnums=0)(theta_Q, theta_T, mu, data)
    theta_Q = apply_updates(J_Q, ...)
    J_mu = grad(mu_loss, argnums=0)(mu, theta_Q, data)
    mu = apply_updates(J_mu, ...)
    if step % 200 == 0: # Target network necessary
        theta_T = theta_Q
```

==
```python
def Q_loss(theta_Q, theta_T, bold(theta)_pi, data):
    Qnet = combine(Q, theta_Q)
    Tnet = combine(Q, theta_T) # Target network
    # Predict Q values for action we took
    prediction = vmap(Qnet)(data.state, data.action)
    # Now compute labels using TD error
    next_action = vmap(mu)(data.next_state)
    # NOTE: No max! Mu approximates argmax
    next_Q = vmap(Tnet)(data.next_state, next_action)
    label = data.reward + gamma * data.done * next_Q
    return (prediction - label) ** 2


```
==
```python
def mu_loss(mu, theta_Q, data):
    # Find the action that maximizes the Q function
    Qnet = combine(Q, theta_Q)
    # Instead of multiply, chain rule -- plug action into Q
    action = vmap(mu)(data.state)
    q_value = vmap(Qnet)(data.state, action)
    # Update the policy parameters to maximize the Q value
    # Gradient ascent but we min loss, use negative
    return -q_value
```

==
You can also read about Twin Delayed DDPG (TD3) #pause
- Adds some improvements to DDPG to improve performance #pause
    - Add noise to target 
    $ Q(s, mu(s, bold(theta)_mu) + epsilon, bold(theta)_mu, theta_T) $ #pause
    - Learns two Q functions, use the minimum as target
    $ min_(i in 1, 2) Q(s, mu(s, bold(theta)_mu) + epsilon, bold(theta)_mu, theta_(T, i)) $ #pause
    - Update Q functions more often than policy


= Max Entropy RL
// SAC is arguably the best algorithm we have today
// DDPG can learn good policies, but exploration is not so good 
// Random policies lead to better behavior than deterministic + noise
// Can we make DDPG stochastic?
// Introduce max ent objective
// Use reparameterization trick from VAE
    // Do not sum over all possible actions
    // Instead, backprop through reparam node
// SAC

==
Many algorithms add improvements to DDPG #pause

The most popular DDPG-based algorithm is *Soft Actor Critic* (SAC) #pause
- SAC is arguably the "best" model-free algorithm #pause
- The motivation for SAC comes from *max-entropy RL* #pause
- We will very briefly cover max-entropy RL #pause

First, let us introduce entropy

==
Entropy $H$ measures the uncertainty of a distribution #pause

$ H(pi (a | s; bold(theta)_pi)) $ #pause

#side-by-side[
    #high_ent #pause
][
    #low_ent #pause
]

*Question:* Which policy has higher entropy? #pause

Left policy, more uncertain/random

==
$ argmax_(bold(theta)_pi) bb(E)[ cal(G)(bold(tau)) | s_0; bold(theta)_pi] = argmax_(bold(theta)_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; bold(theta)_pi] $ #pause

In max-entropy RL, we maximize both return and policy entropy #pause 

$ argmax_(bold(theta)_pi) bb(E)[ cal(G)(bold(tau)) + cal(H)(bold(tau)) | s_0; bold(theta)_pi] = \ argmax_(bold(theta)_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) + lambda H(pi (a | s_t; bold(theta)_pi)) | s_0; bold(theta)_pi]  $ #pause

Hyperparameter $lambda$ balances entropy and reward #pause

We learn a policy that maximizes the return and behaves randomly

==
$ argmax_(bold(theta)_pi) bb(E)[ cal(G)(bold(tau)) + cal(H)(bold(tau)) | s_0; bold(theta)_pi] = \ argmax_(bold(theta)_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) + lambda H(pi (dot | s_t; bold(theta)_pi)) | s_0; bold(theta)_pi] $ #pause

*Question:* Why do want policy entropy? Lowers the return #pause

*Answer:* No good theoretical reason, helpful in practice #pause
- There are theoretical reasons, but they are good reasons #pause
- Better exploration during training #pause
- More stable training (harder for policy to exploit Q function) #pause
    - Further discussion in offline RL lecture

==
We are talking about the policy like it is random $ pi (a | s; bold(theta)_pi)$ #pause
- DDPG is based on a deterministic policy $a = mu(s, bold(theta)_mu)$ #pause
    - A deterministic policy $mu$ has no entropy (it is not random) #pause

What is going on? How is this possible? #pause

Consider a function $f: S times Theta times bb(R) |-> A$ #pause

$ a = f(s, bold(theta)_mu, epsilon) = mu(s, bold(theta)_mu) + epsilon
$ 

==
$ a = f(s, bold(theta)_mu, epsilon) = mu(s, bold(theta)_mu) + epsilon 
$ #pause

If $epsilon tilde "Normal"(0, 1)$ our function $f$ is still deterministic #pause
- Called *reparameterization trick* #pause
    - Used in variational autoencoders (VAE) #pause

Note we can condition the return on the provided $epsilon$ #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, #pin(1)epsilon_0, epsilon_1, dots#pin(2) ; bold(theta)_mu] $  #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 1.2em)[Noise terms] 

==
$ a = f(s, bold(theta)_mu, epsilon) = mu(s, bold(theta)_mu) + epsilon \
bb(E)[cal(G)(bold(tau)) | s_0, epsilon_0, epsilon_1, dots; bold(theta)_mu] $ #pause

$f$ is technically deterministic function if we condition on $epsilon_0, epsilon_1, dots$ #pause
- In practice, $f$ behaves just like a stochastic policy $pi$ #pause
- Gradient descent will learn $bold(theta)_mu$ that generalize over $epsilon$ #pause

We abuse notation and write $f$ as a random policy #pause

$ f(s, bold(theta)_mu, cancel(epsilon)) =  pi (a | s; bold(theta)_pi) $ #pause

I think this is ugly, but technically it is correct 
//But $f$ is deterministic when we know $epsilon$

==
What happens when we combine DDPG #pause

With the max entropy objective #pause

$ argmax_(bold(theta)_pi) bb(E)[ cal(G)(bold(tau)) + cal(H)(bold(tau)) | s_0; bold(theta)_pi] = \ argmax_(bold(theta)_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) + lambda H(pi (a | s_t; bold(theta)_pi)) | s_0; bold(theta)_pi]  $ #pause


And the reparameterization trick? #pause

$ f(s, bold(theta)_mu, epsilon) = pi (a | s; bold(theta)_mu) $ #pause

We get Soft Actor Critic (SAC)!

==
*Definition:* Soft Actor Critic (SAC) adds a max entropy objective and "stochastic" policy to DDPG #pause

#side-by-side[$ pi (a | s_0; bold(theta)_mu) = mu(s_0, bold(theta)_mu) + epsilon $ #pause][
$ epsilon tilde "Normal"(0, sigma) $
] #pause

Learn $sigma$ to balance reward $cal(R)$ and entropy $H$ 

==
#side-by-side[$ pi (a | s_0; bold(theta)_mu) = mu(s_0, bold(theta)_mu) + epsilon $][
$ epsilon tilde "Normal"(0, sigma) $
] #pause

*Step 1:* Learn a $Q$ function for max entropy policy (Q learning) #pause

$ 
eta = Q(s_0, a_0, bold(theta)_mu, bold(theta)_Q) \ - (r_0 + lambda underbrace(H(pi (a | s_0; bold(theta)_mu)), "Entropy bonus") + gamma Q(s_1, underbrace(mu(s_1, bold(theta)_mu) + epsilon, "Noisy action"), bold(theta)_(mu), bold(theta)_(Q))) #pause \ 

bold(theta)_(Q, i+1) = argmin_(bold(theta)_(Q, i)) eta^2
$ 
==

#side-by-side[$ pi (a | s_0; bold(theta)_mu) = mu(s_0, bold(theta)_mu) + epsilon $][
$ epsilon tilde "Normal"(0, sigma) $
] #pause

*Step 2:* Learn a $pi$ that maximizes $Q$ (policy gradient) #pause

#v(1.5em)
$ bold(theta)_(mu, i+1) = argmax_bold(theta)_(mu, i) Q(s_0, mu(s_0, bold(theta)_mu) + epsilon, bold(theta)_mu, bold(theta)_Q) $  #pause

$ pi (a | s_0; bold(theta)_mu) = mu(s_0, bold(theta)_mu) + epsilon $

= Thoughts on Model-Free RL
==
Like PPO, there are many variants of SAC #pause
    - Learn separate value and Q functions #pause
    - Double Q function #pause
    - Lagrangian entropy adjustment #pause
    - Reduce gradient variance #pause

Like PPO, SAC is complicated -- uses many "implementation tricks" #pause
- Often not documented #pause
- CleanRL describes modern SAC, using tricks from 5 papers #pause
- https://docs.cleanrl.dev/rl-algorithms/sac/#implementation-details_1 #pause

Coding SAC could take an entire lecture, read CleanRL

==
Duality between policy gradient actor critic and Q learning actor critic #pause
#side-by-side[
    Introduces the concept, simple #pause

    A2C #pause

    DDPG #pause

][
    Improves the concept, complex #pause

    $=>$ PPO #pause

    $=>$ SAC #pause
]

I suggest you try DDPG or TD3 before SAC #pause
- Easier to implement #pause
- Fewer hyperparameters #pause
- Tuned DDPG/TD3 can outperform untuned SAC 

==
What algorithm is best in 2025? #pause
- For discrete actions (Atari), DQN variants still perform best (PQN) #pause
- For continuous actions (MuJoCo), SAC/TD3 perform best #pause

PPO is less sensitive to hyperparameters than SAC/DQN #pause
- Noobs like PPO, they cannot tune hyperparameters #pause
- Often performs worse than tuned DQN/TD3/SAC #pause

Tuned DDPG/A2C 95% as good as tuned SAC/PPO #pause
- Much easier to debug

= Final Project Tips
==
Log and plot EVERYTHING #pause
    - Losses, mean advantage, mean Q, policy entropy, etc #pause
        - Use these to help debug and tune hyperparameters #pause
        - E.g., exploding losses, decrease learning rate #pause
        - E.g., Q values too large? Increase time between target net updates #pause
        - E.g., converge to bad policy? Add entropy term to loss to increase exploration #pause

If you get stuck, visualize your policy #pause
- Record some episodes (videos/frames/etc) #pause
- Watch the policy, what did it learn to do? #pause
    - Think about why it learned to do this (exploiting bugs in MDP) 

==

Why does Steven spend so much time on theory instead of coding? #pause

"I spent months training policies, it does not learn" #pause
- Categorical action space of size $2^32$ #pause
    - *Question:* What is the problem? #pause
    - Need to try at least $2^32$ actions per state! #pause
    - Output layer of network is too large ($2^32$ neurons)! #pause
- Episode is 5000 timestep long with reward at last timestep #pause
    - $gamma = 0.99$ (default) #pause
    - *Question:* What is the problem? #pause
    - $gamma^5000 cal(R)(s_5000) = 0.99^5000 cal(R)(s_1000) approx 10^(-22) cal(R)(s_5000)$


==

In supervised learning, follow MNIST tutorial and everything works #pause
- This is *NOT* the case in RL #pause
- You must use your brain to be successful! #pause
- In RL, your code never works on the first try #pause
- Even if it is correct, you need to play with hyperparameters #pause

Theory is absolutely necessary to understand: #pause 
- *Why* your policy fails #pause
- *How* to fix it 



/*
==
```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 2 * action_dims),
    Lambda(lambda x: split(x, 2)) # mean and log std
])
```
==
```python
def bound_action(action, upper, lower): 
    return (upper + lower / 2) 
        * tanh(action - (upper - lower) / 2)
        
def sample_action(model, state, A_bounds, noise):
    mean, log_std = model(state)
    noisy_action = normal(mean, exp(log_std))
    return bound_action(noisy_action, *A_bounds)

```

==
```python
Q = Sequential([
    # Different from DQN network
    # Input action and state, output one value
    Lambda(lambda s, a: concatenate(s, a)),
    Linear(state_size + action_dims, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 1),
])
```

==
```python
while not terminated:
    # Exploration: make sure actions within action space!
    action = sample_action(mu, state, bounds, noise)
    transition = env.step(action)
    replay_buffer.append(transition)
    data = replay_buffer.sample()
    # Theta_pi params are in mu neural network
    # Argnums tells us differentiation variable
    J_Q = Q_TD_loss(theta_Q, theta_T, mu, data)
    J_mu = mu_loss(mu, theta_Q, data)
    theta_Q, mu = apply_updates(J_Q, J_mu, ...)
    # Target network usually necessary
    if step % 200 == 0:
        theta_T = theta_Q
```

==
```python
def Q_TD_loss(theta_Q, theta_T, bold(theta)_pi, data):
    Qnet = combine(Q, theta_Q)
    Tnet = combine(Q, theta_T) # Target network
    # Predict Q values for action we took
    prediction = vmap(Qnet)(data.state, data.action)
    # Now compute labels
    next_action = vmap(mu)(data.next_state)
    # NOTE: No argmax! Mu approximates argmax
    next_Q = vmap(Tnet)(data.next_state, next_action)
    entropy = -log(std)
    label = reward + gamma * data.done * next_Q
    return (prediction - label) ** 2


```
==
```python
def mu_loss(mu, theta_Q, data):
    # Find the action that maximizes the Q function
    Qnet = combine(Q, theta_Q)
    # Instead of multiply, chain rule -- plug action into Q
    action = vmap(mu)(data.state)
    q_value = vmap(Qnet)(data.state, action)
    # Update the policy parameters to maximize the Q value
    # Gradient ascent but we min loss, use negative
    return -q_value
```
*/