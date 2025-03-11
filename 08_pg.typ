/**/#import "@preview/algorithmic:0.1.0"
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

#let overshoot = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (10, 6),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 1,
            x-label: $ theta_pi $,
            y-label: $ cal(G) $,
            {
            plot.add(
                domain: (0, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] $,
                x => calc.pow(x, 1) / (1 + calc.pow(x, 16)) ,
            )
            plot.add-anchor("pt", (1,1))
            })
    //draw.line("plot.pt", ((), "|-", (0,1)), mark: (start: ">"), name: "line")
    draw.circle((3.6, 4.3), radius: 0.2cm, fill: black)
    draw.circle((7.5, 0), radius: 0.2cm, fill: black)
    }
)}

#let policy_shift = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (10, 4),
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
                label: $ pi (a | s; theta_(pi, 1)) $,
                x => normal_fn(-1, 0.5, x),
            ) 
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: blue)),
                label: $ pi (a | s; theta_(pi, 2)) $,
                x => normal_fn(-0.5, 0.3, x),
            )
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: green)),
                label: $ pi (a | s; theta_(pi, 3)) $,
                x => normal_fn(-0.1, 0.23, x),
            )
            })
            draw.line((5,0), (5,4), stroke: orange)
            draw.content((5,5), text(fill: orange)[$ argmax_(a in A) cal(G) $])
    //draw.line("plot.pt", ((), "|-", (0,1)), mark: (start: ">"), name: "line")
    }
)}
#let big_policy_shift = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (10, 6),
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
                label: $ pi (a | s; theta_pi) $,
                x => normal_fn(-1, 0.5, x),
            )
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: blue)),
                label: $ pi (a | s; theta_pi + eta) $,
                x => normal_fn(1, 0.2, x),
            )
            })
    //draw.line("plot.pt", ((), "|-", (0,1)), mark: (start: ">"), name: "line")
    }
)}

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

= Admin
==

Homework 1 was due yesterday 23:59 #pause

How was the homework? #pause

We are about 50% finished with the course #pause

Any opinions/feedback on the course? #pause
- Can also talk after class #pause
- Or email smorad at um.edu.mo 

==
If you want full participation marks, you must participate in lecture #pause


Right now, the following students have full participation marks: #pause
#side-by-side[
- LIU KEJIA
- LIU HUANRONG
- HOI HOU HONG
- CHEN ZELAI
- WANG ZEKANG
- HE ZHE
][
- WANG MENGQI
- ZHANG BORONG
- HE ENHAO
- QIAO YULIN
- YAO CHENYU
- KAM KA HOU
]

==
Some names might be missing! #pause

I am bad with names, but I remember faces #pause

I have a list of university pictures linked to names #pause

Some of you look very different in your university pictures #pause

If you often answer questions but are missing from the list, I will remember you #pause

Come talk to me during the break or after class #pause

For everyone else, there is still time to participate

#side-by-side[
    Ask/answer lecture questions #pause
 ][
    Ask questions at office hours
 ]


==
A cute video of trajectory optimization #pause

https://www.youtube.com/watch?v=tudxHzZ5_ls

==
Richard Sutton and Andrew Barto (authors of RL textbook) recently won the Turing award ("Nobel prize of computing") #pause

#cimage("fig/08/turing.jpg", height: 70%)

==
They won the award "For developing the conceptual and algorithmic foundations of reinforcement learning" #pause

Richard Sutton's _Bitter Lesson_ #pause

http://www.incompleteideas.net/IncIdeas/BitterLesson.html


// Still want to maximize the return (restate this), dependent on theta

= Parameterized Policies
// Example with continuous actions
// Q learning with continuous actions not possible
// What if we can learn the policy instead?
// How do we represent the policy?
// Normal distribution or categorical
// We created a policy, but how do we learn it?

