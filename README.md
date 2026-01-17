# Godot Bite Sized - World 2D
This repo represents the Godot Bite Sized World - 2D. What is a Bite Sized World - 2D, you might ask? The world object is the game world object being created under my (Godot Bite Sized content series)[https://github.com/timjbruce/godotbitesized]. In this series, I take a 5-10 lesson and make something concrete for developers to follow along / learn about Godot. Second, it is the 2D World object that will be used in games that I create. While most of the items in this series are components that can be re-used within many games. This one, however, is not something that I've componentized - maybe one day!

## Build 1
**Build 1 is in Godot 4.5.1**

Build 1 of the World is going to be similar to Build 1 of the Player - _very basic_. This is about a 4 minute project, minus the reading. It's going to contain a world scene and a script that is used to handle global requirements. We'll also copy the Player Build 1 component into this world to see how the two interact. As a note, we're going to paint the player in for this first build. In future builds, we're going to instantiate. Why? I'm keeping the lessons short and sweet so we can see progress and move things along.

At the end of this build, your Scene and FileSystem windows will look like this and you'll have a player moving around in a world!

![Here's what your final scene, with the World built out, and FileSystem winodws should look like](readmeassets/build_1/1_final_scene_and_filesystem.png)

Now, let's start!

The first thing we're going to do is in the scene window, and select the 2D Scene object under "Create Root Node."

![Create the world node by clicking the 2D Scene option under Create Root Node](readmeassets/build_1/1_create_world_node.png)

Double Click on the "Node2D" in your Scene window and rename it "World," like so.

![Rename the root node to World](readmeassets/build_1/1_rename_node_world.png)

Now, we're going to add a timer node to the world scene. We don't have a use for the timer as of yet, but I like to add one if I know I'm going to use it (**hint:** we will!). After you add it, double click the Timer and rename it "GlobalTimer." Your scene should look like this.

![GlobalTimer is added to the world scene](readmeassets/build_1/1_global_timer_added.png)

Now, let's save the scene. We're going to create a folder under the project called "World" first. This is used to keep all the assets for the world in one directory, so we can add in our other components over time and not have any overlap. Your FileSystem window will look similar to this, without the "readmeassets" folder (unless you cloned this repo!).

![World scene is saved and is ready for use](readmeassets/build_1/1_world_scene_saved.png)

Next, copy the "Player" folder from our Player project into the project. You'll need to do this in Explorer, Command Prompt, Finder, whatever on your system. When you expand "Player" folder, your FileSystem window should look like this.

![The player component is added to the project](readmeassets/build_1/1_player_added_to_project.png)

Now, we will select the "Player.tscn" file (the `Player` scene) from the FileSystem and drag it up to the `World` node in the `World Scene` window. This will drop the "Player" component into the world and make it a child of the `World` node.

![Drag the Player scene to the World node to add it to the World scene](readmeassets/build_1/1_drag_player_to_world.png)

Finally, we need to repeat some steps from the "Player" build to add the input map for the project so we can test this. Let's take care of the input map!

Open the Project Settings dialog by selecting the "Project -> Project Settings..." menu. Click on the "Input Map" tab so we can add new actions. We're going to add actions to move the player "up," "down," "left," and "right" using the arrow keys (or WASD, if you want) and left joystick controller (if you don't have a controller, you can skip this part). Here are the steps for "up" and you can repeat these for the other directions.

Type in "up" for the action and click on the +Add button. This will add the "up" action to the Input Map.

![The up action needs to be added to the input map for the game. This will allow the game to receive named inputs from the player](readmeassets/build_1/1_add_up_input_map.png)

Next, click the "+" next to "up" to open a dialog to add events that can trigger "up" to occur. This dialog box listens for input, making it easy to add the keys. Press the up arrow or W key to add it

![Next you define what inputs map to this named game input. We will add the up arrow and joystick up](readmeassets/build_1/1_add_arrow_up_event_to_up.png)

Click the "+" again and now press the left joystick on your controller up to assign it to up, as well

![Now the up event has two inputs mapped to it, up arrow and joystick up](readmeassets/build_1/1_add_joystick_up_event.png)

Repeat this process for "down," "left," and "right." The final output should look like this:

![Up, Down, Left, and Right events are now mapped to input events](readmeassets/build_1/1_all_inputs_mapped.png)

Click the "Close" button to return to the project.

Finally, we're going to add a bit of code to this solution. We're going to create a `Globals` script that will, initially, be pretty sparse. The `Globals` script will eventually allow us to track the different objects with simpler names. It will also allow us to listen for signals that we will be using. In future builds, we aren't going to "paint" objects in. We might want different numbers of enemies. When enemies die, they might drop loot. All of these dynamic items can be hard to track when an object is ready for other objects to subscribe to signals. We're not quite at the point to worry about this functionality, but we want to setup the framework that allows us to manage it now.

You might be asking why do this in a script instead of the `World` node. My simple answer is that this script can be available from all over. There might be a case where you want to do something that doesn't fall within the scope of the `World` node. This separation gives a lot more flexibility should that need arise and saves time from refactoring down the road.

We're going to start by creating a new folder under the `World` folder called `Scripts`. Right click on "World" in the FileSystem, choose "Create New" and  "Folder,"  set the name of the new folder to "Scripts," and click "OK." Your FileSystem window should look like this at the end.

![Add a scripts folder to the World directory in your FileSystem](readmeassets/build_1/1_scripts_folder_added.png)

Next, we'll add the script. Right click on the `Scripts` folder in the FileSystem window, choose "Create New" and "Script," change the name to `Globals.gd`, and click "Create." Your FileSystem window should look like the below.

![Global script is now created](readmeassets/build_1/1_global_script_created.png)

Double-click the script to open it up and copy the following code into the file and save it. You'll note that we're just using it, initially, to capture the nodes for `World`, `GlobalTimer`, and `Player`. These shortcuts allow us to access the objects using a notation of `Globals.object` instead of the `$Tree` notation. This can make a lot of work easier in the future. I know I could have accessed the variables directly in setting these values, but I prefer using setters instead of setting values directly, just in case there is some specific logic I want to see in the setting/storing of a variable. 

```
extends Node

var world: Node2D
var player: player_2d_body
var global_timer: Timer


func set_world(inc_world: Node2D) -> void:
	world = inc_world
	
func set_player(inc_player: player_2d_body) -> void:
	player = inc_player
	
func set_global_timer(inc_timer: Timer) -> void:
	global_timer = inc_timer
```

Now that we have a `Globals` script, we need to add it to the project so that we can access it as such. Select the "Project," "Project Settings" menu. Once there, click on the "Globals" tab. Type `res://World/Scripts/Globals.gd` in the "Path" field and make sure `Globals` is in the "Node Name" field. Click the "+Add" button and the script should be added to the window like so.

![Global script is now added to the project and can be used](readmeassets/build_1/1_globals_added.png)

Click on "Close" to return to the project.

Last step before we test! We're going to add a small script to the `World` node to use the Globals script. This isn't necessary at this step, but let's do this to make sure the Globals works.

In the "Scene" window, make sure the `World` node is selected and click the "Add new script" button.

![Global script is now added to the project and can be used](readmeassets/build_1/1_add_script_to_world_node.png)

Click the "Create" button and the code editor should open the `world.gd` script in the code editor. We're going to use the simple code below to just set the variables that we created in the `Globals` area with the set_x commands. Paste this code into the world.gd file and save it.

```
extends Node2D

func _ready() -> void:
	Globals.set_world($".")
	Globals.set_player($Player)
	Globals.set_global_timer($GlobalTimer)
```

Now we're going to press F5 to run the game. Since we haven't selected a main scene yet, Godot will ask for the main scene. You should have the "World" scene open right now, so you can click on "Select Current." If you do not have it open, click on the "Select" button, navigate to the "world.tscn" file in your project, and click "Open."

Your window should now have the "World" scene running in your game and you should see a Player idle in the game. Just like with the "Player Build 1" project, you won't see the player move around as you use the keys or joystick due to the camera. You can override this setting by clicking the "Override the in-game camera" button. Because there is no game world for this component, your Player is allowed to move off the screen and back onto it!

![Use the override the in-game camera to watch your player move around, and off, the screen](readmeassets/build_1/1_override_camera.png)

Happy Building and I'll see you for the next component build!