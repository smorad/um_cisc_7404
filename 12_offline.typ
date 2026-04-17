#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.4.2": canvas
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

// TODO: Cover inverse RL better as we use it in LLM lecture

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Offline Learning],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  //config-common(handout: true),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)


#let exp_plot = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (10, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: 2,
            //y-ticks: (0, 1),
            y-min: -5,
            y-max: 5,
            x-label: $ r $,
            y-label: [$ $],
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ r $,
                x => x,
            ) 
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: blue)),
                label: $ f(r) $,
                x => calc.exp(x),
            ) 

            })
    }
)}

#let bimodal = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
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
                label: $ pi (a | s_0; bold(theta)_(beta)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            plot.annotate({
                line((-1,0), (-1,1.1), stroke: (paint: orange, thickness: 1mm))
                content((-1,1.2), text(fill: orange)[$ a_+ $])

                line((1,0), (1,1.1), stroke: (paint: orange, thickness: 1mm))
                content((1,1.2), text(fill: orange)[$ a_- $])
            }) 
        })
    }
)}

#let bimodal_pi = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
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
                label: $ pi (a | s_0; bold(theta)_(pi)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            plot.annotate({
                line((-1,0), (-1,1.1), stroke: (paint: orange, thickness: 1mm))
                content((-1,1.2), text(fill: orange)[$ a_+ $])

                line((1,0), (1,1.1), stroke: (paint: orange, thickness: 1mm))
                content((1,1.2), text(fill: orange)[$ a_- $])
            }) 
        })
    }
)}

#let bimodal_return = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; bold(theta)_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; bold(theta)_(beta)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            /*
            plot.annotate({
                line((1.5,0), (1.5,4), stroke: orange)
                content((1.5,5), text(fill: orange)[$ cal(G)(bold(E)_1) $])

                line((4.5,0), (4.5,4), stroke: orange)
                content((4.5,5), text(fill: orange)[$ cal(G)(bold(E)_2) $])
            })
            */
        })
    }
)}

#let bimodal_reweight = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; bold(theta)_(pi)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s_0; bold(theta)_(pi)) $,
                x => 0.75 * normal_fn(-1, 0.3, x) + 0.1 * normal_fn(1, 0.3, x),
            ) 

            plot.annotate({
                line((-1,0), (-1,1.1), stroke: (paint: orange, thickness: 1mm))
                content((-1,1.2), text(fill: orange)[$ a_+ $])

                line((1,0), (1,1.1), stroke: (paint: orange, thickness: 1mm))
                content((1,1.2), text(fill: orange)[$ a_- $])
            }) 
        })
    }
)}

#let bimodal_return_adv = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; bold(theta)_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; bold(theta)_(beta)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            plot.annotate({
                line((1.5,0), (1.5,4), stroke: orange)
                content((0.5,5), text(fill: orange)[$ A(s, a=a_"good", bold(theta)_beta) $])

                line((4.5,0), (4.5,4), stroke: blue)
                content((6.0,-2), text(fill: blue)[$ A(s, a=a_"bad", bold(theta)_beta) $])
            })
        })
    }
)}

#let bimodal_reweight_adv = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        import cetz.draw: *
        import cetz-plot: *
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; bold(theta)_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; bold(theta)_(beta)) $,
                x => 0.75 * normal_fn(-1, 0.3, x) + 0.25 * normal_fn(1, 0.3, x), 
            ) 

            plot.annotate({
                line((1.5,0), (1.5,4), stroke: orange)
                content((0.5,5), text(fill: orange)[$ A(s, a=a_"good", bold(theta)_beta) $])

                line((4.5,0), (4.5,4), stroke: blue)
                content((6.0,-2), text(fill: blue)[$ A(s, a=a_"bad", bold(theta)_beta) $])
            })
        })
    }
)}

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Admin

==
Last exam next lecture! #pause
- 4 questions #pause
    + Advantages #pause
    + Off-policy gradient #pause
    + DDPG (learning $mu$) #pause
    + Behavior cloning


= Learning from Offline Data

==

#side-by-side[
#cimage("fig/11/flip.jpg") #pause
][
*Example:* You are a scientist at Boston Dynamics/Tencent Robotics/etc #pause
- Must do demos to get funding #pause
- Teach a robot to backflip #pause

]
*Problem:* Your robot weighs 100 kg #pause
- If it fails to backflip, it will break #pause
- Must break 10M robots to learn with RL 

==
RL only works in simulators #pause

In real scenarios, it is dangerous to explore #pause
- Robot backflip (random action breaks robot) #pause
- Self driving (random action kills pedestrian) #pause
- Surgery (random action stabs nurse) #pause

*Question:* How can we learn a policy *without* exploration? #pause

*Answer:* Not really #pause

*Question:* So what can we do? #pause

*Answer:* Let expert (human) safely collect training data (explore)

==
*Definition:* In offline policy learning, we cannot access the MDP. Instead, we have a dataset $bold(X)$ collected by unknown policy $pi (a | s; bold(theta)_beta)$.

$ bold(X) = mat(bold(tau)_1, bold(tau)_2, dots) = mat(
    vec((s_0, a_0, r_0, s_1), (s_1, a_1, r_1, s_2), dots.v),
    vec((s_0, a_0, r_0, s_1), (s_1, a_1, r_1, s_2), dots.v),
    dots
)
$ #pause

