With a stochastic policy gradient derivation, we sum (take expectation) over all possible actions for each timestep. While this makes sense in finite action spaces, it becomes quite intractable over large action spaces, because it requires a lot of samples to properly approximate the expectation. I propose to use the gradient of the transition function to reduce the number of terms needed to approximate the expected return, improving sample efficiency. 

To do this, we leverage the gradient information of the state transition function. The trick is to write the policy as deterministic, so we can leave the transition function inside the gradient operator. 

First, let's start by deriving the gradient of the expected return with respect to the policy gradient -- in other words, derive the policy gradient. You have likely seen this before, but I want to use my notation. Writing it in this manner is important for later.

$
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = nabla_(theta_pi) [sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) Pr(s_(n + 1) | s_0, theta_pi) ] 
$

Expand the transitition probabilities with the Markov property

$
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = nabla_(theta_pi) [sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n "Tr"(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ] 
$

Move $nabla$ inside

$
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ (product_(t=0)^n "Tr"(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)) ] 
$

Split products

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \ nabla_(theta_pi) [ (product_(t=0)^n "Tr"(s_(t+1) | s_t, a_t)) dot (product_(t=0)^n pi (a_t | s_t; theta_pi)) ] 
$

Move $nabla$ further inside 

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) sum_(a_0, dots, a_n in A) \  (product_(t=0)^n "Tr"(s_(t+1) | s_t, a_t)) dot nabla_(theta_pi) [(product_(t=0)^n pi (a_t | s_t; theta_pi)) ] 
$

We go on to use the log derivative trick and write the return gradient in terms of the sum of policy gradients, resulting in a high-variance score estimator. Thus, we are unable to use gradient information of the transition function when training our policy. Things change a bit if we consider a *deterministic* policy $mu$ and try and derive the policy gradient. 

David Silver derives a deterministic policy gradient in #link("https://proceedings.mlr.press/v32/silver14.pdf")[#text(fill: blue)[Deterministic Policy Gradients]]. However, by estimating the return with the Q function return, they do not need to write the transition function in the deterministic policy gradient. Instead, they use an objective like

$ nabla_(a_T)[Q(s_T, a_T) bar.v_(a_T = mu(s_T, theta_pi)) ] dot  nabla_(theta_pi)  [mu(s_T, theta_pi)] $


If we replace the Q function return estimate with the Monte Carlo return, then we *cannot* pull the transition function outside the gradient. Note we also no longer need to sum over all actions. 

Let us try and derive the policy gradient for a deterministic policy $mu$. I'll skip a couple steps since they are the same for the stochastic policy gradient above. Notice, in particular, that we no longer have to sum over all actions at each timestep in the trajectory, and that we place $mu$ inside of $"Tr"$.

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) nabla_(theta_pi) [ product_(t=0)^n "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) ] $

Perform the log-derivative trick

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) product_(t=0)^n "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) nabla_(theta_pi) [ sum_(t=0)^n log "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) ] $

Move $nabla$ in the sum

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) product_(t=0)^n "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) sum_(t=0)^n  nabla_(theta_pi) [ log "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) ] $

Using the chain rule, once for $log$, once for $"Tr"( dots, mu)$

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) product_(t=0)^n "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) sum_(t=0)^n (nabla_(a_t) "Tr"(s_(t+1) | s_t, a_t))/ "Tr"(s_(t+1) | s_t, a_t)   dot nabla_theta_pi mu(s_t, theta_pi) $

Now computing the gradient over an infinite sequence can cause some issues. We can generalize to the n-step return up to some horizon $T$ by introducing the Q function.



$ nabla_theta_pi bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =  sum_(n=0)^T gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot  sum_(s_1, dots, s_n in S) product_(t=0)^n "Tr"(s_(t+1) | s_t, mu(s_t, theta_pi)) \ ( sum_(t=0)^(T-1) (nabla_(a_t) "Tr"(s_(t+1) | s_t, a_t))/ "Tr"(s_(t+1) | s_t, a_t)   dot nabla_theta_pi mu(s_t, theta_pi)) + gamma^T (nabla_(a_T)[Q(s_T, a_T) bar.v_(a_T = mu(s_T, theta_pi)) ] dot  nabla_(theta_pi)  [mu(s_T, theta_pi)])  $

Then, we can just rewrite the first term as the expected return up until $T$

$ nabla_theta_pi bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =  bb(E)[cal(G)(bold(tau)_(T)) | s_0; theta_pi] \ ( sum_(t=0)^(T-1) (nabla_(a_t) "Tr"(s_(t+1) | s_t, a_t))/ "Tr"(s_(t+1) | s_t, a_t)   dot nabla_theta_pi mu(s_t, theta_pi)) + gamma^T (nabla_(a_T)[Q(s_T, a_T) bar.v_(a_T = mu(s_T, theta_pi)) ] dot  nabla_(theta_pi)  [mu(s_T, theta_pi)])  $

This formulation gives us a mix of sample efficiency and tractability. We rollout our transition model up to timestep $T$, provding policy gradients with much better sample efficiency than the usual score estimator in stochastic policy gradient or DDPG. Again, the trick is that we can see how our actions influence future states and rewards via the gradient of $"Tr"$.

On the other hand, we only need to compute transition model rollouts up to $T$. This is especially useful since transition model error grows quadratically, and $"Tr"$ becomes unreliable after a certain point anyways. At this point $T$, we can simply switch to the standard DPG/DDPG objective, which should be accurate over longer time periods.