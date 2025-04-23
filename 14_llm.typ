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
#let bimodal_pi = { 
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
            y-max: 1,
            x-label: $ a $,
            y-label: [$ $],
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s_0; theta_(pi)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ a_+ $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ a_- $])
    }
)}

#let bimodal_reweight = { 
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
            y-max: 1,
            x-label: $ a $,
            y-label: [],
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; theta_(pi)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s_0; theta_(pi)) $,
                x => 0.75 * normal_fn(-1, 0.3, x) + 0.25 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ a_+ $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ a_- $])
    }
)}


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
Last lecture! #pause

Who started final project coding? #pause 
- Who is already training? #pause
- Who learned a good policy? #pause

If you did not make progress, maybe switch to easy backup project #pause

Remember to read the final project requirements carefully! #pause
- Code #pause
- Final report #pause
- Video demonstration #pause

Deadline 3 May (10 days)

==
All grades entered except for final project #pause
- Mean grade is 85/100 #pause
- Final project worth 30%, still possible to increase grade #pause

Participation scores entered #pause
- Group is 100/100 #pause
- Individual #pause

If you reguarly speak and have 0/100 individual, come see me after class #pause
- If you lie, I give you 0/100 group participation #pause
    - "I answered many questions" but I never saw you before

==
Quiz 3 graded #pause
- Grades uploaded on moodle #pause
- Mean score 70/100, ignoring missing exams #pause

Mean over all quiz (quiz 1, quiz 2, quiz 3, drop lowest) = 77/100 #pause

Some students have 0/100 for quiz 3 #pause
- Some students did not turn in exam #pause
    - Some already had 100/100 on quiz 1 and 2 #pause
    - If you have 0/100 but turned in assignment, come see me #pause
- 7 students *must see me in office hours* #pause
    - Read quiz 3 feedback


==
Quiz 3 lowest scoring question: *Q1* #pause
- Makes me sad, I thought this was easy question #pause
- Many students do not know what actor-critic is #pause
    - Q learning/TD learning is *not* actor critic! #pause
    - Actor critic combines Q/V learning with policy gradient #pause
    - *Question:* Can someone explain why Q1 was difficult?
==
Different opinions from *Q1* part 2: #pause
- Weak math background, math too hard, like coding better
- I like math explanations, but coding is very hard #pause
- I do not like coding or math (ML is coding + math!) #pause
- Never heard of JAX, it is very fast, I like learning it
- Do not know JAX, do not like using it #pause
- Don't like quizzes #pause
- You give too much time for quizzes, should only give 60 mins

==
Shared opinions #pause
- Do not like quizzes #pause
    - One student: Give less time for quizzes #pause
- Class makes me study a lot #pause
    - Great! This is how you learn material #pause
- Like Q learning more than actor critic #pause
    - Can understand Q learning #pause
    - Cannot understand actor critic #pause
- Assignment 2 stressful #pause
    - After success, feels magical!
==
Opinion: Do not like participation, some students are shy #pause
    - You must be brave #pause
    - I also do not like talking, I worry about making mistakes #pause
    - Researcher/engineer/professor *must* be good at participation #pause
    - Good at programming/research *is not enough*
    - Many smarter scientists than Yann LeCun or Geoffrey Hinton #pause
        - LeCun/Hinton famous due to presentation skills #pause
    - It is not fair, but a reality of the world #pause
        - If you want to succeed, you must overcome shyness
/*
==
Opinion: More practice coding, more colab homeworks
    - I assigned DQN/PG assignment after DQN lecture (lecture 7)
    - Some students already struggled to finish this
    - Adding A2C/DDPG would not give enough time for final project
    - Important to spend time understanding Bandit/TO/MDP/Q (lecture 1-6)
    - Next year I will give the final project earlier
        - Focus/practice your favorite algorithm
    - Comments? Suggestions?
*/
==
*Question for next year:* Quiz format? #pause
+ 3 quizzes total, 1 quizzes dropped
+ 2 quizzes total, 0 quizzes dropped 
+ 1 final exam instead of quizzes #pause

*Question for next year:* Homework 2 choice #pause
+ Choose either DQN or PG
+ Complete both DQN and PG #pause

