#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let base_poem = {
    quote(block: true)[
        #text(font: "Chalkduster", size: 22pt)[
            User: Hello, please write me a poem.

            Agent: Sure thing! Here is a poem:

            Roses are red,
            violets are blue,
            you are beautiful,
            and I love you
            ]
        ]
}

#let poem_action = {
    quote(block: true)[
        #text(font: "Chalkduster", size: 22pt)[
            User: Hello, please write me a poem.

            Agent: Sure thing! Here is a poem:

            Roses are red,
            violets are blue,
            #pin(1)you#pin(2) #pin(3)are#pin(4) #text(fill: luma(70%))[#pin(5)beautiful#pin(6),
            and I love you]
            ]
        ]
}

#let poem_state = {
    quote(block: true)[
        #text(font: "Chalkduster", size: 22pt)[
            User: #text(fill: orange)[Hello, please write me a poem.]

            Agent: #text(fill: purple)[Sure thing! Here is a poem:

            Roses are red,
            violets are blue,
            #pin(1)you#pin(2) #pin(3)are#pin(4)] #text(fill: luma(70%))[#pin(5)beautiful#pin(6),
            and I love you]
            ]
        ]
}

#let state_vec = $ vec(
    #text(fill:orange)[Hello],
    #text(fill:orange)[,],
    #text(fill:orange)[please],
    dots.v,
    #text(fill:purple)[you],
    #text(fill:purple)[`<EOS>`]
) $

#let state_vec_partial = $ vec(
    #text(fill:orange)[Hello],
    #text(fill:orange)[,],
    #text(fill:orange)[please],
    dots.v,
    #text(fill:purple)[,],
    #text(fill:purple)[you]
) $


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Large Language Models],
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
Last lecture!

Who started final project coding?
- Who is already training?
- Who learned a good policy?

If you did not make progress, maybe switch to easy backup project

Remember to read the final project requirements carefully!
- Code
- Final report
- Video demonstration

Deadline 3 May (10 days)

==
I am grading Quiz 3 myself

Will take some time for complete grades

==
*Question for next year:* Which is better?
- 3 quizzes total, 1 quizzes dropped
- 2 quizzes total, 0 quizzes dropped

*Question for next year:* Homework 2 choice
- Choose either DQN or PG
- Complete both DQN and PG

*Question for next year:* Final project
- Choose your own problem?
- I give you either Atari or MuJoCo game to solve



= Language Modeling
==
In my deep learning course, we viewed LLMs as deep learning

Today, we will view LLMs as decision making machines

We will combine everything we learned to create LLMs:
- Policy gradient
- Value functions
- Actor critic
- Imitation learning
- Offline RL
- POMDPs

You have all the knowledge you need to build LLMs!


==
Let us consider the problem of language modeling

We are presented with some variable-length text

And we want to craft a reply

#base_poem
==
#base_poem

*Question:* What is the action space $A$ of our problem?

*Answer 1:* All possible text $A = {"A", "Aardvark", dots, "Zebra"}^n $ 

*Answer 2:* All possible words $A = {"A", "Aardvark", dots, "Zebra", "<EOS>"} $ 

==
$ A = {"A", "Aardvark", dots, "Zebra"}^n $ 

$ A = {"A", "Aardvark", dots, "Zebra" "<EOS>"} $ 

First approach, produce the entire output at once

Second approach, produce one word at a time

*Question:* Which is correct?

*Answer:* First method

$ A = {"A", "Aardvark", dots, "Zebra"}^n $ 

*Question:* Any issues with this action space?

==
$ A = {"A", "Aardvark", dots, "Zebra"}^n $ 

*Answer:* $n in [0, oo]$ so action space is infinite

But we learned policy gradient for continuous/infinite action space

*Question:* Why does policy gradient fail with this infinite action space?

BenBen joint angles, etc are bounded, continuous, and with ordering 

Action $a=4.1$ is similar to $a=4$, policy can generalize

Meaning of A $!=$ meaning of Aardvark

Policy cannot generalize over infinite discrete actions!


==
#side-by-side[$ A = {"A", "Aardvark", dots, "Zebra"}^n $ ][Very difficult to model]



Instead, factorize action space into single word or *token*

