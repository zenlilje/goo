package Goo
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class CMenuItem extends CWidget
	{
		public var Caption:String = "Menu Item";
		
		public var Text:CTextField =  null;
		public var Normal:MovieClip = new MovieClip();
		public var Over:MovieClip = new MovieClip;
		
		public var SubItems:Array = new Array( );
		
		public var Open:Boolean = false;
		
		public function CMenuItem(ParentWidget:Sprite, sName:String)
		{
			Caption = sName;
			super(ParentWidget, sName);			
			PublicProperties.push( "Caption" );
		}
		
		public override function Create( ) : void
		{	
			//Over.graphics.lineStyle( 1, GUI.ColorBorder,1,true );
			//Over.graphics.drawRect(1,1, GUI.SizeButtonWidth-2, GUI.SizeButtonHeight-2 );
			if ( Text == null ) Text = new CTextField( this, name );
			Text.Serialise = false;
				
			Text.width = 1;
			Text.autoSize = TextFieldAutoSize.LEFT;
			//Text.width = GUI.SizeMenuItemWidth;
			//Text.height = GUI.SizeMenuItemHeight;
			Text.text = Caption ;
			Text.selectable = false;
			Text.mouseEnabled = false;
			Text.x +=2;
			
			Normal.graphics.clear( );
			if ( parent is CMenuItem )
			{			
				Normal.graphics.beginFill( GUI.ColorMenuBG, 1 );
				Normal.graphics.drawRect(0,0, GUI.SizeMenuItemMax, GUI.SizeMenuItemHeight );
				Over.graphics.beginFill( GUI.ColorMenuOverBG );
				Over.graphics.drawRect(0,0, GUI.SizeMenuItemMax, GUI.SizeMenuItemHeight );
				Over.graphics.endFill()
			}
			else
			{				
				Normal.graphics.beginFill( GUI.ColorMenuBG, 0 );
				Normal.graphics.drawRect(0,0, Text.width+8, GUI.SizeMenuItemHeight );
				Over.graphics.beginFill( GUI.ColorMenuOverBG );
				Over.graphics.drawRect(0,0, Text.width+8, GUI.SizeMenuItemHeight );
				Over.graphics.endFill()
			}			
			
			Normal.graphics.endFill();
			addChild( Normal );
			
			addChild( Text );
			
			buttonMode = true;
		}
		
		public override function SetupEvents( ) : void
		{
			super.SetupEvents();
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
		}
		
		protected override function onClick(event:MouseEvent):void
		{
			//if ( event.currentTarget != this ) return;
			event.stopImmediatePropagation();
			
			if ( Callback != null ) 
			{			
				Callback(this, event);
			}
			
			if ( DesignMode == true ) return;
			
			if ( parent is CPanel )
			{
				var pan:CPanel = parent as CPanel;
				pan.HideSubMenus();
			}
			
			if ( parent is CMenuItem )
			{
				var p:CMenuItem = parent as CMenuItem;
				p.ShowSubItems( false )
			}
			else if ( Open )
			{
				ShowSubItems( false );	
			}
			else
			{
				ShowSubItems( true );			
			}			
		}	
		protected function onMouseOver(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
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
		
		public function AddSubMenuItem( sName:String, Callback:Function ) : CMenuItem
		{
			var m:CMenuItem = new CMenuItem( this, sName );
			m.AddCallback( Callback );
			addChild( m );
			SubItems.push( m );
			m.y = GUI.SizeMenuItemHeight * SubItems.length;
			m.visible = false;
			return m;
		}
		public function ShowSubItems( b:Boolean ) : void
		{
			Open = b;
			for ( var i:uint=0; i< SubItems.length; i++ )
			{
				var m:CMenuItem = SubItems[i];
				m.visible = b;
			}
		}
		
		public override function getChildAt( n:int ) : DisplayObject
		{
			if ( SubItems == null ) return super.getChildAt(n );
			else
				return SubItems[n];
		}
		
		//we should not return the width of sub items (hiddent) rather of this item only
		public override function GetWidth( ) : int
		{
			if ( Text != null )
				return Text.width;
			else return width;
		}
	}
}