*Question for next year:* Final project #pause
+ Choose your own problem
+ I give you either Atari or MuJoCo game to solve 



= Language Decision Process
==
In my deep learning course, we viewed LLMs as deep learning #pause
- Today, we will view LLMs as decision making machines #pause

We will combine everything we learned to create LLMs: #pause
- Actor critic #pause
    - Policy gradient 
    - V/Q functions 
    - Advantage #pause
- Imitation learning #pause
- Offline RL #pause
- POMDPs #pause

You are smarter than you think, we have everything to build LLMs! 


==
Let us consider the problem of language modeling #pause

User gives us variable-length text #pause

We want to reply with different text #pause

#base_poem
==
#base_poem #pause

*Question:* What is the action space $A$ for this task? #pause

*Answer 1:* All possible text $A = {"A", "Aardvark", dots, "Zebra"}^n $ #pause

*Answer 2:* All possible words $A = {"A", "Aardvark", dots, "Zebra", #text[`<EOS>`]} $ 

==
$ A = {"A", "Aardvark", dots, "Zebra"}^n $ 

$ A = {"A", "Aardvark", dots, "Zebra", #text[`<EOS>`]} $ #pause

First approach, produce the entire response at once #pause

Second approach, produce response one word at a time #pause

*Question:* Which follows MDP definition?

*Answer:* First method, one input produces one output $#pin(1)a#pin(2) tilde pi (dot | #pin(3)s#pin(4) ; theta_pi)$ #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: bottom, height: 1.5em)[User input] 
#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: top, height: 1.5em)[Policy output] #pause

$ A = {"A", "Aardvark", dots, "Zebra"}^n $ #pause

*Question:* Any issues with this action space?

==
$ A = {"A", "Aardvark", dots, "Zebra"}^n $ 

*Answer:* $n in [0, oo]$ so action space is infinite #pause

But policy gradient can represent continuous/infinite action space #pause

*Question:* Why does policy gradient not work here? #pause

BenBen joint angles are continuous and ordered #pause

Action $a=1.8 pi "rad"$ similar to $a=1.9 pi "rad"$, policy can generalize #pause

For LLM action space, meaning of A $!=$ meaning of Aardvark #pause

Policy cannot generalize over unordered discrete actions!


// Stopped here
==
#side-by-side[$ A = {"A", "Aardvark", dots, "Zebra"}^n $ ][Very difficult to model] #pause

Instead, factorize action space into single word or *token* #pause 

$ A = {"A", "Aardvark", dots, "Zebra", #text[`<EOS>`]} $ #pause

We implement the action space as a dictionary or integer$->$token map #pause

$ {0: "A", space 1:"Aardvark", space dots, space 250,000: "Zebra"} $

Action 1 corresponds to the word "Aardvark"

This is still a very large action space!

==
$ A = {"A", "Aardvark", dots, "Zebra", #text[`<EOS>`]} $ 

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

Now your investors are punching you, saying you wasted their money

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
    #cimage("fig/12/good-driver.png", height: 60%)
][
    #cimage("fig/11/texting.jpg", height: 60%)
] 

*Question:* What can we do?

*Answer 1:* Remove idiots from dataset 

*Answer 2:* Offline RL/weighted behavior cloning 

= Supervised Fine Tuning
==
Removing idiots from the dataset is *Supervised Fine Tuning* (SFT)

First, train on the large dataset to learn as much as possible

Then, continue training with a *small* and *specific* dataset

$ argmin_(theta_pi) sum_(s in bold(X)_"SFT") sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

This is a "lazy" form of weighted behavioral cloning

==
#side-by-side[
    Initially, we model all "experts" from a large dataset. Some experts are bad.
    #bimodal_pi
][
    SFT on smaller dataset, we "forget" other experts and focus on "better" experts in small dataset
    #bimodal_reweight
]


==

SFT works best for *small* and *specific* datasets
- Impersonating anime characters
- Expertise on 18th century painters
- Improve LLM arithmetic

Humans can manually verify the correctness of small datasets

Useful for specific tasks, but does not scale to general intelligence!

We must do better for general LLM training

For this, we must use RL

= Preferences 
// Need rewards for RL
// Rewards are hard to create
==
To use RL, we must have rewards 

*Example:* I want you to tell me the reward for two responses:

#text(font: "Chalkduster", size: 22pt)[
    User: What is Macau?

    #side-by-side[
        Agent: Macau is a Special Administrative Region (SAR) in the south of China
    ][
        Agent: Macau is a city in Asia near the equator 
    ]
]