$ A = {"A", "Aardvark", dots, "Zebra" "<EOS>"} $ 

We implement the action space as a dictionary or integer$->$token map

$ {0: "A", space 1:"Aardvark", space dots, space 250,000: "Zebra"} $

Action 1 corresponds to the word "Aardvark"

This is still a very large action space!

==
$ A = {"A", "Aardvark", dots, "Zebra"} $ 

#poem_action

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] 
#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 1.5em)[$a_(t-1) in A$] 
#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.5em)[$a_(t+1) in A$] 

At each timestep, we take an action 

But decision processes require a state for every action

$ a_t tilde pi (dot | s_t; theta_pi) $

==
$ A = {"A", "Aardvark", dots, "Zebra"} $ 

#poem_state

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] 

*Question:* What is the state at time $t$?

*Answer:* Everything we have #text(fill: orange)[seen], and everything we have #text(fill: purple)[done]

*Question:* Is this a POMDP or MDP? *Answer:* POMDP!

==

#poem_state

*Question:* What is our observation space $frak(O)$?

#side-by-side[
    All possible words
][
$ frak(O) = {"A", "Aardvark", dots, "Zebra", "<EOS>"} $ 
]

#side-by-side[
    Same as the action space!
][
$ A = {"A", "Aardvark", dots, "Zebra", "<EOS>"} $ 
]
This simplifies our POMDP state

==
#poem_state

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] 

#side-by-side(align: horizon)[
    $ s_t = #state_vec_partial $
][
    *Question:* Can we make the state more compact/efficient?
]

==
#poem_state

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] 

#side-by-side(align: horizon)[
    $ s_t = #state_vec_partial $
][
    $ s_t = f(#state_vec_partial, theta_f) = f(bold(tau)_t, theta_f) $
]

==


#side-by-side(align: horizon)[
    $ s_t = #state_vec_partial $
][
    $ s_t = f(#state_vec_partial, theta_f) = f(bold(tau)_t, theta_f) $
]

*Question:* What models can we use for $f$?

Transformer (GPT-4, Qwen, DeepSeek R1, LLaMA)

Recurrent neural network (Mamba)

Transformer + RNN (Griffin, Google Gemma)
==
#side-by-side(align: horizon)[
    $ s_t = f(#state_vec_partial, theta_f) = f(bold(tau)_t, theta_f) $
][
    $ pi (a_t | s_t; theta_pi) $
]

Usually, $f$ is a transformer or transformer + RNN

The policy is often a simple linear classifier

#side-by-side[
    $ pi (a_t | s_t; bold(theta)_pi) = "Softmax"(bold(theta)_pi^top s_t) $
][
    $ bold(theta)_pi in bb(R)^(|A| times |S|) $
]

==
#text(fill: red)[$f$ input]
#text(fill: blue)[Model output]

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: #text(fill: red)[Hello, please write me a poem.]

        Agent:   #text(fill: blue)[Sure] #text(fill: luma(80%))[thing! Here is a poem:

            Roses are red,
            violets are blue,
            you are beautiful,
            and I love you]
    ]
]

==

#text(fill: red)[$f$ input]
#text(fill: blue)[Model output]

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: #text(fill: red)[Hello, please write me a poem.]

        Agent: #text(fill: red)[Sure] #text(fill: blue)[thing] #text(fill: luma(80%))[! Here is a poem:

            Roses are red,
            violets are blue,
            you are beautiful,
            and I love you]
    ]
]

==

#text(fill: red)[$f$ input]
#text(fill: blue)[Model output]

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: #text(fill: red)[Hello, please write me a poem.]

        Agent: #text(fill: red)[Sure thing] #text(fill: blue)[!] #text(fill: luma(80%))[Here is a poem:

            Roses are red,
            violets are blue,
            you are beautiful,
            and I love you]
    ]
]

