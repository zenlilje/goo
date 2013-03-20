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
		
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import Goo.CButton;
	import Goo.CLabel;
	import Goo.CList;
	import Goo.CMenuItem;
	import Goo.CPanel;
	import Goo.CStatusBar;
	import Goo.CTextField;
	import Goo.CWidget;
	import Goo.CWindow;
	import Goo.GUI;
	import Goo.Keys;
	
	
	public class GUIDesigner extends Sprite
	{		
		private var WidgetToCreate:CWidget = null;
		private var fr:FileReference = new FileReference( );
		//private var MainWidget:CWidget = null;
		private var RootWidget:CWidget = null;
		private var MenuPanel:CPanel = null;
		private var RootClicked:Boolean = false;
		private var SelectedWidget:CWidget = null;
		private var DesignHandle:CDesignerHandles = null;
		private var Properties:CPropertiesInspector = null;
		
		private const STATE_MOVE:String = "STATE_MOVE";
		private const STATE_SCALE:String = "STATE_SCALE"; 
		private var State:String = STATE_MOVE;
		
		private var WidgetCount:int = 0;
		
		
		public function GUIDesigner()
		{
			trace( "GUIDesigner" );
			CWindowTools.SetupWindow( stage );
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			MenuPanel = new CPanel( this, "MenuPanel" ) ;
			MenuPanel.Resize( stage.stageWidth, GUI.SizeMenuItemHeight+2 );			
			
			var mi:CMenuItem = new CMenuItem( MenuPanel, "File" ) ;
			mi.AddCallback( OnMenu );
			mi.AddSubMenuItem( "New", OnMenu );
			mi.AddSubMenuItem( "Open", OnLoadXML );
			mi.AddSubMenuItem( "Save", OnSaveXML );
			mi.AddSubMenuItem( "Merge", OnMergeXML );
			
			var me:CMenuItem = new CMenuItem( MenuPanel, "Edit" ) ;
			me.AddCallback( OnMenu );			
			me.AddSubMenuItem( "Delete", OnMenu );
			me.AddSubMenuItem( "Copy", OnMenu );
			me.AddSubMenuItem( "Paste", OnMenu );
			
			var min:CMenuItem = new CMenuItem( MenuPanel, "Insert" ) ;
			min.AddCallback( OnMenu );
			
			min.AddSubMenuItem( "Insert Button", OnMenu );
			min.AddSubMenuItem( "Insert Label", OnMenu );
			min.AddSubMenuItem( "Insert List", OnMenu );
			min.AddSubMenuItem( "Insert MenuItem", OnMenu );
			min.AddSubMenuItem( "Insert Panel", OnMenu );
			min.AddSubMenuItem( "Insert StatusBar", OnMenu );
			min.AddSubMenuItem( "Insert Window", OnMenu );
			
			var v:CMenuItem = new CMenuItem( MenuPanel, "Debug" ) ;
			v.AddSubMenuItem("Test", OnMenu );
			v.AddSubMenuItem("Show XML", OnMenu );
			v.AddSubMenuItem("Trace XML", OnMenu );
			
			RootWidget = new CWidget( this, "Root" );
			RootWidget.y = GUI.SizeMenuItemHeight;	
			
			Properties = new CPropertiesInspector( this, "Properties" ) ;
			Properties.Caption = "Properties";
			Properties.Resize( 200, 500 );
			Properties.x = stage.width-Properties.width - 10;
			Properties.y = GUI.SizeMenuItemHeight+4;
			Properties.AddCallback( PropertyCallback );
			//btn2.y = 48;
			
			DesignHandle = new CDesignerHandles( null, "SCALER", null );
			DesignHandle.Serialise = false;
			DesignHandle.addEventListener( CDesignerHandles.CONTROL_RESIZE, onControlResize );			
			
			addChild( MenuPanel ); //add the menu panel again so that it's on top;
			
			var sb:CStatusBar = new CStatusBar( this, "Status" );
			sb.y = (stage.stageHeight ) - MenuPanel.Bounds.height;
			//sb.y = 100;
			addChild( sb );
			
			SetupRoot( );
			
			SetupEvents( );
			
			//test
			//GUI.LoadXML( "test.xml", win );
			//GUI.SaveXML( "test.xml" , win );
		}
		
		private function SetupEvents():void
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );			
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			trace( event.keyCode );
			if ( event.keyCode == Keys.KEY_DELETE )
			{
				DeleteSelected();	
			}
		}
		
		private function PropertyCallback( widget:CWidget, e:Event ):void
		{
			//refresh the handle
			if ( DesignHandle != null ) DesignHandle.SetTarget( DesignHandle.TargetWidget );			
		}
		
		protected function SetupRoot( ) : void
		{	
			RootWidget.y=GUI.SizeMenuItemHeight+ 5;
			RootWidget.LayoutOffset.y = 30;
			RootWidget.Resize(  stage.stageWidth,  stage.stageHeight );
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
				case "Delete" :
					DeleteSelected( );					
				break;
				case "Copy" :
					if ( SelectedWidget != null )
					{
						//var cdata:String = SelectedWidget.ToXML().toXMLString();
						var xml:XML = <xml/>;
						var cdata:String = GUI.ParseToXML(SelectedWidget, xml);
						//cdata = "<xml>" + cdata + "</xml>";
						//trace( cdata );
						Clipboard.generalClipboard.setData( ClipboardFormats.HTML_FORMAT, cdata, true);
					}
				break;
				case "Paste" :
				{
					var data:String = Clipboard.generalClipboard.getData( ClipboardFormats.HTML_FORMAT ) as String;					
					GUI.LoadXMLIntoWidget( data, ParentWidget );
					SetupCallbacks( ParentWidget );
					//trace( data );
				}
				break;
				case "Insert Panel" :
					var pan:CPanel = new CPanel ( ParentWidget, "Unnamed" );
					pan.DesignMode = true;
					pan.AddCallback( DesignerCallback );
					pan.x = 0;
					pan.y = 0;
					Baptize( pan );
					SelectWidget( pan );					
				break;
				case "Insert Button" :
					var But:CButton = new CButton( ParentWidget, "Unnamed" );
					But.DesignMode = true;
					But.AddCallback( DesignerCallback );
					But.x = 0;
					But.y = 0;
					Baptize( But );
					SelectWidget( But );					
				break;
				case "Insert Label" :
					var tf:CLabel = new CLabel( ParentWidget, "Unnamed" );
					tf.DesignMode = true;					
					tf.AddCallback( DesignerCallback );
					Baptize( tf );
					SelectWidget( tf );
				break;
				case "Insert List" :
					var lst:CList = new CList( ParentWidget, "Unnamed" );
					lst.DesignMode = true;
					lst.AddCallback( DesignerCallback );
					Baptize( lst );
					SelectWidget( lst );
				break;
				case "Insert Window":
					var win:CWindow = new CWindow( ParentWidget, "Unnamed Window" );
					win.DesignMode = true;
					win.AddCallback( DesignerCallback );
					win.x = 0;
					win.y = 0;
					Baptize( win );
					SelectWidget( win );					
				break;
				case "Insert MenuItem":					
					if ( ParentWidget is CMenuItem )
					{
						var sm:CMenuItem = ParentWidget as CMenuItem ;
						sm.DesignMode = true;
						var mit:CMenuItem = sm.AddSubMenuItem( "SubItem", DesignerCallback );
						sm.ShowSubItems(true );
						sm.AddCallback( DesignerCallback );
						Baptize( mit );
						//SelectWidget ( mit );
					}
					else
					{
						var mi:CMenuItem = new CMenuItem( ParentWidget, "Menu" );
						mi.DesignMode = true;
						mi.AddCallback( DesignerCallback );
						mi.x = 0;
						mi.y = 0;
						Baptize( mi );
						SelectWidget ( mi );
					}					
										
				break;
				case "Insert StatusBar":
					var sb:CStatusBar = new CStatusBar( ParentWidget, "Status" );
					sb.DesignMode = true;s
					sb.AddCallback( DesignerCallback );
					Baptize( sb );
					SelectWidget( sb );
				break;				
				case "Trace XML":
					var s:XML = GUI.ParseToXML( RootWidget, null );
					trace( s.toXMLString() );
				break;		
				case "Show XML":
					DumpXMLToScreen( );
				break;
				case "Test":
					CreateTestWindow( );
				break;
			}
			
			ParentWidget.Layout();			
		}
		
		/**
		 * Gives a unique(ish) name to the widget 
		 * @param Widget
		 * 
		 */		
		private function Baptize(Widget:CWidget):void
		{
			WidgetCount++;
			Widget.name = Widget.Type + WidgetCount;			
		}
		
		private function CreateTestWindow():void
		{			
			//gather xml
			var xml:XML = <xml/>;
			var s:XML = GUI.ParseToXML( RootWidget, xml );
			s.widget.y = 0;
			
			var nroot:MovieClip = CWindowTools.NewWindow( this );			
			GUI.LoadXMLIntoWidget( s, nroot );			
		}
		
		private function DumpXMLToScreen() : void
		{
			var xml:XML = <xml/>;
			var s:XML = GUI.ParseToXML( RootWidget, xml );
			s.widget.y = 0;
			
			var nroot:MovieClip = CWindowTools.NewWindow( this );
			var tf:TextField = new TextField( );
			tf.type = TextFieldType.INPUT;
			nroot.addChild( tf );
			tf.width = nroot.width;
			tf.height= nroot.height;
			tf.text = s.toXMLString();
			nroot.visible = true;
		}
		
		private function DeleteSelected():void
		{
			if ( SelectedWidget != null )
			{
				SelectedWidget.parent.removeChild( SelectedWidget );
				if ( SelectedWidget.parent is CWidget ) 
				{
					var w:CWidget = SelectedWidget.parent as CWidget;
					w.Layout();
				}
				SelectedWidget.Dispose( );
				SelectWidget( null );
				
			}			
		}
		
		public function SelectWidget( Widget:CWidget ) : void
		{			
			if ( Widget == null ) 
			{
				if ( RootWidget.contains( DesignHandle ))
					RootWidget.removeChild( DesignHandle );				
			}
			else
			{
				RootWidget.addChild( DesignHandle );
				if ( Widget != RootWidget )
					DesignHandle.SetTarget( Widget );
			}
			Properties.SetTarget( Widget );
			SelectedWidget = Widget;
		}
		
		
		public function RootCallback( Widget:CWidget, e:Event ) : void
		{
			trace( Widget.name + " : " + e.toString() );
			if ( e.eventPhase == 2 ) 
			{
				if ( RootWidget.contains( DesignHandle ))
				RootWidget.removeChild( DesignHandle );
				SelectWidget( null );
			}
		}
		
		public function DesignerCallback( Widget:CWidget, e:Event ) : void
		{
			trace( Widget.name + " : " + e.toString() );
			e.stopImmediatePropagation();
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
			GUI.LoadXMLIntoWidget( s, this );
			RootWidget = this.getChildByName( "Root" ) as CWidget;
			SetupRoot( );
			
			SetupCallbacks( RootWidget ) ;
		}
		
		//recursively setup designer callbacks from a loaded file
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