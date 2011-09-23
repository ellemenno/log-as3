
package
{
	import flash.display.Sprite;
	
	import pixeldroid.logging.Logger;
	import pixeldroid.logging.LogLevel;
	
	public class TestStandard extends Sprite
	{
	
		public function TestStandard()
		{
			super();
			
			Logger.instance.fatal(this, "{0} log message", "fatal");
			Logger.instance.error(this, "{0} log message", "error");
			Logger.instance.warn(this, "{0} log message", "warn");
			Logger.instance.info(this, "{0} log message", "info");
			Logger.instance.debug(this, "{0} log message", "debug");
			
			Logger.instance.log(LogLevel.FATAL, this, "{0} log message", "log:FATAL");
			Logger.instance.log(LogLevel.ERROR, this, "{0} log message", "log:ERROR");
			Logger.instance.log(LogLevel.WARN, this, "{0} log message", "log:WARN");
			Logger.instance.log(LogLevel.INFO, this, "{0} log message", "log:INFO");
			Logger.instance.log(LogLevel.DEBUG, this, "{0} log message", "log:DEBUG");
		}
	}
}