$ a_t tilde pi(dot | s_t, bold(theta)_beta) $ #pause

$ bold(theta)_beta = ? $

//==
// https://www.youtube.com/watch?v=4N4czAm61Fc


= Imitation Learning
==
The easiest way to learn from offline data is *imitation learning* #pause
- We should imitate an expert policy $pi (a | s; bold(theta)_beta)$ #pause
- Does not even use rewards! #pause

$ pi (a | s; bold(theta)_pi) = pi (a | s; bold(theta)_beta) #pause =>

argmin_(bold(theta)_pi) (pi (a | s; bold(theta)_beta) - pi (a | s; bold(theta)_pi))^2 $ #pause

*Question:* Does this work? #pause

*Answer:* Not exactly, $pi(a | s)$ is a distribution not a scalar #pause

*Question:* How can we measure the difference of two distributions? #pause

*Answer:* KL divergence measures difference in distributions

==
$ KL(Pr(X), Pr(Y)) = sum_(omega in Omega_X) Pr(X=omega) log Pr(X=omega) / Pr(Y=omega) $ #pause

Minimize difference between $underbrace(pi (a | s; bold(theta)_beta), Pr(X))$ and $underbrace(pi (a | s; bold(theta)_pi), Pr(Y))$ #pause

$ argmin_(bold(theta)_pi) space KL(pi (a | s; bold(theta)_beta), pi (a | s; bold(theta)_pi)) $ #pause

Plug policies into KL equation #pause

$ argmin_(bold(theta)_pi) sum_(a in A) pi (a | s; bold(theta)_beta) log (pi (a | s; bold(theta)_beta)) / (pi (a | s; bold(theta)_pi)) $

==

$ argmin_(bold(theta)_pi) sum_(a in A) pi (a | s; bold(theta)_beta) log (pi (a | s; bold(theta)_beta)) / (pi (a | s; bold(theta)_pi)) $ #pause

Log of divisors is difference of logs #pause

$ argmin_(bold(theta)_pi) sum_(a in A) pi (a | s; bold(theta)_beta) [ log(pi (a | s; bold(theta)_beta)) - log (pi (a | s; bold(theta)_pi)) ] $ #pause

Distribute behavior policy into difference #pause

$ argmin_(bold(theta)_pi) sum_(a in A) pi (a | s; bold(theta)_beta)  log pi (a | s; bold(theta)_beta) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi)  $

==

$ argmin_(bold(theta)_pi) sum_(a in A) pi (a | s; bold(theta)_beta)  log pi (a | s; bold(theta)_beta) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

First term is constant with respect to $bold(theta)_pi$ (only depends on $bold(theta)_beta$) #pause
- Can ignore the first term for optimization purposes #pause

$ argmin_(bold(theta)_pi) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

This is the *cross-entropy* objective #pause

*Question:* Have we seen this objective in deep learning? #pause

*Answer:* Loss for classification tasks

==
$ argmin_(bold(theta)_pi) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

*Question:* Where does $s$ come from? #pause *Answer:* Dataset $bold(X)$ #pause

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

This is equivalent to an expectation over the dataset or behavior policy #pause

$ argmin_(bold(theta)_pi) bb(E)[sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) mid(|) underbrace(bold(X), bold(theta)_beta)] $ 


==

*Definition:* Behavioral cloning learns the parameters $bold(theta)_pi$ to match an expert policy $bold(theta)_beta$ that collected the dataset $bold(X)$ #pause

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

Behavioral cloning is a simple supervised learning algorithm!

==

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

*Question:* How do we evaluate this? #pause

If $A$ is discrete, we can sum over possible actions $a in A$ #pause
- Our expert policy will often be one-hot #pause
- $pi (a = a_* | s; bold(theta)_beta) = 1$ (action the expert took) #pause
- $pi (a != a_* | s; bold(theta)_beta) = 0$ (all other actions) #pause

What if $A$ is continuous (infinite)? 

==
$ argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

If $A$ is continuous, we have an infinite sum #pause

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) dif a $ #pause

Not all integrals are solvable #pause

Need to be careful how we model $pi$, to make sure we can solve this

==

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) dif a $ #pause

To ensure we have an analytical solution to this integral: #pause
- Use Dirac delta expert policy $pi (a | s; bold(theta)_beta) = delta(a - a_*)$ #pause
- Use Gaussian learned policy $pi (a | s; bold(theta)_pi) = "Normal"(mu, sigma)$

==

*Definition:* Behavioral cloning uses *supervised learning* for decision making, minimizing the cross-entropy between expert $bold(theta)_beta$ and our $bold(theta)_pi$

$ argmin_(bold(theta)_pi) sum_(s, a in bold(X)) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $

For continuous actions, we pick special distributions so the cross entropy loss is tractable (Dirac delta $bold(theta)_beta$, Gaussian $bold(theta)_pi$) #pause

#v(1.5em)