*Question:* What should the reward be for each response?

Humans are not good at choosing rewards

It is much easier for humans to determine *preferences* 
- Left response is better than right response

==
*Problem:* Humans provide preferences, but we need a reward

Can we convert preferences into a reward?

Consider two trajectories : $bold(tau)_+, bold(tau)_-$

#text(font: "Chalkduster", size: 22pt)[

    #side-by-side[
        $ bold(tau)_+ = o_0, a_0, o_1, a_1, dots $
        User: What is Macau?
        Agent: Macau is a Special Administrative Region (SAR) in the south of China
    ][
        $ bold(tau)_- = o_0, a_0, o_1, a_1, dots $
        User: What is Macau?
        Agent: Macau is a city in Asia near the equator 
    ]
]

To represent preference as return, ensure that $cal(G)(bold(tau)_+) > cal(G)(bold(tau)_-)$
==

Measure preference in terms of an unknown reward function

$ rho(bold(tau)_-, bold(tau_+)) = underbrace(cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-), "Human preference") $

Humans bad at choosing scale, rescale to $[0, 1]$ using sigmoid 

$ rho(bold(tau)_-, bold(tau_+)) = sigma (cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-)) $

Do not know $cal(G)$, but can think of $rho$ as a normalized advantage

$ A(s_0, theta_pi_-, theta_pi_+) = sigma( bb(E)[cal(G)(bold(tau)) | s_0, theta_pi_+] - bb(E)[cal(G)(bold(tau)) | s_0 ; theta_pi_-] ) $ 

//$ rho(bold(tau)_-, bold(tau_+)) = underbrace(sigma (cal(R)(s_+) - cal(R)(s_-)), "Probability human prefers" s_+) $

==
*Definition:* The Bradley-Terry advantage relates human preferences of a given pair to the return, without explicitly computing the return

$ rho(bold(tau)_-, bold(tau_+)) = sigma (cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-)) $

We treat this as the probability of a human preferring $bold(tau)_+$ over $bold(tau)_-$

$ rho(bold(tau)_-, bold(tau_+)) = Pr("Human prefers" bold(tau)_+) / ( Pr("Human prefers" bold(tau)_+) + Pr("Human prefers" bold(tau)_-)) $


$ rho(bold(tau)_-, bold(tau_+)) approx 1: "Human prefers" bold(tau_+) \

rho(bold(tau)_-, bold(tau_+)) approx 0: "Human prefers" bold(tau_-) $

==

$ rho(bold(tau)_-, bold(tau_+)) &= sigma (cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-)) \

rho(bold(tau)_-, bold(tau_+)) &approx 1: "Human prefers" bold(tau)_+ \

rho(bold(tau)_-, bold(tau_+)) &approx 0: "Human prefers" bold(tau)_- $

Can maximize Bradley-Terry advantage to maximize return

$ argmax_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = underbrace(argmax_(theta_pi) sum_(bold(tau)_-, bold(tau)_+) rho(bold(tau)_-, bold(tau)_+), "Choose" a in bold(tau)_+ "not" a in bold(tau)_-) $

Now, we can use RL!

= RLHF

==
With the Bradley-Terry advantage, collect human preference dataset 

#side-by-side[
    $ 
    bold(x) = vec(bold(tau)_-, bold(tau)_+, rho(bold(tau)_-, bold(tau)_+))
    $
][
    $ bold(X) = mat(
        bold(x)_1,
        bold(x)_2,
        dots
    ) $
]

*Question:* How do we use RL on a fixed dataset?

*Answer:* Offline RL!

RLHF $=$ Offline RL with preferences (human-selected returns)

==
Generative pretraining/imitation learning is 99% of training
- $pi$ learns smart responses, but mixed with many idiot responses
- Focus is general knowledge and language understanding

