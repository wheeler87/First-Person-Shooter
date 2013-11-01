package com.game.plugins.physics 
{
	import com.game.entity.BaseEntity;
	import com.game.entity.characer.Character;
	import com.game.entity.components.bounds.Bounds;
	import com.game.entity.components.influence.InfluenceName;
	import com.game.entity.components.movement.Movement;
	import com.game.entity.components.position.Position;
	import com.game.entity.characer.Enemy;
	import com.game.entity.slug.Slug;
	import com.game.entity.wall.Wall;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import com.geom.Matrix3D;
	import com.geom.Point3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class PhysicsPlugin extends BasePlugin 
	{
		private var _helperV1:Vector3D = new Vector3D();
		private var _helperV2:Vector3D = new Vector3D();
		private var _helperV3:Vector3D = new Vector3D();
		private var _helperV4:Vector3D = new Vector3D();
		
		private var _helperM1:Matrix3D=new Matrix3D()
		
		public function PhysicsPlugin(owner:Game) 
		{
			super(owner);
		}
		
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.PHYSICS_INITIALIZATION);
			owner.synchronizer.addUpdateTask(advanceMovement, PriorityUpdate.ADVANCE_MOVEMENT);
			owner.synchronizer.addUpdateTask(resloveCollisions, PriorityUpdate.RESLOVE_COLLISIONS);
		}
		override public function onExit():void 
		{
			super.onExit();
			owner.synchronizer.removeInitializationTask(initialize);
			owner.synchronizer.removeUpdateTask(advanceMovement);
			owner.synchronizer.removeUpdateTask(resloveCollisions);
		}
		
		private function initialize():void
		{
			initEntity(owner.player);
			for each(var enemy:Enemy in owner.enemies) {
				initEntity(enemy);
			}
		}
		private function advanceMovement():void
		{
			var dt:int = owner.settings.updateStepDuration;
			var movement:Movement;
			var position:Position;
			
			movement = owner.player.movement;
			position = owner.player.position;
			advanceEntityMovement(movement,position,dt);
			
			for each(var enemy:Enemy in owner.enemies) {
				
				movement = enemy.movement;
				position = enemy.position;
				advanceEntityMovement(movement,position,dt);
			}
			
			for each(var slug:Slug in owner.slugs) {
				movement = slug.movement;
				position = slug.position;
				advanceEntityMovement(movement, position, dt);
			}
			
		}
		private function resloveCollisions():void
		{
			resetCollisionInfo();
			resloveWallsCollisions();
			resloveEntitiesCollisions();
		}
		
		private function initEntity(value:Character):void
		{
			value.movement.locked = true;
			
		}
		private function advanceEntityMovement(movement:Movement,position:Position,dt:int):void
		{
			if (movement.locked) {
				return;
			}
			recalculateEntityVelocity(movement, position);
			recalculateEntityHeading(movement,position);
			rotateEntity(movement, position, dt);
			reLocateEntity(movement,position, dt);
			
		}
		
		private function recalculateEntityVelocity(movement:Movement,position:Position):void
		{
			if (!movement.rawVelocity) return;
			
			if (movement.followDirectionMode) {
				
				movement.velocity.x = movement.velocityPool;
				movement.velocity.y = 0;
				movement.velocity.z = 0;
				
				_helperM1.identity();
				_helperM1.rotateY(movement.directionAngleY);
				_helperM1.transformVector(movement.velocity);
				
				movement.rawVelocity = false;
			}else if (movement.followTargetMode) {
				if (movement.targetCaptured) {
					movement.velocity.scaleBy(0);
					
				}else {
					var directionAngleY:Number = -Math.atan2(movement.target.z - position.worldCoordinates.z, movement.target.x - position.worldCoordinates.x)
					movement.velocity.x = movement.velocityPool;
					movement.velocity.y = 0;
					movement.velocity.z = 0;
					movement.angleYToTarget = directionAngleY;
					
					_helperM1.identity();
					_helperM1.rotateY(directionAngleY);
					_helperM1.transformVector(movement.velocity);
					
				}
				movement.rawVelocity = false;
				
				
			}else {
				movement.velocity.scaleBy(0);
				movement.rawVelocity = false;
			}
		}
		private function recalculateEntityHeading(movement:Movement,position:Position):void
		{
			if (!movement.rawHeading) return;
			var currentAngle:Number = position.worldAngleY;
			
			
			var destinationAngle:Number = currentAngle;
			if (movement.followDirectionMode) {
				destinationAngle = movement.directionAngleY-movement.headingOffset;
			}else if (movement.followTargetMode) {
				destinationAngle = -Math.atan2(movement.target.z - position.worldCoordinates.z,movement.target.x - position.worldCoordinates.x) - movement.headingOffset;
			}else if (movement.turnToDirectionMode) {
				destinationAngle = movement.turnDestiationAngle;
			}
			var heading:Vector3D = _helperV1;
			heading.x = -Math.cos(currentAngle);
			heading.y = -Math.sin(currentAngle);
			
			var lNormal:Vector3D = _helperV2;
			lNormal.x = -Math.cos(currentAngle-Math.PI * 0.5);
			lNormal.y = -Math.sin(currentAngle-Math.PI * 0.5);
			
			
			var destinationHeading:Vector3D = _helperV3;
			destinationHeading.x = -Math.cos(destinationAngle);
			destinationHeading.y = -Math.sin(destinationAngle);
			
			var headingDot:Number = heading.dotProduct(destinationHeading);
			var normalDot:Number = lNormal.dotProduct(destinationHeading);
			
			var delta:Number = Vector3D.angleBetween(heading, destinationHeading);
			var velocityOrt:int = (normalDot >= 0)? -1: 1;
			if (headingDot < 0) {
				delta = (delta < 0)?delta + Math.PI:delta - Math.PI;
			}
			
			movement.headingAngle = destinationAngle;
			movement.angularVelocity = velocityOrt * movement.angularVelocityPool;
			movement.headingCaptured = Math.abs(delta) < (movement.angularVelocityPool * owner.settings.updateStepDuration * 0.8*0.001);
			//movement.headingCaptured = false;
			
			movement.rawHeading = false;
			
		}
		private function rotateEntity(movement:Movement,position:Position, dt:int):void
		{
			if (movement.headingCaptured) return;
			if (movement.angularVelocity == 0) {
				movement.headingCaptured = true;
			}
			
			var dtSec:Number = dt * 0.001;
			
			var lastHeadingAngle:Number = position.worldAngleY;
			var currentHeadingAngle:Number = position.worldAngleY + movement.angularVelocity * dtSec;
			var wishfulHeadingAngle:Number = movement.headingAngle-movement.headingOffset;
			
			position.worldAngleY=currentHeadingAngle;
			
			
			var lastHeading:Vector3D = _helperV1;
			lastHeading.x = Math.cos(lastHeadingAngle);
			lastHeading.y = Math.sin(lastHeadingAngle);
			
			var currentHeading:Vector3D=_helperV2
			currentHeading.x = Math.cos(currentHeadingAngle);
			currentHeading.y = Math.sin(currentHeadingAngle);
			
			var wishfulNormal:Vector3D = _helperV3;
			wishfulNormal.x = Math.cos(wishfulHeadingAngle + Math.PI*0.5);
			wishfulNormal.y = Math.sin(wishfulHeadingAngle + Math.PI*0.5);
			
			var dot1:Number = wishfulNormal.dotProduct(lastHeading);
			var dot2:Number = wishfulNormal.dotProduct(currentHeading);
			if ((dot1 * dot2) <= 0) {
				movement.headingCaptured = true;
				position.worldAngleY=wishfulHeadingAngle
				//trace("captured")
			}
			
		}
		
		
		private function reLocateEntity(movement:Movement,position:Position, dt:int):void
		{
			
			
			if (!movement.headingCaptured) {
				return;
			}
			if (!movement.velocity.lengthSquared) {
				return;
			}
			
			
			
			
			var dtSec:Number = dt * 0.001;
			
			var dx:Number= movement.velocity.x * dtSec;
			var dy:Number=movement.velocity.y * dtSec;
			var dz:Number=movement.velocity.z * dtSec;
			
			position.move(dx, dy, dz);
			position.worldAngleY = movement.directionAngleY+movement.headingOffset;
			
			
			
			if (movement.followTargetMode) {
				
				
				var toTarget:Vector3D = _helperV1;
				var fromOldToTarget:Vector3D = _helperV2;
				
				toTarget.x = movement.target.x - position.worldCoordinates.x;
				toTarget.y = movement.target.y - position.worldCoordinates.y;
				toTarget.z = movement.target.z - position.worldCoordinates.z;
				
				fromOldToTarget.x = movement.target.x - position.lastWorldCoordinates.x;
				fromOldToTarget.y = movement.target.y - position.lastWorldCoordinates.y;
				fromOldToTarget.z = movement.target.z - position.lastWorldCoordinates.z;
				
				movement.targetCaptured = (fromOldToTarget.lengthSquared < toTarget.lengthSquared);
				position.worldAngleY = movement.angleYToTarget+movement.headingOffset;
				
				if (movement.targetCaptured) {
					movement.rawVelocity = true;
				}
				
			}
		}
		private function resloveWallsCollisions():void
		{
			var walls:Vector.<Wall> = owner.walls;
			
			var position:Position;
			var bounds:Bounds
			
			position = owner.player.position;
			bounds = owner.player.bounds;
			resloveEntityCollisionWithWalls(position, bounds, walls);
			
			for each(var slug:Slug in owner.slugs) {
				position = slug.position;
				bounds = slug.bounds;
				resloveEntityCollisionWithWalls(position, bounds, walls);
			}
		}
		private function resloveEntitiesCollisions():void
		{
			resloveEntityToEntitiesGroupCollision(owner.player, owner.slugs);
			for each(var enemy:Enemy in owner.enemies) {
				resloveEntityToEntitiesGroupCollision(enemy, owner.slugs);
			}
			
			
		}
		
		private function resloveEntityCollisionWithWalls(position:Position,bounds:Bounds,walls:Vector.<Wall>):void
		{
			var rNormal:Vector3D = _helperV1;
			var heading:Vector3D = _helperV2;
			
			var toEntity:Vector3D = _helperV3;
			var toOldEntity:Vector3D = _helperV4;
			
			for each(var wall:Wall in walls) {
				if (wall.info.angleX != 0) continue;
				heading.x = Math.cos(-wall.info.angleY);
				heading.y = Math.sin(-wall.info.angleY);
				rNormal.x = Math.cos(-wall.info.angleY + Math.PI * 0.5);
				rNormal.y = Math.sin(-wall.info.angleY + Math.PI * 0.5);
				
				toEntity.x = position.worldCoordinates.x-wall.info.originX;
				toEntity.y = position.worldCoordinates.z-wall.info.originZ;
				
				toOldEntity.x = position.lastWorldCoordinates.x - wall.info.originX;
				toOldEntity.y = position.lastWorldCoordinates.z - wall.info.originZ;
				
				var headingDot:int = heading.dotProduct(toEntity);
				if ((headingDot < 0) || (headingDot >= wall.width)) {
					continue;
				}
				var normalDot:Number = toEntity.dotProduct(rNormal);
				if ((normalDot < bounds.radius) && (normalDot > ( -bounds.radius))) {
					position.stepBackward();
					bounds.collidedWithWall = true;
					bounds.collidedWallID = wall.id;
					break;
				}
			}
		}
		
		
		private function resloveEntityToEntitiesGroupCollision(entity:BaseEntity, group:Object):void
		{
			var position1:Position;
			var position2:Position;
			var bounds1:Bounds;
			var bounds2:Bounds;
			
			position1 = entity.getCompoentByName(Position.NAME) as Position;
			bounds1 = entity.getCompoentByName(Bounds.NAME) as Bounds;
			
			var length:int = group.length;
			var entityFromGroup:BaseEntity;
			for (var i:int = 0; i < length; i++ ) {
				entityFromGroup = group[i] as BaseEntity;
				position2 = entityFromGroup.getCompoentByName(Position.NAME) as Position;
				bounds2 = entityFromGroup.getCompoentByName(Bounds.NAME) as Bounds;
				resloveEntityToEntityCollision(position1, bounds1, position2, bounds2);
			}
			
		}
		
		
		private function resloveEntityToEntityCollision(position1:Position, bounds1:Bounds, position2:Position, bounds2:Bounds):void
		{
			
			var step:Vector3D = _helperV1;
			step.x = position2.worldCoordinates.x - position2.lastWorldCoordinates.x;
			step.y = position2.worldCoordinates.y - position2.lastWorldCoordinates.y;
			step.z = position2.worldCoordinates.z - position2.lastWorldCoordinates.z;
			
			var headingAngle:Number = -Math.atan2(step.z, step.y);
			var stepLength:Number = step.length;
			
			var heading:Vector3D = _helperV1;
			heading.x = Math.cos(headingAngle);
			heading.y = Math.sin(headingAngle);
			heading.z = 0;
			
			var normal:Vector3D = _helperV2;
			normal.x = Math.cos(headingAngle + Math.PI * 0.5);
			normal.y = Math.sin(headingAngle + Math.PI * 0.5);
			
			
			var toFirst:Vector3D = _helperV3;
			toFirst.x = position1.worldCoordinates.x - position2.worldCoordinates.x;
			toFirst.y = position1.worldCoordinates.z - position2.worldCoordinates.z;
			toFirst.z = 0;
			
			var minDistance:Number = bounds1.radius + bounds2.radius;
			
			var headingDot:Number = toFirst.dotProduct(heading);
			if ((headingDot > (stepLength + minDistance)) || (headingDot < ( -minDistance))) {
				return;
			}
			
			var normalDot:Number = toFirst.dotProduct(normal);
			if ((normalDot < minDistance) && (normalDot > ( -minDistance))) {
				bounds1.collidedWithEntity=true
				bounds1.collidedEntityID = bounds2.owner.id;
				//
				bounds2.collidedWithEntity=true
				bounds2.collidedEntityID = bounds1.owner.id;
			}
			
		}
		private function resetCollisionInfo():void
		{
			owner.player.bounds.resetCollisionInfo();
			for each(var enemy:Enemy in owner.enemies) {
				enemy.bounds.resetCollisionInfo();
			}
		}
	}

}