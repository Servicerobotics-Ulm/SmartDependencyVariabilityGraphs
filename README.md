# SmartDependencyVariabilityGraphs
This is a proof of concept implementation of a general method for variability management in service robotics based on separation of roles and composition which allows to model, compose and resolve variability of software building blocks.

The model-driven implementation in Eclipse allows users to describe via DSLs: 
1) Building blocks at different levels of abstraction, their variability entities and the decomposition relationships between building blocks.
2) Dependency Variability Graphs: The graph-based dependency relationships between variability entities (including their values by applying function composition).

Furthermore, it offers an implementation of the LISP-based DSL [SmartTCL](https://wiki.servicerobotik-ulm.de/about-smartsoft:robotic-behavior:smarttcl) with the Eclipse Modeling Tools. This allows to program concrete behavior for simulated or real robots in combination with the [SmartSoft Approach](https://wiki.servicerobotik-ulm.de/about-smartsoft:approach). 

![SmartDVG-2](https://user-images.githubusercontent.com/95618174/184313669-f6b2ac7e-745f-457a-bbca-5f195e153078.png)

A code generator is then able to generate a solver of such models that determines requirements-related and environmental-contextual variant bindings of building blocks. Requirements specified by the endusers of these building blocks can be constraints for specific properties of the model (a property is a special subtype of a variability entity) and/or preference specifications for modeled conflict of objectives between properties.  

# Installation
To try it out, you need to do the following:
1) Download and install Eclipse Modeling Tools 2022-06 (https://www.eclipse.org/downloads/packages/release/2022-06/r/eclipse-modeling-tools)
2) Start Eclipse
3) *Help*->*Install New Software* (*Xtext Complete SDK* and *Sirius Specifier Environment*)
4) Restart Eclipse
5) *Install New Software* -> *Add* -> *Archive* -> Select *SmartDependencyVariabilityGraphs.zip* in the *feature* folder -> *Add*
6) Unselect *Group items by category* -> Select *SmartDependencyVariabilityGraphs* -> *Next* -> *Next* -> Accept and *Finish*
7) Select *Unsigned* -> *Trust Selected* -> *Restart Now*
8) *Help*->*Check for Updates*->Make sure that all available updates are selected->*Next*->*Next*-> Accept and *Finish*
9) Select the *Type*s you need to trust -> *Trust Selected* -> *Restart Now*

# Usage
https://wiki.servicerobotik-ulm.de/sdvg:smartdependencyvariabilitygraphs
