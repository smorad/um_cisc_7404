#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

// TODO: Learn theta_f (memory) through IL
// Assume frozen and RL only learns theta_pi (linear)

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

Some students have 0/100 for quiz 3 #pause
- Some already had 100/100 on quiz 1 and 2 #pause
- Some students had 0/100 until 14:30 today, issue fixed #pause
    - Double check your score now #pause

Mean over all quiz (quiz 1, quiz 2, quiz 3, drop lowest) = 77/100 

==
Quiz 3 lowest scoring question: #pause *Q1* #pause
- Makes me sad, I thought this was easy question #pause
- Many students do not know what actor-critic is #pause
    - Q learning/TD learning is *not* actor-critic! #pause
    - Actor critic combines Q/V learning with policy gradient #pause
    - *Question:* Can someone explain why Q1 was difficult?
==
Different opinions from *Q1* part 2: #pause
- Math too hard, like coding better (60% respondents)
- Like math, coding too hard (30% respondents) #pause
- Do not like coding or math (change your degree!) (10% respondents) #pause
- Never knew JAX, it is very fast, like learning it (80% respondents)
- Never knew JAX, do not like it (20% respondents)

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
    - Researcher/engineer/professor *must* be good at presentations #pause
    - Good at programming/math *is not enough* #pause
    - Many smarter scientists than Yann LeCun or Geoffrey Hinton #pause
        - Backpropagation published twice before Hinton #pause
            - Other 2 researchers have worse social/presentation skills #pause
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

*Answer 1:* All possible text $A = {"Aardvark", "Apple",dots, "Zebra"}^n $ #pause

*Answer 2:* All possible words $A = {"Aardvark", "Apple",dots, "Zebra", #text[`<EOS>`]} $ 

==
$ A = {"Aardvark", "Apple",dots, "Zebra"}^n $ 

$ A = {"Aardvark", "Apple",dots, "Zebra", #text[`<EOS>`]} $ #pause

First approach, produce the entire response at once #pause

Second approach, produce response one word at a time #pause

*Question:* Which follows MDP definition?

*Answer:* First method, one input produces one output $#pin(1)a#pin(2) tilde pi (dot | #pin(3)s#pin(4) ; theta_pi)$ #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: bottom, height: 1.5em)[User input] 
#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: top, height: 1.5em)[Policy output] #pause

$ A = {"Aardvark", "Apple",dots, "Zebra"}^n $ #pause

*Question:* Any issues with this action space?

==
$ A = {"Aardvark", "Apple",dots, "Zebra"}^n $ 

*Answer:* $n in [0, oo]$ so action space is infinite #pause

But policy gradient can represent continuous/infinite action space #pause

*Question:* Why does policy gradient not work here? #pause

BenBen joint angles are continuous and ordered #pause

Action $a=1.8 pi "rad"$ similar to $a=1.9 pi "rad"$, policy can generalize #pause

For LLM action space, meaning of Apple $!=$ meaning of Aardvark #pause

Policy cannot generalize over infinite discrete actions!


// Stopped here
==
#side-by-side[$ A = {"Aardvark", "Apple",dots, "Zebra"}^n $ ][Very difficult to model] #pause

Instead, factorize action space into single word or *token* #pause 

$ A = {"Aardvark", "Apple",dots, "Zebra", #text[`<EOS>`]} $ #pause

We implement the action space as a dictionary or integer$->$token map #pause

$ {0: "Aardvark", space 1:"Apple", space dots, space 128,000: "Zebra"} $ #pause

Action 1 corresponds to the word "Apple" #pause

This is still a very large action space! #pause
- DeepSeek R1 $|A| = 128,000$

==
$ A = {"Aardvark", "Apple",dots, "Zebra", #text[`<EOS>`]} $ #pause

#poem_action #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] #pause
#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 1.5em)[$a_(t-1) in A$] #pause
#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.5em)[$a_(t+1) in A$] #pause

Each token/word in the response is an action #pause

But decision processes require a state for every action

$ a_t tilde pi (dot | s_t; theta_pi) $

==
$ A = {"Aardvark", "Apple",dots, "Zebra"} $ #pause

#poem_state #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] #pause

*Question:* What is $s_t$? ($a_t tilde pi (dot | s_t; theta_pi)$) #pause

*Answer:* Everything we have #text(fill: orange)[seen], and everything we have #text(fill: purple)[done] #pause

*Question:* Is this a POMDP or MDP? #pause *Answer:* POMDP!

==

#poem_state #pause

*Question:* What is our observation space $frak(O)$? #pause

#side-by-side[
    All possible words
][
$ frak(O) = {"Aardvark", "Apple", dots, "Zebra", "<EOS>"} $ 
] #pause

#side-by-side[
    Same as the action space!
][
$ A = {"Aardvark", "Apple",dots, "Zebra", "<EOS>"} $ 
] #pause
This simplifies our POMDP state

==
#poem_state #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[$a_t in A$] #pause

#side-by-side(align: horizon)[
    $ s_t = #state_vec_partial $ #pause
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
] #pause

*Question:* What models can we use for $f$? #pause
- Transformer (GPT-4, Qwen, DeepSeek R1, LLaMA) #pause
- Recurrent neural network (Mamba) #pause
- Transformer + RNN (Griffin, Google Gemma, Tencent Hunyuan)
==
#side-by-side(align: horizon)[
    $ s_t = f(#state_vec_partial, theta_f) = f(bold(tau)_t, theta_f) $ #pause
][
    $ pi (a | s_t; theta_pi) $ #pause
]

$f$ is a very large memory model (99% of parameters) #pause

The policy is the final layer of the LLM (simple linear classifier) #pause

#side-by-side[
    $ pi (a | bold(s)_t; bold(theta)_pi) = softmax(bold(theta)_pi^top bold(s)_t) $
][
    $ bold(theta)_pi in bb(R)^(|A| times |S|) $
]

