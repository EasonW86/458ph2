# Project Criteria
The project phases you hand in will be expected to conform to a set of guidelines which will influence the way they are marked. The following general criteria will be used when marking the project, in approximately the indicated proportions.


### Documentation - 20%
Each phase should be handed in with external documentation in the form of a written report. The purpose of the report is to allow someone who is already familiar with the PT Pascal compiler to understand and use the modified program without looking at the modifications to the code. The documentation should include a description of the purpose of the modifications, a list of the changes made to the S/SL source, the&nbsp;specification of any semantic operations which were added or modified, a description of the changes to the token streams and an explanation of any new error signals.


### Structure and Clarity - 20%
Modifications should be implemented simply and cleanly and structured to make them as readable as possible. As much as possible, changes should be made in the S/SL rather than in the semantic mechanisms, and you should resist the temptation to add new semantic mechanisms. When necessary, modifications to semantic mechanisms should be consistent with the purpose and structure of the mechanism and fit cleanly into the PT implementation. Modifications should be carefully commented and use meaningful naming conventions consistent with the existing PT Pascal coding style.

### Testing and Correctness - 60%
You should demonstrate that your changes work using careful testing. With each phase you should hand in a suite of test input designed to demonstrate the (partial) correctness of the changes by forcing the phase through every new or modified logic path in the S/SL source for the phase at least once. The test suite should be accompanied by written comments indicating the purpose of each test input and an argument for the completeness of the suite based on coverage of every modified section of the program code.

### Project Weighting by Phase
Based on evaluations done by project teams of previous years after they had completed their projects, the workload for the project is split between the four phases in approximately the following proportions:

1. Scanner/Screener 15%
2. Parser 20%
3. Semantic Analysis 25%
4. Code Generation 25%

The calculation of the final project mark for each team will be weighted by phase based on these proportions. If the average proportion of effort reported by this class at the end of the course is significantly different from these proportions then I may adjust the weighting accordingly. The final 15% of the project mark will be from the self-evaluation of team members in each team at the end of the course.

E.G. 
```
Final project mark =  0.15 * scanner/screener mark + 
                      0.20 * parser mark + 
                      0.25 * semantic analysis mark + 
                      0.25 * code generator mark + 
                      0.15 * team evaluation mark
```