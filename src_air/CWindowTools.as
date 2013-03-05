package
{
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class CWindowTools
	{
		public function CWindowTools()
		{
		}
		
		public static function SetupWindow( stage:Stage ) : void
		{
			stage.nativeWindow.width = 800;
			stage.nativeWindow.height= 800;			
		}
		
		/**
		 * Creates a new nativewindow and returns a movieclip added 
		 * @return 
		 * 
		 */		
		public static function NewWindow( parent:Sprite ) : MovieClip
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();			
			var n:NativeWindow = new NativeWindow( options );
			//create a root movieclip
			var nroot:MovieClip = new MovieClip();
			nroot.graphics.beginFill(0xffffff );
			nroot.graphics.drawRect(0,0, n.width, n.height );
			n.stage.addChild( nroot );
			n.stage.scaleMode = StageScaleMode.NO_SCALE;
			n.stage.align = StageAlign.TOP_LEFT;			
			n.visible = true;
			nroot.NativeWindow = n;
			return nroot;
		}
	}
}