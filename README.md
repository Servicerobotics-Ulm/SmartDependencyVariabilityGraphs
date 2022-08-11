# SmartDependencyVariabilityGraphs
This is a proof of concept implementation of a general method for variability management in service robotics based on Dependency Variability Graphs which allows to model, compose and resolve variability of software building blocks.

The model-driven implementation allows users to describe via DSLs: 
1) Building blocks at different levels of abstraction, their variability entities and the decomposition relationships between building blocks.
2) The graph-based dependency relationship between variability entities (including their values by applying function composition).

A code generator is then able to generate a solver of such models that determines requirements-related and environmental-contextual variant bindings of building blocks. Requirements specified by the endusers of these building blocks can be constraints for specific properties of the model (a property is a special subtype of a variability entity) and/or preference specifications for modeled conflict of objectives between properties.  

# Installation
To try it out, you need to do the following:
1) Download and install Eclipse Modeling Tools (https://www.eclipse.org/downloads/packages/release/2022-06/r/eclipse-modeling-tools)
2) Start Eclipse
3) *Install New Software* (*Xtext Complete SDK*, *Sirius Specifier Environment*, *Sirius Properties Views - Specifier Support*)
4) Restart Eclipse
5) *Install New Software* -> *Add* -> *Archive* -> Select *SmartDependencyVariabilityGraphs.zip* in the *feature* folder -> *Add*
6) Unselect *Group items by category* -> Select *SmartDependencyVariabilityGraphs* -> *Next* -> *Next* -> Accept and *Finish*
7) Select *Unsigned* -> *Trust Selected* -> *Restart Now*
