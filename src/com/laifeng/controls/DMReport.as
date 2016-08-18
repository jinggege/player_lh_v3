package  com.laifeng.controls
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.ModuleKey;
	import com.laifeng.interfaces.IDataModule;
	import com.laifeng.module.vo.StreamLogData;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	
	public class DMReport implements IDataModule
	{
		public const REPORT_URL:String = "http://pstat.xiu.youku.com:80/lr?";
		
		public function DMReport()
		{
			
		}
		
		public function start():void{
			_dmCenter = DataModule.get.getModule(ModuleKey.DM_LIVECORE) as DMCenter;
		}
		
		
		/**统计 :get playlist  success*/
		public function reportGetplaylistSucceed(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=pls";
			url += "&r="     		+  roomId;
			url += "&s="     		+  getStreamId();
			url += "&sid=" 		+ sessionId;
			url += "&tc="   		+ data["tryCount"];
			url += "&u=" 		+ "pc";
			url += "&ct="   		+ data["ct"];
			url += "&src=" 		+ "-1";
			url += "&s_raw=" + "";
			url += "&pu="   + getStreamUrl();
			
			sendReport(url);
		}
		
		public function reportGetplaylistFail(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=plf";
			url += "&r="            + roomId;
			url += "&s="            +  getStreamId();
			url += "&sid="        + sessionId;
			url += "&reason=" + data["reason"];
			url += "&u="        + "pc";
			url += "&tc="          + data["tryCount"];
			url += "&ct="          + data["ct"];
			url += "&ec="          + data["ec"];
			url += "&src="        + "-1";
			url += "&s_raw="   + "";
			
			sendReport(url);
		}
		
		
		public function reportPlayurlSucceed(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=rps";
			url += "&r="     		+ roomId;
			url += "&s="     		+ getStreamId();
			url += "&sid=" 		+ sessionId;
			url += "&u=" 		+ "pc";
			url += "&ct="   		+ data["ct"];
			url += "&src=" 		+ "-1";
			url += "&s_raw=" + "";
			url += "&pu="   + getStreamUrl();
			sendReport(url);
		}
		
		public function reportGetplayurlFail(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=rpf";
			url += "&r="            + roomId;
			url += "&s="            + getStreamId();
			url += "&sid="    	  + sessionId;
			url += "&reason=" + data["msg"];
			url += "&u="        + "pc";
			url += "&ct="          + data["ct"];
			url += "&ec="          + data["code"];
			url += "&src="        + "-1";
			url += "&s_raw="   + "";
			sendReport(url);
		}
		
		
		/**统计: pull stream  success*/
		public function sendStreamSucceedReport(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=pss";
			url += "&r="     + roomId;
			url += "&s="     + getStreamId();
			url += "&sid=" + sessionId;
			url += "&tc="   + 1;
			url += "&d="    + data.d;
			url += "&u=" + "pc";
			url += "&ct="   + data.d;
			url += "&pu="   + getStreamUrl();
			url += "&src=" + "-1";
			url += "&s_raw=" + "";
			sendReport(url);
		}
		
		
		/**统计: pull stream  fail*/
		public function sendStreamFailReport(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=psf";
			url += "&r="     + roomId;
			url += "&s="     + getStreamId();
			url += "&sid=" + sessionId;
			url += "&tc="   + 1;
			url += "&u=" + "pc";
			url += "&ct="   + data.d;
			url += "&reason=" + "StreamNotFound!";
			url += "&pu="   + getStreamUrl();
			url += "&ec=3000";
			url += "&src=" + "-1";
			url += "&s_raw=" + "";
			sendReport(url);
		}
		
		
		/**播放卡*/
		public function sendLowSpeed():void{
			var url:String = REPORT_URL;
			url += "t=pd";
			url += "&r=" 	   + roomId;
			url += "&s=" 	   + getStreamId();
			url += "&sid=" + sessionId;
			url += "&ct="   + "3";
			url += "&u=" + "pc";
			url += "&src=" + "-1";
			url += "&s_raw=" + "";
			sendReport(url);
		}
		
		
		/**1分钟发一次*/
		public function sendCVLog(kaStr:String):void{
			var url:String = REPORT_URL;
			url += "t=cv1";
			url += "&r=" 		+ roomId;
			url += "&s=" 		+ getStreamId();
			url += "&sid=" 	+ sessionId;
			url += "&nt=" 	+ streamLogData.nsTime;
			url += "&bt=" 	+ streamLogData.bufferTime;
			url += "&btl=" 	+ streamLogData.bytesLoaded;
			url += "&bfl=" 	+ streamLogData.bufferLength;
			url += "&bec=" 	+ streamLogData.bufferEmptyCount;      //bufferEmptyCount
			url += "&cbec=" + streamLogData.currBfeCount;   //currentBufferEmptyCount
			url += "&st=" 	+ streamLogData.systemTime;
			url += "&vt=" 	+ streamLogData.videoTime;
			url += "&pu="   + getStreamUrl();
			url += "&ct="   + "1";
			url += "&u=" + "pc";
			url += "&src=" + "-1";
			url += "&s_raw=" + "";
			url += "&ka=" + kaStr;
			
			/*
			if(isP2p()){
			url += "&useP2p=" + "true";
			url += "&loacaltionid=" + LiveConfig.get.streamLogData.localconntionId;
			if(LiveConfig.get.streamLogData.playStatus.indexOf("noData")<0){
			url+= formatP2pPlaystatus(LiveConfig.get.streamLogData.playStatus);
			}
			}
			*/
			
			sendReport(url);
		}
		
		
		/**
		 * stream delay
		 * 播放延迟
		 * 改为统计  从拉流到第一帧画面出现 所用的时间
		 */
		public function sendStreamDelay(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=dp";
			url += "&r="    + roomId;
			url += "&s="     + getStreamId();
			url += "&sid=" + sessionId;
			url += "&d="    + 3000;
			url += "&u=" + "pc";
			url += "&ct="   + data["delayTime"];
			url += "&src=" + "-1";
			url += "&s_raw=" + "";
			
			sendReport(url); 
		}
		
		public function sendStreamError(data:Object):void{
			var url:String = REPORT_URL;
			url += "t=err";
			url += "&r=" + roomId;
			url += "&s=" + getStreamId();
			url += "&sid=" + sessionId;
			url += "&reason=" + data["msg"];
			url += "&pu="   + getStreamUrl();
			url += "&ec=3000";
			url += "&ct="   + "0";
			url += "&u=" + "pc";
			url += "&src=" + "-1";
			url += "&s_raw=" + "";
			
			sendReport(url);
		}
		
		
		/**发送log*/
		private function sendReport(url:String):void{
			url += "&v="+LiveConfig.PLAYER_VERSION;
			url += "&appid="+appId+"&userid="+this.userId;
			try{
				ExternalInterface.call(LiveConfig.get.jsNameSpace+"reportStatus",{url:encodeURI(url)});
			}catch(err:Error){/** 不做处理 */}
		}
		
		
		private function formatP2pPlaystatus(str:String):String{
			var log:String  = "";
			var arr:Array = str.split("\n");
			var row:String = "";
			for(var i:int=0; i<arr.length; i++){
				row = arr[i];
				var sArr:Array = row.split(": ");
				
				if(sArr[0]=="curSavingRatio"){
					var s:String = sArr[1];
					s = s.substring(0,s.length-1);
					sArr[1] = Number(s)/100;
				}
				log += "&"+sArr[0]+"="+sArr[1];
				sArr = null;
			}
			
			arr = null;
			return log;
		}
		
		
		
		private function get userId():String{
			return LiveConfig.get.initOption.userid;
		}
		
		private function get appId():int{
			return LiveConfig.get.initOption.appId;
		}
		
		private function get roomId():String{
			return LiveConfig.get.initOption.roomId;
		}
		
		private function get sessionId():String{
			return LiveConfig.get.initOption.sessionId;
		}
		
		
		private function getStreamId():String{
			return _dmCenter.getLiveCoreData().streamId;
		}
		
		
		
		private function getStreamUrl():String{
			return _dmCenter.getLiveCoreData().getStreamUrl();
		}
		
		
		
		private function get streamLogData():StreamLogData{
			return LiveConfig.get.streamLogData;
		}
		
		
		
		public function destroy():void{
			
		}
		
		
		
		private var _dmCenter:DMCenter;
		
		
		
		
	}
}