==
One more example to make the decision process clear #pause

$s_t = f(#redm[$bold(tau)_t$], theta_f)$ #pause

$#bluem[$a_t$] tilde pi (a | s_t; theta_pi)$ #pause

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: #text(fill: red)[Hello, please write me a poem.] #pause

        Agent:  #text(fill: blue)[Sure] #text(fill: luma(80%))[thing! Here is a poem:

            Roses are red,
            violets are blue,
            you are beautiful,
            and I love you]
    ]
]

==

$s_t = f(#redm[$bold(tau)_t$], theta_f)$ 

$#bluem[$a_t$] tilde pi (a | s_t; theta_pi)$ 

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

$s_t = f(#redm[$bold(tau)_t$], theta_f)$ 

$#bluem[$a_t$] tilde pi (a | s_t; theta_pi)$ 

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: #text(fill: red)[Hello, please write me a poem.]

        Agent: #text(fill: red)[Sure thing]#text(fill: blue)[!] #text(fill: luma(80%))[Here is a poem:

            Roses are red,
            violets are blue,
            you are beautiful,
            and I love you]
    ]
] #pause

We understand the policy $theta_pi$ and memory $theta_f$ #pause

Now how do we learn $theta_pi$ and $theta_f$?

= Pretraining
==
Now, we understand the decision making process #pause
- Observation space $frak(O)$ #pause
- Action space $A$ #pause
- Policy $pi (a | s; theta_pi)$ #pause
- Memory $f(bold(tau)_t, theta_f)$ #pause

*Question:* Do we understand $S$? #pause *Answer:* No, using POMDP #pause
- $S$ is the latent space learned by $theta_f$ #pause
    - It has some meaning, but humans cannot understand it! #pause

*Question:* Do we understand $Tr$? #pause *Answer:* No!
- We do not know the meaning of $S$, so we cannot know $Tr$

==
We covered:
- Observation space $frak(O)$
- Action space $A$
- Policy $pi (a | s; theta_pi)$
- Memory $f(bold(tau)_t, theta_f)$
- State space $S$
- Transition function $Tr$ #pause

