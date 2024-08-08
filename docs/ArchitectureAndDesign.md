
## Architecture and Design
The architecture of a software system encompasses the set of key decisions about its overall organization. 

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them. 

In this section you should start by briefly describing the overall components of the project and their interrelations. You should also describe how you solved typical problems you may have encountered, pointing to well-known architectural and design patterns, if applicable.

### Logical architecture
The purpose of this subsection is to document the high-level logical structure of the code (Logical View), using a UML diagram with logical packages, without the worry of allocating to components, processes or machines.

It can be beneficial to present the system both in a horizontal or vertical decomposition:
* horizontal decomposition may define layers and implementation concepts, such as the user interface, business logic and concepts; 
* vertical decomposition can define a hierarchy of subsystems that cover all layers of implementation.

![image](https://user-images.githubusercontent.com/97168603/225685256-aa8afec9-83ab-4043-a70a-642a5f2d0239.png)

### Physical architecture
The goal of this subsection is to document the high-level physical structure of the software system (machines, connections, software components installed, and their dependencies) using UML deployment diagrams (Deployment View) or component diagrams (Implementation View), separate or integrated, showing the physical structure of the system.

It should describe also the technologies considered and justify the selections made. Examples of technologies relevant for uni4all are, for example, frameworks for mobile applications (such as Flutter).

![physical_arch](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/images/Physical_Arch.png)

- Mobile Device: User device;
- Wikipedia's Service Machine: Wikipedia API;
- Email Service Machine: Email API;
- Backend Server: Server to store the app's data;
- App(Wiki Discuss): Installed in users Mobile device;

### Vertical prototype

 <pre>    Initial Screen              Login                     Register                   Perfil                      Demo </pre> 
 <img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/images/Mockups/Init_0.png" width=180px>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/images/Mockups/Login_0.png" width=180px>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/images/Mockups/Register_0.png" width=180px>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/images/Mockups/Perfil_0.png" width=180px>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/images/Mockups/Demo_0.gif" width=180px>


* Was implemented layout of 3 screens using flutter. The [.apk](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T4/blob/master/docs/app-release.apk) file. 


To help on validating all the architectural, design and technological decisions made, we usually implement a vertical prototype, a thin vertical slice of the system.

In this subsection please describe which feature you have implemented, and how, together with a snapshot of the user interface, if applicable.

At this phase, instead of a complete user story, you can simply implement a feature that demonstrates thay you can use the technology, for example, show a screen with the app credits (name and authors).

