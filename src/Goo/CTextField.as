package Goo
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	//import flashx.textLayout.formats.TextAlign;
	
	//import org.osmf.media.DefaultMediaFactory;
	
	public class CTextField extends CWidget
	{
		
		private var Text:TextField = new TextField();
		private var _TextAlign:String = TextFormatAlign.LEFT;
		private var _type:String = TextFieldType.DYNAMIC;
		
		
		public function CTextField( ParentWidget:Sprite, sName:String)
		{
			super(ParentWidget, sName);
		}
		
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			Create( );
		}

		public function get TextAlign():String
		{
			return _TextAlign;
		}

		public function set TextAlign(value:String):void
		{
			_TextAlign = value;
			Create( );
		}

		public override function Create( ) : void
		{
			super.Create( );
			graphics.clear( );
			
			var tf:TextFormat = Text.defaultTextFormat;
			tf.font = "Arial";
			tf.align = _TextAlign; //TextAlign for Air 3.1
			//Text.border = true;
			//Text.borderColor = 0xff0000;
			Text.defaultTextFormat = tf;
			//Text.background = true;
			//Text.backgroundColor = 0xff0000 ;
			//Text.border = true;
			//Text.borderColor = 0x000000;
			Text.text = name;
			Text.type = _type;
			
			if ( _type ==TextFieldType.INPUT )
			{
				Text.selectable = true;	
				Text.mouseEnabled = true;
			}
			else
			{
				Text.selectable = false;
				Text.mouseEnabled = false;
			}
			
			
			addChild( Text );
			this.mouseEnabled = false;
		}
		
		public function get defaultTextFormat() : TextFormat
		{
			return Text.defaultTextFormat;
		}
		
		public function get text( ) : String
		{
			return Text.text;
		}
		
		public function set text( s:String ) : void
		{
			Text.text = s;
		}
		public override function set width( n:Number ) : void
		{
			Text.width= n;
		}
		public override function set height( n:Number ) : void
		{
			Text.height= n;
		}
		
		public function set autoSize( s:String ) : void
		{
			Text.autoSize = s;
		}
		
		public function set selectable( b:Boolean ) : void
		{
			Text.selectable = b;
		}
		
		public function set align( s:String ) : void
		{
			var tf:TextFormat = Text.defaultTextFormat;
			tf.align = s
			Text.defaultTextFormat = tf;
			Text.text = Text.text; //redo the text to apply the format
		}
		
		public function set bold( b:Boolean ) : void
		{
			var tf:TextFormat = Text.defaultTextFormat;
			tf.bold = b
			Text.defaultTextFormat = tf;
			Text.text = Text.text; //redo the text to apply the format
		}
	}
}