*Question:* What are we missing? #pause

*Answer:* Reward function $cal(R)$

==

#poem_action #pause

*Question:* What should our reward function $cal(R)$ for this be? #pause

*Answer:* RLHF? #pause

RLHF will not work yet, GPT-3 requires 45TB of data #pause

RLHF requires humans to annotate 40,000,000,000,000 pages of text #pause

Cannot use RLHF now, maybe later

==

#poem_action

Hard to write reward function for text #pause

*Question:* What do we do when we cannot find a reward function? #pause

*Answer:* Imitation learning!

==
Using behavior cloning, policy can learn to speak like humans #pause

$ underbrace(pi (a | s; theta_pi), "Learned policy") = underbrace(pi (a | s; theta_beta), "Human speech") $ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - underbrace(pi (a | s; theta_beta), "Human speech") log underbrace(pi (a | s; theta_pi), "Learned policy") $ #pause

*Question:* Am I missing anything? #pause Hint: Where does $s$ come from? #pause

*Answer:* Must learn $theta_f$ to find $s = f(bold(tau), theta_f)$

==
$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - underbrace(pi (a | s; theta_beta), "Human speech") log underbrace(pi (a | s; theta_pi), "Learned policy") $ #pause

$ s_t = f(#pin(1)bold(tau)_t#pin(2), theta_f) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 1.5em)[$o_0, a_0, dots, o_t$] #pause

Plug in for $s$ and find both $theta_pi, theta_f$ #pause

#v(1.5em)

$ underbrace( argmin_(theta_pi, theta_f) sum_(bold(tau) in bold(X)) sum_(t=0)^n sum_(a in A) - pi (a | #pin(3)f(bold(tau)_t, theta_f )#pin(4) ; theta_beta) log #pin(5)pi (a | f(bold(tau)_t, theta_f ); theta_pi), #text(fill: orange)[Speak like human]) $ #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: top, height: 1.5em)[Human thought] #pause

Model learns to #text(fill: blue)[think like human ($theta_f$)] and #text(fill: orange)[talk like human ($theta_pi$)]

==
$ argmin_(theta_pi, theta_f) sum_(bold(tau) in bold(X)) sum_(t=0)^n sum_(a in A) - pi (a | f(bold(tau)_t, theta_f ) ; theta_beta) log pi (a | f(bold(tau)_t, theta_f ); theta_pi) $ #pause

In my deep learning course, I call this *Generative PreTraining* (GPT) #pause

In this course, I prefer to call it imitation learning! #pause

*Key idea:* GPT is imitation learning #pause

Objective is to speak like a human (imitate speech) #pause

To speak like a human, model learn to think like a human (imitate thought)


==
$ argmin_(theta_pi, theta_f) sum_(bold(tau) in bold(X)) sum_(t=0)^n sum_(a in A) - pi (a | f(bold(tau)_t, theta_f ) ; theta_beta) log pi (a | f(bold(tau)_t, theta_f ); theta_pi) $ #pause

In BC, we learn from an offline dataset $bold(X)$ collected following $theta_beta$ #pause

How do we get $bold(X)$ for our LLM? #pause

I don't know, this is a tech company secret! #pause
- Crawl websites
- Instagram/Little Red Book comments
- Download books #pause

I know the datasets today are very huge (petabytes!)

==
$ argmin_(theta_pi, theta_f) sum_(bold(tau) in bold(X)) sum_(t=0)^n sum_(a in A) - pi (a | f(bold(tau)_t, theta_f ) ; theta_beta) log pi (a | f(bold(tau)_t, theta_f ); theta_pi) $ #pause

*Example:* You want to create an LLM startup #pause
+ Convince investors to give you 100B MOP #pause
+ Buy 10,000 GPUs #pause
+ Collect 1 PB dataset #pause
+ Implement deep transformer $f$ and policy $pi$ #pause
+ Train BC objective for 3 months #pause

Now you have a very human LLM #pause
- After so much training, the policy knows to think/speak like a human 

==
Time to show your powerful LLM to your investors #pause

#quote(block: true)[
    #text(font: "Chalkduster", size: 22pt)[
        User: Hello, please write me a poem. #pause

        Agent: No, poems are stupid. #pause
    ]
]

Now your investors are screaming, saying you wasted their money #pause

*Question:* What happened? #pause

*Answer:* Our human expert $theta_beta$ is a combination many "experts" #pause
- Many of these "experts" are idiots or lazy #pause
- Video comments, internet forums, etc
    
==
#side-by-side[
    $ pi (a_+ | s_0; theta_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; theta_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] #pause

We acted like an internet comment instead of poet #pause

Both poems and comments in our dataset, our model will imitate both
==
#side-by-side[
    #cimage("fig/12/good-driver.png", height: 60%)
][
    #cimage("fig/11/texting.jpg", height: 60%)
] #pause

