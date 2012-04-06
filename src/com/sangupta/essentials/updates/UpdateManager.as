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

package com.sangupta.essentials.updates {
	
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import com.sangupta.as3utils.AssertUtils;
	import com.sangupta.as3utils.DateUtils;
	import com.sangupta.essentials.Essentials;
	import com.sangupta.essentials.config.UpdatesConfig;
	import com.sangupta.essentials.core.IUpdateManager;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class UpdateManager implements IUpdateManager {
		
		private static const logger:ILogger = Log.getLogger('org.myjerry.essentials.updates.UpdateManager');
		
		protected static const LAST_APP_UPDATE_CHECK:String = 'last.app.update.check';
		
		private var config:UpdatesConfig = null;
		
		private var appUpdater:ApplicationUpdaterUI = null;
		
		private var updatesChecked:Boolean = false;
		
		public function UpdateManager(config:UpdatesConfig):void {
			this.config = config;

			// we are managing application updates
			if(config.manageApplicationUpdates) {
				if(config.checkForApplicationUpdatesAtStartup) {
					// application updates, need to be checked at application startup
					checkForApplicationUpdates();
				} else if(config.checkForApplicationUpdatesWhenIdle) {
					// check when app is idle
					var nativeApp:NativeApplication = NativeApplication.nativeApplication;
					nativeApp.idleThreshold = config.applicationIdleTimeToCheckForUpdatesInMinutes * 60;
					nativeApp.addEventListener(Event.USER_IDLE, userIdleHandler);
				}
			}
		}
		
		/**
		 * Event handler for the user being idle on this application
		 */
		private function userIdleHandler(event:Event):void {
			// the user has been idle
			if(!updatesChecked) {
				checkForApplicationUpdates();
			}
		}
		
		/**
		 * Go ahead and check for application updates
		 */
		public function checkForApplicationUpdates():void {
			if(!config.manageApplicationUpdates) {
				throw new Error("Application update management is disabled.");
			}
			
			if(AssertUtils.isEmptyString(this.config.applicationUpdateURL)) {
				throw new Error("Cannot check for application updates on null/empty update URL.");
			}
			
			if(!checkAppUpdateApplicable()) {
				// application update is not applicable, because
				// the last update was checked in the defined frequency
				return;
			}
			
			this.appUpdater = new ApplicationUpdaterUI();
			this.appUpdater.updateURL = this.config.applicationUpdateURL;
			this.appUpdater.isCheckForUpdateVisible = this.config.isCheckForUpdateVisible;
			this.appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); 
			this.appUpdater.addEventListener(ErrorEvent.ERROR, onError);
			this.appUpdater.initialize(); 
		}
		
		private function onUpdate(event:UpdateEvent):void {
			if(!this.updatesChecked) {
				if(!this.appUpdater.isUpdateInProgress) {
					this.appUpdater.checkNow();
					this.updatesChecked = true;
					saveLastUpdateTime();
				}
			}
		}
		
		private function onError(event:ErrorEvent):void {
			logger.error('Error initializing AIR update framework: ' + event.text);
		}
		
		public function forceUpdateApplication():void {
			if(!config.manageApplicationUpdates) {
				throw new Error("Application update management is disabled.");
			}
		}
		
		public function isUpdatedLaunchOfApplication():Boolean {
			return false;
		}
		
		private function checkAppUpdateApplicable():Boolean {
			if(this.config.applicationUpdateFrequency == 0) {
				return true;
			}
			
			return testDateDifference(readLastUpdateTime(), this.config.applicationUpdateFrequency);
		}

		/**
		 * Prepare the object for disposal.
		 */
		public function dispose():void {
			this.appUpdater = null;
			
			NativeApplication.nativeApplication.removeEventListener(Event.USER_IDLE, userIdleHandler);
		}
		
		private function readLastUpdateTime():Date {
			var time:String = Essentials.preferences.getPreference(LAST_APP_UPDATE_CHECK);
			var d:Date = null;
			if(AssertUtils.isNotEmptyString(time)) {
				var t:Number = Number(time);
				d = new Date();
				d.time = t;
			}
			
			return d;
		}
		
		private function saveLastUpdateTime():void {
			var d:Date = new Date();
			var time:Number = d.time;
			Essentials.preferences.savePreference(LAST_APP_UPDATE_CHECK, String(time));
		}

		private function testDateDifference(lastCheck:Date, days:uint):Boolean {
			if(lastCheck == null) {
				return true;
			}
			
			var currentDate:Date = new Date();
			var diffDays:Number = DateUtils.diffDateInDays(lastCheck, currentDate);
			if(diffDays >= days) {
				return true;
			}
			
			return false;
		}

	}
}
