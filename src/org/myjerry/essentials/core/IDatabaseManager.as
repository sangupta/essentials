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

package org.myjerry.essentials.core {
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.net.Responder;
	
	import org.myjerry.as3extensions.IDisposable;

	public interface IDatabaseManager extends IDisposable
	{
		function getStatement(query:String):SQLStatement;
		
		function executeSQLQuery(statement:String):SQLResult;
		
		function beginTransaction(option:String = null, responder:Responder = null):void;
		
		function commitTransaction(responder:Responder = null):void;
		
		function rollbackTransaction(responder:Responder = null):void;
			
	}
}