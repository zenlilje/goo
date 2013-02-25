package Designer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Goo.CWidget;
	import Goo.GUI;
	
	public class CDesignerHandles2 extends CWidget
	{
		public static const CONTROL_RESIZE:String = "CONTROL_RESIZE";
		
		public static const MODE_NONE:int = 0;
		public static const MODE_MOVE:int = 1;
		public static const MODE_RESIZETL:int = 2;
		public static const MODE_RESIZEBR:int = 3;
		
		public var Mode:int = MODE_NONE;
		
		public  var TargetWidget:CWidget = null;
		public var ClickPoint:Point = new Point( 0,0 );
		public var ClickBounds:Rectangle = new Rectangle(0,0, 1,1 );
		
		public function CDesignerHandles2(ParentWidget:Sprite, sName:String, TargetR:Rectangle=null)
		{
			super(ParentWidget, sName, TargetR);
		}
		
		public function Redraw( ) : void
		{
			graphics.clear();
			graphics.beginFill( 0xff0000, 0.1 );
			graphics.drawRect(0,0, Bounds.width, Bounds.height );
			
			graphics.beginFill( 0x000000 );
			graphics.drawRect( 0,0, GUI.SizeHandle, GUI.SizeHandle );
			graphics.beginFill( 0x000000 );
			graphics.drawRect( Bounds.width-GUI.SizeHandle,Bounds.height-GUI.SizeHandle, GUI.SizeHandle, GUI.SizeHandle );
		}
		
		public function SetTarget( w:CWidget ) : void
		{
			TargetWidget = w;
			if ( w == null ) return;
			
			Bounds = w.Bounds.clone();
			
			var pt:Point = w.localToGlobal( new Point (0,0) );			
			x = pt.x;
			y = pt.y;
			Redraw( );
			visible = true;
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			ClickPoint.x = event.stageX;
			ClickPoint.y = event.stageY;
			
			ClickBounds = TargetWidget.Bounds.clone();
			
			if (( event.localX < GUI.SizeHandle )
				&& ( event.localY < GUI.SizeHandle ))
			{
				Mode = MODE_RESIZETL ;
				startDrag( );
			}
			else			
			if (( event.localX > width - GUI.SizeHandle )
				&& ( event.localY > height-GUI.SizeHandle ))
			{
				Mode = MODE_RESIZEBR ;
			}
			else
			{
				Mode = MODE_MOVE ;
				startDrag( );
			}			
			
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{			
			//var pt:Point = localToGlobal( new Point( event.stageX, stageY) );
			if ( Mode == MODE_RESIZEBR )
			{
				Bounds.width = event.stageX - x;
				Bounds.height = event.stageY - y;
			}
			if ( Mode == MODE_RESIZETL )
			{				
				var pt:Point = TargetWidget.localToGlobal( new Point ( 0, 0 ) ); 
				//trace( pt.x - x );				
				Bounds.width = ClickBounds.width+ ( pt.x-x ) ;
				Bounds.height = ClickBounds.height+ ( pt.y-y );
				//TargetWidget.Resize( width, height );
			}
			
			Redraw( );
			//ResizeTarget( );
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stopDrag( );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			ResizeTarget( );
		}
		
		public function ResizeTarget( ) : void
		{
			if ( TargetWidget == null ) return;
			var pt:Point = TargetWidget.parent.globalToLocal( new Point ( x,y ));
			if ( Mode == MODE_MOVE )
			{
				TargetWidget.x = pt.x;
				TargetWidget.y = pt.y;
			}
			if ( Mode == MODE_RESIZETL )
			{
				TargetWidget.x = pt.x;
				TargetWidget.y = pt.y;
				TargetWidget.Resize( width, height );
			}
			if ( Mode == MODE_RESIZEBR )
			{				
				TargetWidget.Resize( width, height );
			}
			TargetWidget.Layout();
			
		}
	}
}