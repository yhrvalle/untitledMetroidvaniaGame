# untitled metroidvania game

## Introduction 
this is my first project in godot and i pretend to use 100% gdscript, i dont really like
python and its syntax but ill bear with it. 
<br> I already have some experience in game develpment and coding with c# and java.

## Objective
- learn about the engine itself
- follow this [game architecuture](https://www.gdquest.com/library/modular_game_architecture/)
	-   consists in building a moduler game that follows this folder strucuture:
```bash
├── res://
│   ├── addons/
│   ├── content/
│   ├── ui/
│   ├── gyms/
│   └── systems/
└──
```
- basically:
	- addons: reusable code libraries should be independent from the game core code(probably not going to lmao)
	- systems: game core rule, should be independent from ui and specific game content
	- ui: only receive and display data, dont modify game state or game logic
	- content: quests, dialogue, levels, characters, and all the associated scripts (content uses systems, systems use libraries, UI uses systems, but nothing else depends on content)
	- gyms: member gets their own subfolder where they can experiment, code prototypes, and test ideas without following any conventions (this folder should be excluded from game builds)

> "After every change, the CI runs and checks naming conventions, performance and memory benchmarks, and structural rules like "no code outside of gyms can reference code inside gyms." If it fails, you need to adjust your work to pass."

- learn how to juiceee (vfx, shaders, lightnign)
- ci/cd in game dev

## Convention
- basically everything is snake_case besides node and classes (enum is Pascal and CONSTANT_CASE)

| file        | class      | node        |
|-------------|------------|-------------|
| snake_case  | PascalCase | PascalCase  |