==
There are two types of algorithms #pause
- Value based methods (Q learning, trajectory optimization) #pause
- Policy gradient methods (today's material) #pause

All other algorithms are some combination of these two methods #pause

Once you know policy gradient, you can understand any decision making algorithm #pause

*Note:* LLM finetuning almost always uses policy gradient methods #pause
- Direct Preference Optimization (DPO) #pause
- Group Relative Policy Optimization (GRPO) #pause

Policy gradient can change pretrained model parameters 

==

Q learning is perfect, why do we need a new algorithm? #pause

With Q learning, we learn a Q function #pause

From the Q function, we derive an optimal policy #pause

$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a in A) Q(s_t, a, theta_pi), 
  0 "otherwise"
) $ #pause

So why do we need a new algorithm?

/*
The policy is if/else -- it does not require parameters $theta_pi$ to implement #pause

You may wonder why I have used $theta_pi$ throughout the course #pause

Today, we will see why
*/

== 

*Example:* Consider a Unitree BenBen, with 12 joints #pause

#side-by-side[
    #cimage("fig/08/benben.png", height: 50%) #pause
][
    #cimage("fig/08/humanoid.jpg", height: 50%) #pause
]


To learn to motion, we must learn actions for all joints $A in [0, 2 pi]^(12)$


==

#side-by-side[
    #cimage("fig/08/benben.png", height: 50%) #pause
][
$ A in [0, 2 pi]^(12) $ #pause

*Question:* Can we use our greedy max Q policy for BenBen? #pause
]

$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a in A) Q(s_t, a, theta_pi), 
  0 "otherwise"
) $ #pause

*Answer:* No, $argmax_(a in A)$, but $A$ is infinite. How can we take $argmax$ over an infinite set?

==

Can discretize action space (similar to last time, discretized state space) #pause

Discrete actions lead to clunky/clumsy robots #pause

We want our BenBen to dance naturally #pause

More flexible algorithm, policy for discrete or *continuous* action spaces #pause

In continuous action spaces, there are infinitely many actions #pause

Policy gradient can learn over this infinite action space #pause

Does that sound impossible?

==

The secret is directly learning the policy (action distribution) #pause

$ pi (a | s; theta_pi) $ #pause

This is a distribution over the action space #pause

Some distributions (like Gaussian) have infinite support #pause

If $pi (a | s; theta_pi)$ is Gaussian, every action has nonzero probability #pause

We can improve the action distribution over time

= Policy Gradient
// Derivation
// Reinforce
// On or off policy?
// Off policy PG (leads into actor critic?)

==
*Definition:* General form of policy-conditioned discounted return #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ #pause

Where the state distribution is #pause

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $ 

==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ #pause

*Question:* What can we change here to change the return? #pause

*Answer:* The policy parameters $theta_pi$ #pause

$ Pr(s_(n + 1) | s_n) = sum_(a_n in A) Tr (s_(n+1) | s_n, a_n) dot pi (a_n | s_n; theta_pi) $ #pause

*Question:* How should we change $theta_pi$? #pause

*Answer:* Change $theta_pi$ so we reach good $s in S$, making the return larger


==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ #pause

We want to make $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ larger #pause

*Question:* How to change the policy parameters to improve the return? #pause

HINT: Calculus and optimization #pause

==

#side-by-side[
*Answer:* Gradient ascent, find the greatest slope and move that way #pause
][
#cimage("fig/08/surface.png", height: 60%) #pause
]


#v(1.5em)

$ #pin(5)theta_(pi, i+1)#pin(6) = #pin(1)theta_(pi, i)#pin(2) + alpha dot #pin(3)gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)]#pin(4) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Current policy] #pause

#pinit-highlight-equation-from((3,4), (3,3), fill: blue, pos: bottom, height: 1.2em)[$theta$ direction that maximizes return] #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[New policy] 

==

#v(1em)

