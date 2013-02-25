package Goo
{
	
	/**
	 * A Panel that can layout widgets
	 * Used as a menu bar, toolbar, or any widget that needs widget flow
	 * 
	 */
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class CPanel extends CWidget
	{			
		public var LayoutStyle:int = GUI.LayoutHorizontal;
		
		public function CPanel(ParentWidget:Sprite, sName:String)
		{
			super(ParentWidget, sName);
		}
		
		//todo smarter heights
		public override function Layout( ) : void
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
				
				xx+=w.GetWidth() + 2;
				
				
				if ( xx >= width-w.width ) 
				{
					xx = 2;
					yy += w.height;
				}
			}
		}
		
		public override function Create( ) : void
		{	
			graphics.clear( );
			
			//graphics.beginFill( GUI.ColorWindow );
			GUI.DrawGradient( this, Bounds, GUI.ColorWindow, GUI.ColorWindow2, 90 );
			
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