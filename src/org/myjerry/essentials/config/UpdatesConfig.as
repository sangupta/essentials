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
	
	public class UpdatesConfig {
		
		/**
		 * Specifies whether Essentials manages the given application's update mechanism or not.
		 */
		public var manageApplicationUpdates:Boolean = true;
		
		/**
		 * Specifies whether a dialog is displayed when checking for application updates.
		 */
		public var isCheckForUpdateVisible:Boolean = false;
		
		/**
		 * Specifies whether application updates need to be checked at the launch of application or not.
		 */
		public var checkForApplicationUpdatesAtStartup:Boolean = true;
		
		/**
		 * The application update frequency in number of days. A value of zero means that app updates
		 * are checked everytime the application is launched. For non-zero values, updates are checked
		 * at the defined frequency (in number of days).
		 */
		public var applicationUpdateFrequency:uint = 0;
		
		/**
		 * The URL at which to check for the application updates
		 */
		public var applicationUpdateURL:String = null;
		
		/**
		 * Specifies whether to check for application updates when the application
		 * is idle.
		 */
		public var checkForApplicationUpdatesWhenIdle:Boolean = false;
		
		/**
		 * Time in minutes for which the application should be idle, after which
		 * Essentials checks for application update.
		 */
		public var applicationIdleTimeToCheckForUpdatesInMinutes:uint = 10;
		
		/**
		 * Maintain the application upgrade history over time.
		 */
		public var maintainApplicationUpgradeHistory:Boolean = true;

	}
}
