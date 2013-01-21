---
categories: brain, systems, computation
date: 2013/01/19 00:00:00
title: Speculative Execution in the Human Mind
subtitle: TBD
---

By analyzing brain signals of a person making a conscious decision, neuroscientists may have discovered evidence proving free will does not exist. Nature describes an experiment where people under fMRI scans were told to press a button with either their left or right finger after performing some task. By looking at brain activity in the fMRI scan, the researchers could predict, with 60% accuracy, which finger the subject will use to press the button <i>almost a full second</i> before the subject consciously decided which finger to move. When fMRI scans were replaced with electrodes implanted in the brain, the accuracy rose to 80%.

Does this show that our brains make decisions without any regard to our consciousness, essentially disproving free will? Do we really have conscious control of our actions and thoughts, or are we simply following a deterministic set of rules put forth at birth in the finite state machine we call our minds?

This first blog post won't try to answer these questions (that'll be for another time). Instead, this seemingly future-predicting brain activity will be explained as a possible analogy to a common optimization technique in computational systems (such as the brain): speculative execution.

<b>Computational Systems</b>

Computational systems - such as the microprocessor in your laptop, the MapReduce cluster running Google's search engine, or the brain inside your head - compute information by executing a series of tasks. These kinds of systems can be viewed abstractly as machines that take in input, execute some computational tasks on that input, and produce an output. The performance of the system is based on how many inputs can be processed in a given period of time. The faster it can process inputs and produce outputs, the faster the computational system.

Computational machines abstractly consist of individual computing elements that perform the computations; these are the machine's resources. A single computing element can process only one task at a time. Thus, having more computing elements (more resources) is one way to make a computational system faster, since more tasks can be processed simultaneously.

Now let's try to better understand what these "tasks" are. For computer processors, each line of a program can be thought of as an individual task (in reality that program is turned into assembly, and each assembly instruction is one task, but we're in the land of abstract thought). For MapReduce clusters, each "job" can be thought of as one task. For our brains, each functional action it performs can be thought of as one task (more on this later).

<b>Executing independent tasks</b>

Let’s look at the simple computer program below, which contains 4 independent tasks.

$$code(lang=python)
1	w = f(a)
2	x = f(b)
3	y = f(c)
4	z = f(d)
$$/code

Say we have one system with 1 computing element and another with 4 computing elements, and a single computing element can process 1 task per second. How long would these two systems take to run the program above? Since the first system can only process 1 task at a time, the 4 tasks will run sequentially and take 4 seconds total. The second system can utilize all 4 of its computing elements at once; by running all 4 tasks in parallel, the program will finish in only 1 second. By having 4x as many computing elements, we gain a 4x increase in speed!  This is why there has been a trend of increasing number of cores in microprocessors.

<b>Executing dependent tasks</b>

Now let’s look at the following program (the inputs to the functions have changed):

$$code(lang=python)
1	w = f(a)
2	x = f(w)
3	y = f(x)
4	z = f(y)
$$/code

How fast will this program run on our two systems? Is the second system still 4x faster than the first? Unfortunately, no. Task 4 relies on the output produced by task 3. Task 3 relies on the output produced by task 2. And task 2 relies on the output produced by task 1. Therefore, task 4 can't run until task 3 finishes, which can't run until task 2 finishes, which can't run until task 1 finishes. No matter how many computing elements in the system, no more than one can be utilized at a time; the other resources simply sit idle. Thus, if a workload consists of many dependent tasks then all of the system's resources will not be fully utilized during overall execution. 4 times more resources will not lead to 4 times faster speed.

<b>Speculative Execution to the rescue</b>

Speculative execution attempts to optimize for dependent tasks. To keep resources utilized, the system takes a sort of gamble. In the previous code example, if the value of variable w was known ahead of time, then task 2 could run on another computing element while task 1 is still being processed. Unfortunately there's no way to know what task 1 will output ahead of time; computational systems cannot predict the future. Instead, the system makes a "speculative guess" as to what task 1 will output and executes task 2 with that guess as the input. 

What if the guess is wrong? Once task 1 completes the system will realize its speculative input to task 2 is incorrect. Task 2 is simply repeated with the right input. Since task 2 was going to be processed after task 1 anyways, nothing is lost by speculating wrong and attempting to execute task 2 early (except the cost of power).

What if the guess is right? When task 1 is finished, then the system already has the answer to task 2! The system can then continue on to task 3 immediately after task 1, and the overall execution time of the program will be lower than if the 4 tasks were executed sequentially.

<b>Another example</b>

In the previous example, it's very hard to speculate the value of an integer (there's so many possibilities!). A more common speculation is branch prediction - guessing if the code in an "IF" statement should be executed. Let’s look at the following code:

$$code(lang=python)
1	x = f(a)  # takes a very long time
2	if x:
3		do task 3
4	else:
5		do task 5
6	more code...
$$/code

If variable x is true, then task 3 should be executed. If x is false, then task 5 should be executed. Task 1, which outputs variable x, takes a <i>very long time</i>. Instead of keeping the entire system idle while task 1 runs, the system can speculate x and utilize its idle resources to run either task 3 or task 5. Since x can only take 2 values, it is much easier to predict than an integer.

Once x is computed, the system will know if the guess was right or not. If it was right, then the system can simply continue, and it effectively utilized its computing elements to execute tasks in parallel and achieve a speed optimization. If the guess is wrong, then the running task (task 3 or task 5) is immediately stopped and the machine's state returns to as if nothing speculative was run. 

Unfortunately there is a cost to do this "wrong guess correction". However, since the resources would have been idle regardless and there is a large gain for a correct guess, doing speculative execution should overall yield a faster system.

<b>Speculative Execution in the free will experiment</b>

A brain is very different than a computer. A CPU core is meant to execute lines of code sequentially, while brains are extremely parallelized systems that we do not fully understand. Having said that, the brain can be abstractly thought of as a computational system with <i>a lot</i> of computing elements. This abstraction could deem each functional unit of the brain as a computing element (the hippocampus, the motor cortex, etc). Or, each individual neuron can be thought of as a computing element. Regardless, making some sort of abstraction allows the following interpretation of the original free will experiment:

$$code(lang=python)
1	finger_to_move = pick_some_finger_to_move()  // takes a long time
2	if finger_to_move == left_index:
3		move_left_index_finger()
4	else:
5		move_right_index_finger()
6	more brain functions...
$$/code

This is the same type of computation we analyzed in the previous example. Previously, while task 1 was being executed, either task 3 or task 5 would speculatively start; if it picked wrong, then the other would start. This could be happening in our brains as we make conscious decisions to move. The motor cortex could speculatively begin to fire neurons anticipating moving the left finger. If the consciousness ends up choosing the other finger, then the brain simply corrects the error and ends up moving the right finger. If it guessed right, then time and brain power are saved. If it guessed wrong, oh well.

I believe that computation is a fundamental part of the universe. The idea of parallel computing elements, dependent tasks, and speculative execution were not invented by engineers - they were discovered. These concepts exist in the universe just like the air we breathe and water we drink. If us humans were able to discover the optimization of speculative execution, then I think it's perfectly feasible to think evolution could have discovered the same thing. What this means for free will, I don't know.