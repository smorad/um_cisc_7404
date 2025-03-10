#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.3"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let log_trick = { 
    set text(size: 25pt)
    canvas(length: 1cm, {
  plot.plot(
    size: (10, 4),
    name: "plot",
    x-tick-step: 2,
    y-tick-step: none,
    y-ticks: (0, 1),
    y-min: -1,
    y-max: 1,
    {
      plot.add(
        domain: (0, 5), 
        style: (stroke: (thickness: 5pt, paint: red)),
        label: $ Pr (x; theta) $,
        x => calc.pow(x, 3) / (1 + calc.pow(x, 4)) ,
      )
      plot.add(
        domain: (0.01, 5), 
        style: (stroke: (thickness: 3pt, paint: blue)),
        label: $ log Pr (x; theta) $,
        x => calc.log(calc.abs(calc.pow(x, 3)) / (1 + calc.pow(x, 4))),
      )
    })
})}

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Policy Gradient],
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


// Two core algorithms for model-free decision making
// One is Q learning the other is policy gradient
// In Q learning, we focus on learning value and then create a policy using value functions
// In policy gradient, we learn the policy directly
// We always still rely on the discounted return, but we do not always need to approximate it
// I always find that policy gradient is a bit more difficult to understand than Q learning
// But I have been especially careful with our notation and writing out full expectations everywhere
// I think this will make policy gradient a bit more intuitive
// Most of the LLM finetuning methods are based on policy gradient

= Objectives
// Still want to maximize the return (restate this), dependent on theta

= Action Space Distributions
// Example with continuous actions
// Q learning with continuous actions not possible
// What would an action policy distribution look like?


= Policy Gradient
// Derivation
// Reinforce
// On or off policy?
// Off policy PG (leads into actor critic?)

==
*Definition:* General form of policy-conditioned discounted return 

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

Where the state distribution is 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $

==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

*Question:* What can we change here to change the return?


$ Pr(s_(n + 1) | s_n) = sum_(a_n in A) Tr (s_(n+1) | s_n, a_n) dot pi (a_n | s_n; theta_pi) $

*Answer:* The policy parameters $theta_pi$

==



$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$

We want to make $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ larger 

*Question:* How to change the policy parameters to improve the return?

#v(2em)

$ #pin(5)theta_(pi, i+1)#pin(6) = #pin(1)theta_(pi, i)#pin(2) + alpha dot #pin(3)gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)]#pin(4) $

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Current policy] 

#pinit-highlight-equation-from((3,4), (3,3), fill: blue, pos: bottom, height: 1.2em)[$theta$ direction that maximizes return] 

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[New policy] 

==

#v(1em)

$ #pin(5)theta_(pi, i+1)#pin(6) = #pin(1)theta_(pi, i)#pin(2) + alpha dot #pin(3)gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)]#pin(4) $

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Current policy] 

#pinit-highlight-equation-from((3,4), (3,3), fill: blue, pos: bottom, height: 1.2em)[$theta$ direction that maximizes return] 

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[New policy]

#v(2em)

If find $gradient_(theta_(pi)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi)]$, we can improve the policy and return


==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $

We want 

$ gradient_(theta_(pi)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi)] $

First, combine top two equations so we have more space

==

#text(size: 23pt)[
$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $

Plug line 2 into line 1

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ // Rewrite
]
==
#text(size: 23pt)[
$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ 

Take the gradient of both sides

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = nabla_(theta_pi) sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ // Take gradient of both sides
]
==

#text(size: 23pt)[
$ 
= nabla_(theta_pi) sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ 

Move gradient inside sums

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ // Move gradient inside
]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ 

Rewrite $Pr (s_(n+1) | s_0; theta_pi)$ by pulling action sum outside

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ] 
$ // Rewrite p(s_n | s_0) pulling action sum outside
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ] 
$ // Rewrite p(s_n | s_0) pulling action sum outside

Move the gradient operator further inside the sum

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ]
$ // Move gradient further inside
]
==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ]
$