//$ argmin_(bold(theta)_pi) sum_(s in bold(X)) 1/2 log(2 pi #pin(7)sigma#pin(8)^2) + (#pin(1)a_*#pin(2) - #pin(3)mu#pin(4))^2 / (2 #pin(5)sigma#pin(6)^2) $ #pause

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) 1/2 (log#pin(5)sigma#pin(6)^2 + (#pin(1)a_*#pin(2) - #pin(3)mu#pin(4))^2 / (#pin(7)sigma#pin(8)^2)) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Expert action] 
#pinit-highlight-equation-from((7,8), (7,8), fill: blue, pos: bottom, height: 1.2em)[Policy outputs] 
#pinit-highlight(3,4, fill: blue.transparentize(80%))
#pinit-highlight(5,6, fill: blue.transparentize(80%))

= Coding

==
Similar to policy gradient, just with different loss function #pause

The policies and methods change depending on action space #pause
- Discrete actions use a categorical distribution #pause
- Continuous actions usually use normal distribution #pause

Start with discrete actions, then do continous

==
Implement a model for a categorical policy #pause

```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    # Output logits (real numbers)
    Linear(hidden_size, action_size),
])
``` #pause

Identical to policy gradient



==
Next, implement discrete loss function #pause

```python
    def bc_loss(model, states, actions):
        # Often, we can't know the expert action distribution
        # We only have the taken expert action
        # Taken action has p=1, all other actions p=0
        # Represent as a one-hot vector
        expert_probs = actions
        log_policy_probs = log_softmax(vmap(model)(states))
        # Log loss, can reduce over batch using mean or sum
        bce_loss = -sum(
            expert_probs * log_policy_probs, axis=1).mean()
        return bce_loss
```
==
Finally, to run our policy we sample actions from our policy #pause

```python
def sample_action(model, state, key):
    z = model(state)
    # BE VERY CAREFUL, always read documentation
    # Sometimes takes UNNORMALIZED logits, sometimes probs
    action_probs = softmax(model, state)
    a = categorical(key, action_probs)
    a = categorical(key, z) # Does not even use pi
    return a
``` #pause
Identical to policy gradient
==

Now, consider Gaussian policy (continuous actions) #pause 

```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    # Output mu and log_sigma 
    Linear(hidden_size, 2 * action_size),
    Lambda(x: split(x, 2))
])
``` #pause

Same as policy gradient

==
Implement continuous loss function #pause
- Use simplified cross entropy (Dirac-Gaussian) #pause

```python
def bc_loss(model, states, actions):
    expert_probs = actions # Dirac delta
    mu, log_std = vmap(model)(states)
    # Gaussian CE, also called Gaus. Neg. Log Likelihood
    # gnll_loss = log_std + 0.5 * ( 
    #     (mu - action)**2 / exp(log_std)**2
    # ) 
    gnll_loss = jax.scipy.stats.norm.logpdf(
        x=action, loc=mu, scale=exp(log_std))

    return gnll_loss
```

==
Next, we need to sample actions from our policy network
```python
def sample_action(model, state, key):
    mu, log_sigma = model(state)
    # a ~ N(mu, sigma)
    noise = random.normal(key, (action_size,))
    a = mu + exp(log_sigma) * noise
    return a
```

==
The training loop is much simpler than RL #pause

```python
model = Sequential(...)
opt_state = ...
# Just supervised learning
for batch in dataset:
    states, actions = batch
    J = grad(bc_loss)(model, states, actions)
    update = optim.update(J, opt_state)
    model = apply_updates(update, model)
``` #pause

Then deploy the policy #pause

```python
a_t = sample_action(model, s_t, key)
```

= Applications
==

Behavioral cloning seems very powerful! #pause
- No need for reward function #pause
- No need for exploration, learn from fixed dataset #pause
- Simpler to implement than RL #pause
- More stable to train than RL #pause

Sounds very promising, why do we care about RL? #pause

*Question:* What are some disadvantages of BC?

==
#side-by-side[
    #cimage("fig/11/texting.jpg", height: 80%)

][
    *Limitation:* Imperfect expert #pause

    Dataset is following an "expert" $bold(theta)_beta$ #pause
    - Most humans are not experts #pause
        - You will learn a policy that drives like it is texting
]


==
Even where all the data is from a reliable "expert", we have problems #pause

Consider a human surgeon #pause
- Machines can be faster and more precise than human surgeons #pause
- We only learn to imitation a suboptimal human #pause

$ pi (a | s; bold(theta)_pi ) approx underbrace(pi (a | s; bold(theta)_beta), "Human policy") $ #pause

= Offline RL
// Refresher of on-policy and off-policy RL
    // Both require exploration and collecting data from env
    // Imitation learning does not
    // Downsides of IL
    // Can we do better?
// What is offline RL
// Example applications, why we care
// Benefit of offline RL over imitation learning
    // Stitching diagram

==

*Review:* 
In on-policy RL, each iteration we collect a *new* dataset using our policy #pause

In off-policy RL, each iteration we *update* our dataset using our policy #pause

In imitation learning, we are given a fixed *expert* dataset

*Question:* Did you find imitation learning interesting? Why?

==

Imitation learning from a fixed dataset is attractive for many reasons #pause
- Fixed dataset results in much simpler code #pause
    - No need to collect new data, step environment, etc #pause
- Easier and more stable to train (supervised learning) #pause

