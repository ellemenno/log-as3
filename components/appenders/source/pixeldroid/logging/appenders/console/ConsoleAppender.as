
package pixeldroid.logging.appenders.console
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import pixeldroid.logging.ILogAppender;
	import pixeldroid.logging.ILogConfig;
	import pixeldroid.logging.ILogEntry;
	import pixeldroid.logging.LogUtils;


	/**
	 * Implements a simple on-screen display for viewing run-time text messages.
	 *
	 * <p>
	 * New messages accumulate at the bottom of the console,
	 * old messages roll off the top.
	 * </p>
	 *
	 * <p>
	 * The console can be hidden, shown, paused, resumed, and cleared. Text in the console is selectable
	 * so it can be copied to the clipboard. Text in the console may be saved to file via the context menu.
	 * </p>
	 *
	 * <p>
	 * The buffer size is also configurable. As the buffer fills up, oldest lines are discarded first.
	 * </p>
	 *
	 * <p>
	 * The console is scrollable by dragging a selection inside it with the cursor,
	 * or clicking to give it focus and using the arrow keys, but does not provide a scrollbar.
	 * </p>
	 *
	 * @example The following code shows a simple console instantiation;
	 * see the constructor documentation for more options:
	 * <listing version="3.0" >
	 * package {
	 *    import pixeldroid.logging.appenders.console.ConsoleAppender;
	 *    import flash.display.Sprite;
	 *
	 *    public class MyConsoleExample extends Sprite {
	 * 	  public var console:ConsoleAppender = new ConsoleAppender();
	 * 	  public function MyConsoleExample() {
	 * 		 super();
	 * 		 addChild(console);
	 * 		 info("Console added and ready");
	 * 	  }
	 *    }
	 * }
	 * </listing>
	 */
	public class ConsoleAppender extends Sprite implements ILogAppender
	{

		/**
		 * Monospaced font used to display messages logged to the console.
		 *
		 * <p>"ProggyTiny.ttf", Copyright 2004 by Tristan Grimmer.</p>
		 *
		 * @see http://proggyfonts.com/index.php?menu=download
		 */
		[Embed(mimeType="application/x-font", source="ProggyTiny.ttf", fontName="FONT_CONSOLE", embedAsCFF="false")]
		public static var FONT_CONSOLE:Class;

		protected var background:Shape;
		protected var console:TextField;
		protected var loggingPaused:Boolean;

		protected var _properties:ConsoleAppenderProperties;


		/**
		 * Create a new Console with optional parameters.
		 *
		 * @param properties Optional instance of ConsoleAppenderProperties for custom settings
		 *
		 * @see pixeldroid.logging.appenders.console.ConsoleAppenderProperties
		 */
		public function ConsoleAppender(properties:ConsoleAppenderProperties = null)
		{
			super();

			_properties = properties || new ConsoleAppenderProperties();
			loggingPaused = true;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		/**
		 * Append a message to the bottom of the console, scrolling older content up.
		 *
		 * @param logEntry Entry containing message to log
		 * @param config Logging configuration defining message formatting pattern
		 */
		public function append(logEntry:ILogEntry, config:ILogConfig):void
		{
			consoleAppend(LogUtils.formatString(config.pattern, logEntry));
		}


		/**
		 * Clear all messages from the console.
		 */
		public function clear():void
		{
			console.replaceText(0, console.length, "");
		}


		/**
		 * Hide the console. Messages are still received.
		 */
		public function hide():void
		{
			visible = false;
		}


		/**
		 * Pause the console. Messages received while paused are ignored.
		 */
		public function pause():void
		{
			consoleAppend("<PAUSE>");
			loggingPaused = true;
		}

		/** @private */
		public function get properties():ConsoleAppenderProperties  { return _properties; }


		/**
		 * The current console property values for color, dimension, buffersize, etc.
		 */
		public function set properties(value:ConsoleAppenderProperties):void
		{
			_properties = value;
			applyProperties();
		}


		/**
		 * Resume the console.
		 */
		public function resume():void
		{
			loggingPaused = false;
			consoleAppend("<RESUME>");
		}


		/**
		 * Show the console.
		 */
		public function show():void
		{
			visible = true;
		}


		/**
		 * The currently configured human readable instructions for manipulating the console.
		 */
		public function get usage():String
		{
			return _properties.usage;
		}


		/**
		 * Apply the current property values to the configurable console parts
		 */
		protected function applyProperties():void
		{
			background.graphics.clear();
			background.graphics.beginFill(_properties.backColor, _properties.backAlpha);
			background.graphics.drawRect(0, 0, _properties.width, _properties.height);
			background.graphics.endFill();

			const format:TextFormat = new TextFormat();
			format.font = "FONT_CONSOLE";
			format.color = _properties.foreColor;
			format.size = _properties.fontSize;
			format.align = TextFormatAlign.LEFT;
			format.leading = _properties.leading;

			const oldText:String = console.text;
			clear();

			console.antiAliasType = (format.size > 24) ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			console.gridFitType = GridFitType.PIXEL;
			console.embedFonts = true;
			console.defaultTextFormat = format;
			console.multiline = true;
			console.selectable = true;
			console.wordWrap = true;
			console.width = _properties.width;
			console.height = _properties.height;

			const oldState:Boolean = loggingPaused;
			loggingPaused = false;
			consoleAppend(oldText);
			loggingPaused = oldState;
		}


		/**
		 * Do the actual work of adding text to the end of the textfield and
		 * keeping scrolled to the bottom
		 */
		protected function consoleAppend(message:String):void
		{
			if (loggingPaused == false)
			{
				console.appendText(message + "\n");
				const overage:int = console.numLines - _properties.bufferSize;
				if (overage > 0)
					console.replaceText(0, console.getLineOffset(overage), "");
				console.scrollV = console.maxScrollV;
			}
		}


		/**
		 * Watches for keyboard hotkeys.
		 * By default:
		 * <ul>
		 * <li>tick (`) toggles hide</li>
		 * <li>ctrl-tick toggles pause</li>
		 * <li>ctrl-bkspc clears</li>
		 * </ul>
		 */
		protected function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.charCode == _properties.hideKeyCode)
			{
				if (e.ctrlKey == true)
					toggleLog();
				else
					toggleVis();
			}
			else if ((e.keyCode == _properties.clearKeyCode) && (e.ctrlKey == true))
				clear();
		}

		/**
		 * Initialize
		 */
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);

			addChild(background = new Shape());
			addChild(console = new TextField());
			applyProperties();

			loggingPaused = false;

			consoleAppend("");
			consoleAppend(_properties.usage);
			consoleAppend("");
		}

		protected function toggleLog():void  {(loggingPaused == true) ? resume() : pause(); }

		protected function toggleVis():void  {(visible == false) ? show() : hide(); }
	}

}
