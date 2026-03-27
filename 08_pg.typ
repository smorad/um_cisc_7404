#import "@preview/algorithmic:1.0.6"
#import algorithmic: style-algorithm, algorithm-figure, algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let log_trick = { 
    set text(size: 25pt)
    cetz.canvas(length: 1cm, {
        import cetz.draw: *
        import cetz-plot: *
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
    cetz.canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
        plot.plot(
            size: (10, 6),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 1,
            x-label: $ bold(theta) $,
            y-label: $ cal(G) $,
            {
            plot.add(
                domain: (0, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] $,
                x => calc.pow(x, 1) / (1 + calc.pow(x, 16)) ,
            )
            plot.add-anchor("pt", (1,1))
            })
    //draw.line("plot.pt", ((), "|-", (0,1)), mark: (start: ">"), name: "line")
    circle((3.6, 4.3), radius: 0.2cm, fill: black)
    circle((7.5, 0), radius: 0.2cm, fill: black)
    }
)}

#let policy_shift = { 
    set text(size: 25pt)
    cetz.canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
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
                label: $ pi (a | s; bold(theta)_(1)) $,
                x => normal_fn(-1, 0.5, x),
            ) 
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: blue)),
                label: $ pi (a | s; bold(theta)_(2)) $,
                x => normal_fn(-0.5, 0.3, x),
            )
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: green)),
                label: $ pi (a | s; bold(theta)_(3)) $,
                x => normal_fn(-0.1, 0.23, x),
            )
            plot.annotate({
                line((0,0), (0,4), stroke: orange)
                content((0,5), text(fill: orange)[$ argmax_(a in A) cal(G) $])
            })
        })
    }
)}
#let big_policy_shift = { 
    set text(size: 25pt)
    cetz.canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
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
                label: $ pi (a | s; bold(theta)) $,
                x => normal_fn(-1, 0.5, x),
            )
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: blue)),
                label: $ pi (a | s; bold(theta) + eta) $,
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
  //config-common(handout: true),
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
Exam next week #pause
- I still need to write it #pause
- Will post exam question information on Moodle tomorrow #pause
    - Most likely 3-4 questions on V/Q/policy gradient

==
If you want full participation marks, you must participate in lecture #pause
- Ask/answer lecture questions #pause
- Ask questions at office hours


==
A cute video of trajectory optimization #pause

https://www.youtube.com/watch?v=tudxHzZ5_ls

==

Last year, two authors of the RL textbook won the Turing Awards #pause

#cimage("fig/08/turing.jpg", height: 80%)

==
Richard Sutton was the first to combine neural networks with RL#footnote[Sutton, Richard S., et al. "Policy gradient methods for reinforcement learning with function approximation." Advances in neural information processing systems 12 (1999).]#pause
- He is widely considered the father of modern RL #pause
- He also was also responsible for the algorithm we will review today #pause

Richard Sutton's _Bitter Lesson_ #pause

http://www.incompleteideas.net/IncIdeas/BitterLesson.html


= Review

= Parameterized Policies
// Example with continuous actions
// Q learning with continuous actions not possible
// What if we can learn the policy instead?
// How do we represent the policy?
// Normal distribution or categorical
// We created a policy, but how do we learn it?

