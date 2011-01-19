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

package org.myjerry.essentials.config {
	
	public class AppConfig {
		
		/**
		 * Capture application size and location on screen and reload it across launches
		 */
		public var preserveApplicationWindowState:Boolean = true;
		
		/**
		 * Maintain a unique UUID for this installation of the application.
		 */
		public var maintainApplicationUUID:Boolean = true;
		
		/**
		 * Catch and log uncaught error events
		 */
		public var catchAndLogUncaughtErrorEvents:Boolean = true;
		
		/**
		 * Specifies whether the application needs to allow minimize to system tray.
		 */
		public var allowMinimizeToSystemTray:Boolean = false;
		
		/**
		 * The tooltip that needs to be displayed when the application is minimized.
		 */
		public var systemTrayToolTip:String = null;
		
		/**
		 * The context sensitive menu that needs to be displayed when the app is minimized.
		 */
		public var createMinimizeApplicationContextMenu:Function = null;
		
		/**
		 * Callback function that will be called when the application is restored back.
		 */
		public var onApplicationRestoreCallback:Function = null;

		/**
		 * Default application width in case it has not been already set
		 */
		public var defaultApplicationWidth:Number = 800;
		
		/**
		 * Default application height in case it has not been already set
		 */
		public var defaultApplicationHeight:Number = 600;
		
	}
}