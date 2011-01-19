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

package org.myjerry.essentials.utils {
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.StringUtil;

	public class StringUtils {
		
		private static const logger:ILogger = Log.getLogger('org.myjerry.essentials.utils.StringUtils');

		public static function isNotEmpty(str:String):Boolean {
			return !(isEmpty(str));
		}

		public static function isEmpty(str:String):Boolean {
			if(str == null) {
				return true;
			}
			var s:String = StringUtil.trim(str);
			if(s.length == 0) {
				return true;
			}
			return false;
		}

		public static function getBoolean(boolString:String, defaultValue:Boolean = false):Boolean {
			if(isNotEmpty(boolString)) {
				boolString = StringUtil.trim(boolString.toLowerCase());
				if(equals("yes", boolString) || equals("true", boolString)) {
					return true;
				}
				if(equals("no", boolString) || equals("false", boolString)) {
					return false;
				}

				logger.debug('Cannot convert string: ' + boolString + ' to boolean value.');
			}
			return defaultValue; 
		}

		/**
		 * Tests whether two strings are equal or not.
		 */
		public static function equals(string1:String, string2:String, caseSensitive:Boolean = true):Boolean {
			if((string1 == null) || (string2 == null)) {
				return false;
			}
			
			if(!caseSensitive) {
				string1 = string1.toUpperCase();
				string2 = string2.toUpperCase();
			}
			
			if((string1.length == string2.length) && (string1.indexOf(string2) == 0) ) {
				return true;
			}
			return false; 
		}

		public static function getNumber(num:String):Number {
			if(isEmpty(num)) {
				return 0;
			}
			return Number(num);
		}
	}
}