*Question:* Idiots in the dataset. What can we do? #pause

*Answer 1:* Delete idiots from dataset (supervised fine tuning) #pause

*Answer 2:* Offline RL

= Supervised Fine Tuning
==
Deleting idiots from the dataset is *Supervised Fine Tuning* (SFT) #pause
+ Train BC on the large dataset like before #pause
+ Continue training with a *small* and *accurate* dataset #pause

*Variant 1:* Change how the model thinks and talks #pause

$ argmin_(theta_pi, theta_f) sum_(bold(tau) in bold(X)_"SFT") sum_(t=0)^n sum_(a in A) - pi (a | f(bold(tau)_t, theta_f ) ; theta_beta) log pi (a | f(bold(tau)_t, theta_f ); theta_pi) $ #pause

*Variant 2:* Change how the model talks ($theta_f$ already known) #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

==
#side-by-side[
    Initially, we model all "experts" from a large dataset. Some experts are bad.
    #bimodal_pi
][
    Keep training on small dataset, forget old experts and focus on better experts in small dataset.
    #bimodal_reweight
]


==

SFT works best for *small* and *specific* datasets #pause
- Impersonating anime characters #pause
- Expertise on 18th century painters #pause
- Improve LLM arithmetic #pause

Humans can manually verify the correctness of small datasets #pause

Useful for specific tasks, but does not scale to general intelligence! #pause
- Imitation learning can only imitate humans #pause
- RL can learn optimal policy, better than any human #pause
    - To achieve superhuman intelligence, we must use RL!

= Preferences 
// Need rewards for RL
// Rewards are hard to create
==
To use RL, we must have rewards #pause
- Use rewards to compute the return (and we maximzie the return)

We already said it is very hard to create reward functions #pause
- With a fixed dataset humans can specify returns/rewards for each datapoint #pause

With rewards, humans must label each subsequence $bold(tau)_t$ #pause

$ cal(R)(f("I", theta_f)), cal(R)(f("I love", theta_f)), cal(R)(f("I love you", theta_f)) $ #pause

It is easier for humans to label the return of a trajectory instead #pause

$ cal(G)(bold(tau)) = cal(G)("I love you") = 12 $
==

*Example:* I want you to label returns for two trajectories #pause

#text(font: "Chalkduster", size: 22pt)[
    User: What is Macau? #pause

    #side-by-side[
        Agent: Macau is a Special Administrative Region (SAR) in the south of China #pause
    ][
        Agent: Macau is a city in Asia near the equator #pause
    ]
]

*Question:* What should the return be for each response? #pause

Humans cannot agree on returns #pause

It is easier for humans to determine *preferences* #pause

*Question:* Who prefers left response? #pause Right response? #pause
- Many humans will agree with preferences!

==
*Problem:* Humans provide preferences, but we need return #pause

Can we convert preferences into a return? #pause

Consider two trajectories : $bold(tau)_+, bold(tau)_-$ #pause

