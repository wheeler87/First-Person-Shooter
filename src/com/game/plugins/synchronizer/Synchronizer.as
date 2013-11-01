package com.game.plugins.synchronizer 
{
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Synchronizer extends BasePlugin 
	{
		
		private var _initializationTasks:Vector.<TaskData>;
		private var _updateTasks:Vector.<TaskData>;
		private var _enterFrameTasks:Vector.<TaskData>;
		
		public function Synchronizer(owner:Game) 
		{
			super(owner);
			
			_initializationTasks = new Vector.<TaskData>();
			_updateTasks = new Vector.<TaskData>();
			_enterFrameTasks = new Vector.<TaskData>();
		}
		public function addInitializationTask(value:Function, priority:int):void
		{
			addTask(value, priority, _initializationTasks);
		}
		public function addUpdateTask(value:Function, priority:int):void
		{
			addTask(value, priority, _updateTasks);
		}
		public function addEnterFrameTask(value:Function, priority:int):void
		{
			addTask(value, priority, _enterFrameTasks);
		}
		public function removeInitializationTask(value:Function):void
		{
			removeTask(value,_initializationTasks)
		}
		public function removeUpdateTask(value:Function):void
		{
			removeTask(value,_updateTasks)
		}
		public function removeEnterFrameTask(value:Function):void
		{
			removeTask(value,_enterFrameTasks)
		}
		public function runInitializationTasks():void
		{
			runTasks(_initializationTasks);
		}
		public function runUpdateTasks():void
		{
			runTasks(_updateTasks);
		}
		public function runEnterFrameTasks():void
		{
			runTasks(_enterFrameTasks);
		}
		
		private function addTask(value:Function,priority:int, list:Vector.<TaskData>):void
		{
			var taskData:TaskData = TaskData.searchByCallBack(list, value);
			if (!taskData) {
				taskData = new TaskData();
				list.push(taskData);
			}
			taskData.callback = value;
			taskData.priority = priority;
			list.sort(TaskData.sorter);
		}
		private function removeTask(value:Function, list:Vector.<TaskData>):void
		{
			var taskData:TaskData = TaskData.searchByCallBack(list,value);
			if (!taskData) return;
			list.splice(list.indexOf(taskData), 1);
		}
		private function runTasks(list:Vector.<TaskData>):void
		{
			for each(var task:TaskData in list) {
				task.callback();
			}
		}
	}

}
class TaskData
{
	public var callback:Function
	public var priority:int;
	
	public function TaskData():void
	{
		
	}
	static public function sorter(a:TaskData, b:TaskData):int
	{
		if (a.priority < b.priority) return  1;
		if (a.priority > b.priority) return -1;
		return 0;
	}
	static public function searchByCallBack(group:Vector.<TaskData>, callback:Function):TaskData
	{
		var result:TaskData;
		for each(var task:TaskData in group) {
			if (task.callback == callback) {
				result = task;
				break;
			}
		}
		return result;
	}
	
}