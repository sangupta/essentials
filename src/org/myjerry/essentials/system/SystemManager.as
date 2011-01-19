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

package org.myjerry.essentials.system {
	
	import flash.desktop.NativeApplication;
	
	import org.myjerry.essentials.config.SystemConfig;
	import org.myjerry.essentials.core.ISystem;
	
	public class SystemManager implements ISystem {
		
		private var config:SystemConfig = null;
		
		public function SystemManager(config:SystemConfig) {
			super();
			this.config = config;
		}
		
		private var _applicationVersion:String = null;
		
		private var _applicationVersionLabel:String = null;
		
		private var _isAir25SDK:Boolean = false;
		
		/**
		 * Returns the value of the tag specified as by the tag name in the application descriptor.
		 * If there are multiple tags by the given name, the value of the first matching tag is
		 * returned back. Returns <code>null</code> if the tag is not found.
		 */
		public function getApplicationDescriptorTagValue(tagName:String):String {
			var xmlList:XMLList = NativeApplication.nativeApplication.applicationDescriptor.children();
			
			for each(var item:XML in xmlList) {
				if(item.name().localName == tagName) {
					return item.toString();
				}
			}

			return null;
		}
		
		public function get applicationVersion():String {
			if(_applicationVersion == null) {
				// for AIR 2.0 SDK and previous the tag is called 'version'
				_applicationVersion = getApplicationDescriptorTagValue("version");
				
				// for AIR 2.5 SDK the tag is called 'versionNumber'
				if(_applicationVersion == null) {
					_applicationVersion = getApplicationDescriptorTagValue("versionNumber");
					_isAir25SDK = true;
				}
			}
			
			return _applicationVersion;
		}
		
		public function get applicationVersionLabel():String {
			if(_applicationVersionLabel == null) {
				if(isAir25SDK) {
					// the value is only defined for AIR 2.5 SDK+
					_applicationVersionLabel = getApplicationDescriptorTagValue("versionLabel");
				} else {
					_applicationVersionLabel = applicationVersion;
				}
			}
			
			return _applicationVersion;
		}

		public function get applicationID():String {
			return NativeApplication.nativeApplication.applicationID;
		}
		
		public function get publisherID():String {
			return NativeApplication.nativeApplication.publisherID;
		}
		
		public function get isAir25SDK():Boolean {
			return _isAir25SDK;
		}
		
		public function dispose():void {
			
		}
	}
}