==
There are two types of algorithms #pause
- Value based methods (Q learning) #pause
- Policy gradient methods (today's material) #pause

All other algorithms are some combination of these two methods #pause
- After today, you can understand any decision making algorithm #pause

*Note:* LLM training almost always uses policy gradient methods #pause
- Direct Preference Optimization (DPO) #pause
- Group Relative Policy Optimization (GRPO) #pause

Policy gradient can change pretrained model parameters #pause
- Hear "finetuning", think policy gradient

==

Q learning is perfect, why do we need a new algorithm? #pause
- With Q learning, we learn a Q function #pause
- From the Q function, we derive an optimal policy #pause

$ pi (a_t | s_t; bold(theta)) =  cases( 
  1 "if" a_t = argmax_(a in A) Q(s_t, a, bold(theta)), 
  0 "otherwise"
) $ #pause

So why do we need a new algorithm?

/*
The policy is if/else -- it does not require parameters $bold(theta)$ to implement #pause

You may wonder why I have used $bold(theta)$ throughout the course #pause

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

$ pi (a_t | s_t; bold(theta)) =  cases( 
  1 "if" a_t = argmax_(a in A) Q(s_t, a, bold(theta)), 
  0 "otherwise"
) $ #pause

*Answer:* No, $argmax_(a in A)$, but $A$ is infinite. How can we take $argmax$ over an infinite set?

==

Can discretize action space (similar to last time, discretized state space) #pause
- Discrete actions lead to clunky/clumsy robots #pause
- We want our BenBen to dance naturally #pause

More flexible algorithm, policy for discrete or *continuous* action spaces #pause
- In continuous action spaces, there are infinitely many actions #pause
- Policy gradient can learn over this infinite action space #pause
    - Does that sound impossible?

==

In Q learning, we learn parameters $bold(theta)$ for $Q$ #pause
- Learn $Q$, use $Q$ in greedy policy #pause
    - Greedy policy is implicitly a function of $bold(theta)$ #pause
- In policy gradient, $bold(theta)$ represent policy parameters #pause
    - Learn policy directly, without $Q$ #pause

$ pi (a | s; bold(theta)) $ #pause

This is a distribution over the action space #pause
- Some distributions (like Gaussian) have infinite support #pause
- If $pi (a | s; bold(theta))$ is Gaussian, every action has nonzero probability #pause

We can improve the action distribution over time

= Policy Gradient
// Derivation
// Reinforce
// On or off policy?
// Off policy PG (leads into actor critic?)

==
Recall the policy-conditioned discounted return #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; pi)
$ #pause

Where the state distribution is #pause

$ Pr (s_(n+1) | s_0; pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t) ) $ 

==
Let us make $pi$ a neural network with parameters $bold(theta)$ #pause

$ pi (a_t | s_t; bold(theta)) $ #pause

We can say that the parameters $bold(theta)$ fully determine $pi$ #pause

$ Pr (s_(n+1) | s_0; bold(theta)) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ) $ #pause

And write the expected return in terms of $bold(theta)$ instead of $pi$ #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; bold(theta))
$ #pause

==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; bold(theta))
$ #pause

*Question:* Which term can we change here to improve the return? #pause

*Answer:* The policy parameters $bold(theta)$ #pause

$ Pr (s_(n + 1) | s_n; bold(theta)) = sum_(a_n in A) Tr (s_(n+1) | s_n, a_n) dot pi (a_n | s_n; bold(theta)) $ #pause

*Question:* How should we change $bold(theta)$? #pause

*Answer:* Change $bold(theta)$ to reach good $s in S$, making the return larger


==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; bold(theta))
$ #pause

We want to make $bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)]$ larger #pause

*Question:* How to change the policy parameters to improve the return? #pause

HINT: Calculus and optimization #pause

==

#side-by-side[
*Answer:* Gradient ascent, find the greatest slope and move that way #pause
][
#cimage("fig/08/surface.png", height: 60%) #pause
]


#v(1.5em)

$ #pin(5)bold(theta)_(i+1)#pin(6) = #pin(1)bold(theta)_(i)#pin(2) + alpha dot #pin(3)gradient_(bold(theta)_(i)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)]#pin(4) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Current policy] #pause

#pinit-highlight-equation-from((3,4), (3,3), fill: blue, pos: bottom, height: 1.2em)[$bold(theta)$ direction that maximizes return] #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[New policy] 

==

#v(1em)

$ #pin(5)bold(theta)_(i+1)#pin(6) = #pin(1)bold(theta)_(i)#pin(2) + alpha dot #pin(3)gradient_(bold(theta)_(i)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)]#pin(4) $

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Current policy] 

#pinit-highlight-equation-from((3,4), (3,3), fill: blue, pos: bottom, height: 1.2em)[$bold(theta)$ direction that maximizes return] 

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[New policy] #pause

#v(1.5em)

If find $gradient_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)]$, we can improve the policy and return #pause

#align(center, policy_shift)

==

$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; bold(theta))
$ #pause

$ Pr (s_(n+1) | s_0; bold(theta)) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ) $ #pause

We want 

$ gradient_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] $ #pause

First, combine top two equations so we have more space

==

#text(size: 23pt)[
$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; bold(theta))
$ 

$ Pr (s_(n+1) | s_0; bold(theta)) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ) $ #pause

Plug line 2 into line 1 #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ))
$ // Rewrite
]

==

#text(size: 23pt)[
$ 
bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ))
$ #pause

Take the gradient with respect to $bold(theta)$ of both sides #pause

$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = nabla_(bold(theta))[ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ))]
$ // Take gradient of both sides
]
==

#text(size: 23pt)[
$ 
= nabla_(bold(theta)) [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ (sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ))]
$  #pause

Move gradient inside sums #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(bold(theta)) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) )]
$ // Move gradient inside
]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(bold(theta)) [sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) )]
$ #pause 

Rewrite $Pr (s_(n+1) | s_0; bold(theta))$ by pulling action sum outside #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(bold(theta)) [sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ] 
$ // Rewrite p(s_n | s_0) pulling action sum outside
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot \ nabla_(bold(theta)) [sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) product_(t=0)^n  Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ] 
$ #pause

Move the gradient operator further inside the sum #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(bold(theta)) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ]
$ // Move gradient further inside
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(bold(theta)) [ product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)) ]
$ #pause

Want to move $nabla$ inside, split product #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(bold(theta)) [ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot (product_(t=0)^n pi (a_t | s_t; bold(theta))) ] // Split product
$
]

//Cannot move $nabla_(bold(theta))$ further inside, as all $s_(t+1)$ depends on $pi (a_0 | s_0; bold(theta))$ #pause

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(bold(theta)) [ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot (product_(t=0)^n pi (a_t | s_t; bold(theta))) ]
$ #pause

First term is a constant factor, pull out constant #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot nabla_(bold(theta))[product_(t=0)^n pi (a_t | s_t; bold(theta)) ]
$
]
==
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot nabla_(bold(theta))[product_(t=0)^n pi (a_t | s_t; bold(theta)) ]
$ #pause

Can use chain and product rule, but will create a mess of terms #pause

$ nabla_(bold(theta)) [ pi (a_n | s_n; bold(theta)) dots dot pi (a_0 | s_0; bold(theta))] = \
 nabla_(bold(theta)) [ pi (a_n | s_n; bold(theta)) ] dot pi (a_(n-1) | s_(n-1); bold(theta)) dots $

It will be very expensive/intractable to compute all terms!


//Have to backpropagate through $n^2$ products, which is intractable


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
#side-by-side(align: horizon)[

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot nabla_(bold(theta))[product_(t=0)^n pi (a_t | s_t; bold(theta)) ]
$ #pause
    
][
   $ nabla_x f(x)  = f(x) nabla_x log f(x) $ #pause
]

Apply log-derivative trick to $nabla product$ #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot product_(t=0)^n pi (a_t | s_t; bold(theta)) dot nabla_(bold(theta))[log( product_(t=0)^n pi (a_t | s_t; bold(theta)) ) ]
$ // log trick: grad f(x) = f(x) grad log f(x)
]
==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot product_(t=0)^n pi (a_t | s_t; bold(theta)) dot nabla_(bold(theta))[log( product_(t=0)^n pi (a_t | s_t; bold(theta)) ) ]
$ #pause // log trick: grad f(x) = f(x) grad log f(x)

The log of products is the sum of logs: $log(a b) = log(a) + log(b)$ #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot product_(t=0)^n pi (a_t | s_t; bold(theta)) dot nabla_(bold(theta))[sum_(t=0)^n log pi (a_t | s_t; bold(theta))  ]
$ // split log prods to sum logs

]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot product_(t=0)^n pi (a_t | s_t; bold(theta)) dot nabla_(bold(theta))[sum_(t=0)^n log pi (a_t | s_t; bold(theta))  ]
$ #pause 

Gradient of sum is sum of gradients #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot product_(t=0)^n pi (a_t | s_t; bold(theta)) dot sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta))  
$ // Distribute grad into sum
]

==
#text(size: 23pt)[
$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t)) dot product_(t=0)^n pi (a_t | s_t; bold(theta)) dot sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta))  
$  #pause

Last step, recombine product #pause

$ 
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta))) dot sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta))  
$ 

]


==
$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)))  sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta))
$ #pause

*Definition:* This is the *policy gradient* #pause
- Rewrote the gradient of the return in terms of the gradient of policy #pause
- But this is a bit messy, and we don't know how to train it yet!

==
We have the policy gradient #pause

$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)))  sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta))
$ #pause

Can we write it in a simpler form so we can approximate it?

==
#text(size: 23pt)[
$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) \ #pin(1)dot sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) (product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; bold(theta)))#pin(2)  sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) 
$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* Is this familiar?] #pause

#v(2em)

$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) #pin(5)Pr (s_(n+1) | s_0; bold(theta))#pin(6)  sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) 
$

#pinit-highlight(5, 6)
]

==
$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = \ #pin(1)sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; bold(theta))#pin(2)  sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) 
$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[*Question:* Is this familiar?] #pause

#v(2em)

$ #redm[$ bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] $] $

==
$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = \ sum_(#pin(1)n=0#pin(2))^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; bold(theta)) sum_(t=0)^(#pin(3)n#pin(4)) nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) 
$ #pause

Would like to rewrite as 

$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] sum_(t=0)^n nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) 
$ #pause

#pinit-highlight(1, 2)
#pinit-highlight(3, 4)
Careful, rightmost sum relies on $n$ -- cannot rewrite expectation like this 

==
$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; bold(theta)) sum_(t=0)^(n) nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) $ #pause

Focus on the gradient for just the initial action ($a_0$) #pause

$ nabla_(bold(theta) | a_0) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = \ sum_(n=0)^oo gamma^n sum_(s_(n + 1)) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; bold(theta)), bb(E)[cal(G) | s_0; bold(theta)] dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) $ 

==
$ nabla_(bold(theta) | a_0) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = \ underbrace(sum_(n=0)^oo gamma^n sum_(s_(n + 1)) cal(R)(s_(n+1)) Pr (s_(n+1) | s_0; bold(theta)), bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)]) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) $ 

Now we can rewrite this as an expectation #pause

$ nabla_(bold(theta) | a_0) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[ cal(G)(bold(tau)) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) | s_0; bold(theta)] $ 

Markov property: Treat each timestep $t$ in a trajectory as the start $s_0, a_0$ #pause

$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[ cal(G)(bold(tau)) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) | s_0; bold(theta)] $ 

==
$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[ cal(G)(bold(tau)) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) | s_0; bold(theta)] $ #pause

*Question:* Can we pull the $nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta))$ term out of $bb(E)[dots]$? #pause

*Hint:* Recall that the expectation sums over actions

$ sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(#redm[$a_t in A$]) Tr(s_(t+1) | s_t, a_t) dot pi (#redm[$a_t$] | s_t) ) $ #pause

*Answer:* Cannot pull $log pi$ out, this $bb(E)$ sums over actions 

==
*Definition:* The policy gradient family of algorithms #pause

Update the parameters iteratively until convergence #pause

$ bold(theta)_(i+1) = bold(theta)_(i) + alpha dot gradient_(bold(theta)_(i)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)] $ #pause

Using the policy gradient #pause

$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[ cal(G)(bold(tau)) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) | s_0; bold(theta)] $ 

==
$ bold(theta)_(i+1) = bold(theta)_(i) + alpha dot gradient_(bold(theta)_(i)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)] $ 

$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[ cal(G)(bold(tau)) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) | s_0; bold(theta)] $  #pause

*Question:* Is policy gradient on-policy or off-policy? #pause

*Answer:* On-policy (cannot reuse old data) #pause
- Collect data using $pi (a | s; bold(theta))$ #pause
- Update parameters $bold(theta)_(i+1) = ...$ #pause
- You need $nabla_(bold(theta)_(i+1)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i+1)]$ but your data is $bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)]$


= REINFORCE
==
$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] = bb(E)[ cal(G)(bold(tau)) dot nabla_(bold(theta)) log pi (a_0 | s_0; bold(theta)) | s_0; bold(theta)]  
$  #pause

This is our formula #pause

*Question:* How do we compute this expectation? #pause

*Answer:* Empirically! #pause *Note:* Use full trajectory for $bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)]$ #pause

$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] approx sum_(t=0)^oo cal(G)(bold(tau)_t) dot pi (a_t | s_t; bold(theta)) $

//Where $bold(tau)_t$ starts at timestep $t$: $bold(tau)_t = (s_t, a_t, s_(t+1), a_(t+1), dots)$
#side-by-side[
    $ bold(tau)_0 = mat(s_0, s_1, s_2, dots; a_0, a_1, a_2, dots)^top $
][
    $ bold(tau)_1 = mat(s_1, s_2, dots; a_1, a_2, dots)^top $
][
    $ bold(tau)_2 = mat(s_2, dots; a_2, dots)^top $ 
]

==
$ nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] approx sum_(t=0)^oo cal(G)(bold(tau)_t) dot pi (a_t | s_t; bold(theta)) $ #pause

$ = &cal(G)(mat(s_0, s_1, s_2, dots; a_0, a_1, a_2, dots)^top) && dot pi (a_0 | s_0; bold(theta)) \
+  &cal(G)(mat(s_1, s_2, dots; a_1, a_2, dots)^top) && dot pi (a_1 | s_1; bold(theta)) \ 
+ &cal(G)(mat(s_2, dots; a_2, dots)^top) && dot pi (a_2 | s_2; bold(theta)) \
+ & dots

$


==
*Definition:* The REINFORCE algorithm updates $bold(theta)$ with empirical (Monte Carlo) returns #pause

$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] approx sum_(t=0)^oo cal(G)(bold(tau)_t) dot nabla_(bold(theta)) log pi (a_t | s_t; bold(theta))
$ #pause

$ bold(tau)_t = mat(s_t, a_t; s_(t+1), a_(t+1); dots.v, dots.v) $

$ bold(theta)_(i+1) = bold(theta)_(i) + alpha dot gradient_(bold(theta)_(i)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)] $

==
$ 
nabla_(bold(theta)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)] approx sum_(t=0)^oo cal(G)(bold(tau)_t) dot nabla_(bold(theta)) log pi (a_t | s_t; bold(theta)) \ #pause

bold(theta)_(i+1) = bold(theta)_(i) + alpha dot gradient_(bold(theta)_(i)) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_(i)] $ #pause

*Question:* Any other ways to express $bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)]$? #pause 

*Answer:* Value or Q function #pause

$ 
nabla_(bold(theta)_pi) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_pi] &= V(s_0, bold(theta)_V, bold(theta)_pi) dot nabla_(bold(theta)_pi) log pi (a_0 | s_0; bold(theta)_pi) \

nabla_(bold(theta)_pi) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_pi] &= Q(s_0, a_0, bold(theta)_Q, bold(theta)_pi) dot nabla_(bold(theta)_pi) log pi (a_0 | s_0; bold(theta)_pi)
$ #pause

We call this *actor-critic*, more discussion next time

= Coding


==
We can implement our policy using all sorts of action distributions #pause
- For discrete tasks, we often use *categorical* distributions #pause
- For continuous tasks, we usually use *normal* distributions #pause
    - However, some people say beta distributions work better! #footnote["Improving stochastic policy gradients in continuous control with deep reinforcement learning using the beta distribution." International conference on machine learning. PMLR, 2017.]

==
The coding looks a little bit different than the math #pause
- We often separate the model, policy distribution, and sampled action #pause

```python
# Compute "logits", unnormalized probabilities
z = model(x) 
# Create distribution pi(a | s; theta)
p_a = dist(z) # For loss function
# Sample action that we use in environment
a = sample(p_a) # For env step
```


==
Create a model for discrete action spaces #pause

```python
discrete_action_model = nn.Sequential([
    nn.Linear(state_size, hidden_size),
    nn.Lambda(leaky_relu),
    nn.Linear(hidden_size, hidden_size),
    nn.Lambda(leaky_relu)
    # Output logits for possible actions
    nn.Linear(hidden_size, action_size),
])
``` 

==

Need a function to get actions for our environment

```python
def sample_action(model, state, key):
    z = model(state)
    # BE VERY CAREFUL, always read documentation
    # Sometimes takes UNNORMALIZED logits, sometimes probs
    action_probs = softmax(model, state)
    a = categorical(key, action_probs)
    a = categorical(key, z) # Does not even use pi
    return a

```

==

```python
def REINFORCE_loss(model, episode):
    """REINFORCE for discrete actions"""
    G = compute_return(rewards) # empirical return
    # We need log(pi(a | s)), softmax => probs
    # log_softmax more stable than log(softmax(x))
    log_probs = log_softmax(model(episode.states))
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
continuous_action_model = nn.Sequential([
    nn.Linear(state_size, hidden_size),
    nn.Lambda(leaky_relu),
    nn.Linear(hidden_size, hidden_size),
    nn.Lambda(leaky_relu)
    nn.Linear(hidden_size, 2 * action_size),
    # Like to use a diagonal multivariate Gaussian
    # Assumes independence between actions (approximation)
    nn.Lambda(lambda x: split(x, 2))
])
```

==
```python
def sample_action(model, state, key):
    # Log(sigma) because neural network outputs +/-
    # sigma only + but log_sigma can be +/-
    mu, log_sigma = model(state)
    a = normal(key, mu, exp(sigma))
    return a
```

==
```python
def REINFORCE_loss(model, episode):
    """REINFORCE for continuous actions using Gaussian pi"""
    G = compute_return(rewards) # empirical return
    # Policy outputs mean and log(std dev)
    mus, log_sigmas = model(episode.states)
    # Log probability of action we took under action dist 
    # log pi(a = episode.a | s)
    # (a-mus)**2 / (2*exp(log_sigmas)**2)+log_sigmas
    log_probs = vmap(jax.scipy.stats.norm.logpdf)(
        episode.actions, mus, exp(log_sigmas))
    policy_gradient = mean(G * log_probs)
    # Want gradient ascent, library does gradient descent
    return -policy_gradient
```

= Homework

==
Homework 3 is the last homework #pause
- *Start early*, one training run can take up to an hour #pause
- If you have bugs, you will need to restart training #pause
- If you wait until the day before, you will not succeed #pause

Due 04.19, same as deep Q learning assignment

==

https://colab.research.google.com/drive/1JWfMYviwt7tgU08QDeIZV82MuzVQZbX1