Offline RL/RLHF is 1% of training
- Small but very very important!
- "Unlocks" intelligence by focusing on good responses

Remember, offline RL can learn a *better* policy $theta_pi$ than the expert $theta_beta$!
- Trajectory stitching
- LLM can become *smarter* than any expert in the dataset
    - Very important! Not possible with imitation learning/pretraining

==
*Question:* What offline RL algorithms do we know?
+ Weighted behavioral cloning with rewards/returns
    - RWR, MARWIL, etc
+ Q learning with constraints
    - BCQ, CQL, etc
    - Constraints prevent overextrapolation
+ Inverse RL
    - Learn reward function from dataset, then use online RL

Most people use approaches 1 and 3

*Question:* Why not approach 2? *Answer:* I don't know, try it out!


==

Weighted behavioral cloning 
- Direct Preference Optimization (DPO)
- Kahneman Tversky Optimization (KTO)

Inverse RL 
- REINFORCE/Policy Gradient
- Proximal Policy Optimization (PPO)
- Group Relative Policy Optimization (GRPO)

= Inverse RL
==
In inverse RL, we learn the parameters for the reward function $theta_cal(R)$

$ cal(R)(s, theta_cal(R)) $

For a POMDP, it is simpler to learn the return instead (do not know $s$)

$ cal(G)(bold(tau), theta_cal(G)) $

Recall our dataset

#side-by-side[
    $ 
    bold(x) = vec(bold(tau)_-, bold(tau)_+, rho(bold(tau)_-, bold(tau)_+))
    $
][
    $ bold(X) = mat(
        bold(x)_1,
        bold(x)_2,
        dots
    ) $
]

==
#side-by-side[
    $ 
    bold(x) = vec(bold(tau)_-, bold(tau)_+, rho(bold(tau)_-, bold(tau)_+))
    $
][
    $ bold(X) = mat(
        bold(x)_1,
        bold(x)_2,
        dots
    ) $
]

$ rho(bold(tau)_-, bold(tau_+), theta_cal(G)) = sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))) = Pr("Human prefers" bold(tau)_+ ) $


We want to find $theta_cal(G)$ that predicts the human preferences in our dataset

Since $rho$ is a probability, we maximize the log likelihood 


$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), Pr("Human prefers" bold(tau)_+ )) 
$

==

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), Pr("Human prefers" bold(tau)_+ )) 
$

We often model $cal(G)(bold(tau), theta_cal(G))$ using another LLM

$ cal(G)(bold(tau), bold(theta)_cal(G)) = bold(theta)_cal(G)^top underbrace(f(bold(tau), theta_f), s) $

We only learn a linear layer $bold(theta)_cal(G)$, not the LLM parameters $theta_f$!

Now, we can compute the return for any trajectory

We use any online RL algorithm!

==

Let us start with REINFORCE (Monte Carlo policy gradient)

$
theta_(pi, i+1) &= theta_(pi, i) + alpha dot nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] \ 

nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] &= bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] dot nabla_theta_(pi, i) log pi (a_0 | s_0; theta_(pi, i))
$

Plug in our learned return function $cal(G)(bold(tau), theta_cal(G))$

$
theta_(pi, i+1) &= theta_(pi, i) + alpha dot nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau), theta_cal(G)) | s_0; theta_(pi, i)] \

nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] &= bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] dot nabla_theta_(pi, i) log pi (a_0 | s_0; theta_(pi, i))
$

That is it, easy!

==

Standard training process:
1. Give the LLM a user query
2. LLM generates a response
3. Update LLM parameters $theta_pi, theta_f$ using return
    - $theta_f$ not shown, but used to compute $s$


==
*Definition:* Inverse REINFORCE learns a return function using the Bradley-Terry advantage, then learns a policy (LLM) using REINFORCE

*Step 1:* Learn the return

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), Pr("Human prefers" bold(tau)_+ )) 
$

*Step 2:* Learn the policy using Monte Carlo policy gradient 

$
theta_(pi, i+1) = theta_(pi, i) + alpha dot nabla_(theta_pi) bb(E)[cal(G)(bold(tau), theta_cal(G)) | s_0; theta_pi]
$

==
*Definition:* Constrained inverse REINFORCE adds a constraint to ensure the policy does not change too much

