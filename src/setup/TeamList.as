package setup
{
	import flash.display.*;
	import flash.events.*
	import com.whirled.net.MessageReceivedEvent; 
	import com.whirled.net.PropertyChangedEvent;
	import com.whirled.game.OccupantChangedEvent;
	import constants;
	import game.accessPoints.GameInformation;
	
	public class TeamList extends Sprite
	{
		/* GUI Items */
		private var titleBox :Array;
		private var textBoxes :Array;
		private var shipImages :Array;
		private var whiteBoxes :Array;
		
		/* Control vars */
		private var curX :int;
		private var curY :int;
		
		/** Makes sure nothing gets rendered before all tables are initialised */
		private var initialised :Boolean;
		
		/* Tables */
		private var shipTypeList :Object;
		private var jobberLevelList :Object;
		private var readyStateList :Object;
				
		/* Selected Properties */
		
		public function TeamList()
		{	
			initialise();
			
			GameInformation.addEventListener(PropertyChangedEvent.PROPERTY_CHANGED, propertyChanged);	
			if(GameInformation.amInControl())
			{
				var ids = GameInformation.getPlayerIds();
				var table = new Object();
				var table2 = new Object();
				var table3 = new Object();
				for(var i = 0; i < ids.length; i++)
				{
					table[i] = "Frig";
					table2[i] = "Elite";
					table3[i] = false;
				}
				GameInformation.shipTypeTable = table;
				GameInformation.jobberLevelTable = table2;
				GameInformation.readyStateTable = table3;
				GameInformation.teamOneTable = new Array();
				GameInformation.teamTwoTable = new Array();
				GameInformation.spectatorTable = GameInformation.getPlayerIds();
				
				GameInformation.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceived);
				GameInformation.addEventListener(OccupantChangedEvent.OCCUPANT_LEFT, occupantLeft);
			}
			else
			{
				//Forces the client to wait for all the tables to be changed by the host
				GameInformation.addEventListener(OccupantChangedEvent.OCCUPANT_LEFT, disable);
				GameInformation.addEventListener(OccupantChangedEvent.OCCUPANT_ENTERED, disable);
			}
					
			initialised = false; //Independent of the initialise() function, it detects if the tables have
								 //been initialised
			
						
			/* the render function is called once the tables are all set */
			
		}
		
		/**
		Renders the menus onto the screen when it is called.
		*/
		public function render()
		{
			clearScreen();
			initialise();
			
			curX = 0;
			curY = 0;
			
			var spectatorList = GameInformation.spectatorTable;
			var teamOneList = GameInformation.teamOneTable;
			var teamTwoList = GameInformation.teamTwoTable;
			
			shipTypeList = GameInformation.shipTypeTable;
			jobberLevelList = GameInformation.jobberLevelTable;
			readyStateList = GameInformation.readyStateTable;
			
			//Add the spectator box
			titleBox[0] = new TitleBox("Spectators");
			curY += 18; //size of the spectator box
			
			
			/* do the spectator related functions here */
			drawSection(spectatorList);
			
			
			curY += 4; //Space between the sections
			curX = 0;
			
			//Add the team one box
			titleBox[1] = new TitleBox("Team One");
			titleBox[1].y = curY;
			curY += 18; //size of the team one box
			
			/* do the team one related functions here */
			drawSection(teamOneList);
			
			curY += 4; //Space between the sections
			curX = 0;
			
			//Add the team two box
			titleBox[2] = new TitleBox("Team Two");
			titleBox[2].y = curY;			
			curY += 18; //size of the team two box
			
			
			/* do the team two related functions here */
			drawSection(teamTwoList);
			
			curY += 4; //Space between the sections
			curX = 0;
			
			//Add all the listners and add to the stage
			for(var i = 0; i < 3; i++)
			{
				titleBox[i].joinButton.addEventListener(MouseEvent.CLICK, joinTeam);
				addChild(titleBox[i]);			
			}
		}
		
		/**
		Takes an array from render and draws it on the screen
		*/
		private function drawSection(idArray:Array)
		{
			for(var i = 0; i < idArray.length; i++)
				{
					textBoxes.push(new TextBox(
											   GameInformation.getOccupantName(idArray[i])
											   )
								   );
					textBoxes[textBoxes.length - 1].x = curX;
					textBoxes[textBoxes.length - 1].y = curY;
					addChild(textBoxes[textBoxes.length - 1]);
										
					var pos = GameInformation.getPlayerPosition(idArray[i]);
					whiteBoxes.push(new WhiteBox(jobberLevelList[pos], readyStateList[pos]));
					whiteBoxes[whiteBoxes.length - 1].y = curY + 18;
					whiteBoxes[whiteBoxes.length - 1].x = curX;
					
					switch(shipTypeList[pos])
					{
						case "Sloop": 
							shipImages.push(new SloopMC());
							break;
						case "Brig": 
							shipImages.push(new WarBrigMC());
							break;
						case "Frig": 
							shipImages.push(new WarFrigateMC());
							break;
					}
					shipImages[shipImages.length - 1].x = curX + 5;
					shipImages[shipImages.length - 1].y = curY + 19; 
					
					addChild(whiteBoxes[whiteBoxes.length - 1]);
					addChild(shipImages[shipImages.length - 1]);
					
										
					curX += 130;
					if(curX > 650)
					{
						curX = 0;
						curY += 50;
					}
					
				}
				
				if(idArray.length > 0)
				{
					curY += 50;
				}
				else
				{
					textBoxes.push(new TextBox("Empty"));
					textBoxes[textBoxes.length - 1].y = curY;
					addChild(textBoxes[textBoxes.length - 1]);
					curY += 20;
				}
		}
		
		
		/**
		Removes all the items from the screen, called when an option is changed and the
		screen needs to be re-rendered.
		*/
		private function clearScreen()
		{
			for(var i = 0; i < titleBox.length ; i++)
			{
				if(titleBox[i] != null)
				removeChild(titleBox[i]);
			}			
			for(i = 0; i < textBoxes.length; i++)
			{
				removeChild(textBoxes[i]);
			}			
			//For every ship image there will always be a white box
			for(i = 0; i < shipImages.length; i++)
			{
				removeChild(shipImages[i]);
				removeChild(whiteBoxes[i]);
			}
		}
		
		/**
		Initialises all the arrays
		*/
		private function initialise()
		{
			titleBox = new Array(3);
			textBoxes = new Array();
			shipImages = new Array();
			whiteBoxes = new Array();			
		}
		
		private function joinTeam(evt:Event)
		{
			var team:uint;
			switch(evt.target)
			{
				case titleBox[0].joinButton : team = 0;
				break;
				case titleBox[1].joinButton : team = 1;
				break;
				case titleBox[2].joinButton: team = 2;
				break;
			}
			var msg = new Object();
			msg[0] = GameInformation.myId;
			msg[1] = team;
			GameInformation.sendMessage (constants.CHANGE_TEAM, msg);

		}
		
		public function occupantLeft(evt:OccupantChangedEvent)
		{
			initialised = false;
			//grab all of the tables and add an entry for this new player 
			var table;
			var id = evt.occupantId;
			var seat = GameInformation.getPlayerPosition(id);
			table = GameInformation.shipTypeTable;
			table[seat] = null;
			GameInformation.shipTypeTable = table;
			
			table = GameInformation.jobberLevelTable;
			table[seat] = null;
			GameInformation.jobberLevelTable = table;
			
			table = GameInformation.readyStateTable;
			table[seat] = null;
			GameInformation.readyStateTable = table;
			
			var tableArray:Object;
			var newArray = new Array();
			
			tableArray = GameInformation.teamOneTable;
			for(var i = 0; i < tableArray.length; i++)
			{
				if(tableArray[i] != id)
				newArray.push(tableArray[i]);
			}
			GameInformation.teamOneTable = newArray;
			newArray = new Array();
			
			tableArray = GameInformation.teamTwoTable;
			for(i = 0; i < tableArray.length; i++)
			{
				if(tableArray[i] != id)
				newArray.push(tableArray[i]);
			}
			GameInformation.teamTwoTable = newArray;
			newArray = new Array();
			
			tableArray = GameInformation.spectatorTable;
			for(i = 0; i < tableArray.length; i++)
			{
				if(tableArray[i] != id)
				newArray.push(tableArray[i]);
			}
			GameInformation.spectatorTable = newArray;
		}
		
		public function disable(evt:Event)
		{
			initialised = false;
		}
		
		/** Respond to messages from other clients. */
		protected function messageReceived (evt :MessageReceivedEvent) :void
		{
			if(GameInformation.amInControl())
			{
				var table;
				/* Setup screen messages */
				if(evt.name == constants.CHANGE_TEAM)
				{
					var id = evt.value[0];
					var team = evt.value[1];
					
					var spectatorList = GameInformation.spectatorTable;
					var teamOneList = GameInformation.teamOneTable;
					var teamTwoList = GameInformation.teamTwoTable;
					
					var newSpectatorList = new Array();
					var newTeamOneList = new Array();
					var newTeamTwoList = new Array();
					
					
					//Iterate through the tables and remove the id
					for(var i = 0; i < spectatorList.length; i++)
					{
						if(spectatorList[i] != id)
						newSpectatorList.push(spectatorList[i]);						
					}
					for(i = 0; i < teamOneList.length; i++)
					{
						if(teamOneList[i] != id)
						newTeamOneList.push(teamOneList[i]);						
					}
					for(i = 0; i < teamTwoList.length; i++)
					{
						if(teamTwoList[i] != id)
						newTeamTwoList.push(teamTwoList[i]);						
					}
					
					//Add the id to the relevant list
					switch(team)
					{
						case 0: newSpectatorList.push(id); break;
						case 1: newTeamOneList.push(id); break;
						case 2: newTeamTwoList.push(id); break;
					}
					
					//Put the lists back					
					GameInformation.teamOneTable = newTeamOneList;
					GameInformation.teamTwoTable = newTeamTwoList;
					GameInformation.spectatorTable = newSpectatorList;
				}
				else if(evt.name == constants.CHANGE_SHIP)
				{
					table = GameInformation.shipTypeTable;
					table[evt.value[0]] = evt.value[1];
					GameInformation.shipTypeTable = table;
				}
				else if(evt.name == constants.CHANGE_JOBBER_LEVEL)
				{
					table = GameInformation.jobberLevelTable;
					table[evt.value[0]] = evt.value[1];
					GameInformation.jobberLevelTable = table;
				}
				else if(evt.name == constants.CHANGE_READY)
				{
					table = GameInformation.readyStateTable;
					table[evt.value[0]] = evt.value[1];
					GameInformation.readyStateTable = table;
				}
				
			}
		}

		/** Responds to property changes. */
		protected function propertyChanged (event :PropertyChangedEvent) :void
		{
			/* Setup screen properties */
			//All three tables are upated at once, spectator table always being last
			//therefore there is no need to listen for the other two
			if(event.name == constants.SPECTATOR_TABLE 
			   || event.name == constants.SHIP_TYPE_TABLE && initialised
			   || event.name == constants.JOBBER_LEVEL_TABLE && initialised
			   || event.name == constants.READY_STATE_TABLE && initialised) 
			{
				render();
				initialised = true;
				if(GameInformation.amInControl() && event.name == constants.READY_STATE_TABLE)
				{
					//Check to see if everyone is ready
					var players = GameInformation.getPlayerIds();
					var readyTable = GameInformation.readyStateTable;
					var allReady = true;
					
					for(var i = 0; i < players.length; i++)
					{
						if(!readyTable[i])
						allReady = false;
					}					
					
					if(allReady)
					GameInformation.sendMessage(constants.START_GAME); //gets handled in main
				}
			}
		}
		
		protected function handleUnload (event :Event) :void
		{
			// Not sure if this is even being called
			// Unload anything on whirled such as event handlers, don't see any problems occuring because of this though
		}
	}
}