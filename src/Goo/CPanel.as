package Goo
{
	
	/**
	 * A Panel that can layout widgets
	 * Used as a menu bar, toolbar, or any widget that needs widget flow
	 * 
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class CPanel extends CWidget
	{			
		private var _LayoutStyle:int = GUI.LayoutHorizontal;
		
		public function CPanel(ParentWidget:Sprite, sName:String)
		{
			Bounds = new Rectangle( 0,0, GUI.SizeWindowWidth, GUI.SizeWindowHeight );
			super(ParentWidget, sName);
		}
		
		
		
		//todo smarter heights

		public function get LayoutStyle():int
		{
			return _LayoutStyle;
		}

		public function set LayoutStyle(value:int):void
		{
			_LayoutStyle = value;
			Layout( );
		}

		public override function Layout( ) : void
		{
			if ( _LayoutStyle == GUI.LayoutHorizontal ) 
				LayoutHorizontalFlow( );
			else if ( _LayoutStyle == GUI.LayoutVertical ) 
			{
				LayoutVertical( );
			}
		}
		
		private function LayoutHorizontalFlow( ) : void
		{
			var xx:int = 2;
			var yy:int = 2;
			for ( var i:uint = 0; i< numChildren; i++ )
			{
				if ( !(getChildAt( i ) is CWidget)) continue;
				var w:CWidget = getChildAt( i )  as CWidget;
				if ( w == null ) continue;
				w.x = xx;
				w.y = yy;
				
				xx+=w.width + 2;
				
				
				if ( xx >= width-w.width ) 
				{
					xx = 2;
					yy += w.height;
				}
			}
		}
		private function LayoutVertical( ) : void
		{
			var xx:int = 2;
			var yy:int = 2;
			for ( var i:uint = 0; i< numChildren; i++ )
			{
				if ( !(getChildAt( i ) is CWidget)) continue;
				var w:CWidget = getChildAt( i )  as CWidget;
				if ( w == null ) continue;
				w.x = xx;
				w.y = yy;
				
				yy += w.height;
			}
		}
				
		public override function Create( ) : void
		{	
			graphics.clear( );			
			
			GUI.DrawGradient( this, new Rectangle (0,0, Bounds.width, Bounds.height), GUI.ColorWindow, GUI.ColorWindow2, 90 );
			
			graphics.lineStyle(1, GUI.ColorWindowShadow );
			graphics.moveTo(0, Bounds.height );
			graphics.lineTo( Bounds.width, Bounds.height );
		}
		
		public override function addChild( e:DisplayObject ) : DisplayObject
		{
			super.addChild( e );
			Layout( );
			return e;
		}
		
		public function HideSubMenus( ) : void
		{
			for ( var i:uint = 0; i< numChildren; i++ )
			{
				if ( !(getChildAt( i ) is CMenuItem)) continue;
				var w:CMenuItem = getChildAt( i )  as CMenuItem;
				if ( w == null ) continue;
				w.ShowSubItems(false );
			}
		}
	}
}