$ #pin(5)theta_(pi, i+1)#pin(6) = #pin(1)theta_(pi, i)#pin(2) + alpha dot #pin(3)gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)]#pin(4) $

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Current policy] 

#pinit-highlight-equation-from((3,4), (3,3), fill: blue, pos: bottom, height: 1.2em)[$theta$ direction that maximizes return] 

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[New policy] #pause

#v(1.5em)

If find $gradient_(theta_(pi)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi)]$, we can improve the policy and return #pause

#align(center, policy_shift)

==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ #pause

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $ #pause

We want 

$ gradient_(theta_(pi)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi)] $ #pause

First, combine top two equations so we have more space

==

#text(size: 23pt)[
$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $ #pause

Plug line 2 into line 1 #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ))
$ // Rewrite
]

==

#text(size: 23pt)[
$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ))
$ #pause

Take the gradient with respect to $theta_pi$ of both sides #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = nabla_(theta_pi)[ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ))]
$ // Take gradient of both sides
]
==

#text(size: 23pt)[
$ 
= nabla_(theta_pi) [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ))]
$  #pause

Move gradient inside sums #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ // Move gradient inside
]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) )]
$ #pause 

Rewrite $Pr (s_(n+1) | s_0; theta_pi)$ by pulling action sum outside #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ] 
$ // Rewrite p(s_n | s_0) pulling action sum outside
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(theta_pi) [sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ] 
$ #pause

Move the gradient operator further inside the sum #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ]
$ // Move gradient further inside
]
==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ]
$ #pause

Cannot move $nabla_(theta_pi)$ further inside, as all $s_(t+1)$ depends on $pi (a_0 | s_0; theta_pi)$ #pause

$ nabla_(theta_pi) [ dots dot pi (a_1 | s_1; theta_pi) dot Tr(s_(1) | s_0, a_0) dot pi (a_0 | s_0; theta_pi)] $

Can use chain and product rule, but will create a mess of terms #pause

Have to backpropagate through $n^2$ products, which is intractable


/*
Expanded product has many terms, computing gradient very expensive

//Computing this gradient is very expensive, how $a_0$ impacts $Tr(s_(n+1))$

Can only compute for short sequences and small state/action spaces
*/

//Utilize the *log-derivative trick*

// *Trick:* Optimize log objective

==

*Log-derivative trick:* #pause

*Question:* What is $ nabla_x log(f(x)) $ #pause

*Answer:* 

$ nabla_x log(f(x)) &= 1 / f(x) dot nabla_x f(x) \ #pause

 f(x) nabla_x log f(x)  &= nabla_x f(x) \ #pause

 nabla_x f(x) &= f(x) nabla_x log f(x)  
$


==

#text(size: 23pt)[
#side-by-side(align: horizon)[$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ]
$ #pause ][
   $ nabla_x f(x)  = f(x) nabla_x log f(x) $ #pause
]

Apply log-derivative trick to $nabla product$ #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ log( product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ // log trick: grad f(x) = f(x) grad log f(x)
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ log( product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ #pause // log trick: grad f(x) = f(x) grad log f(x)

The log of products is the sum of logs: $log(a b) = log(a) + log(b)$ #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ // log prod is one big sum
]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log( Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ]
$ #pause

The log of products is the sum of logs (again) #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log Tr(s_(t+1) | s_t, a_t) + log pi (a_t | s_t; theta_pi) ]
$ // log(Tr * pi) is a sum of logs
]

==

#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log Tr(s_(t+1) | s_t, a_t) + log pi (a_t | s_t; theta_pi) ]
$ #pause

Gradient with respect to $theta$, no $theta$ in $Tr$, $Tr$ is constant that  disappears #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ 
]

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ #pause

This is the *policy gradient* #pause

Rewrote the gradient of the return in terms of the gradient of policy


==
#text(size: 23pt)[
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) \ #pin(1)dot sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi))#pin(2) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* Is this familiar?] #pause

#v(2em)

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) #pin(5)Pr (s_(n+1) | s_0; theta_pi)#pin(6) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$

