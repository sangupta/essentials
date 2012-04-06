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

package com.sangupta.essentials.config {

	public class EssentialsConfiguration {
		
		public const app:AppConfig = new AppConfig();
		
		public const database:DatabaseConfig = new DatabaseConfig();
		
		public const net:NetConfig = new NetConfig();
		
		public const preference:PreferenceConfig = new PreferenceConfig();
		
		public const system:SystemConfig = new SystemConfig();
		
		public const updates:UpdatesConfig = new UpdatesConfig();
		
		public const usage:UsageConfig = new UsageConfig();
	}
}
