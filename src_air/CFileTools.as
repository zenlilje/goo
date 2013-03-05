package 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import Goo.CWidget;
	import Goo.GUI;

	public class CFileTools
	{
		public function CFileTools()
		{
		}
		
		public static function SaveXML( sFile:String, SourceWidget:CWidget ) : void
		{
			var f:File = File.documentsDirectory;
			f = f.resolvePath( sFile );
			var fs:FileStream = new FileStream();
			var sa:Array = new Array( );
			var root:XML = <xml />;			
			var s:String = GUI.ParseToXML( SourceWidget , root ).toXMLString();
			//trace( s );
			sa.push( s );
			
			fs.open( f, FileMode.WRITE );
			fs.writeUTFBytes( sa.join("\n" ) );
			fs.close( );
		}
	}
}