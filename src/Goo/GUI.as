package Goo
{
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public class GUI
	{	
		
		//colors
		public static const ColorBorder:int = 0x0;
		public static var ColorBorderLight:uint = 0xaaaaaa;
		public static const ColorButtonOver:int = 0xffffee;
		public static const ColorWindow:int = 0xeeeeee;
		public static const ColorWindow2:int = 0xcccccc;
		public static const ColorWindow3:int = 0xaaaaaa;
		public static const ColorWindowHeader:int = 0xaaaaaa;
		public static const ColorWindowHeader2:int = 0x888888;
		public static const ColorWindowShadow:int = 0x999999;
		public static const ColorHeaderText:int = 0xffffff;
		public static const ColorText:int = 0x0;
		public static const ColorMenuBG:int = 0xeeeeee;
		public static const ColorMenuOverBG:int = 0x888888;
		
		//sizes
		public static const SizeButtonWidth:int = 64;
		public static const SizeButtonHeight:int = 24;
		public static const SizeButtonPad:int = 2;
		
		public static const SizeMenuItemWidth:int = 64;
		public static const SizeMenuItemHeight:int = 24;
		public static const SizeMenuItemMax:int = 80;
		
		public static const SizeWindowHeaderHeight:int = 24;
		public static const SizeWindowWidth:int = 320;
		public static const SizeWindowHeight:int = 240;
		
		public static const SizeListItemHeight:int = 24;
		
		public static var SizeListHeight:int = 100;
		public static var SizeListWidth:int = 80;
		
		//scroll bar button
		public static var SizeScrollButtonHeight:int = 24;
		public static var SizeScrollButtonWidth:int = 24;		
		
		//dragging handle
		public static const SizeHandle:int = 10;
		
		//layout
		public static const LayoutNone:String= "None"; //widgets are added in absolute position
		public static const LayoutAbsolute:String = "Absolute"; //widgets are added in absolute position
		public static const LayoutHorizontal:String = "Horizontal"; //widgets are added horizontally and then wrapped down
		public static const LayoutVertical:String = "Vertical"; //widgets are added vertically and then wrapped across		
		
		public static var Indent:int = 0;
		
		
		public function GUI()
		{
		}
		
		/**
		 * Loads Goo XML from a string into the target container 
		 * @param s
		 * @param TargetWidget
		 * 
		 */		
		public static function LoadXMLIntoWidget( s:String, TargetWidget:Sprite ) : void
		{
			var xml:XML = new XML( s );
			if ( xml == null ) 
			{
				trace( "XML INVALID " + s );
				return;
			}
			ParseFromXML( TargetWidget, xml.widget );
		}
		
		/**
		 * Recursively Parses an XMLList and constructs widgets
		 * Called by LoadXMLFromString  
		 * @param Widget
		 * @param node
		 * 
		 */		
		public static function ParseFromXML( Widget:Sprite, node:XMLList ) : void
		{			
			//var Widgets:XMLList = node.Widget;
			var ChildWidget:Sprite = null;
			for each ( var child:XML in node )
			{
				//trace( child.widgettype );
				ChildWidget = ConstructWidget( Widget, child );
				//parse any child Widgets
				GUI.Indent++;
				ParseFromXML( ChildWidget, child.widget ) ;
				GUI.Indent--;
			}
		}
		
		/**
		 * Consructs a single widget from an xml node 
		 * @param Parent
		 * @param node
		 * @return the constructed widget , or null if the xml was unknown
		 * 
		 */		
		public static function ConstructWidget(  Parent:Sprite, node:XML ) : CWidget
		{
			//quick indent
			var s:String = "";
			for ( var i:int = 0; i< Indent; i++ ) s+="-"; 
			trace( s + node.widgettype );
			
			var w:CWidget = null;
			var sName:String = node.name;
			switch ( node.widgettype.toString() )
			{
				case "Goo::CWidget":
					w = new CWidget( Parent, sName );
				break;
				case "Goo::CWindow":
					w = new CWindow( Parent, sName );
				break;
				case "Goo::CPanel":
					w = new CPanel( Parent, sName );
				break;
				case "Goo::CButton":					
					w = new CButton( Parent, sName );										
				break;				
				case "Goo::CMenuItem":
					w = new CMenuItem( Parent, sName );					
				break;
			}
			
			if ( w == null )
			{
				trace( "UNHANDLED WIDGET TYPE " + node.widgettype.toString() ) ;
				return null;
			}
			//common items
			w.x = node.x;
			w.y = node.y;
			w.Resize( node.width, node.height );
			//w.width = node.width;
			//w.height = node.height;
			
			return w;
		}
		
		/**
		 * Loads an XML file into a widget 
		 * @param sFile
		 * @param TargetWidget
		 * 
		 */		
		public static function LoadXML( sFile:String, TargetWidget:Sprite ) : void
		{
			var load:Loader = new Loader( );
			TargetWidget.addChild( load ); //add the loader to the widget for later unpacking
			load.load( new URLRequest( sFile ) );
			load.loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete );
		}
		
		protected static function onLoadComplete(event:Event):void
		{
			var LoadInfo:LoaderInfo = event.target as LoaderInfo;
			LoadInfo.content.parent;
		}
		
		/**
		 * Recursively parses a widget into xml 
		 * @param Widget
		 * @param node
		 * @return the combined xml
		 * 
		 */		
		public static function ParseToXML( Widget:CWidget, node:XML ) : XML
		{
			var s:String = "";
			if ( !(Widget is CWidget) ) return new XML();
			//trace( Widget.name );
			//var tempnode:XML = node.appendChild( Widget.ToXML() );
			var tempnode:XML = Widget.ToXML();
			if ( node == null ) node = <xml/>;			
			node.appendChild( tempnode );
			
			for ( var i:int = 0; i<Widget.numChildren; i++ )
			{
				var w:CWidget = Widget.getChildAt(i) as CWidget;
				if (( w != null ) && ( w.Serialise == true ))
				{
					ParseToXML( Widget.getChildAt(i)  as CWidget , tempnode );
				}
			}
			return node;
		}
		
		/**
		 * Saves a widget to a file (including child widgets)
		 * AIR only 
		 * @param sFile
		 * @param SourceWidget
		 * 
		 */		
		public static function SaveXML( sFile:String, SourceWidget:CWidget) : void
		{	
			CFileTools.SaveXML( sFile, SourceWidget ) ;			
		}
		
		/**
		 * Draws a gradient into a widgets 
		 * @param TargetWidget
		 * @param TargetRect
		 * @param c1 First colour
		 * @param c2 Second colour
		 * @param angle
		 * 
		 */		
		public static function DrawGradient( TargetWidget:CWidget, TargetRect:Rectangle, c1:uint, c2:uint, angle=0 ) : void
		{
			//graphics.beginFill( GUI.ColorWindow );
			var matr:Matrix = new Matrix();
			matr.createGradientBox(TargetRect.width, TargetRect.height, angle, 0, 0);
			
			TargetWidget.graphics.beginGradientFill( GradientType.LINEAR, [c1, c2],[1,1],[0x00,0xff], matr );
			TargetWidget.graphics.drawRect(TargetRect.x,TargetRect.y, TargetRect.width, TargetRect.height );
			TargetWidget.graphics.endFill();
		}
	}
}