#pinit-highlight(5, 6)
]

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ #pin(1)sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; theta_pi)#pin(2) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* Is this familiar?] #pause

#v(2em)

$ #redm[$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] $] $

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; theta_pi) [ sum_(t=0)^n nabla_(theta_pi) log pi (a_t | s_t; theta_pi) ]
$ #pause

Careful rewriting as return because $pi$ relies on $n$ #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) nabla_(theta_pi) log pi (a | s; theta_pi) 
$

We can write the gradient of the return in terms of the policy gradient

==

*Definition:* The policy gradient family of algorithms #pause

Update the parameters iteratively until convergence #pause

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $ #pause

Using the policy gradient 

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) nabla_(theta_pi) log pi (a | s; theta_pi) 
$

==
$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = #pin(1)bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]#pin(2) dot sum_(s, a in bold(tau)) nabla_(theta_pi) log pi (a | s; theta_pi) 
$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* How to find this?] #pause

#v(2em)

*Answer:* Estimate expectation empirically #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] approx hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) nabla_(theta_pi) log pi (a | s; theta_pi) 
$

==
*Definition:* The REINFORCE algorithm updates $theta_pi$ with empirical returns #pause

Monte-Carlo variant of policy gradient #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] approx hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) nabla_(theta_pi) log pi (a | s; theta_pi) 
$ #pause

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] approx hat(bb(E))[cal(G)(bold(tau)) | s_0; #pin(1)theta_pi#pin(2)] dot sum_(s, a in bold(tau)) nabla_(theta_pi) log pi (a | s; theta_pi) 
$

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $

*Question:* Is REINFORCE on-policy or off-policy? #pause

HINT: 
- On-policy algorithms require data collected with $theta_pi$
- Off-policy algorithms can use data collected with any policy #pause

*Answer:* On-policy, empirical return based on $theta_pi$ 

#pinit-highlight(1, 2)

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot gradient_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $ #pause

*Question:* Any other ways to express $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$? #pause

*Answer:* Value function or Q function #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0; theta_pi, theta_V) dot sum_(s, a in bold(tau)) log pi (a | s; theta_pi) 
$ #pause

We call this *actor-critic*, more discussion next time

= Coding
==
We can implement our policy using all sorts of action distributions #pause

For discrete tasks, we often use *categorical* distributions #pause

For continuous tasks, we usually use *normal* distributions #pause

However, some people say Beta distributions work better! #footnote["Improving stochastic policy gradients in continuous control with deep reinforcement learning using the beta distribution." International conference on machine learning. PMLR, 2017.]


==
Create a policy for discrete action spaces #pause

```python
discrete_action_policy = nn.Sequential([
    nn.Linear(state_size, hidden_size),
    nn.Lambda(leaky_relu),
    nn.Linear(hidden_size, hidden_size),
    nn.Lambda(leaky_relu)
    nn.Linear(hidden_size, action_size),
    # Probability over possible actions
    nn.Lambda(jax.nn.log_softmax) # log(softmax(x))
])
``` #pause

We use `log_softmax` for numerically stable gradients 

==

```python
def REINFORCE_loss(theta_pi, episode):
    """REINFORCE for discrete actions"""
    G = compute_return(rewards) # empirical return
    # Policy already outputs log(softmax(x)) 
    log_probs = pi(episode.states, theta_pi) 
    # We only update the policy for the actions we took
    # Discrete/categorical actions
    # Can use sum or mean
    policy_gradient = mean(G * log_probs[episode.actions])
    # Want gradient ascent, most library do gradient descent
    return -policy_gradient
```

==
What about continuous action spaces? #pause

```python
continuous_action_policy = nn.Sequential([
    nn.Linear(state_size, hidden_size),
    nn.Lambda(leaky_relu),
    nn.Linear(hidden_size, hidden_size),
    nn.Lambda(leaky_relu)
    nn.Linear(hidden_size, 2 * action_size),
    # Like to use a diagonal multivariate Gaussian
    # Assumes independence between actions (approximation)
    # Produce mu and log_sigma for each action dim
    nn.Lambda(lambda x: split(x, 2))
])
```

==
```python
def REINFORCE_loss(theta_pi, episode):
    """REINFORCE for continuous actions using Gaussian pi"""
    G = compute_return(rewards) # empirical return
    # Policy outputs mean and log(std dev)
    mus, log_sigmas = pi(episode.states, theta_pi)
    # Log probability from equation of Gaussian
    log_probs = -(
        (episode.actions - mus) ** 2 
        / (2 * exp(log_sigmas) ** 2) 
        + log_sigmas
    )
    policy_gradient = mean(G * log_probs)
    # Want gradient ascent, most library do gradient descent
    return -policy_gradient
```

= Homework

==
Homework 2 is the final homework, and it is a little special #pause

You can choose one of two Assignments #pause
- Policy gradient (easier, max 80/100) #pause
- Deep Q learning (harder, max 100/100) #pause

I will only grade one assignment #pause

You can try and estimate the return for completing each assignment #pause

My suggestion: start with policy gradient #pause

If you solve policy gradient early, then try deep Q learning #pause

Deep Q learning requires more hyperparameter tuning

==

*Start early*, one training run can take up to an hour #pause

If you have bugs, you will need to restart training #pause

If you wait until the day before, you will not succeed #pause

Due in 3 weeks (04.09)

/*

= Natural Policy Gradient

==
When the policy $pi$ is linear, things work well

When $pi$ is nonlinear (deep network), it can be more difficult to train

*Question:* Why?

*Answer:* A small parameter update can cause a big change in policy 

== 
With a deep network, a small change in $theta_pi$ can result in a large distribution shift 

$ pi ( dot | s; theta_pi) approx.not pi (dot | s; theta_pi + eta ) $

Small parameter updates can destroy the policy or cause large changes

$ theta_(pi, i+1) = theta_(pi, i) + underbrace(alpha dot bb(E)[cal(G)(bold(tau)) | s_0; theta_pi], eta) $  

Even with a small learning rate $alpha$, we still have this issue!

==

Updates can result in *overshooting*

#align(center, overshoot)

This also happens in supervised learning, but is easier to recover

If the policy breaks in RL, we collect bad training data

==

Small parameter updates can cause large shifts in the policy distribution

With a neural network, updating $pi(a | s = S_i)$ changes $pi(a | s = S_j)$

#align(center, big_policy_shift)

==

One of the main causes of these issues is the *optimization space*

We update our parameters using Euclidean distance in parameter space 

$ "d"(theta_(pi, i + 1), theta_(pi, i)) < k $

Euclidean change in parameter does not bound the action distribution

$ "d" (pi (dot | s; theta_pi), pi (dot | s; theta_pi + eta)) lt.not k $

Can we bound the change in action distribution?

==
Right now, the update is euclidean in the parameter space

$ theta_(pi, i+1) approx theta_(pi, i) + eta $  

But unbounded in the policy distribution space

$ pi (dot | s; theta_pi) approx.not pi (dot | s; theta_pi + eta) $

Instead, we want to bound the policy in the distribution space

*Question:* Can we measure the distance between two distributions?

*Answer:* Yes, using *KL divergence*

==

$ "KL" ["Pr"_1, "Pr"_2] = sum_(omega in Omega) "Pr"_1(omega) dot log ("Pr"_1(omega)) / ("Pr"_2(omega)) $

For policies

$ "KL" [pi (dot | s; theta_pi), pi (dot | s; theta_pi + eta) ] = sum_(a in A) pi (dot | s; theta_pi) dot log (pi (dot | s; theta_pi)) / (pi (dot | s; theta_pi + eta)) $
*/