*Step 1:* Learn the return

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), Pr("Human prefers" bold(tau)_+ )) 
$

*Step 2:* Learn the policy *with a KL constraint*

$
theta_(pi, i+1) = theta_(pi, i) + alpha dot nabla_(theta_pi)  
    bb(E)[cal(G)(bold(tau), theta_cal(G)) | s_0; theta_(pi, i)] \ - 
    underbrace(nabla_(theta_(pi, i + 1)) KL[pi (a | s; theta_(beta)), pi (a | s; theta_(pi, i + 1))], "Stay close to" theta_beta)
$

==
Finally, I want to discuss GRPO

However, GRPO is based on PPO
- PPO is complicated and has too many terms
- I think this will confuse everyone
- The important part of GRPO is group normalization, not PPO

I will present Steven's GRPO: REINFORCE with group normalization 
- Much simpler version
- Help you understand the key idea behind GRPO

==
*Definition:* Steven's Group Relative Policy Optimization (S-GRPO) normalizes the return using completions of the same user query $s_q$

$ bold(tau)_i tilde Pr (bold(tau) | s_q; theta_pi) $

$ theta_(pi, i+1) &= theta_(pi, i) + alpha dot nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau), theta_cal(G)) | s_q; theta_(pi, i)] $

$
nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_q; theta_(pi, i)] &= underbrace( (1 / n sum_(i=1)^n cal(G)(bold(tau)_i, theta_cal(G))), "Empirical return" ) dot nabla_theta_(pi, i) log pi (a | s; theta_(pi, i))
$


==
Updates compare answers to the same question, reducing variance

$ s_q = f("Where is Macau?", theta_f) $

$ bold(tau)_1 &= "Macau is a Special Administrative Region (SAR) in " dots \
bold(tau)_2 &= "Macau is a city in Asia near the equator" dots \
dots.v & 
$

//$ hat(G) = 1 / n sum_(i=1)^n cal(G)(bold(tau)_i, theta_cal(G)) $
$
nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_q; theta_(pi, i)] &= underbrace( (1 / n sum_(i=1)^n cal(G)(bold(tau)_i, theta_cal(G))), "Empirical return" ) dot nabla_theta_(pi, i) log pi (a | s; theta_(pi, i))
$

Very similar to the Bradley-Terry model: learns $theta_cal(G)$ using $bold(tau)_-, bold(tau)_+$

==
Real GRPO combines group normalization with the PPO objective
- Use the MC return like S-GRPO, deleting $V$ from PPO 
    - However, they still use the advantage
- PPO-clip to prevent large policy changes
- KL constraint to keep the learned policy near the pretrained policy 


/*
= Preference Optimization
==
// Replace advantage with preference
One offline RL method reweights the BC objective based on return

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta]) $ #pause

Recall that MARWIL uses the advantage instead of return

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot underbrace(exp(A(s, a, theta_beta) ), "Advantage weight") $ #pause

$ A(s, a, theta_beta) = Q(s, a, theta_beta) - V(s, theta_beta) $ #pause

==
We can think of preferences as a type of advantage

$ A(s, a, theta_beta) = underbrace(Q(s, a, theta_beta), "Specific action") - underbrace(V(s, theta_beta), "Policy action") $ #pause

$ Pr(s_0, a_+, a_-, theta_pi) &= softmax( 
    vec(
        bb(E)[cal(G)(bold(tau)) | s_0, a_-; theta_pi],
        bb(E)[cal(G)(bold(tau)) | s_0, a_+; theta_pi],
    )) \ &= 
    softmax(vec(
        Q(s_0, a_-, theta_pi),
        Q(s_0, a_+, theta_pi),
    )
) $

Represents the probability of the user preferring $a_+$ over $a_-$
*/


= Alignment
==
You may hear about LLM *alignment* 

*Alignment:* Does the language model respect human values?
- Polite or rude?
- Biased or racist?
- Good or evil?

With RLHF, learn return function from human preferences
- Humans can prefer biased/racist/evil answers
- No ground truth, biased/racist/evil depends on culture
- LLM optimizes return function
    - LLM can learn to be biased/racist/evil


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