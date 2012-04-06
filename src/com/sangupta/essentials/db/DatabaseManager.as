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
	
	import com.sangupta.as3extensions.IDisposable;
	import com.sangupta.as3extensions.db.Database;
	import com.sangupta.essentials.config.DatabaseConfig;
	import com.sangupta.essentials.core.IDatabaseManager;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class DatabaseManager extends Database implements IDatabaseManager, IDisposable {

		/**
		 * Shared logger between this class and its child classes (if any)
		 */
		protected static const logger:ILogger = Log.getLogger('org.myjerry.essentials.EssentialsApplication');
		
		/**
		 * Constructor
		 */
		public function DatabaseManager(configuration:DatabaseConfig) {
			super();
			
			// create a database connection if not already done
			if(configuration.databaseConnection == null) {
				// create the connection
				dbConnection = new SQLConnection();
				
				// create a reference to the database file
				var dbFile:File = new File(configuration.databaseFileName);
				
				// create the database if it is not already present
				dbConnection.open(dbFile , SQLMode.CREATE);
			} else {
				// connection present - just see if it is open
				if(!configuration.databaseConnection.connected) {
					// connection is not connected
					// open the connection if we can
					throw new Error('Database connection supplied is not open.'); 
				}
				
				dbConnection = configuration.databaseConnection;
			}
			
			// check and create DATABASE TABLES as necessary
			var dbTables:DatabaseTables = new DatabaseTables();
			dbTables.checkAndCreateDatabaseTables(this, configuration);
		}
		
	}
}
