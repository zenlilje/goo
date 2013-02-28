package Designer
{
	
	/**
	 * GUI Designer
	 * using Flash Goo Components / Widgets
	 * 
	 * Kark Lilje
	 * www.karllilje.com 
	 * 
	 * */
		
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import Goo.CButton;
	import Goo.CMenuItem;
	import Goo.CPanel;
	import Goo.CWidget;
	import Goo.CWindow;
	import Goo.GUI;
	
	[frameRate="40"]
	public class GUIDesigner extends Sprite
	{
		
		private var WidgetToCreate:CWidget = null;
		private var fr:FileReference = new FileReference( );
		//private var MainWidget:CWidget = null;
		private var RootWidget:CWidget = null;
		private var MenuPanel:CPanel = null;
		private var RootClicked:Boolean = false;
		private var SelectedWidget:CWidget = null;
		private var DesignHandle:CDesignerHandles2 = null;
		private var Properties:CPropertiesInspector = null;
		
		private const STATE_MOVE:String = "STATE_MOVE";
		private const STATE_SCALE:String = "STATE_SCALE"; 
		private var State:String = STATE_MOVE;
		
		public function GUIDesigner()
		{
			stage.nativeWindow.width = 800;
			stage.nativeWindow.height= 800;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			MenuPanel = new CPanel( this, "MenuPanel" ) ;
			MenuPanel.Resize( stage.nativeWindow.width, GUI.SizeMenuItemHeight+2 );			
			
			var mi:CMenuItem = new CMenuItem( MenuPanel, "File" ) ;
			mi.AddCallback( OnMenu );
			mi.AddSubMenuItem( "New", OnMenu );
			mi.AddSubMenuItem( "Open", OnLoadXML );
			mi.AddSubMenuItem( "Save", OnSaveXML );
			mi.AddSubMenuItem( "Merge", OnMergeXML );
			
			var me:CMenuItem = new CMenuItem( MenuPanel, "Edit" ) ;
			me.AddCallback( OnMenu );			
			me.AddSubMenuItem( "Copy", OnMenu );
			me.AddSubMenuItem( "Paste", OnMenu );
			
			var min:CMenuItem = new CMenuItem( MenuPanel, "Insert" ) ;
			min.AddCallback( OnMenu );
			min.AddSubMenuItem( "Insert Button", OnMenu );
			min.AddSubMenuItem( "Insert Window", OnMenu );
			min.AddSubMenuItem( "Insert MenuItem", OnMenu );
			
			var v:CMenuItem = new CMenuItem( MenuPanel, "Debug" ) ;
			v.AddSubMenuItem("Dump XML", OnMenu );
			
			RootWidget = new CWidget( this, "Root" );
		
			
			//RootWidget.addEventListener( MouseEvent.MOUSE_DOWN, onRootDown );			
			//var SaveButton:CButton = new CButton( RootWidget, "Save XML" );
			//SaveButton.AddCallback( OnSaveXML );			
			//SaveButton.x = 128;
			//SaveButton.y = 48;
			/*
			var win:CWindow = new CWindow( RootWidget, "MyWindow" );
			win.AddCallback( ControllerCallback );
			win.x = 200;
			win.y = 200;
			//win.width = 128;			
			
			var btn:CButton = new CButton( win.Panel, "Button" );
			btn.AddCallback( ControllerCallback );
			win.Panel.addChild( btn );
			
			var btn2:CButton = new CButton( win.Panel, "Button 2" );
			btn2.AddCallback( ControllerCallback );
			win.Panel.addChild( btn2 );
			win.Panel.Layout();
			*/
			
			
			Properties = new CPropertiesInspector( this, "Properties" ) ;
			Properties.Resize( 200, 500 );
			Properties.x = stage.width-Properties.width - 10;
			Properties.y = GUI.SizeMenuItemHeight+4;
			Properties.AddCallback( PropertyCallback );
			
			//btn2.y = 48;
			
			DesignHandle = new CDesignerHandles2( null, "SCALER", null );
			DesignHandle.Serialise = false;
			DesignHandle.addEventListener( CDesignerHandles.CONTROL_RESIZE, onControlResize );
			
			
			addChild( MenuPanel ); //add the menu panel again so that it's on top;
			
			SetupRoot( );
			
			//test
			//GUI.LoadXML( "test.xml", win );
			//GUI.SaveXML( "test.xml" , win );
		}
		
		private function PropertyCallback( widget:CWidget, e:Event ):void
		{
			//refresh the handle
			if ( DesignHandle != null ) DesignHandle.SetTarget( DesignHandle.TargetWidget );			
		}
		
		protected function SetupRoot( ) : void
		{	
			RootWidget.y=0;
			RootWidget.LayoutOffset.y = 30;
			RootWidget.Resize(  stage.nativeWindow.width,  stage.nativeWindow.height );
			RootWidget.AddCallback( RootCallback );
			addChild( MenuPanel );
			addChild( Properties );
		}
		
		protected function onControlResize(event:Event):void
		{
			if ( DesignHandle.TargetWidget != null )
			{
				DesignHandle.ResizeTarget( );
				DesignHandle.SetTarget( DesignHandle.TargetWidget );
			}
		}
		
		protected function onRootDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			RootClicked = true;					
		}
		
		public function OnMenu( Widget:CWidget, e:Event ) : void
		{
			trace( Widget.name + " : " + e.toString() );
			
			var ParentWidget:CWidget = RootWidget;
			if ( SelectedWidget != null ) ParentWidget = SelectedWidget;
			
			switch ( Widget.name )
			{
				case "New" :
					ClearGUI();
				break;
				case "Insert Button" :
					var But:CButton = new CButton( ParentWidget, "Unnamed" );
					But.DesignMode = true;
					But.AddCallback( DesignerCallback );
					But.x = 0;
					But.y = 30;
				break;
				case "Insert Window":
					var win:CWindow = new CWindow( ParentWidget, "Unnamed Window" );
					win.DesignMode = true;
					win.AddCallback( DesignerCallback );
					win.x = 0;
					win.y = 30;
				break;
				case "Insert MenuItem":					
					if ( ParentWidget is CMenuItem )
					{
						var sm:CMenuItem = ParentWidget as CMenuItem ;
						sm.DesignMode = true;
						sm.AddSubMenuItem( "SubItem", DesignerCallback );
						sm.ShowSubItems(true );
						sm.AddCallback( DesignerCallback );
					}
					else
					{
						var mi:CMenuItem = new CMenuItem( ParentWidget, "Menu" );
						mi.DesignMode = true;
						mi.AddCallback( DesignerCallback );
						mi.x = 0;
						mi.y = 30;
					}
				break;
				case "Dump XML":
					var s:XML = GUI.ParseToXML( RootWidget, null );
					trace( s.toXMLString() );
				break;				
			}
			
			ParentWidget.Layout();			
		}
		
		public function RootCallback( Widget:CWidget, e:Event ) : void
		{
			trace( Widget.name + " : " + e.toString() );
			if ( e.eventPhase == 2 ) 
			{
				if ( RootWidget.contains( DesignHandle ))
				RootWidget.removeChild( DesignHandle );
			DesignHandle.SetTarget( null );
			Properties.SetTarget( null );
			SelectedWidget = null;
			}
		}
		
		public function DesignerCallback( Widget:CWidget, e:Event ) : void
		{
			trace( Widget.name + " : " + e.toString() );
			
			if (( Widget == RootWidget ) && ( RootClicked==false ))
			{
				if ( RootWidget.contains( DesignHandle ))
					RootWidget.removeChild( DesignHandle );
				DesignHandle.SetTarget( null );
				Properties.SetTarget( null );
			}
			else
			{
				RootWidget.addChild( DesignHandle );
				if ( Widget != RootWidget )
					DesignHandle.SetTarget( Widget );
			}
			RootClicked = false;
			SelectedWidget = Widget;
			Properties.SetTarget( SelectedWidget );
		}
		
		public function OnSaveXML( Widget:CWidget, e:Event ) : void
		{
			//trace( "Save XML:" );
			var xml:XML = <xml/>;
			var s:String = GUI.ParseToXML( RootWidget , xml ).toXMLString();
			//var f:File = File.documentsDirectory;
			//f = f.resolvePath( "windowxml.xml" );			
			fr.save( s, "windowxml.xml");
			//GUI.SaveXML( "windowxml.xml", getChildByName( "MyWindow" ) as CWidget );
		}
		
		public function OnLoadXML( Widget:CWidget, e:Event ) : void
		{
			var docFilter:FileFilter = new FileFilter("GUI Documents *.xml,*.gui", "*.xml;*.gui");

			var  success:Boolean = fr.browse([docFilter] );
			fr.addEventListener( Event.SELECT, onFileSelected );			
		}
		
		protected function onFileSelected(event:Event):void
		{
			// TODO Auto-generated method stub
			fr.load( );
			fr.addEventListener(Event.COMPLETE, onFileComplete );
			ClearGUI();
			removeChild( RootWidget );
			RootWidget = null;
		}
		
		protected function onFileComplete(event:Event):void
		{
			//GUI.LoadXML( fr., this );
			fr.removeEventListener( Event.COMPLETE, onFileComplete );
			var s:String = event.target.data ;
			//trace( "load complete " + s );
			GUI.LoadXMLFromString( s, this );
			RootWidget = this.getChildByName( "Root" ) as CWidget;
			SetupRoot( );
			
			SetupCallbacks( RootWidget ) ;
		}
		
		//Setup designer callbacks from a loaded file
		public function SetupCallbacks( parent:CWidget ) : void
		{
			for ( var i:int = 0; i< parent.numChildren; i++ )
			{
				var w:CWidget = parent.getChildAt(i) as CWidget;
				if ( w != null )
				{
					w.AddCallback( DesignerCallback );
					SetupCallbacks( w );
				}
			}
		}
		
		public function OnMergeXML( Widget:CWidget, e:Event ) : void
		{
			var docFilter:FileFilter = new FileFilter("GUI Documents *.xml,*.gui", "*.xml;*.gui");			
			var  success:Boolean = fr.browse([docFilter] );
			fr.addEventListener( Event.SELECT, onFileSelectedMerge );			
		}
		protected function onFileSelectedMerge(event:Event):void
		{
			// TODO Auto-generated method stub
			fr.load( );
			fr.addEventListener(Event.COMPLETE, onFileComplete );		
		}
		
		//Removes all widgets from the Root, leaving any other graphics
		protected function ClearGUI( ) : void
		{
			while ( RootWidget.numChildren >0 )
			{
				var w:CWidget = RootWidget.getChildAt(0 ) as CWidget;
				if ( w == null ) continue;
				RootWidget.removeChild( w );
				w.Dispose( );
				w = null;
			}
		}
		
	}
}