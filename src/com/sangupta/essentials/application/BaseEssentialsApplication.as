/**
 *
 * Essentials - Core functionality for Adobe AIR desktop application
 * Copyright (C) 2011-2012, Sandeep Gupta
 * http://www.sangupta.com/projects/essentials
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

package com.sangupta.essentials.application {

	import com.sangupta.as3utils.AssertUtils;
	import com.sangupta.essentials.Essentials;
	import com.sangupta.essentials.config.AppConfig;
	import com.sangupta.essentials.core.IEssentialsApplication;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.BitmapData;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.UncaughtErrorEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.UIDUtil;
	
	/**
	 * Contains all convenience functions that can be abstracted
	 */
	public class BaseEssentialsApplication implements IEssentialsApplication {
		
		protected static const logger:ILogger = Log.getLogger('org.myjerry.essentials.EssentialsApplication');
		
		protected static const APPLICATION_UUID:String = 'application.uuid';
		
		protected var config:AppConfig;
		
		protected var uuid:String = null;

		public function BaseEssentialsApplication() {
			super();
		}
		
		/**
		 * Function to return a unique identifier for this particular installation of the application.
		 * The UID is created only once for this installation and as long as the 'Local Store' for the
		 * application is not deleted, the UID will stay and would be the one returned.
		 */
		public function getApplicationUUID():String {
			if(!this.config.maintainApplicationUUID) {
				throw new Error("Essentials is not configured to track application UUID");
			}
			
			if(uuid == null) {
				uuid = Essentials.preferences.getPreference(APPLICATION_UUID);
				if(AssertUtils.isEmptyString(uuid)) {
					// create a new UUID and store it
					uuid = UIDUtil.createUID();
					Essentials.preferences.savePreference(APPLICATION_UUID, uuid);
				}
			}
			
			return uuid;
		}

		/**
		 * Function to handle and capture information uncaught error events
		 */
		protected function uncaughtErrorEventHandler(uncaughtErrorEvent:UncaughtErrorEvent):void {
			var logMessage:String = "Uncaught Error Event trapped: ";
			logMessage += "on target " + uncaughtErrorEvent.currentTarget;

			logMessage += "with ID: " + uncaughtErrorEvent.errorID;
			var ee:Error = null;
			if(uncaughtErrorEvent is Error) {
				ee = uncaughtErrorEvent as Error;
				logMessage += "[ERROR TYPE] Error ID: " + ee.errorID + '; message: ' + ee.message + "; stack trace: " + ee.getStackTrace();
			} else if(uncaughtErrorEvent is UncaughtErrorEvent) {
				ee = uncaughtErrorEvent.error as Error;
				logMessage += "[EVENT TYPE] Error ID: " + ee.errorID + '; message: ' + ee.message + "; stack trace: " + ee.getStackTrace();
				logMessage += 'event phase: ' + uncaughtErrorEvent.eventPhase + '; text: ' + uncaughtErrorEvent.text;
			}
			
			logger.error(logMessage);
		}
		
		public function get isFirstLaunchOfApplication():Boolean {
			throw new Error('not implemented');
		}

		/**
		 * The image to be used for docking - this is applicable only for Windows platform
		 */
		private var dockImage:BitmapData = null;

		/**
		 * Function to actually minimize the application
		 */
		public function minimizeToTray():void {
			if(NativeApplication.supportsDockIcon){
				// For MAC
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, undock);
				
				// create the context menu if applicable
				if(this.config.createMinimizeApplicationContextMenu != null) {
					dockIcon.menu = this.config.createMinimizeApplicationContextMenu();
				}
			} else if (NativeApplication.supportsSystemTrayIcon) {
				// For WINDOWS
				var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = this.config.systemTrayToolTip;
				sysTrayIcon.addEventListener(MouseEvent.CLICK, undock);
				
				// create the context menu if applicable
				if(this.config.createMinimizeApplicationContextMenu != null) {
					sysTrayIcon.menu = this.config.createMinimizeApplicationContextMenu();
				}
			}
			
			if(dockImage == null) {
				// load the docking image
				// and then call the docking function
				loadDockImageAndThenDock();
			} else {
				// go ahead and dock the application
				dock();
			}
		}
		
		protected function loadDockImageAndThenDock():void {
			// load the dock image
			// via the loader
			// set up call to dock on its completion handler
		}
		
		protected function dock(event:Event = null):void {
			FlexGlobals.topLevelApplication.stage.visible = false;
			if(dockImage != null) {
				NativeApplication.nativeApplication.icon.bitmaps = [dockImage];
			}
		}

		protected function undock(event:InvokeEvent):void {
			FlexGlobals.topLevelApplication.stage.visible = true;
			NativeApplication.nativeApplication.icon.bitmaps = [];
		}
		
		protected function applicationResizeHandler(resizeEvent:ResizeEvent):void {
			
		}
		
		protected function applicationMoveHandler(nativeWindowBoundsEvent:NativeWindowBoundsEvent):void {
			
		}
		
		public function dispose():void {
			
		}

		protected static const APPLICATION_WIDTH:String = 'application.width';
		
		protected static const APPLICATION_HEIGHT:String = 'application.height';
		
		protected static const APPLICATION_POSITION_X:String = 'applicationPositionX';
		
		protected static const APPLICATION_POSITION_Y:String = 'applicationPositionY';

		/**
		 * The width of the main application window
		 */
		protected var width:Number;
		
		/**
		 * The height of the main application window
		 */
		protected var height:Number;
		
		/**
		 * The X-position of the main application window
		 */
		protected var xCoord:Number;
		
		/**
		 * The Y-position of the main application window
		 */
		protected var yCoord:Number;

		/**
		 * Save the application window location
		 */
		protected function saveApplicationLocation():void {
			Essentials.preferences.savePreference(APPLICATION_WIDTH, this.width.toString());
			Essentials.preferences.savePreference(APPLICATION_HEIGHT, this.height.toString());
			Essentials.preferences.savePreference(APPLICATION_POSITION_X, this.xCoord.toString());
			Essentials.preferences.savePreference(APPLICATION_POSITION_Y, this.yCoord.toString());
		}
		
		protected function captureState():void {
			throw new Error("Must be implemented in a child class.");
		}
		
		protected function restoreApplicationState():void {
			throw new Error("Must be implemented in a child class.");
		}
		
		public function resetLastKnownApplicationLocation():void {
			restoreApplicationState();
		}
	}
}
