package com.game.entity.characer 
{
	import com.game.entity.components.animation.Animation;
	import com.game.entity.components.indicator.Indicator;
	import com.info.components.IInfoComponent;
	import com.info.components.player.PlayerInfo;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Player extends Character 
	{
		
		public var animation:Animation
		public var indicator:Indicator;
		
		public function Player() 
		{
			super();
			animation = new Animation();
			addComponent(animation);
			
			indicator = new Indicator();
			addComponent(indicator);
			
		}
		override public function init(info:IInfoComponent):void 
		{
			super.init(info);
			
			life.init(playerInfo.hitpoints);
			movement.init(playerInfo.speed,playerInfo.turnSpeedRadians);
			bounds.init(playerInfo.boundRadius, playerInfo.height);
			amunition.init(playerInfo.defaultWeaponID);
			
		}
		public function get playerInfo():PlayerInfo{return info as PlayerInfo}
	}

}