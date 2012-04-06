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

package com.sangupta.essentials.net {

	import com.sangupta.essentials.config.NetConfig;
	import com.sangupta.essentials.core.IConnectionManager;
	import com.sangupta.essentials.events.EssentialsEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class EssentialsConnectionManager implements IConnectionManager {
		
		private var config:NetConfig = null;
		
		private var eventDispatcher:IEventDispatcher = null;
		
		private var isOnline:Boolean = false;
		
		public function get isApplicationOnline():Boolean {
			return this.isOnline;
		}
		
		private var _connectivityInitialized:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function EssentialsConnectionManager(config:NetConfig, eventDispatcher:IEventDispatcher):void {
			this.config = config;
			this.eventDispatcher = eventDispatcher;
			
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, detectConnectivity);
		}

		protected function detectConnectivity(event:Event = null):void {
			var url:URLRequest = new URLRequest(this.config.connectivityCheckURL);
			// convert seconds to milli-seconds
			url.idleTimeout = this.config.connectivityCheckTimeOutIntervalInSeconds * 1000;
			url.method = URLRequestMethod.HEAD;
			url.useCache = false;
			url.cacheResponse = false;
			
			var stream:URLLoader  = new URLLoader();
			stream.addEventListener(Event.COMPLETE, streamLoadCompleteEvent);
//			stream.addEventListener(HTTPStatusEvent.HTTP_STATUS,streamConnectHttpStatusHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, streamLoadErrorEvent);
			stream.load(url);
		}

//		private function streamConnectHttpStatusHandler(event:HTTPStatusEvent = null):void {
//			if(event != null && event.status != 0) {
//				this.isOnline = true;
//			} else {
//				this.isOnline = false;
//			}
//			
//			this.connectivityInitialized = true;
//			
//			if(this.dispatchEvents) {
//				this.eventDispatcher.dispatchEvent(new EssentialsEvent(EssentialsEvent.CONNECTIVITY_CHANGE, { isOnline:isOnline }));
//			}
//		}
		
		
		private function streamLoadCompleteEvent(event:Event):void {
			event.preventDefault();
			event.stopImmediatePropagation();
			
			var stream:URLLoader = event.target as URLLoader;
			
			stream.removeEventListener(Event.COMPLETE, streamLoadCompleteEvent);
//			stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS,streamConnectHttpStatusHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, streamLoadErrorEvent);
			
			if(!isApplicationOnline) {
				this.isOnline = true;
				if(this.config.dispatchConnectivityEvents) {
					this.eventDispatcher.dispatchEvent(new EssentialsEvent(EssentialsEvent.CONNECTIVITY_CHANGE, { isOnline:isOnline }));
				}
			}
			this._connectivityInitialized = true;
		}
		
		private function streamLoadErrorEvent(event:IOErrorEvent):void {
			event.preventDefault();
			event.stopImmediatePropagation();
			
			if(isApplicationOnline) {
				this.isOnline = false;
				if(this.config.dispatchConnectivityEvents) {
					this.eventDispatcher.dispatchEvent(new EssentialsEvent(EssentialsEvent.CONNECTIVITY_CHANGE, { isOnline:isApplicationOnline }));
				}
			}
			
			this._connectivityInitialized = true;
		}
		
		public function get connectivityInitialized():Boolean {
			return this._connectivityInitialized;
		}
		
		public function dispose():void {
			this.eventDispatcher = null;
			
			NativeApplication.nativeApplication.removeEventListener(Event.NETWORK_CHANGE, detectConnectivity);
		}
		
	}
}
