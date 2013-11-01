package com.game.entity.characer 
{
	import com.game.entity.components.ai.AI;
	import com.game.entity.components.animation.Animation;
	import com.info.components.enemy.EnemyInfo;
	import com.info.components.IInfoComponent;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Enemy extends Character 
	{
		public var ai:AI
		public var animation:Animation
		
		public function Enemy() 
		{
			super();
			
			ai = new AI();
			addComponent(ai);
			
			animation = new Animation();
			addComponent(animation);
		}
		override public function init(info:IInfoComponent):void 
		{
			super.init(info);
			life.init(enemyInfo.hitpoints,enemyInfo.deathDuration);
			movement.init(enemyInfo.speed,enemyInfo.turnSpeedRadians);
			bounds.init(enemyInfo.boundRadius, enemyInfo.height);
			amunition.init(enemyInfo.defaultWeaponID);
			
			animation.init(enemyInfo.animationGroupID);
			
			ai.init(enemyInfo.cogitationTime, enemyInfo.rememberTime);
			
		}
		
		public function get enemyInfo():EnemyInfo { return info as EnemyInfo }
		
	}

}