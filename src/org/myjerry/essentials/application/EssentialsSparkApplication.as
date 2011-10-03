/**
 *
 * Essentials - Core utilities for Adobe AIR desktop application development
 * Copyright (C) 2011, myJerry Developers
 * http://www.myjerry.org/essentials
 *
 * The file is licensed under the the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.myjerry.essentials.application {
	
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	
	import mx.events.AIREvent;
	import mx.events.ResizeEvent;
	
	import org.myjerry.as3extensions.IDisposable;
	import org.myjerry.as3utils.AssertUtils;
	import org.myjerry.as3utils.StringUtils;
	import org.myjerry.essentials.Essentials;
	import org.myjerry.essentials.application.BaseEssentialsApplication;
	import org.myjerry.essentials.config.AppConfig;
	import org.myjerry.essentials.config.EssentialsConfiguration;
	import org.myjerry.as3utils.StringUtils;
	
	import spark.components.WindowedApplication;
	
	public class EssentialsSparkApplication extends BaseEssentialsApplication implements IDisposable {
		
		/**
		 * The instance of the Spark windowed application over which we work
		 */
		private var application:WindowedApplication = null;
		
		/**
		 * The contructor
		 */
		public function EssentialsSparkApplication(app:WindowedApplication, configuration:AppConfig) {
			this.config = configuration;
			this.application = app;
			
			// preserve window state if needed
			if(this.config.preserveApplicationWindowState) {
				app.addEventListener(ResizeEvent.RESIZE, applicationResizeHandler);
				app.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE, applicationMoveHandler);
			}
			
			// check for uncaught exceptions
			if(this.config.catchAndLogUncaughtErrorEvents) {
				this.application.addEventListener(AIREvent.WINDOW_COMPLETE, applicationCompleteHandler);
			}
			
			// add shutdown hook
			this.application.addEventListener(Event.CLOSE, applicationCloseEventHandler);
		}
		
		private function applicationCloseEventHandler(event:Event):void {
			if(this.application != null) {
				this.application.removeEventListener(Event.CLOSE, applicationCloseEventHandler);
			}
			
			// shutdown the entire framework now
			Essentials.shutDown();
		}
		
		private function applicationCompleteHandler(event:AIREvent):void {
			this.application.removeEventListener(AIREvent.WINDOW_COMPLETE, applicationCompleteHandler);
			this.application.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorEventHandler);
		}
		
		override public function dispose():void {
			super.dispose();
			
			this.application.removeEventListener(ResizeEvent.RESIZE, applicationResizeHandler);
			this.application.nativeWindow.removeEventListener(NativeWindowBoundsEvent.MOVE, applicationMoveHandler);
			this.application.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorEventHandler);

			this.application = null;
		}
		
		override protected function captureState():void {
			// check if the current window is not maximized or minimized
			if(application.stage != null && application.stage.nativeWindow != null) {
				if(!application.stage.nativeWindow.closed) {
					var displayState:String = application.stage.nativeWindow.displayState ;
					if(displayState == NativeWindowDisplayState.MAXIMIZED || displayState == NativeWindowDisplayState.MINIMIZED) {
						return;
					}
				}
			}
			
			if(application.nativeWindow.closed) {
				logger.debug('the window is already closed, cannot capture its state');
				return;
			}
			
			// check for screen corners for being in range
			if((application.nativeWindow.x < 0) || (application.nativeWindow.y < 0)) {
				return;
			}
			
			if(((application.nativeWindow.x + application.width) > Capabilities.screenResolutionX) || ((application.nativeWindow.y + application.height) > Capabilities.screenResolutionY)) {
				return;
			} 
			
			this.xCoord = application.nativeWindow.x;
			this.yCoord = application.nativeWindow.y;
			this.width = application.width;
			this.height = application.height;
		}
		
		override protected function restoreApplicationState():void {
			var num:String = null;
			var n:Number = 0;
			var defaultValue:Number = 0;
			
			// set width
			num = Essentials.preferences.getPreference(APPLICATION_WIDTH);
			defaultValue = this.config.defaultApplicationWidth;
			if(AssertUtils.isNotEmptyString(num)) {
				n = StringUtils.getNumber(num);
				if(n <  defaultValue) {
					n = defaultValue;
				}
				application.width = n;
			} else {
				// set the default width
				application.width = this.config.defaultApplicationWidth;
			}
			
			// set height
			num = Essentials.preferences.getPreference(APPLICATION_HEIGHT);
			defaultValue = this.config.defaultApplicationHeight;
			if(AssertUtils.isNotEmptyString(num)) {
				n = StringUtils.getNumber(num);
				if(n < defaultValue) {
					n = defaultValue;
				}
				application.height = n;
			} else {
				application.height = this.config.defaultApplicationHeight;
			}
			
			// set X coord
			num = Essentials.preferences.getPreference(APPLICATION_POSITION_X);
			if(AssertUtils.isNotEmptyString(num)) {
				n = StringUtils.getNumber(num);
				if(n < 0) {
					n = (Capabilities.screenResolutionX - application.width) / 2;
				}
				application.nativeWindow.x = n;
			} else {
				application.nativeWindow.x = (Capabilities.screenResolutionX - application.width) / 2;
			}
			
			// set width
			num = Essentials.preferences.getPreference(APPLICATION_POSITION_Y);
			if(AssertUtils.isNotEmptyString(num)) {
				n = StringUtils.getNumber(num);
				if(n < 0) {
					n = (Capabilities.screenResolutionY - application.height) / 2;
				}
				application.nativeWindow.y = n;
			} else {
				application.nativeWindow.y = (Capabilities.screenResolutionY - application.height) / 2;
			}
			
			// capture the current state again - just to make sure
			// that we override any corrupt or unavailable value
			captureState();
		}

	}
}