#text(font: "Chalkduster", size: 22pt)[

    #side-by-side[
        $ bold(tau)_+ = o_0, a_0, o_1, a_1, dots $ #pause
        $bold(tau)_+ = $ User: What is Macau?
        Agent: Macau is a Special Administrative Region (SAR) in the south of China #pause
    ][
        $ bold(tau)_- = o_0, a_0, o_1, a_1, dots $ #pause
        $bold(tau)_- = $ User: What is Macau?
        Agent: Macau is a city in Asia near the equator #pause
    ]
]

*Question:* How can we design $cal(G)$ that reflects our preference for $bold(tau)_+$? #pause

*Answer:* Make $cal(G)(bold(tau)_+) > cal(G)(bold(tau)_-)$ 
==

Measure preference in terms of an unknown return function #pause

$ rho(bold(tau)_-, bold(tau_+)) = underbrace(cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-), "Human preference") $ #pause

Humans bad at choosing scale, rescale to $[0, 1]$ using sigmoid #pause

$ rho(bold(tau)_-, bold(tau_+)) = sigma (cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-)) $ #pause

$ cases( 
    rho > 0.5 "then" cal(G)(bold(tau)_+) > cal(G)(bold(tau)_-),
    rho < 0.5 "then" cal(G)(bold(tau)_+) < cal(G)(bold(tau)_-) 
) $

//Do not know $cal(G)$, but can think of $rho$ as a normalized advantage

//$ A(s_0, theta_pi_-, theta_pi_+) = sigma( bb(E)[cal(G)(bold(tau)) | s_0, theta_pi_+] - bb(E)[cal(G)(bold(tau)) | s_0 ; theta_pi_-] ) $ 

//$ rho(bold(tau)_-, bold(tau_+)) = underbrace(sigma (cal(R)(s_+) - cal(R)(s_-)), "Probability human prefers" s_+) $

==
*Definition:* The Bradley-Terry advantage relates pairwise preferences to the return, without explicitly computing the return #pause

$ rho(bold(tau)_-, bold(tau_+)) = sigma (cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-)) $ #pause

We can treat $rho$ as the *probability* of a human preferring $bold(tau)_+$ over $bold(tau)_-$ #pause

$ rho(bold(tau)_-, bold(tau_+)) = Pr("Human prefers" bold(tau)_+) / ( Pr("Human prefers" bold(tau)_+) + Pr("Human prefers" bold(tau)_-)) $ #pause


$ rho(bold(tau)_-, bold(tau_+)) = 1: "All humans prefer" bold(tau_+) \

rho(bold(tau)_-, bold(tau_+)) = 0: "All humans prefer" bold(tau_-) \

rho(bold(tau)_-, bold(tau_+)) = 0.8: "Most humans prefer" bold(tau_+) $ \

==

$ rho(bold(tau)_-, bold(tau_+)) &= sigma (cal(G)(bold(tau)_+) - cal(G)(bold(tau)_-)) \

rho(bold(tau)_-, bold(tau_+)) & = 1: "All humans prefer" bold(tau)_+ \

rho(bold(tau)_-, bold(tau_+)) & = 0: "All humans prefer" bold(tau)_- $ #pause

Can maximize Bradley-Terry advantage to maximize return #pause

$ argmax_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = underbrace(argmax_(theta_pi) sum_(bold(tau)_-, bold(tau)_+) rho(bold(tau)_-, bold(tau)_+), "Choose" a in bold(tau)_+ "not" a in bold(tau)_-) $ #pause

Now, we have an objective that we can solve with RL!

= RLHF

==
With the Bradley-Terry advantage, collect human preference dataset #pause

#side-by-side(align: horizon)[
    $ 
    bold(x) = vec(bold(tau)_-, bold(tau)_+, rho(bold(tau)_-, bold(tau)_+))
    $ #pause
][
    $ bold(X) = mat(
        bold(x)_1,
        bold(x)_2,
        dots
    ) $ #pause
]

*Question:* How do we use RL on a fixed dataset? #pause