==
#text(fill: red)[$f$ input]
#text(fill: blue)[Model output]

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: #text(fill: red)[#highlight(fill: red.transparentize(70%))[Hello, please write me a poem.]]

        Agent: #text(fill: red)[#highlight(fill: red.transparentize(70%))[Sure thing! Here is a poem:

            #pin(3)Roses are red,
            violets are blue,
            you are#pin(4)]]#pin(6) #text(fill: luma(80%))[
            #pin(1)#text(fill: blue)[beautiful]#pin(2),
            and I love you]
    ]
]
#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.5em)[$a_(t) tilde pi (dot | s_t; theta_pi)$] 
#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: bottom, height: 1.5em)[$s_t = f(bold(tau)_t, theta_f)$] 





= Pretraining
==
Now, we understand the decision making process
- Observation space $frak(O)$
- Action space $A$
- Policy model $pi (a | s; theta_pi)$
- Memory model $f(bold(tau)_t, theta_f)$

*Question:* Do we know $Tr$? 

*Answer:* No, but model-free algorithms do not assume we know $Tr$

*Question:* Do we know $S$?

*Answer:* No, but using POMDP formulation this is ok. $S$ is the latent space, we cannot understand it

==
We have
- Observation space $frak(O)$
- Action space $A$
- Policy model $pi (a | s; theta_pi)$
- Memory model $f(bold(tau)_t, theta_f)$
Do not need
- State space $S$
- Transition function $Tr$

*Question:* What are we missing?

*Answer:* Reward function $cal(R)$

==

#poem_action

*Question:* What should our reward function $cal(R)$ be?

*Answer:* RLHF?

RLHF will not work yet, GPT-3 requires 45TB of data

Average English word is 40 bytes 

RLHF requires humans to annotate 40,000,000,000,000 pages of text

==

#poem_action

What can we do for reward function?

RLHF will not scale

Hard to write reward function for text

*Question:* What do we do when we reward function is too hard?

*Answer:* Imitation learning!

==
Using behavior cloning, policy can learn to speak like humans

$ underbrace(pi (a | s; theta_pi), "Learned policy") = underbrace(pi (a | s; theta_beta), "Human speech") $

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - underbrace(pi (a | s; theta_beta), "Human speech") log underbrace(pi (a | s; theta_pi), "Learned policy") $ 

In my deep learning course, I call this *Generative PreTraining* (GPT)

In this course, I prefer to call it imitation learning!

Policy learns to imitate (speak like) humans

==
$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - underbrace(pi (a | s; theta_beta), "Human speech") log underbrace(pi (a | s; theta_pi), "Learned policy") $ 

In BC, we learn from an offline dataset $bold(X)$ collected following $theta_beta$

How do we choose $bold(X)$ for our LLM?

I don't know, this is a tech company secret!
- Crawl websites
- Instagram/Little Red Book comments
- Download books

I know the datasets today are very huge (petabytes!)

==
$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - underbrace(pi (a | s; theta_beta), "Human speech") log underbrace(pi (a | s; theta_pi), "Learned policy") $ 

+ Convince investors to give you 100B MOP
+ Buy 10,000 GPUs
+ Collect 1 PB dataset
+ Implement deep transformer $f$ and linear $pi$
+ Optimize BC objective for 3 months

Now you have a very human model

After training on so much data, the policy learns to think like a human

You trained an LLM!

==
Time to show your powerful LLM to your investors

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: Hello, please write me a poem.

        Agent: No, poems are stupid.             
    ]
]

Now your investors are screaming, saying you wasted their money

*Question:* What happened?

*Answer:* Our human expert $theta_beta$ is actually many "experts"

Many of these "experts" are idiots or lazy
- Video comments, internet forums, etc
    
==
#side-by-side[
    $ pi (a_+ | s_0; theta_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; theta_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] 

We responded like a Instagram/LittleRedBook comment instead of poet

Both poems and comments in our dataset, our model will imitate both
==
#side-by-side[
    $ pi (a_+ | s_0; theta_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; theta_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] 

*Question:* We saw this before, what was the solution?

*Answer:* Offline RL/weighted behavior cloning

==
TODO Supervised finetuning is "dataset cleaning" + BC


==
Generative pretraining/imitation learning is 99% of training
- $pi$ learns smart responses, but mixed with many idiot responses
- Focus is general knowledge and language understanding
- Learns *optimal policy*

Offline RL is 1% of training
- Small but very very important!
- "Unlocks" intelligence by focusing on smart responses

