
package pixeldroid.logging.appenders.console
{
	import flash.ui.Keyboard;


	/**
	 * Simple value object to hold the various configurable values for ConsoleAppender.
	 */
	public class ConsoleAppenderProperties
	{
		/**
		 * Max number of recent lines to retain in the buffer.
		 * Oldest lines are purged when this limit is reached.
		 */
		public var bufferSize:int = 64;

		/**
		 * Width of console (pixels)
		 */
		public var width:Number = 780;

		/**
		 * Height of console (pixels)
		 */
		public var height:Number = 200;

		/**
		 * Background color
		 */
		public var backColor:uint = 0x000000;

		/**
		 * Background opacity.
		 * 1 is completely opaque; 0 is completely transparent.
		 */
		public var backAlpha:Number = .8;

		/**
		 * Line height (pixels)
		 */
		public var fontSize:Number = 16;

		/**
		 * Font leading (pixels)
		 */
		public var leading:int = 2;

		/**
		 * Text color
		 */
		public var foreColor:uint = 0xffffff;

		/**
		 * Keycode value for key that toggles console visibility (hide / show).
		 */
		public var hideKeyCode:uint = '`'.charCodeAt(0);

		/**
		 * Keycode value for key that clears the console of log entries.
		 */
		public var clearKeyCode:uint = Keyboard.BACKSPACE;

		/**
		 * Human readable instructions for using the console
		 */
		public var usage:String = "Console Usage :\n" + "  tick (`) toggles hide\n" + "  ctrl-tick toggles pause\n" + "  ctrl-bkspc clears";
	}
}
