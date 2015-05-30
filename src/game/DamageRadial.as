package game
{
	import flash.display.MovieClip;
	
	public class DamageRadial extends DamageRadialMC
	{
		public function DamageRadial()
		{
			this.damageCircle.rotation = 180;
			this.bilgeCircle.rotation = 0;
		}
		
		public function set bilge(percentage)
		{
			this.bilgeCircle.rotation = -((Math.max(percentage,0.0000001) / 100) * 180);
		}
		
		public function set damage(percentage)
		{
			this.damageCircle.rotation = ((Math.max(percentage,0.0000001) / 100) * 180) + 180;
		}
	}
}