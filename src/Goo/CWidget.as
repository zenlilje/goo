package Goo
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import avmplus.getQualifiedClassName;
	
	public class CWidget extends Sprite
	{		
		protected var Callback:Function;
		
		//when true this widget is being designed/altered by an external designer and has special handling
		protected var _DesignMode:Boolean = false;
		
		protected var _Serialise:Boolean = true; //when false this widget won't be written out
		//we have our own bounds because our sizes are set before redrawing
		//(flash calculates bounds after drawing)
		public var Bounds:Rectangle = null;	
		public var LayoutOffset:Point = new Point( 0,0 );
		
		public var PublicProperties:Array = new Array( );
		
		public function CWidget( ParentWidget:Sprite, sName:String, TargetR:Rectangle = null )
		{			
			if ( Bounds == null ) Bounds = new Rectangle(0,0, 8,24 );
			PublicProperties.push( "x" );
			PublicProperties.push( "y" );
			PublicProperties.push( "width" );
			PublicProperties.push( "height" );
			
			name = sName;
			if ( TargetR != null ) Bounds = TargetR;
			if ( ParentWidget != null ) ParentWidget.addChild( this );
			super();			
			Create();
			SetupEvents( );
		}
		
		public function get DesignMode () : Boolean
		{
			return _DesignMode;
		}
		public function set DesignMode( b:Boolean ) : void
		{
			_DesignMode = b;
		}
		public function get Serialise():Boolean
		{			
			return _Serialise;
		}		
		
		public function set Serialise(value:Boolean):void
		{
			_Serialise = value;
		}
		
		public function Dispose( ) : void
		{
			removeEventListener( MouseEvent.CLICK, onClick, false );		
		}
		
		//override this to create the appearance of the control
		public function Create( ) : void
		{
			graphics.clear( );
			graphics.beginFill(GUI.ColorWindow) ;
			graphics.drawRect(0,0, Bounds.width, Bounds.height );
			graphics.endFill();
		}
		
		public function AddCallback( c:Function ) : void
		{
			Callback = c;			
		}
		
		public function SetupEvents( ) : void
		{
			addEventListener( MouseEvent.CLICK, onClick, false );
		}
		
		protected function onClick(event:MouseEvent):void
		{
			//if ( event.currentTarget != this ) return;
			event.stopImmediatePropagation();
			if ( Callback == null )
			{
				trace( "WARNING: CWidget (" + name + ") Callback is NULL" ) ;
				return;
			}
			
			Callback(this, event);
			
		}		
		
		/**
		 * Converts this Widget to XML
		 * (non-recursive) 
		 * @return 
		 * 
		 */		
		public function ToXML( ) : XML
		{
			var xml:XML = <widget />;
			xml.widgettype = getQualifiedClassName(this);			
			xml.name = name;
			xml.x = x;
			xml.y = y;
			xml.width = width;
			xml.height = height;
			
			for ( var i:int = 0;i < PublicProperties.length; i++ )
			{
				var s:String = PublicProperties[i];
				if ( this.hasOwnProperty(s) )
				{
					xml[s] = this[s];
				}
			}
			
			return xml;
		}
		
		public function Resize( twidth:int, theight:int) : void
		{
			Bounds = new Rectangle( x, y, twidth, theight);
			Create( );
			Layout( );
			if ( parent is CWidget ) 
			{
				var w:CWidget = parent as CWidget;
				w.Layout( );
			}
		}
		
		/*public function GetWidth( ) : int
		{
			return width;
		}*/
		
		override public function get width() : Number 
		{
			return Bounds.width;
		}
		
		override public function set width( n:Number ) : void
		{		  
		  Resize( n, Bounds.height );
		}
		
		/**
		 * Layout the widget (if available) 
		 * 
		 */		
		public function Layout( ) : void
		{
			
		}
		
		
	}
}