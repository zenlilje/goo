package Goo
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	public class CWindow extends CWidget
	{
		public var Caption:String = "Window" ;
		public var Text:CTextField = null;
		public var HeaderRect:Rectangle = new Rectangle(0,0, GUI.SizeWindowWidth, GUI.SizeWindowHeaderHeight );
		public var Panel:CPanel = null;		
		
		public function CWindow( ParentWidget:Sprite, sName:String )
		{	
			HeaderRect.width = GUI.SizeWindowWidth;
			HeaderRect.height = GUI.SizeWindowHeaderHeight;
			
			super( ParentWidget, sName, new Rectangle( 0,0, GUI.SizeWindowWidth, GUI.SizeWindowHeight+GUI.SizeWindowHeaderHeight ) );
			
			PublicProperties.push( "Caption" );
			
		}
		public override function Create( ) : void
		{
			//trace( "new CWindow " );
			//header bar
			this.graphics.clear();
			
			if ( Text == null ) Text = new CTextField( this, "HeaderText" );
			Text.Serialise = false;
			
			HeaderRect.width = Bounds.width;
			
			GUI.DrawGradient( this, HeaderRect, GUI.ColorWindowHeader, GUI.ColorWindowHeader2, 180 );
			Text.y = 0;
			addChild( Text );
			Text.x = GUI.SizeButtonPad;
			//Text.y -= GUI.SizeWindowHeaderHeight;
			Text.text = Caption ;
			Text.width = Bounds.width;
			Text.height = GUI.SizeWindowHeaderHeight;
			Text.align = TextFormatAlign.LEFT;
			Text.bold = true;
			
			Text.selectable = false;
			Text.mouseEnabled = false;			
			//main panel
			
			//TargetRect.y = GUI.SizeWindowHeaderHeight;
			if ( Panel == null ) Panel = new CPanel( this, "Panel" );
			Panel.Bounds = Bounds.clone();			
			Panel.Bounds.x = 0;
			Panel.Bounds.y = 0;
			Panel.Bounds.height -= GUI.SizeWindowHeaderHeight+1;
			Panel.Bounds.width-=2;
			Panel.Create( );
			Panel.x = 1;
			Panel.y = GUI.SizeWindowHeaderHeight;
			//GUI.DrawGradient( Panel, TargetRect, GUI.ColorWindow, GUI.ColorWindow2, 90 );
			
			//border
			graphics.lineStyle( 2, GUI.ColorBorder );
			graphics.drawRect( 0,0, Bounds.width+1, Bounds.height +1 );
		}
		
		public override function SetupEvents( ) : void
		{
			super.SetupEvents();
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		protected function onMouseDown(event:MouseEvent):void
		{
			//trace( "---" );
			//trace( event.target );
			//trace( event.currentTarget );
			if (( event.currentTarget == event.target )  && ( event.localY<GUI.SizeWindowHeaderHeight ))
			{
				startDrag( );
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stopDrag();			
		}
		
		public override function addChild( e:DisplayObject ) : DisplayObject
		{			
			if (( Panel == null ) || ( e == Panel ) || ( e == Text )) super.addChild( e );
			else
			Panel.addChild( e );
			//e.y += GUI.SizeWindowHeaderHeight;
			return e ;
		}
		
		public override function Layout( ) :void
		{
			super.Layout();
			Panel.Layout();
		}
		
		public override function AddCallback( c:Function ) : void
		{
			Callback = c;
			Panel.AddCallback( PanelCallback );
		}
		
		//relay panel callbacks to the main window
		public function PanelCallback( Widget:CWidget, e:Event ) : void
		{
			if ( Widget == Panel ) 
				Callback( this, e );
		}
		
		public override function get numChildren( ) : int
		{	
			return Panel.numChildren;
		}
		
		public override function getChildAt( n:int ) : DisplayObject
		{
			if ( Panel == null ) return super.getChildAt(n );
			else
			return Panel.getChildAt(n );
		}
		
		
	}
}