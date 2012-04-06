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

package com.sangupta.essentials.db {
	import com.sangupta.essentials.config.DatabaseConfig;
	import com.sangupta.essentials.core.IDatabaseManager;
	
	public class DatabaseTables {
		
		public function DatabaseTables():void {
			super();
		}
		
		/**
		 * The function checks and create all database tables as necessary for the operation
		 * of the Essentials framework.
		 */
		public function checkAndCreateDatabaseTables(dbManager:IDatabaseManager, config:DatabaseConfig):void {
			createPreferencesTable(dbManager, config.preferencesTableName);
			
			createAppUpdateHistoryTable(dbManager, config.appUpdateHistoryTableName);
		}
		
		private function createPreferencesTable(dbManager:IDatabaseManager, tableName:String):void {
			var query:String = "CREATE TABLE IF NOT EXISTS " + tableName + " (" +
				"    ID       INTEGER PRIMARY KEY AUTOINCREMENT," +
				"    key      TEXT NOT NULL," +
				"    value    TEXT" +
				")";

			
			dbManager.executeSQLQuery(query);
		}
		
		private function createAppUpdateHistoryTable(dbManager:IDatabaseManager, tableName:String):void {
			var query:String = "CREATE TABLE IF NOT EXISTS " + tableName + " (" +
				"	historyID		INTEGER PRIMARY KEY AUTOINCREMENT," +
				"	appVersion 		TEXT NOT NULL," +
				"	lastModified 	INTEGER NOT NULL" +
				")";
			
			dbManager.executeSQLQuery(query);
		}
	}
}
