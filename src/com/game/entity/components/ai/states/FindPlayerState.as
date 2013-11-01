package com.game.entity.components.ai.states 
{
	import com.game.entity.components.ai.memory.Note;
	import com.geom.Point3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class FindPlayerState extends BaseAiState 
	{
		private var _helperV1:Vector3D = new Vector3D();
		private var _helperV2:Vector3D = new Vector3D();
		
		private var _positionPonts:Vector.<Vector3D>
		
		
		public function FindPlayerState() 
		{
			super();
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			configurateMovement();
			advanceMovement();
			
		}
		override public function onExit():void 
		{
			super.onExit();
			if (_positionPonts) {
				_positionPonts.length = 0;
			}
			entity.movement.stopMove();
			
		}
		override public function update(dt:int):void 
		{
			super.update(dt);
			
			if (isPlayerDetected()) {
				owner.setState(owner.attackPlayerState);
				return;
				
			}
			
			
			if (entity.movement.targetCaptured) {
				if ((!_positionPonts) || (!_positionPonts.length)) {
					configurateMovement();
				}else {
					advanceMovement();
				}
			}
		}
		
		private function isPlayerDetected():Boolean
		{
			//return false;
			var playerNote:Note = owner.memory.getNoteByTargetID(entity.game.player.id);
			var result:Boolean = ((!playerNote.forgoten) && (playerNote.visibleTarget));
			return result;
		}
		
		
		private function configurateMovement():void
		{
			var spawners:Vector.<Point3D> = owner.navigation.spawners.slice();
			var location:Vector3D = entity.position.worldCoordinates;
			var closestSpawner:Point3D = owner.navigation.getClosestSpawner(location.x, location.y, location.z);
			spawners.slice(spawners.indexOf(closestSpawner), 1);
			var index:int = spawners.length * Math.random();
			var desinationSpawner:Point3D = spawners[index];
			
			var destination:Vector3D = _helperV1;
			destination.x = desinationSpawner.x;
			destination.y = location.y;
			destination.z = desinationSpawner.z;
			
			
			_positionPonts = owner.navigation.generateMovementPoints(location, destination);
			
		}
		private function advanceMovement():void
		{
			var destination:Vector3D = _positionPonts.shift();
			
			
			var x:Number = destination.x;
			var y:Number = entity.position.worldCoordinates.y;
			var z:Number = destination.z;
			
			
			
			entity.movement.stopMove();
			entity.movement.moveAtPosition(x, y, z);
		}
	}

}