But imitation learning (IL) also has disadvantages #pause
- Only imitates, does not think or plan #pause
    - Can only do as good as expert #pause
    - Humans are usually bad "experts" #pause
    - We want to do *better* than humans #pause

*Question:* Can we learn policies from fixed datasets that do better than the experts?

==
Unlike imitation learning, offline RL can do *better* than the expert #pause
- Can learn an optimal policy from a random "expert"! #pause
- How is this possible without exploration? #pause

In imitation learning, we learn to imitate dataset trajectories #pause

In offline RL, we learn to *stitch* together subtrajectories into optimal trajectories

==
#cimage("fig/12/stitching.png")

==
Offline RL is a very new field #pause

If we can make offline RL work reliably, it can be very powerful #pause
- Learn superhuman driving from existing Xiaomi dataset #pause
- Learn superhuman surgery from existing surgery videos #pause
- Learn language model finetuning from existing internet text #pause

We can learn nice policies from completely random data! 
- https://youtu.be/gU1UEZVlUk0

==
*Goal:* learn a policy that maximizes the return #pause

$ argmax_(bold(theta)_pi) bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_pi] $ #pause

There are two ways to approach offline RL #pause
- Improve behavior cloning with rewards #pause
- Off-policy RL without exploration #pause

Let us begin with behavior cloning first




= Behavioral Cloning with Rewards
// Main idea is behavior cloning
// However, reweight actions based on advantage
// Constrained to the dataset (no out of distribution actions)
// Learn Q/V based only on dataset actions
    // Cannot overextrapolate to new actions!
    // Use this to select "better" trajectories
    // Should we use TD or MC?
        // Only want to learn for behavior policy, can use MC because more stable

==
Recall the behavior cloning objective #pause

Want to minimize difference between learned and expert policy #pause

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) space KL(pi (a | s; bold(theta)_beta), pi (a | s; bold(theta)_pi)) $ #pause

From this, we derive the cross entropy loss #pause

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ 

==

$ argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

Consider the following situation: #pause
- Two possible actions $A = {a_+, a_-}$ #pause
- Single state $s_0$ in the dataset, visited *twice* #pause
- First time, expert takes action $a_+$ in $s$ #pause
- Second time, expert takes action $a_-$ in $s$ #pause

Expert must behave better in one state than the other! #pause

$ argmin_(bold(theta)_pi) sum_(a in {a_+, a_-}) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) $


==
// $ argmin_(bold(theta)_pi) sum_(a in {a_+, a_-}) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ 

#side-by-side[
    $ pi (a_+ | s_0; bold(theta)_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; bold(theta)_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] #pause

*Question:* Which action is better behavior?

==
#side-by-side[
    $ pi (a_+ | s_0; bold(theta)_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 40%)
][
    $ pi (a_- | s_0; bold(theta)_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 40%)
] #pause

*Question:* Two actions in same state, what policy $bold(theta)_pi$ does BC learn? #pause

*Answer:* Randomly choose $a in {a_+, a_-}$ #pause

*Question:* Is this a good idea?

==
#side-by-side[
    $ pi (a_+ | s_0; bold(theta)_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; bold(theta)_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] #pause
*Question:* We know which action is better, how can we measure this? #pause

*Answer:* Reward! In BC, no reward. In offline RL, we have reward!

==

Expert has equal probability for both good and bad actions #pause

#side-by-side[
    #bimodal #pause
][
    #bimodal_pi #pause
]

With IL, we can only imitate the expert #pause
- With offline RL, we have empirical rewards, we can do better!


==
#side-by-side[
    #bimodal
][
    #bimodal_pi
]

*Question:* What should we do with $pi (a_+ | s_0; bold(theta)_pi)$ and $pi (a_- | s_0; bold(theta)_pi)$? #pause

*Answer:* Increase probability of $a_+$, decrease probability of $a_-$

==
#side-by-side[
    #bimodal 
][
    #bimodal_reweight 
] #pause

We want to reweight action probabilities #pause

*Question:* How do we determine good and bad actions? #pause

*Answer:* Reward!

==
// TODO: Return and fix
$ argmin_(bold(theta)_pi) sum_(a in {a_+, a_-}) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) $ 

Increase probability of $a_+$ and decrease probability of $a_-$ using reward #pause

*Question:* How? #pause Hint:

$ argmin_(bold(theta)_pi) - pi (a_+ | s_0; bold(theta)_beta) log pi (a_+ | s_0; bold(theta)_pi) - pi (a_- | s_0; bold(theta)_beta) log pi (a_- | s_0; bold(theta)_pi) $ #pause

*Answer:* Reweight each action in the objective using the reward #pause

#text(size: 24pt)[$ argmin_(bold(theta)_pi) - #redm[$r_+$] pi (a_+ | s_0; bold(theta)_beta) log pi (a_+ | s_0; bold(theta)_pi) - #redm[$r_-$] pi (a_- | s_0; bold(theta)_beta) log pi (a_- | s_0; bold(theta)_pi) $]

==

*Definition:* In *Expectation Maximization Reinforcement Learning* (EMRL, Hinton), we reweight the behavior cloning objective using the reward #pause

