package Goo
{				
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * A status bar that typicall appears on the bottom of a window
	 * Width is by default the full width of the parent 
	 * @author karll
	 * 
	 */	
	public class CStatusBar extends CPanel
	{
		public var TextBox:CTextField = null;
		
		public function CStatusBar(ParentWidget:Sprite, sName:String)
		{
			if ( Bounds == null )
			{
				Bounds = new Rectangle( 0,0, ParentWidget.width, GUI.SizeMenuItemHeight);
			}
			super(ParentWidget, sName);
			
			TextBox = new CTextField( this, "Text" );
			TextBox.text = "Status";
			TextBox.Resize( Bounds.width, Bounds.height );
		}
		
		public function set Text( s:String ) : void
		{
			TextBox.text = s;
		}
	}
}