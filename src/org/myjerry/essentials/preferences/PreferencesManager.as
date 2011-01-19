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

package org.myjerry.essentials.preferences {
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import org.myjerry.essentials.Essentials;
	import org.myjerry.essentials.config.PreferenceConfig;
	import org.myjerry.essentials.core.IDatabaseManager;
	import org.myjerry.essentials.core.IPreferenceManager;
	import org.myjerry.essentials.utils.StringUtils;
	
	public class PreferencesManager implements IPreferenceManager {
		
		private var config:PreferenceConfig = null;
		
		public function PreferencesManager(config:PreferenceConfig):void {
			this.config = config;
		}
		
		public function getPreference(preferenceKey:String):String {
			var statement:SQLStatement = Essentials.database.getStatement("SELECT * FROM preferences WHERE key=:key");
			statement.parameters[":key"] = preferenceKey;
			statement.execute();
			var result:SQLResult = statement.getResult();
			if(result != null && result.data != null) {
				return result.data[0].value;
			}
			return null;
		}
		
		public function savePreference(preferenceKey:String, preferenceValue:String):Boolean
		{
			// check if we already have a setting or not
			// TODO: move to using a COUNT for query
			try {
				var statement:SQLStatement = Essentials.database.getStatement('SELECT * FROM preferences WHERE key=:key');
				statement.parameters[":key"] = preferenceKey;
				statement.execute();
				var result:SQLResult = statement.getResult();
				if(result != null && result.data != null) {
					// we have the key in preference store
					// update the key
					statement = Essentials.database.getStatement('UPDATE preferences SET value=:value where key=:key');
				} else {
					// the key is not there in preference store
					// insert the key
					statement = Essentials.database.getStatement('INSERT INTO preferences (key, value) values (:key, :value)');
				}
				statement.parameters[":key"] = preferenceKey;
				statement.parameters[":value"] = preferenceValue;
				statement.execute();
			} catch(e:Error) {
				trace('Error saving preference: ' + e.errorID + '; ' + e.message + '; ' + e.getStackTrace());
				
				return false;
			}
			
			return true;
		}
		
		public function deletePreference(preferenceKey:String):void {
			var statement:SQLStatement = Essentials.database.getStatement('DELETE FROM preferences WHERE key=:key');
			statement.parameters[":key"] = preferenceKey;
			statement.execute();
		}
		
		public function getBooleanPreference(preferenceKey:String, defaultValue:Boolean):Boolean {
			var value:String = getPreference(preferenceKey);
			return StringUtils.getBoolean(value, defaultValue);
		}
		
		public function saveBooleanPreference(preferenceKey:String, preferenceValue:Boolean):Boolean {
			if(preferenceValue) {
				return savePreference(preferenceKey, 'true');
			}
			return savePreference(preferenceKey, 'false');
		}
		
		public function dispose():void {
			this.config = null;
		}
	}
}