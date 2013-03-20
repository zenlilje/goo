package Goo
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;	
	
	public class CLabel extends CWidget
	{
		protected var _Label:String = "Button";
		private var Text:CTextField = null;		
		public var Normal:MovieClip = new MovieClip();
		public var Over:MovieClip = new MovieClip;
		
		public function CLabel(ParentWidget:Sprite, sName:String)
		{			
			Bounds = new Rectangle( 0,0, GUI.SizeButtonWidth, GUI.SizeButtonHeight );
			_Label = sName;
			super(ParentWidget, sName);
			Type = "CLabel";
			PublicProperties.push( "Label" );			
		}
		
		public function set Label( s:String ) : void
		{
			_Label = s;
			Create( );
		}
		
		public function get Label( ) : String
		{
			return _Label;
		}
		
		public override function Create( ) : void
		{
			super.Create();
			
			Normal.graphics.clear();
			Normal.graphics.beginFill( GUI.ColorWindow );
			Normal.graphics.drawRect(0,0, Bounds.width, Bounds.height);
			Normal.graphics.endFill();			
			addChild( Normal );
			
			if ( Text == null ) Text = new CTextField( this, "TextField" );
			Text.Serialise = false;
			addChild( Text );
			
			Text.height = 1;			
			Text.align = TextFormatAlign.CENTER ;
			Text.text = _Label ;
			Text.width = Bounds.width;
			Text.height = GUI.SizeButtonHeight;			
			Text.x = 0;
			Text.y = ((Bounds.height - Text.height)/2)+2;
			
			buttonMode = true;
		}
	}
}