$ bold(theta)_pi = argmin_(bold(theta)_pi) underbrace(sum_(s_0, r_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi), "BC objective") dot r_0  $ 

==

$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0, r_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot r_0  $ 

Consider the simplified example, with rewards $r_+, r_-$ #pause

#text(size: 24pt)[$ argmin_(bold(theta)_pi) \ - #redm[$r_+$] pi (a_+ | s_0; bold(theta)_beta) log pi (a_+ | s_0; bold(theta)_pi) - #redm[$r_-$] pi (a_- | s_0; bold(theta)_beta) log pi (a_- | s_0; bold(theta)_pi) $] #pause

*Question:* Are there any problems with EMRL? #pause
- Hint: What if $r_+, r_-$ are negative? #pause
- EMRL only works with positive rewards!

==

#text(size: 24pt)[$ argmin_(bold(theta)_pi) - #redm[$r_+$] pi (a_+ | s_0; bold(theta)_beta) log pi (a_+ | s_0; bold(theta)_pi) - #redm[$r_-$] pi (a_- | s_0; bold(theta)_beta) log pi (a_- | s_0; bold(theta)_pi) $] #pause

$ r in bb(R) $ #pause

We want our algorithm to work with positive and negative rewards #pause
- Need a mapping between rewards and weights $f: bb(R) |-> bb(R)_+$ #pause

*Question:* Any other properties for $f$? #pause Hint: Does $f(r) = |r|$ work? #pause

*Answer:* $f$ must be *monotonic* to ensure we still maximize rewards! #pause

$ r_+ > r_- => f(r_+) > f(r_-) $

==

*Question:* What functions $f: [-oo, oo] |-> [0, oo]$ are monotonic? #pause

#align(center, exp_plot) #pause

$ f(r) = exp(r) $

==
*Definition:* Reward Weighted Regression (RWR) reweights the behavior cloning objective using the exponentiated reward #pause

$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0, r_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot exp(r_0) $ #pause

Consider an infinitely large and diverse dataset containing all $s, a$ #pause
- Then, weights are proportional to Boltzmann distribution (softmax) #pause

$ sum_(a_0 in A) exp(bb(E)[cal(R)(s_1) | s_0, a_0]) prop sum_(a_i in A) ( exp(bb(E)[cal(R)(s_1) | s_0, a_i]) ) / ( sum_(a_0 in A) exp(bb(E)[cal(R)(s_1) | s_0, a_0]) ) $

==
$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0, r_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot exp(r_0) $ #pause
RWR finds $bold(theta)_pi$ that maximizes the reward #pause

*Question:* Do we maximize the reward in RL? #pause

*Answer:* No, we maximize the return! #pause

$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot underbrace(exp(bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_beta]), "Replace reward with return") $ 

==
$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot exp(bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_beta]) $ 

We can approximate the expectation using the return from the dataset #pause
- Need infinite rewards to approximate Monte Carlo return #pause
- Returns can be big or small, causing overflows $exp(cal(G)(bold(tau))) -> 0, oo$ #pause

*Question:* Similar problems with actor critic, what was the solution? #pause
- Introduce TD value function (remove infinite sum) #pause
- Introduce advantage (normalize return)

==
$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot exp(bb(E)[cal(G)(bold(tau)) | s_0; bold(theta)_beta]) $ 

$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi) dot underbrace(exp(A(s, a, bold(theta)_beta) ), "Use advantage instead") $ #pause

$ A(s, a, bold(theta)_beta) &= Q(s, a, bold(theta)_beta) - V(s, bold(theta)_beta) \  #pause

A(s_t, s_(t+1), bold(theta)_beta) &= - underbrace([V(s_t, bold(theta)_beta) - (r_t + gamma V(s_(t+1), bold(theta)_beta))], "TD error") $ 


==

*Definition:* Monotonic Advantage Re-Weighted Imitation Learning (MARWIL) is advantage weighted behavior cloning #pause

//*Step 1:* Learn a value function for $bold(theta)_beta$ #pause

$ &#text[Step 1:] cases(
    eta = underbrace(V(s_0, bold(theta)_(beta), bold(theta)_(V,i)) - (r_0 + not d gamma V(s_0, bold(theta)_(beta), bold(theta)_(V,i))), "TD Error"), 

    display(bold(theta)_(V, i+1) = argmin_bold(theta)_(V, i) eta^2))  \ #pause

//$ bold(theta)_V &= argmin_(bold(theta)_V) (V(s_0, bold(theta)_beta, bold(theta)_V) - y)^2 #pause \ 
//y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, bold(theta)_beta, bold(theta)_V)  \ #pause

&#text[Step 2:] cases(
A(s_0, r_0, s_(1), bold(theta)_beta, bold(theta)_V) = - eta,
 display(bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s, s_(1), r_0 in bold(X)) sum_(a in A) underbrace(- pi (a | s_0; bold(theta)_beta) log pi (a | s_0; bold(theta)_pi), "BC objective") dot exp(A))
) $ 

*Note:* Sometimes called Advantage Weighted Regression (AWR)

==

*Question:* Is MARWIL RL or supervised learning? #pause

*Answer:* Both #pause
- Learn policy using supervised learning (SL) #pause
- But weights require learning value function (RL) #pause

