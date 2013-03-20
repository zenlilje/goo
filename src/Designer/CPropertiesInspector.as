package Designer
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.describeType;
	
	import Goo.CButton;
	import Goo.CList;
	import Goo.CTextField;
	import Goo.CWidget;
	import Goo.CWindow;
	import Goo.GUI;
	
	public class CPropertiesInspector extends CWindow
	{
		public var Debug:CTextField = null;
		public var TargetWidget:CWidget = null;
		public var Properties:Array = new Array( );
		
		public function CPropertiesInspector(ParentWidget:Sprite, sName:String)
		{
			Debug = new CTextField( this, "Debug" );
			super(ParentWidget, sName);
				
			this.Panel.LayoutStyle = GUI.LayoutVertical;
			//addChild( Debug );
			Debug.width = width;
			Debug.height = 200;
			Debug.y = 50;
		}
		
		public function SetTarget( Widget:CWidget ) : void
		{
			TargetWidget = Widget;
			
			
			Debug.text = "";
			
			ClearProperties( );
			
			if ( Widget == null ) return;			
			
			AddProperty("name" );
			AddPublicProperties( );		
			AddSpecialProperties( ) ;
			
			// List the class name.
			var classInfo:XML = describeType(TargetWidget);
			Debug.text = "Class " + classInfo.@name.toString() + "\n";
			addChild( Debug );
			
			// List the object's variables, their values, and their types.
			/*
			for each (var v:XML in classInfo..variable) 
			{
				Debug.text += "Variable " + v.@name + "=" + TargetWidget[v.@name] +" (" + v.@type + ")\n";
			}
			*/
			
			// List accessors as properties.
			/*
			for each (var a:XML in classInfo..accessor) {
				// Do not get the property value if it is write only.
				if (a.@access == 'writeonly') {
					Debug.text += "Property " + a.@name + " (" + a.@type +")\n";
				}
				else {
					Debug.text += "Property " + a.@name + "=" + 
						Widget[a.@name] +  " (" + a.@type +")\n";
				}
			} 
			*/
			
			//AddProperty( Widget.name );
		}
		
		public function AddPublicProperties(  ) : void
		{
			for ( var i:int = 0; i < TargetWidget.PublicProperties.length; i++ )
			{
				AddProperty( TargetWidget.PublicProperties[i] );
			}
		}
		
		public function AddSpecialProperties( ) : void
		{
			if ( TargetWidget.Type == "CList" )
			{
				AddButton( AddItem );
			}
		}
		
		public function AddButton( callback:Function ) : void
		{
			var but:CButton = new CButton( this, "Add Item" );
			but.AddCallback( callback );
			Properties.push( but );
		}
		
		public function AddItem( Source:CWidget, event:Event ) : void
		{
			var tl:CList = TargetWidget as CList;
			tl.AddItem("Item" );
			
		}
		
		public override function Resize( twidth:int, theight:int) : void
		{
			super.Resize( twidth, theight );
			Debug.width = twidth;
		}
		
		public function ClearProperties( ) : void
		{
			while ( Properties.length>0 )
			{
				var w:CWidget = Properties.pop();				
				Panel.removeChild( w );
			}
		}
		
		public function AddProperty( Label:String ) : void
		{
			var p:CProperty = new CProperty( this, Label, new Rectangle( 0,0, width, GUI.SizeListItemHeight ));
			p.SetProperty( Label, TargetWidget );
			p.AddCallback( PropertyCallback );
			addChild( p );
			Properties.push( p );
			//w.text = 
		}
		
		public function PropertyCallback( w:CWidget, e:Event ) : void
		{
			if ( Callback != null ) Callback( w, e );
		}
	}
}