Remember, offline RL can learn a *better* policy than the expert!
- Trajectory stitching
- LLM can become *smarter* than any expert in the dataset

==
*Question:* What are the offline RL methods?
+ Weighted behavioral cloning with rewards/returns
    - RWR, MARWIL, etc
+ Q learning with constraints
    - BCQ, CQL, etc
    - Constraints prevent overextrapolation
+ Inverse RL
    - Learn reward function from dataset, then use online RL

In practice, we use approaches 1. and 3. most often

*Question:* Why not approach 2? *Answer:* I don't know, try it out!

==
Terminology is confusing, always creating new words

Deep learning and decision making use different names

#side-by-side[
    Weighted behavioral cloning 

    DL: Preference optimization
    - Direct Preference Optimization (DPO)
    - Kahneman Tversky Optimization (KTO)

][
    Inverse RL

    DL: Reinforcement Learning from Human Feedback (RLHF)
    - REINFORCE/Policy Gradient
    - Proximal Policy Optimization (PPO)
    - Group Relative Policy Optimization (GRPO)
]

= Preference Optimization
// Similar to weighted behavior cloning
// Hard to learn reward function so use humans
    // How would you score these completions?
        // Ask students, large variance
        // Humans are stupid, easier to express preference than give a scalar reward
        // Prefs allow us to reduce the problem further
// DPO

= Reinforcement Learning from Human Feedback
// RLHF is a really bad name
    // For example, GRPO in R1 paper did not use human feedback
        // Or did they? Double check
// Policy gradient
// PPO
// GRPO

= Alignment
==
You may hear about *alignment* when reading about LLMs

Alignment is a very simple concept:

Does our reward function/language model align with human values?
- Polite or rude?
- Biased or racist?
- Good or evil?

Human values differ between people and cultures

This means alignment is an ill-posed problem

Introducing biased datasets or RLHF can introduce alignment issues

= Final Remarks
==
Throughout the course, I focused on teaching the basics and theory
- I know this is not a popular decision, but understand my reasoning
- Today, we defined LLMs entirely with known concepts  
    - MDP and POMDP
    - Behavioral cloning
    - Offline RL
        - Weighted BC
        - Inverse RL
    - Actor critic
        - Policy gradient
        - V/Q functions

Every complex algorithm is just a combination of basic concepts

==
// Focused on teaching you the basics
// As we saw today, once we know the basics, everything becomes more clear!
    // We already covered everything you needed for LLMs, just with different names
        // BC, offline RL, POMDPs, etc
    // You will find that any other decision making application is similar! Just need to read between the lines and connect it back to the basics
    // If you understand the basics, then you can truly understand new algorithms by just reading a paper and drawing connections to what you know
// DPO is very hard to understand if you do not understand BC/offline RL theory
// I know everyone wants to learn the coolest methods

==
// I am very proud of everyone
// I think many of you that I've spoken with can do great things
    // Academic research (theory-heavy)
    // Industrial research (theory-adjacent/empirical, GRPO)
    // Industrial application (apply RL library but with known hyperparameters)

I am very proud of you all for making it so far!

From your participation, many of you are already RL/IL experts!

I know many of you live in Zhuhai, and crossing the border takes time

I hope these lectures have been worth your time

And I hope you enjoyed the course!


==
// The world is a very fragile place
// The news over the past few months has reminded us of this fragility
// All evil requires to triumph is for good men to do nothing
// Creating evil is as simple as negating the reward function

The world is a very fragile place
- Recent news reminds us how fragile the world is
- Do not take stable work/study, food, healthcare, housing for granted!

All of us are born with shortcomings in our reward function
- Greed, bias, fear, indifference, 

Being evil is very easy
$ cal(R)(s) = "Prevent Suffering" \ 
- cal(R)(s)
$

==
#quote(block: true)[Frodo: I wish the ring had never come to me. I wish none of this had happened.]
#quote(block: true)[Gandalf: So do all who live to see such times, but that is not for them to decide. All we have to decide is what to do with the time that is given us.]

We are constantly subjected to circumstances beyond our control

The one thing we can control is our actions

Make sure you choose good actions!

= Course Feedback
==
Please fill out the course feedback!
https://isw.um.edu.mo/siatsl/