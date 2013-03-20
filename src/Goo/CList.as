package Goo
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class CList extends CWidget
	{
		public var Items:Array = new Array( );
		public function CList(ParentWidget:Sprite, sName:String, TargetR:Rectangle=null)
		{
			if ( Bounds == null )
			{
				Bounds = new Rectangle( 0,0, GUI.SizeListWidth, GUI.SizeListHeight );
			}
			super(ParentWidget, sName, TargetR);
			
			Type = "CList";
		}
		
		public override function Create():void
		{			
			graphics.clear( );			
			
			GUI.DrawGradient( this, new Rectangle (0,0, Bounds.width, Bounds.height), GUI.ColorWindow, GUI.ColorWindow2, 90 );
			
			graphics.lineStyle(1, GUI.ColorWindowShadow );
			graphics.moveTo(0, Bounds.height );
			graphics.lineTo( Bounds.width, Bounds.height );
		}
		
		public override function Layout() : void
		{
			var ol:Boolean = false;
			for ( var i:int = 0; i< Items.length; i++ )
			{
				var tf:CLabel = Items[i];
				ol = tf.TriggerLayout;
				tf.TriggerLayout = false;
				tf.y = i * tf.Bounds.height;
				tf.x = GUI.SizeButtonPad;				
				tf.width = this.width - GUI.SizeScrollButtonWidth;
				tf.TriggerLayout = ol;
				tf.visible = true;
				trace( tf.y + " : " + this.height );
				if ( tf.y < -tf.height ) tf.visible = false;
				if ( tf.y > Bounds.height-tf.height ) tf.visible = false;
			}
		}
		
		/**
		 * Add a list item to the list (CTextField)
		 * @param sItem - label of the item
		 * 
		 */		
		public function AddItem( sItem:String ) : void
		{
			var tf:CLabel = new CLabel( this, sItem );
			tf.Label = sItem ;
			if ( DesignMode == true ) tf.DesignMode = true;
			tf.AddCallback( this.Callback );
			Items.push( tf );
			tf.Resize( this.width - GUI.SizeButtonPad*2, tf.height );
			this.addChild( tf );
			Create( );
			Layout( );			
		}
	}
}