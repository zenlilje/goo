package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CWindowTools
	{
		public function CWindowTools()
		{
		}
		
		public static function SetupWindow( stage:Stage ) : void
		{
			//noimp, flash movie fits the player container
		}
		
		/*
		 *  Creates a new flash window and adds it to the parent
		 */
		public static function NewWindow( parent:Sprite ) : MovieClip
		{			
			var nheader: MovieClip = new MovieClip( );
			nheader.graphics.beginFill(0xffffff );
			nheader.graphics.drawRect(0,0, parent.width/2, 32 );
			parent.addChild( nheader );
			nheader.visible = true;
			
			//add a close button
			var c:MovieClip = new MovieClip( );
			with ( c.graphics )
			{
				beginFill( 0xaaaaaa );
				drawRect( 0,0, 16, 16 );
				lineStyle( 1, 0x000000 );
				moveTo( 1,1);
				lineTo( 16, 16 );
				moveTo( 1, 16 );
				lineTo( 16, 1 );
			}
			nheader.addChild( c );
			c.y = 0;			
			c.addEventListener( MouseEvent.CLICK, onCloseClick );
			
			//main area to add widgets
			var nroot = new MovieClip();
			nroot.graphics.beginFill( 0xffffff );
			nroot.graphics.lineStyle( 1, 0xaaaaaa );
			nroot.graphics.drawRect( -16,-16, parent.width/2, parent.height/2 );
			
			nroot.graphics.endFill( );
			nheader.addChild( nroot );
			nroot.x = 0;
			nroot.y = 32;
			
			return nroot;
		}
		
		public static function onCloseClick( e:MouseEvent ) : void
		{
			trace( "!!!" );
			var m : Sprite =  e.target as Sprite;
			m.removeEventListener( MouseEvent.CLICK, onCloseClick );
			m.parent.parent.removeChild( m.parent );
			m.parent.visible = false;
			m = null;
		}
	}
}