*Answer:* Offline RL! #pause

RLHF $=$ Offline RL with preferences (human-selected returns)

==
Generative pretraining/imitation learning is 99% of training #pause
- Learn from smart responses mixed with many idiot responses #pause
- Learns general knowledge, human thought and speech #pause

Offline RL/RLHF is 1% of training #pause
- Small but very very important! #pause
- "Unlocks" intelligence by focusing on good thoughts and responses #pause

Offline RL learns to think ($theta_f$) and speak $theta_pi$ *better* than the expert $theta_beta$! #pause
- LLM can become *smarter* than any expert in the dataset #pause
    - Very important! Not possible with imitation learning/GPT

==
*Question:* What offline RL algorithms do we know? #pause
+ Weighted behavioral cloning with rewards/returns 
    - RWR, MARWIL, etc #pause
+ Q learning with constraints
    - BCQ, CQL, etc
    - Constraints prevent overextrapolation #pause
+ Inverse RL
    - Learn reward/return function from dataset, then use online RL #pause

Most people use approaches 1 and 3 #pause

*Question:* Why not approach 2? #pause *Answer:* I don't know, try it out!


==

We name offline RL algorithms differently for RLHF #pause
- Why? So you can "create" a new algorithm and become famous #pause

Weighted behavioral cloning 
- Direct Preference Optimization (DPO)
- Kahneman Tversky Optimization (KTO)

Inverse RL 
- Constrained REINFORCE/Policy Gradient
- Proximal Policy Optimization (PPO-RLHF)
- Group Relative Policy Optimization (GRPO) #pause

DPO and KTO are very interesting methods, but I have limited time #pause
- Focus on inverse RL

= Inverse RL
==
In inverse RL, we learn the parameters for the reward function $theta_cal(R)$

$ cal(R)(s, theta_cal(R)) $ #pause

In RLHF, it is easier to learn the parameters for return $theta_cal(G)$

$ cal(G)(bold(tau), theta_cal(G)) $ #pause

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
] #pause

$ rho(bold(tau)_-, bold(tau_+), theta_cal(G)) = sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))) = Pr("Human prefers" bold(tau)_+ ) $ #pause

We want to find $theta_cal(G)$ that predicts the human preferences in our dataset #pause

Use cross entropy loss, similar to classification task #pause

/*
Since $rho$ is a probability, we maximize the log likelihood #pause
- Learn $theta_cal(G)$ that make $cal(G)(bold(tau)_+, theta_cal(G))$ big and make $cal(G)(bold(tau)_-, theta_cal(G))$ small #pause
*/

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) underbrace(rho(bold(tau)_-, bold(tau_+)), "Label from" bold(X))  log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), "Learn" theta_cal(G) "to match label") 
$

==

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) underbrace(rho(bold(tau)_-, bold(tau_+)), "Label from" bold(X))  log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), "Learn" theta_cal(G) "to match label") 
$ #pause

We often model $cal(G)(bold(tau), theta_cal(G))$ using another LLM #pause

$ cal(G)(bold(tau), bold(theta)_cal(G)) = softmax(bold(theta)_cal(G)^top #pin(1)f(bold(tau), theta_f)#pin(2)) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: top, height: 1.5em)[$s$] #pause

We only learn a linear layer $bold(theta)_cal(G)$, not the LLM parameters $theta_f$! #pause

With $cal(G), theta_cal(G)$, we can compute the return for any trajectory #pause

We use any online RL algorithm to learn $theta_pi$!

==

Let us start with REINFORCE (Monte Carlo policy gradient) #pause

$
theta_(pi, i+1) &= theta_(pi, i) + alpha dot nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] \  #pause

nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] &= bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] dot nabla_theta_(pi, i) log pi (a_0 | s_0; theta_(pi, i))
$ #pause

Plug in our learned return function $cal(G)(bold(tau), theta_cal(G))$ #pause

$
theta_(pi, i+1) &= theta_(pi, i) + alpha dot nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau), #redm[$theta_cal(G)$]) | s_0; theta_(pi, i)] \

nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau), #redm[$theta_cal(G)$]) | s_0; theta_(pi, i)] &= bb(E)[cal(G)(bold(tau), #redm[$theta_cal(G)$]) | s_0; theta_(pi, i)] dot nabla_theta_(pi, i) log pi (a_0 | s_0; theta_(pi, i))
$ #pause

That is it, easy!

==

After learning $theta_cal(G)$, we can use normal RL #pause

Standard RL training process: #pause
1. Give the LLM a user query (beginning of $bold(tau)$) #pause
2. LLM generates a response (complete $bold(tau)$) #pause
3. Compute the return $cal(G)(bold(tau), theta_cal(G))$ #pause
4. Update LLM parameters $theta_pi, theta_f$ using $cal(G)(bold(tau), theta_cal(G))$ #pause
    - To simplify equations, I will only learn $theta_pi$ #pause
    - But you can also learn $theta_f, theta_pi$ together


==
*Definition:* Inverse REINFORCE learns a return function using the Bradley-Terry advantage, then learns a policy using REINFORCE #pause

*Step 1:* Learn the return

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) underbrace(rho(bold(tau)_-, bold(tau_+)), "Label from" bold(X))  log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), "Learn" theta_cal(G) "to match label") 
$ #pause

*Step 2:* Learn the policy using Monte Carlo policy gradient 

$
theta_(pi, i+1) = theta_(pi, i) + alpha dot nabla_(theta_pi) bb(E)[cal(G)(bold(tau), theta_cal(G)) | s_0; theta_pi]
$

==
*Definition:* Constrained inverse REINFORCE adds a constraint to ensure the policy does not change too much #pause

*Step 1:* Learn the return

$ theta_cal(G) = argmax_(theta_cal(G)) sum_(bold(tau)_+, bold(tau)_- in bold(X)) underbrace(rho(bold(tau)_-, bold(tau_+)), "Label from" bold(X))  log underbrace(sigma (cal(G)(bold(tau)_+, theta_cal(G)) - cal(G)(bold(tau)_-, theta_cal(G))), "Learn" theta_cal(G) "to match label") 
$ #pause

*Step 2:* Learn the policy with a KL constraint

$
theta_(pi, i+1) = #pin(1)theta_(pi, i) + alpha dot nabla_(theta_pi)  
    bb(E)[cal(G)(bold(tau), theta_cal(G)) |#pin(2) s_0; theta_(pi, i)]#pin(3) \ - 
    #pin(4)nabla_(theta_(pi, i + 1)) KL[pi (a | s; theta_(beta)), pi (a | s; theta_(pi, i + 1))]#pin(5)
$ #pause

#pinit-highlight-equation-from((1,3), (2,3), fill: red, pos: top, height: 1.5em)[Policy gradient] #pause
#pinit-highlight-equation-from((4,5), (4,5), fill: blue, pos: bottom, height: 1.5em)[KL constraint, stay close to dataset] 

==
Finally, I want to discuss GRPO #pause

GRPO is based on PPO #pause
- PPO is complicated and has too many terms #pause
- I think this will confuse everyone #pause
- The important part of GRPO is group normalization, not PPO #pause

I will present Steven's GRPO: REINFORCE with group normalization #pause
- Much simpler version of GRPO #pause
- Help you understand the key idea behind GRPO

==
*Definition:* Steven's Group Relative Policy Optimization (S-GRPO) normalizes the return using completions of the same user query $s_q$

$ bold(tau)_i tilde Pr (bold(tau) | s_q; theta_pi) $

$ theta_(pi, i+1) &= theta_(pi, i) + alpha dot nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau), theta_cal(G)) | s_q; theta_(pi, i)] $

$
nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_q; theta_(pi, i)] &= underbrace( (cal(G)(bold(tau), theta_cal(G)) - 1 / n sum_(i=1)^n cal(G)(bold(tau)_i, theta_cal(G))), "Advantage over other competions" ) nabla_theta_(pi, i) log pi (a | s; theta_(pi, i))
$