==
Add improvements to MARWIL to derive other offline RL algorithms #pause
- Advantage Weighted Actor Critic (AWAC) #pause
- Critic Regularized Regression (CRR) #pause
- Implicit Q learning (IQL) #pause
- Maximum a Posteriori Optimization (MPO)

/*
= The Deadly Triad
// Difference between off policy and offline RL
// What off-policy methods could we use for offline RL?
// In assignment 2, you saw how hard TD learning can be
    // Introduce deadly triad
    // Target networks, regularization, etc
    // Q value overestimation
    // Talk a bit about how this happens for off-policy methods too
        // Discuss some fixes
// What happens when we apply standard Q learning without exploration
    // Q value overestimation for OOD actions
    // Works if we try every action in every possible state
    // In many cases, this is too large

==
There are two standard approaches to offline RL #pause

1. Reweight the BC loss using rewards/returns #pause
2. Improve off-policy algorithms to work without exploration #pause

Finished first, now let us visit the second

==
*Goal:* Derive offline RL algorithm from an off-policy algorithm #pause

*Question:* Why off-policy instead of on-policy algorithm? #pause

On-policy requires collecting data with $bold(theta)_pi$ #pause
- But we cannot do this! Dataset is collected with $bold(theta)_beta$ 
- $bold(theta)_beta != bold(theta)_pi$, cannot use on-policy method #pause

Off-policy can learn from any trajectories #pause
- Trajectory collected following $bold(theta)_beta$
- Can use $bold(theta)_beta$ trajectory to update $bold(theta)_pi$ 

==
Ok, let us choose an off-policy algorithm to use #pause

*Question:* Which off-policy RL algorithms do we know? #pause
- Q learning #pause
- DDPG (continuous Q learning) #pause
- Off-policy gradient (does not work well, ignore for now) #pause

*Question:* Temporal Difference or Monte Carlo Q learning? #pause
- MC is on-policy #pause
- Only TD Q learning is off-policy

==
Recall the standard Q learning algorithm #pause

```python
while not terminated:
    transition = env.step(action)
    buffer.append(transition)
    train_data = buffer.sample()
    J = grad(td_loss)(bold(theta)_Q, bold(theta)_T, Q, train_data)
    bold(theta)_Q = opt.update(bold(theta)_Q, J)
``` #pause

*Question:* What can we do to make this offline? Without exploration? #pause

*Answer:*
- Put dataset into replay buffer
- Get rid of `env` code

==

```python
for x in X:
    buffer.append(x) # Add dataset to replay buffer
# Comment out exploration code
# while not terminated:
    # transition = env.step(action)
    # buffer.append(transition)
for epoch in num_epochs:
    train_data = buffer.sample()
    J = grad(td_loss)(bold(theta)_Q, bold(theta)_T, Q, train_data)
    bold(theta)_Q = opt.update(bold(theta)_Q, J)
``` 

==
```python
for x in X:
    buffer.append(x) # Add dataset to replay buffer

for epoch in num_epochs:
    train_data = buffer.sample()
    J = grad(td_loss)(bold(theta)_Q, bold(theta)_T, Q, train_data)
    bold(theta)_Q = opt.update(bold(theta)_Q, J)
``` #pause

*Question:* Will this work? #pause

*Answer:* It can! But only for very simple problems #pause

For harder/interesting problems, loss quickly becomes `NaN`

==

On assignment 2, many of you found issues with deep Q learning #pause
1. Q value would often become very large #pause
2. Loss would become very large #pause
3. Loss/parameters become `NaN` #pause

This was not your fault, it is a known problem in RL! #pause

Called the *deadly triad*, from combining three factors: #pause
1. Function approximation (deep neural network) #pause
2. Recursive bootstrapping (TD, $Q(s, a) = r + gamma max Q(s, a)$) #pause
3. Off-policy learning/limited exploration #pause

Let us further investigate the deadly triad

// Too many states to learn Q
// Must generalize to unseen states
// TD + NN can update other states
// Leads to divergence of the value function
    // Caused by argmax, tends to explode
    // If we cannot explore, we cannot "fix" the diverged states
// Cannot visit unvisited states, what can we do?
    // Limit Q function extrapolation
        // Particularly interested in overestimation
==
Imagine a toy MDP #pause

$ S = {s} #pause quad A = {1, 2} #pause quad Q(s, a, bold(theta)_Q) = bold(theta)_Q dot a #pause quad cal(R)(s) = 0 #pause quad gamma = 1$

Can update $bold(theta)_Q$ using simple TD update #pause

$ bold(theta)_Q = bold(theta)_Q - underbrace([Q(s, a, bold(theta)_Q) - (r + gamma max_(a' in A) Q(s', a', bold(theta)_Q))], "Q error, can consider" nabla cal(L) )$ #pause

$ bold(theta)_Q = bold(theta)_Q - [Q(s, a, bold(theta)_Q) - max_(a' in A) Q(s', a', bold(theta)_Q)]$ #pause

Importantly, to simulate off-policy/offline RL, we have limited dataset #pause
- We only have $s, a=1$ in our dataset, not $s, a=2$ #pause

Let us perform some updates to $bold(theta)_Q$ and see what happens

//$ Q(s, 1, bold(theta)_Q) = bold(theta)_Q dot a = 1 dot 1 = 1 $ #pause

//Receive zero reward $cal(R)(s) = 0$, now let us update $bold(theta)_Q$



==
//$ bold(theta)_Q = Q(s, 1, bold(theta)_Q) - (0 + gamma max_(a' in A) {underbrace(1 dot 1, (a=1) \ 1), underbrace(1 dot 2, (a=2) \ 2)}) $

Initialize $bold(theta)_Q = 1$, update for $a=1$ #pause

$ 
bold(theta)_Q &= bold(theta)_Q - [Q(s, a, bold(theta)_Q) - max_(a' in A) Q(s, a', bold(theta)_Q)] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {Q(s, 1, bold(theta)_Q), Q(s, 2, bold(theta)_Q)}) ] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {bold(theta)_Q dot 1, bold(theta)_Q dot 2}) ] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {1 dot 1, 1 dot 2}) ] \ #pause
bold(theta)_Q &= 1 - [1 - 2] \ #pause
bold(theta)_Q &= 2 $

==

Repeat with $bold(theta)_Q = 2$, update for $a=1$

$ 
bold(theta)_Q &= bold(theta)_Q - [Q(s, a, bold(theta)_Q) - max_(a' in A) Q(s, a', bold(theta)_Q)] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {Q(s, 1, bold(theta)_Q), Q(s, 2, bold(theta)_Q)}) ] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {bold(theta)_Q dot 1, bold(theta)_Q dot 2}) ] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {2 dot 1, 2 dot 2}) ] \ #pause
bold(theta)_Q &= 2 - [2 - 4] \ #pause
bold(theta)_Q &= 4 $

==

Repeat with $bold(theta)_Q = 4$, update for $a=1$

$ 
bold(theta)_Q &= bold(theta)_Q - [Q(s, a, bold(theta)_Q) - max_(a' in A) Q(s, a', bold(theta)_Q)] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {Q(s, 1, bold(theta)_Q), Q(s, 2, bold(theta)_Q)}) ] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {bold(theta)_Q dot 1, bold(theta)_Q dot 2}) ] \ #pause
bold(theta)_Q &= bold(theta)_Q - [ Q(s, 1, bold(theta)_Q) - (max {4 dot 1, 4 dot 2}) ] \ #pause
bold(theta)_Q &= 4 - [4 - 8] \ #pause
bold(theta)_Q &= 8 $

==
Each time we update, $bold(theta)_Q$ increases, even if $cal(R)(s)=0$ #pause
- Larger $bold(theta)_Q$ means larger $Q(s,a, bold(theta)_Q)$ for both $a=1, a=2$ #pause
- #side-by-side[Eventually $bold(theta)_Q -> oo$ #pause][$Q(s, a, bold(theta)_Q) -> oo$ #pause]

*Question:* Why does $bold(theta)_Q$ keep increasing? #pause
+ (Function approximation) We share parameters for $a=1$ and $a=2$ #pause
    - Updating $bold(theta)_Q$ for $a=1$ also updates for $a=2$ #pause
+ (Recursive bootstrap) updating $bold(theta)_Q$ for $a=1$ uses $max_(a in {1, 2})$ in label #pause
+ (Off-policy) Trains on old data, does not contain $a=2$ #pause
    - Eventually, greedy policy should visit $a=2$ #pause

Offline RL guarantees case 3, because we will never explore

==
+ (Function approximation) We share parameters for $a=1$ and $a=2$
    - Updating $bold(theta)_Q$ for $a=1$ also updates for $a=2$
+ (Recursive bootstrap) updating $bold(theta)_Q$ for $a=1$ uses $max_(a in {1, 2})$ in label
+ (Off-policy) Trains on old data, does not contain $a=2$ 
    - Eventually, greedy policy should visit $a=2$ #pause

If we can prevent any of these, we can learn a Q function offline #pause
#side-by-side[
    1. Do not use neural network #pause
][
    Need nn for large state space #pause
]

#side-by-side[
    2. Use MC (non-recursive) instead of TD (recursive) #pause
][
    MC is on-policy only, must use TD #pause
]

#side-by-side[
    3. Visit all possible states/actions #pause
][
    Not possible with fixed dataset
]

= Constraining Q
==
So far, offline Q learning seems impossible #pause

Root problem is the out-of-distribution (OOD) TD update #pause

$ max_(a in A) Q(s, a); quad (s, a) in.not bold(X) $ #pause

We *overextrapolate* for state-action pairs missing from dataset #pause

*Question:* What can we do about this? #pause

*Answer:* Ignore $Q$ for missing state-action pairs #pause

==
We want to ignore $Q(s, a)$ where $s, a in.not bold(X)$ #pause

For a finite discrete state space, this is easy! #pause

Only consider actions we have in our dataset $overline(A)(s)$ #pause

$ overline(A)(s) = {a | (s, a) in bold(X) } $ #pause

$ Q(s_0, a_0, bold(theta)_Q) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma max_(#redm[$a in overline(A)$]) Q(s_(1), a, bold(theta)_Q) $ #pause
 
We ignore actions missing from the dataset! #pause
- This will fix deadly triad via (2. Recursive bootstrap) #pause

*Question:* What if the state space is continuous? Will this work?

==
Continuous state space means we cannot check $(s, a) in bold(X)$ #pause
- Every state $s$ in $bold(X)$ will be different #pause
    - Each state will only have one action #pause
    - $max_(a in overline(A))$ returns the action in the dataset #pause
    - We will learn the behavior policy, not optimal policy #pause

*Solution:* Continuous relaxation of $overline(A)$ #pause

$ overline(A)(s) = {a |  pi (a | s; bold(theta)_beta) > rho} $ #pause

Only consider actions that our behavior policy might take #pause

We can learn $bold(theta)_beta$ using behavioral cloning



// How can we constrain Q?
    // BCQ - restrict actions to those in the dataset
    // CQL - penalize large out of distribution Q values

==
*Definition:* Batch Constrained Q Learning (BCQ) learns the behavior policy, only considers behavior policy actions in the TD update #pause

*Step 1:* Learn the behavior policy through BC #pause

$ bold(theta)_pi = argmin_(bold(theta)_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; bold(theta)_beta) log pi (a | s; bold(theta)_pi) $ #pause

*Step 2:* Learn the Q function #pause

$ bold(theta)_(Q, i + 1) &= argmin_(bold(theta)_(Q, i)) (Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q, i)) - y)^2 \  #pause
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(#redm[$a in overline(A)$]) Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i)) $

==

$ bold(theta)_(Q, i + 1) &= argmin_(bold(theta)_(Q, i)) (Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q, i)) - y)^2 \ 
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in overline(A)) Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i)) $ #pause

Constrain $overline(A)$ to contain actions the behavior policy would take #pause

$ overline(A) = {a | pi (a | s_1; bold(theta)_pi) > rho} $ #pause

where hyperparameter $rho$ determines the level of extrapolation #pause
- Bigger $rho$ means less extrapolation, less optimal #pause
- Smaller $rho$ means more extrapolation, more optimal #pause
- Too much extrapolation leads to deadly triad!

==
BCQ is a good algorithm, but it requires learning a policy using BC #pause

Can we do offline Q learning without learning the behavior policy? #pause

What if we make Q small for OOD actions? #pause

$ min_(a in.not overline(A)) Q(s, a) $ #pause

This still requires knowing $overline(A)$ and use BC #pause

Can we do this without knowing $overline(A)$?

==

*Solution:* Create two conflicting objectives: #pause
- Learn $Q$ as usual with TD error #pause
- Minimize $Q$ values #pause

*Key idea:* This should force all $Q(s, a)$ to be small, unless $(s, a) in bold(X)$ #pause


$ argmin_(bold(theta)_Q) space underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_Q), "Minimize Q") #pause  \

y = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in overline(A)) Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i)) $

==

$ argmin_(bold(theta)_Q) space underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_Q), "Minimize Q")  \

y = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i)) $

However, the scale of TD error and Q values can be different #pause

Very sensitive to scale, we might just set all $Q(s, a) = -oo$ #pause

We need to balance the second term a little better

==
$ argmin_(bold(theta)_Q) space underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_Q), "Minimize Q")  \

y = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i)) $ #pause

We can subtract $Q$ for the action we take in the dataset! #pause

$ argmin_(bold(theta)_Q) space underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_Q) - Q(s_1, a_1, bold(theta)_pi, bold(theta)_Q), "Minimize Q")
$

This balances the second term to be closer to zero

==
$ argmin_(bold(theta)_Q) space underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_Q) - Q(s_1, a_1, bold(theta)_pi, bold(theta)_Q), "Minimize Q")
$ #pause

While minimizing all $Q$ is useful, we care most about the biggest $Q$ #pause
 
We take $max Q$, so we should emphasize minimizing $max Q$ #pause

Replace sum with logsumexp, a combination of max and sum #pause

$ underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q)) - y)^2, "TD error") + underbrace(log(sum_(a in A) exp Q(s_1, a, bold(theta)_pi, bold(theta)_Q)) - Q(s_1, a_1, bold(theta)_pi, bold(theta)_Q), "Minimize Q")
$ 

==
*Definition:* Conservative Q Learning (CQL) learns a Q function that minimizes $Q$ for out of distribution actions

$ bold(theta)_(Q, i + 1) &= argmin_(bold(theta)_(Q, i))  underbrace((Q(s_0, a_0, bold(theta)_pi, bold(theta)_(Q, i)) - y)^2, "TD error") + z^2  \ #pause 
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i)) \ #pause
z &= underbrace((log sum_(a in A) exp Q(s_1, a, bold(theta)_pi, bold(theta)_(Q, i))), "Minimize Q for all" a) - underbrace(Q(s_1, a_1, bold(theta)_pi, bold(theta)_(Q, i)), "Push up Q for" \ "in-distribution" a_1) 
$

= Conclusion

==
Today, we looked at offline RL
- Like IL, but learns optimal policy instead of expert policy

Two standard approaches to offline RL #pause
- Behavioral cloning with weighted objectives #pause
    - EMRL
    - RWR 
    - MARWIL #pause
- Breaking the deadly triad with Q learning #pause
    - BCQ
    - CQL
*/