Cannot move $nabla_(theta_pi)$ further inside, as all $s_(t+1)$ depends on $pi (a_0 | s_0; theta_pi)$

Expanded product has many terms, computing gradient very expensive

//Computing this gradient is very expensive, how $a_0$ impacts $Tr(s_(n+1))$

Can only compute for short sequences and small state/action spaces

Utilize the *log-derivative trick*

// *Trick:* Optimize log objective

==

*Log-derivative trick:*

*Question:* What is $ nabla_x log(f(x)) $

*Answer:* 

$ nabla_x log(f(x)) &= 1 / f(x) dot nabla_x f(x) \

 f(x) nabla_x log f(x)  &= nabla_x f(x) \

 nabla_x f(x) &= f(x) nabla_x log f(x)  
$



/*
$ argmax_theta Pr (x; theta) = argmax_theta log Pr (x; theta) $

#align(center, log_trick)

*Trick:* Optimize log objective instead

$ Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) => log(Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) $

==
*/

#text(size: 23pt)[
#side-by-side(align: horizon)[$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ]
$][
   $ nabla_x f(x)  = f(x) nabla_x log f(x) $
]

Apply log-derivative trick to $nabla product$

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ log( product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ // log trick: grad f(x) = f(x) grad log f(x)
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ log( product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ // log trick: grad f(x) = f(x) grad log f(x)

The log of products is the sum of logs

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ // log prod is one big sum
]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ 

The log of products is the sum of logs

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log Tr(s_(t+1) | s_t, a_t) + log pi (a_t | s_t; theta_pi) ]
$ // log(Tr * pi) is a sum of logs
]

==

#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log Tr(s_(t+1) | s_t, a_t) + log pi (a_t | s_t; theta_pi) ]
$ 

Gradient with respect to $theta$, no $theta$ in $Tr$, $Tr$ disappears

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ 
]

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ 

This is the *policy gradient*

Rewrite the gradient of the return in terms of the gradient of policy


==
#text(size: 23pt)[
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) \ #pin(1)dot sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi))#pin(2) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* Is this familiar?] 

#v(2em)

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) #pin(5)Pr (s_(n+1) | s_0; theta_pi)#pin(6) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$

#pinit-highlight(5, 6)
]

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ #pin(1)sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; theta_pi)#pin(2) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* Is this familiar?] 

#v(2em)

$ #redm[$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] $] $

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; theta_pi) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$

Careful rewriting as return because $pi$ relies on $n$

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

==

*Definition:* The policy gradient family of algorithms 

Update the parameters iteratively until convergence

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

Where the gradient is given as

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

==
$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = #pin(1)bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]#pin(2) dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$
#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* How to find this?] 

#v(2em)

*Answer:* Estimate expectation empirically

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] approx hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

==
*Definition:* The REINFORCE algorithm updates $theta_pi$ with empirical returns

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] approx hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] approx hat(bb(E))[cal(G)(bold(tau)) | s_0; #pin(1)theta_pi#pin(2)] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

*Question:* Is REINFORCE on-policy or off-policy?

HINT: 
- On-policy algorithms require data collected with $theta_pi$
- Off-policy algorithms can use data collected with any policy

*Answer:* On-policy, empirical return based on $theta_pi$

#pinit-highlight(1, 2)

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

*Question:* Any other ways to express $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$?

*Answer:* Value function or Q function

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0; theta_pi, theta_V) dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

We call this *actor-critic*, more discussion next time

==
How do we implement REINFORCE in code?

```python
def REINFORCE_loss(theta_pi, episode):
    """REINFORCE for discrete actions"""
    G = compute_return(episode.rewards) # empirical return
    # Log of the action probabilities
    log_probs = log(pi(episode.states, theta_pi)) 
    # We only update the policy for the actions we took
    # Discrete/categorical actions
    policy_gradient = G * log_probs[episode.actions]
    # Want gradient ascent, most library do gradient descent
    return -policy_gradient
```