==
S-GRPO compare answers to the same query, reducing variance #pause

$ s_q = f("Where is Macau?", theta_f) $ #pause

$ bold(tau)_1 &= "Macau is a Special Administrative Region (SAR) in " dots \
bold(tau)_2 &= "Macau is a city in Asia near the equator" dots \
dots.v & 
$ #pause

$
nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_q; theta_(pi, i)] &= underbrace( (cal(G)(bold(tau), theta_cal(G)) - 1 / n sum_(i=1)^n cal(G)(bold(tau)_i, theta_cal(G))), "Advantage over other competions" ) nabla_theta_(pi, i) log pi (a | s; theta_(pi, i))
$ #pause

Similar to Bradley-Terry: Ranking/normalizing trajectories $bold(tau)_-, bold(tau)_+$

==
Real GRPO combines group normalization with the PPO objective #pause
- Use the MC return like S-GRPO, deleting $V$ from PPO #pause
    - However, they still use the PPO advantage #pause
- PPO-clip to prevent large policy changes #pause
- Off-policy correction and minibatching #pause
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
You may hear about LLM *alignment* #pause

*Alignment:* Does the language model respect human values? #pause
- Polite or rude? #pause
- Unbiased or biased? #pause
- Good or evil? #pause

With RLHF, learn return function from human preferences #pause
- Humans can prefer rude/biased/racist/evil answers #pause
- No ground truth, rude/biased/racist/evil depends on culture #pause
- LLM maximizes the return #pause
    - LLM learns to be biased/racist/evil #pause
    - RL finds superhuman policy, superhuman levels of bias/racism/evil

==

https://www.youtube.com/shorts/RSdIBZX6Adw

https://www.youtube.com/watch?v=eJXDFOwJZMk #pause

*Question:* What do humans do with less intelligent beings? #pause

*Answer:* Eat them 

= Final Remarks
==
Throughout the course, I focused on teaching fundamentals and theory #pause
- I know this can be painful #pause
- Some prefer one lecture on PPO, one on SAC, etc instead of basics #pause
- Today, we defined LLMs using fundamentals #pause
    - POMDP 
    - Behavioral cloning
    - Offline RL
    - Actor critic
        - Policy gradient
        - V/Q functions #pause

Every complex algorithm is some combination of what you learned

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

I am very proud of you all for making it so far! #pause
- From your participation, many of you are already experts! #pause
- It is not expected that you understand everything! #pause
- If you understand MDPs and V/Q functions, that is enough #pause

I know many of you live in Zhuhai, and crossing the border takes time #pause
- I hope these lectures have been useful #pause

And I hope you enjoyed the course!


==
// The world is a very fragile place
// The news over the past few months has reminded us of this fragility
// All evil requires to triumph is for good men to do nothing
// Creating evil is as simple as negating the reward function

The world is a fragile place #pause
- Recent news reminds us how fragile the world is #pause
- We take the ability to study and learn for granted #pause

All of us are born with shortcomings in our reward function #pause
- Greed, bias, fear, indifference #pause
- Consider your own alignment #pause
    - Try and consider the impact of your decisions on others #pause

From assignment 2, you can all create superhuman policies #pause
- You have a powerful tool, you must use it for good #pause
    - Humans are already good at hurting others #pause
    - Do not train superhuman policies to hurt others

==
#quote(block: true)[Frodo: I wish the ring had never come to me. I wish none of this had happened.] #pause

#quote(block: true)[Gandalf: So do all who live to see such times, but that is not for them to decide. All we have to decide is what to do with the time that is given us.] #pause

- We cannot choose our situation $s_0$
- We cannot control circumstances beyond our control $Tr$
- The one think we can control, are our actions $a$

Make sure you choose good actions with the life you are given!

= Course Feedback
==
Please fill out the course feedback!
https://isw.um.edu.mo/siatsl/