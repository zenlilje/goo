package Designer
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Goo.CWidget;
	
	public class CDesignerHandles extends MovieClip
	{
		protected var SizeHandleTL:MovieClip = new MovieClip( );
		protected var SizeHandleBR:MovieClip = new MovieClip( );
		protected var Cover:MovieClip = new MovieClip( );
		public var TargetWidget:CWidget = null;
		public var Dragging:Boolean = false;
		public var TargetRect:Rectangle = new Rectangle( 0,0, 320, 240 );
		
		public static const MODE_SCALETL:int = 1;
		public static const CONTROL_RESIZE:String = "CONTROL_RESIZE"; 
		public var Mode:int = MODE_SCALETL; // 
		
		public function CDesignerHandles()
		{
			super();
			DrawHandles();
			SetupEvents( );
			
			addChild( Cover );
			SizeHandleTL.graphics.clear( );
			SizeHandleTL.graphics.beginFill( 0x000000 );
			SizeHandleTL.graphics.drawRect(0,0, 16, 16 );			
			addChild( SizeHandleTL );
			SizeHandleBR.graphics.clear( );
			SizeHandleBR.graphics.beginFill( 0 );
			SizeHandleBR.graphics.drawRect( -8,-8, 16, 16 );
			SizeHandleBR.x = 230;
			SizeHandleBR.y = 230;
			addChild( SizeHandleBR );
		}
				
		public function DrawHandles( ) : void
		{
			//if ( contains (SizeHandleTL ) ) removeChild( SizeHandleTL );
			
			if ( TargetWidget != null )
			{
				//TargetRect.x = TargetWidget.x;
				//TargetRect.y = TargetWidget.y;
				//TargetRect.width = TargetWidget.width;
				//TargetRect.height = TargetWidget.height;
				Cover.graphics.clear();
				Cover.graphics.beginFill(0xff0000, 0.1 );
				Cover.graphics.drawRect( 0,0, TargetRect.width, TargetRect.height );
				Cover.mouseChildren = false;
				//Cover.x = SizeHandleTL.x;
				//Cover.y = SizeHandleTL.y;
				//SizeHandleBR.x = TargetRect.width;
				//SizeHandleBR.y = TargetRect.height;
				
			}
			
			//addChild( SizeHandleTL );
			//SizeHandleBR.x = TargetRect.width; 
			//SizeHandleBR.y = TargetRect.height;
			//addChild( SizeHandleBR );
		}
		
		private function SetupEvents( ) : void
		{
			SizeHandleTL.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			SizeHandleTL.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			SizeHandleBR.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			SizeHandleBR.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			Cover.addEventListener( MouseEvent.MOUSE_DOWN, onCoverMouseDown );
			Cover.addEventListener( MouseEvent.MOUSE_UP, onCoverMouseUp );
			
			//SizeHandleT
		}
		
		protected function onCoverMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			/*
			SizeHandleTL.x = 0;
			SizeHandleTL.y = 0;
			SizeHandleBR.x = Cover.width;
			SizeHandleBR.y = Cover.height;
			
			this.TargetRect.x = SizeHandleTL.x;
			this.TargetRect.y = SizeHandleTL.y;
			this.TargetRect.width = SizeHandleBR.x - SizeHandleTL.x;
			this.TargetRect.height = SizeHandleBR.y - SizeHandleTL.y;
			*/
		}
		
		protected function onCoverMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Cover.stopDrag();
			DrawHandles();
			Cover.removeEventListener( MouseEvent.MOUSE_MOVE, onCoverMouseMove );
			dispatchEvent( new Event( CONTROL_RESIZE ) );
		}
		
		protected function onCoverMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Cover.startDrag();
			Cover.addEventListener( MouseEvent.MOUSE_MOVE, onCoverMouseMove );
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{			
			if ( Dragging == true )
			{
				if ( TargetWidget != null )
				{
					//TargetWidget.x = event.stageX;
					//TargetWidget.y = event.stageY;
					//TargetRect.width = TargetRect.width - (TargetRect.x-event.stageX);
					//TargetRect.x = event.stageX;
					//TargetRect.y = event.stageY;					
					//this.x = event.stageX;
					//this.y = event.stageY;					
					SetTargetRect( );
					DrawHandles( );
				}
			}
		}
		
		protected function SetTargetRect( ) : void
		{
			this.TargetRect.x = SizeHandleTL.x;
			this.TargetRect.y = SizeHandleTL.y;
			this.TargetRect.width = SizeHandleBR.x - SizeHandleTL.x;
			this.TargetRect.height = SizeHandleBR.y - SizeHandleTL.y;
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			var w:MovieClip = event.target as MovieClip;
			w.startDrag( );
			Dragging = true;
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			var w:MovieClip = event.target as MovieClip;
			w.stopDrag();
			Dragging = false;
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			dispatchEvent( new Event( CONTROL_RESIZE ) );
			SetTargetRect();
			DrawHandles();
			
			x = SizeHandleTL.x;
			y = SizeHandleTL.y;
			//TargetRect.width = 
		}		
		
		//public function 
		
		public function ResizeTarget( ) : void
		{
			if ( TargetWidget == null ) return;
			
			var pt:Point = SizeHandleTL.localToGlobal( new Point ( 0,0 ) );
			var tpt:Point = TargetWidget.parent.globalToLocal( pt );
			TargetWidget.x = tpt.x;
			TargetWidget.y = tpt.y ;
			TargetWidget.Resize( TargetRect.width, TargetRect.height );
		}
		
		public function SetTarget( w:CWidget ) : void
		{
			TargetWidget = w;
			if ( w != null )
			{
				TargetRect.x = TargetWidget.x;
				TargetRect.y = TargetWidget.y;
				
				TargetRect.width = TargetWidget.width;
				TargetRect.height= TargetWidget.height;
				SizeHandleTL.x = 0;
				SizeHandleTL.y = 0;
				SizeHandleBR.x = TargetWidget.width;
				SizeHandleBR.y = TargetWidget.height;
				
				var pt:Point = w.localToGlobal( new Point ( 0,0 ));
				
				this.x = pt.x;
				this.y = pt.y - TargetWidget.parent.y;
				DrawHandles( );
			}
			
		}
	}
}