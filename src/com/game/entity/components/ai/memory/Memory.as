package com.game.entity.components.ai.memory 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Memory 
	{
		public var active:Boolean;
		
		private var _timeToNextStateUpdate:int;
		private var _stateUpdateDelay:int;
		private var _noteLiveTime:int;
		
		private var _notesList:Vector.<Note>;
		private var _notesDict:Dictionary
		private var _noteGroupsDict:Dictionary;
		
		
		
		public function Memory() 
		{
			
			_notesList = new Vector.<Note>();
			_notesDict = new Dictionary();
			_noteGroupsDict = new Dictionary();
		}
		public function init(cogitationTime:int,rememberTime:int):void
		{
			_stateUpdateDelay = cogitationTime;
			_noteLiveTime = rememberTime;
			invalidateState();
		}
		public function advanceCogitation(dt:int):void
		{
			_timeToNextStateUpdate-= dt;
		}
		
		public function stateUpdateRequires():Boolean
		{
			var result:Boolean = ((active)&&(_timeToNextStateUpdate <= 0));
			return result;
		}
		public function markAsUpdated():void
		{
			_timeToNextStateUpdate = _stateUpdateDelay;
		}
		public function invalidateState():void
		{
			_timeToNextStateUpdate = 0;
		}
		
		public function addNote(type:int, targetID:int):Note
		{
			var result:Note = new Note();
			result.type = type;
			result.targetID = targetID;
			result.rememberTime = _noteLiveTime;
			result.forgoten = true;
			
			_notesDict[result.targetID] = result;
			var group:Vector.<Note>;
			if (!_noteGroupsDict[type]) {
				group = new Vector.<Note>();
				_noteGroupsDict[type] = group;
			}
			group = _noteGroupsDict[type];
			group.push(result);
			
			
			return result;
		}
		public function getNoteByTargetID(targetID:int):Note
		{
			var result:Note = _notesDict[targetID] as Note;
			return result;
			
		}
		public function getNotesByType(noteType:int):Vector.<Note>
		{
			var result:Vector.<Note> = _noteGroupsDict[noteType] as Vector.<Note>;
			return result;
		}
		
	}

}