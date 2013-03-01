package Designer
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import Goo.CTextField;
	import Goo.CWidget;
	import Goo.GUI;
	
	public class CProperty extends CWidget
	{
		private var NameBox:CTextField = null;
		private var ValueBox:CTextField = null ;
		private var TargetWidget:CWidget = null;
		
		public function CProperty(ParentWidget:Sprite, sName:String, TargetR:Rectangle=null)
		{
			NameBox = new CTextField( this, "NameBox" );
			ValueBox = new CTextField( this, "ValueBox" );
			
			super(ParentWidget, sName, TargetR);
						
			NameBox.width = 64;
			NameBox.height = GUI.SizeListItemHeight;
			NameBox.selectable = false;
			
			ValueBox.Resize( ParentWidget.width - NameBox.width, GUI.SizeListItemHeight );
			addChild( NameBox );
			addChild( ValueBox );
			ValueBox.x = NameBox.width;			
			ValueBox.type = TextFieldType.INPUT;
			ValueBox.background = true;
			ValueBox.addEventListener( Event.CHANGE, onChange );
		}
		
		public override function Create( ) : void
		{
			graphics.clear( );
			//graphics.beginFill(GUI.ColorWindow) ;
			//graphics.drawRect(0,0, Bounds.width, Bounds.height );
			graphics.lineStyle(1, GUI.ColorBorder );
			graphics.moveTo( 5, GUI.SizeListItemHeight );
			graphics.lineTo( width, GUI.SizeListItemHeight );
			//graphics.endFill();
			NameBox.width = 64;
			ValueBox.width = parent.width - NameBox.width;
		}
		
		protected function onChange(event:Event):void
		{
			if ( TargetWidget != null )
			{
				if ( TargetWidget.hasOwnProperty(NameBox.text) == true )
				{
					if( TargetWidget[NameBox.text] is String ) TargetWidget[NameBox.text] = ValueBox.text;
					if( TargetWidget[NameBox.text] is int) TargetWidget[NameBox.text] = int(ValueBox.text);
					if( TargetWidget[NameBox.text] is Number) TargetWidget[NameBox.text] = Number(ValueBox.text);
					TargetWidget.Create();
				}
			}
			if ( Callback != null ) Callback( this, event );
		}
		
		public function SetProperty( sLabel:String, Item:CWidget ): void
		{
			TargetWidget = Item;
			NameBox.text = sLabel;
			if ( TargetWidget.hasOwnProperty(sLabel) == true )
			{
				ValueBox.text = TargetWidget[sLabel].toString();
			}
		}
	}
}