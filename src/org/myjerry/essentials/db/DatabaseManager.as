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

package org.myjerry.essentials.db {
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.myjerry.as3extensions.IDisposable;
	import org.myjerry.as3utils.AssertUtils;
	import org.myjerry.essentials.config.DatabaseConfig;
	import org.myjerry.essentials.core.IDatabaseManager;
	
	public class DatabaseManager implements IDatabaseManager, IDisposable {

		/**
		 * Shared database connection
		 */
		protected var dbConnection:SQLConnection = null;
		
		/**
		 * Shared logger between this class and its child classes (if any)
		 */
		protected static const logger:ILogger = Log.getLogger('org.myjerry.essentials.EssentialsApplication');
		
		/**
		 * Constructor
		 */
		public function DatabaseManager(configuration:DatabaseConfig) {
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
			var dbManager:DatabaseTables = new DatabaseTables();
			dbManager.checkAndCreateDatabaseTables(this, configuration);
		}
		
		/**
		 * Execute a given query and return its results back.
		 */
		public function executeSQLQuery(statement:String):SQLResult {
			if(dbConnection != null && dbConnection.connected && AssertUtils.isNotEmptyString(statement)) {
				try {
					var sqlStatement:SQLStatement = new SQLStatement();
					sqlStatement.sqlConnection = dbConnection;
					sqlStatement.text = statement ;
					sqlStatement.execute();
					return sqlStatement.getResult();
				} catch(e:Error) {
					logger.error("Error executing DB statement: " + statement + "\nError caught: " + e.toString());
				}
			}
			return null;
		}
		
		/**
		 * Return a prepared statement for the given query string.
		 */
		public function getStatement(query:String):SQLStatement {
			if(AssertUtils.isEmptyString(query)) {
				throw new Error('Query cannot be null/empty.');
			}
			
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = dbConnection;
			statement.text = query;
			return statement;
		}
		
		public function beginTransaction(option:String = null, responder:Responder = null):void {
			dbConnection.begin(option, responder);
		}
		
		public function commitTransaction(responder:Responder = null):void {
			dbConnection.commit(responder);
		}
		
		public function rollbackTransaction(responder:Responder = null):void {
			dbConnection.rollback(responder);
		}
		
		/**
		 * Prepare this object for destruction and garbage collection
		 */
		public function dispose():void {
			try {
				this.dbConnection.close();
			} catch(e:Error) {
				
			}
			
			this.dbConnection = null;
		}
		
	}
}
