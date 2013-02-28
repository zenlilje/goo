package Goo
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	//import flash.text.TextField;
	//import flash.text.TextFormat;
	
	//import flashx.textLayout.formats.TextAlign;

	public class CButton extends CWidget
	{
		protected var _Label:String = "Button";
		private var Text:CTextField = null;		
		public var Normal:MovieClip = new MovieClip();
		public var Over:MovieClip = new MovieClip;
		
		public function CButton(ParentWidget:Sprite, sName:String)
		{			
			Bounds = new Rectangle( 0,0, GUI.SizeButtonWidth, GUI.SizeButtonHeight );
			super(ParentWidget, sName);
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
			Normal.graphics.drawRoundRect(0,0, Bounds.width, Bounds.height, 7, 7 );
			Normal.graphics.endFill();
			Normal.graphics.lineStyle( 1, GUI.ColorBorder,1,true );
			Normal.graphics.drawRoundRect(1,1, Bounds.width-2, Bounds.height-2, 7, 7 );
			addChild( Normal );
			
			Over.graphics.clear();
			Over.graphics.beginFill( GUI.ColorButtonOver );
			Over.graphics.drawRoundRect(0,0, Bounds.width, Bounds.height, 7, 7 );
			Over.graphics.endFill();
			Over.graphics.lineStyle( 1, GUI.ColorBorder,1,true );
			Over.graphics.drawRoundRect(1,1, Bounds.width-2, Bounds.height-2, 7, 7 );
			
			if ( Text == null ) Text = new CTextField( this, "TextField" );
			Text.Serialise = false;
			addChild( Text );
			
			Text.height = 1;			
			Text.align = TextFormatAlign.CENTER ;
			Text.text = _Label ;
			Text.width = Bounds.width;
			Text.height = GUI.SizeButtonHeight;			
			Text.x = 0;
			Text.y = (Bounds.height - Text.height)/2;
			
			buttonMode = true;
		}
		
		public override function SetupEvents( ) : void
		{
			super.SetupEvents();
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			//addEventListener( MouseEvent.MOUSE_UP, onMouseOut );
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			addChild( Over );
			addChild( Text );
			if ( contains( Normal ) ) removeChild( Normal );
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			addChild( Normal );
			addChild( Text );
			if ( contains( Over ) ) removeChild( Over );
		}
		
		
	}
}