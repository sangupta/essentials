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

package org.myjerry.essentials {
	
	import flash.events.EventDispatcher;
	
	import mx.core.WindowedApplication;
	
	import org.myjerry.as3utils.AssertUtils;
	import org.myjerry.essentials.application.EssentialsSparkApplication;
	import org.myjerry.essentials.config.EssentialsConfiguration;
	import org.myjerry.essentials.core.IConnectionManager;
	import org.myjerry.essentials.core.IDatabaseManager;
	import org.myjerry.essentials.core.IEssentialsApplication;
	import org.myjerry.essentials.core.IPreferenceManager;
	import org.myjerry.essentials.core.ISystem;
	import org.myjerry.essentials.core.IUpdateManager;
	import org.myjerry.essentials.core.IUsageManager;
	import org.myjerry.essentials.db.DatabaseManager;
	import org.myjerry.essentials.net.EssentialsConnectionManager;
	import org.myjerry.essentials.preferences.PreferencesManager;
	import org.myjerry.essentials.system.SystemManager;
	import org.myjerry.essentials.updates.UpdateManager;
	import org.myjerry.essentials.usage.UsageManager;
	import org.myjerry.as3utils.StringUtils;
	
	import spark.components.WindowedApplication;

	public class Essentials {
		
		private static var essentialsApplication:IEssentialsApplication = null;
		
		private static var databaseManager:IDatabaseManager = null;
		
		private static var preferencesManager:IPreferenceManager = null;
		
		private static var updateManager:IUpdateManager = null;
		
		private static var connectionManager:IConnectionManager = null;
		
		private static var usageManager:IUsageManager = null;
		
		private static var sys:ISystem = null;
		
		private static var essentialsInitialized:Boolean = false;
		
		/**
		 * The centralized event dispatcher for the Essentials framework.
		 */
		private static const eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public static function get initialized():Boolean {
			return essentialsInitialized;
		}
		
		public static function get app():IEssentialsApplication {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return essentialsApplication;
		}
		
		public static function get database():IDatabaseManager {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return databaseManager;
		}
		
		public static function get preferences():IPreferenceManager {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return preferencesManager;
		}
		
		public static function get updates():IUpdateManager {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return updateManager;
		}
		
		public static function get system():ISystem {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return sys;
		}
		
		public static function get net():IConnectionManager {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return connectionManager;
		}
		
		public static function get usage():IUsageManager {
			if(!initialized) {
				throw new Error('Essentials is not yet initialized.');
			}
			
			return usageManager;
		}
		
		/**
		 * Initialize the Essentials system and make it ready for use
		 */
		public static function initialize(object:Object, configuration:EssentialsConfiguration = null):void {
			// check if we are already initialized or not
			if(essentialsInitialized) {
				throw new Error('Already initialized, use reInitialize() instead.');
			}
			
			// check for the sanity of application object
			// this must be atleast a WindowedApplication (mx or spark does not matter)
			if(object == null) {
				throw new Error('Cannot initialize on a null object.');
			}
			
			// check and create a default essentials configuration object
			if(configuration == null) {
				configuration = new EssentialsConfiguration();
			}
			
			// prepare configuration for use
			validateConfiguration(configuration);
			
			// set the initialized flag to true
			essentialsInitialized = true;

			// initialize the system
			initializeSystem(object, configuration);
		}
		
		public static function reInitialize(object:Object, configuration:EssentialsConfiguration = null):void {
			// check for the sanity of application object
			// this must be atleast a WindowedApplication (mx or spark does not matter)
			if(object == null) {
				throw new Error('Cannot reInitialize on a null object.');
			}
			
			// clean up the previous object initialization
		}
		
		/**
		 * Add a listener to the EssentialsApplication
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if(!essentialsInitialized) {
				throw new Error('Initialize Essentials first.');
			}
			
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Remove a listener from the EssentialsApplication
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			if(!essentialsInitialized) {
				throw new Error('Initialize Essentials first.');
			}
			
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function shutDown():void {
			if(!essentialsInitialized) {
				throw new Error('Initialize Essentials first.');
			}
			
			essentialsApplication.dispose();
		}

		private static function validateConfiguration(config:EssentialsConfiguration):void {
			if(config == null) {
				throw new Error("This is a coding error. Config object can never be null here.");
			}
			
			// check configuration for validation errors
			if(config.app.allowMinimizeToSystemTray) {
				if(AssertUtils.isEmptyString(config.app.systemTrayToolTip)) {
					throw new Error("You need to specify 'systemTrayToolTip' to use minimize to system tray functionality."); 
				}
			}
			
			// now start creating objects
			
			// application state needs preferences allowed
			
			// 
		}
		
		private static function initializeSystem(object:Object, config:EssentialsConfiguration):void {
			// initialize the database system
			// this needs to be done before anything else
			// so that all others can use the database manager to work with
			databaseManager = new DatabaseManager(config.database);
			
			// initialize the preferences manager
			if(config.preference.allowPreferences) {
				preferencesManager = new PreferencesManager(config.preference);
			}
			
			// initialize the specific application
			if(object is spark.components.WindowedApplication) {
				essentialsApplication = new EssentialsSparkApplication(object as spark.components.WindowedApplication, config.app);
			} else if(object is mx.core.WindowedApplication) {
				// essentialsApplication = new EssentialsMxApplication(object as mx.core.WindowedApplication, configuration);
			}
			
			// initialize the update manager
			if(config.updates.manageApplicationUpdates) {
				updateManager = new UpdateManager(config.updates);
			}
			
			// initialize the connection manager
			if(config.net.maintainInternetConnectivityState) {
				connectionManager = new EssentialsConnectionManager(config.net, eventDispatcher);
			}
			
			// initialize the usage manager
			if(config.usage.trackApplicationUsage) {
				usageManager = new UsageManager(config.usage);
			}
			
			// initialize the system manager
			sys = new SystemManager(config.system);
		}
	}
}
