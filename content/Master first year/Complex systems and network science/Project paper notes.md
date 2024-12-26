# Guide points
1. model description
2. significant design decisions/extensions
3. experiments methodology and results, comparison to other models
5. tipping points
6. equilibrium states

# 2 baseline model
The first proposed model implements all basic behaviours present in subsequent models, with slight differences. This environment generates a set of fishes and dolphin around a 2D space where they're free to move.
The fish agents have a set of rules for:
- Roaming: the fish moves in a random direction.
- Fleeing: the fish flees in the direction opposite to the predator when it sees it. If multiple predator are near the fish, it flees in the direction opposite to the nearest predator.
- Reproducing: the fish can spawn another fish in an adjacent position after a fixed set of time.
The dolphin agents have a set of rules for:
- Roaming: the dolphin moves in a random direction.
- Hunting: the dolphin chase in the direction of a fish when it sees it. If multiple fishes are in the range of vision of the dolphins, it chase the nearest.
- Eat: the dolphin eat the fish when it reaches its position, removing the target agent from the simulation.
For a coding base, i used the [Wolf Sheep Predation meh](http://ccl.northwestern.edu/netlogo/models/community/Wolf Sheep Predation meh) by dj| model present in the NetLogo library. 

## 2.1 Significant design decisions and extensions
Fishes and dolphins have their own separate parameters for speed and vision range, while another parameter exclusive to fishes is the reproduction rate, expressed in ticks. Fish reproduction can be turned off with the apposite switch.
Dolphins are only allowed to eat fishes if and only if they're in the same space as their prey. This is a result of the reference model i used, where wolves would eat sheep following the same condition.
This led to giving the dolphins the ability to adjust their velocity to catch fishes if they're close than their current velocity, as otherwise they might get stuck in a back and forth exchange where the dolphin never reaches the fish for any speed difference greater than 0.

## 2.2 Methodology and results
Research was conducted to find under what conditions and limits the network is in a state of equilibrium, while still being able to predict where the fishes or the dolphins would dominate the environment.
That is, at what point do the survivability of fishes exceeds the dolphin hunting effectiveness, and thus we'll see an increase in the population? at what point the population growth will be equal to the lost fishes?
A proper state of equilibrium was not achieved during the tests because of the inconsistency of the dolphin's time to eat a given amount of fishes. Instead, every parameter was tested in a neutral environment (no advantage to fishes nor dolphins) to see how the changes affected the given statistics. Interest was particularly given to the number of ticks in the simulation before the fishes got extincts.
### 2.2.1 Number of Fishes and Dolphins
First off, the number of fishes in the simulation was estimated to increase the lifespan of the simulation at a directly proportional exponential increase.
The number of fishes affected the length of the simulation as predicted, but only when fish reproduction was enabled: without it, the increase was linear, as dolphins can eat one fish at a time. It makes sense that eating more fishes would require more time.
Here some results of the experiments:



The number of dolphins would then, logically, not be linear, as a dolphin can eat more fishes, but a fish cannot be eaten more than once. Each dolphin is responsible to a percentage of fishes eaten, while each fish is responsible only for itself to be eaten. The expected outcome of the variance in number of ticks