==
```python
def REINFORCE_loss(theta_pi, episode):
    """REINFORCE for continuous actions using Gaussian pi"""
    G = compute_return(episode.rewards) # empirical return
    # Policy outputs mean and std dev
    mus, sigmas = pi(episode.states, theta_pi)
    # Log probability from equation of Gaussian
    log_probs = (
        (episode.actions - mus) ** 2 
        / (2 * sigmas ** 2) 
        - log(sigmas)
    )
    policy_gradient = G * log_probs
    # Want gradient ascent, most library do gradient descent
    return -policy_gradient
```


== 
STOP


/*
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) nabla_(theta_pi) [ log( product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) ]
$ // Change to log objective
*/

==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) nabla_(theta_pi) [ log( product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) ]
$ 

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) nabla_(theta_pi) [  sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) ]
$ // Log of products as sum of logs

==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) nabla_(theta_pi) [  sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) ]
$ 

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) nabla_(theta_pi) [  sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t)) + log(pi (a_t | s_t; theta_pi) ) ]
$ // Log policy transition product as sum of logs

==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) nabla_(theta_pi) [  sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t)) + log(pi (a_t | s_t; theta_pi) ) ]
$ 

*Question:* Can we simplify the gradient term?

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) sum_(t=0)^n nabla_(theta_pi)   log pi (a_t | s_t; theta_pi)  
$ // Evaluate gradient


==

*Question:* What is $nabla_x log(f(x))$? *Answer:* $1 / f(x) dot nabla_x f(x)$

$ nabla_x log f(x) = (nabla_x f(x) ) / f(x) $//=> nabla_x f(x) = f(x) nabla_x log f(x) $

==

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ 

==
STOP
==

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ 

Write again as state probability

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)
$ 

==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)
$ 

As we said, very intractable to compute the gradient

We can use a trick from statistics, the *log-derivative* trick

==

$ argmax_theta Pr (x; theta) = argmax_theta log Pr (x; theta) $

#align(center, log_trick)

*Question:* What is $nabla_x log(f(x))$? *Answer:* $1 / f(x) dot nabla_x f(x)$

$ nabla_x log f(x) = (nabla_x f(x) ) / f(x) $//=> nabla_x f(x) = f(x) nabla_x log f(x) $


==

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)
$ 

Multiply by "one"

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  (Pr (s_(n+1) | s_0; theta_pi)) / (Pr (s_(n+1) | s_0; theta_pi)) dot nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)
$ 

Move fraction

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  Pr (s_(n+1) | s_0; theta_pi) dot (nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)) / (Pr (s_(n+1) | s_0; theta_pi))
$ 

==

$ (nabla_x f(x)) / (f(x)) = nabla_x log f(x) $

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  Pr (s_(n+1) | s_0; theta_pi) dot (nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)) / (Pr (s_(n+1) | s_0; theta_pi))
$ 

Use log derivative trick to rewrite gradient

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  Pr (s_(n+1) | s_0; theta_pi) dot nabla_(theta_pi) log( Pr (s_(n+1) | s_0; theta_pi)) 
$ 

==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  Pr (s_(n+1) | s_0; theta_pi) dot nabla_(theta_pi) log( Pr (s_(n+1) | s_0; theta_pi)) 
$ 

We managed to pull the scary term out of the gradient

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $

==

Optimize the log probabilities instead of the probabilities

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  nabla_(theta_pi) log (Pr (s_(n+1) | s_0; theta_pi) )
$ 

*Question:* What is $d / (d x) log(f(x))$? *Answer:* $1 / f(x) dot (d ) / (d x) f(x)$

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  1 / (Pr (s_(n+1) | s_0; theta_pi)) nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)
$ 

==

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  1 / (Pr (s_(n+1) | s_0; theta_pi)) nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)
$  

Rewrite as fraction

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  (nabla_(theta_pi) Pr (s_(n+1) | s_0; theta_pi)) / (Pr (s_(n+1) | s_0; theta_pi)) 
$  





= Natural Policy Gradient


