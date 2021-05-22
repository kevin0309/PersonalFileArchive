var $$ = {
	copyToClipboard: function(val) {
		var t = document.createElement("textarea");
		document.body.appendChild(t);
		t.value = val;
		t.select();
		document.execCommand('copy');
		document.body.removeChild(t);
		toastr["info"]('클립보드에 복사되었습니다.');
	},
	convertToVolumeStr: function(fileVolume) {
		var sizeStr;
		var temp = fileVolume;
		if (temp < 1024)
			sizeStr = Math.round(temp*100)/100.0+' Byte';
		else if ((temp /= 1024) < 1024)
			sizeStr = Math.round(temp*100)/100.0+' KB';
		else if ((temp /= 1024) < 1024)
			sizeStr = Math.round(temp*100)/100.0+' MB';
		else if ((temp /= 1024) < 1024)
			sizeStr = Math.round(temp*100)/100.0+' GB';
		else if ((temp /= 1024) < 1024)
			sizeStr = Math.round(temp*100)/100.0+' TB';
		else if ((temp /= 1024) < 1024)
			sizeStr = Math.round(temp*100)/100.0+' PB';
		return sizeStr;
	},
	/**
	 * 브라우저 환경에 따라 함수를 실행시킨다.<br>
	 * 실핼시킬 함수는 funcObj에 지정한다.
	 * 
	 * @param funcObj	: (object) 실행시킬 함수를 담는 객체<br><br>
	 * <b>funcObj 필드는 다음과 같다.</b><br>
	 * @param pc		: (function) PC 브라우저일때 동작 (PC의 최상위 메소드이므로 해당 파라미터 설정시 하위함수가 동작하지 않음)
	 * @param oldIE	: (function) PC 브라우저 - IE 10 이하 버전에서 동작
	 * @param IE11		: (function) PC 브라우저 - IE 11 에서 동작
	 * @param edge		: (function) PC 브라우저 - IE 12 이상 버전, Edge 브라우저에서 동작
	 * @param chrome	: (function) PC 브라우저 - Chrome 에서 동작
	 * @param firefox	: (function) PC 브라우저 - Firefox 에서 동작
	 * @param opera	: (function) PC 브라우저 - Opera 에서 동작
	 * @param pcEtc	: (function) PC 브라우저 - 위의 PC브라우저에 해당되지 않는 브라우저일 때 동작
	 * <br><br>
	 * @param mobile	: (function) 모바일 브라우저일때 동작 (모바일의 최상위 메소드이므로 해당 파라미터 설정시 하위함수가 동작하지 않음)
	 * @param android	: (function) 모바일 브라우저 - Android 디바이스 에서 동작
	 * @param ios	: (function) 모바일 브라우저 - IOS 디바이스 에서 동작
	 * @param mobileEtc: (function) 모바일 브라우저 - 위의 모바일 디바이스에 해당되지 않는 디바이스일 때 동작
	 * <br><br>
	 * @param error	: (function) javascript에서 window.navigator.platform 객체를 지원하지 않는 브라우저의 경우 동작 
	 */
	browserFilter: function(funcObj) {
		var browsers = 'win16|win32|win64|mac|macintel';
		
		if (navigator.platform) {
			if (browsers.indexOf(navigator.platform.toLowerCase()) < 0) {
				//mobile browsers
				if (typeof(funcObj.mobile) === 'function') {
					funcObj.mobile();
					return;
				}
				
				var userAgent = navigator.userAgent.toLowerCase();
				
				if (userAgent.match('android') != null) {
					//Android devices
					if (typeof(funcObj.android) === 'function') {
						funcObj.android();
						return;
					}
				}
				else if (userAgent.indexOf('iphone')>-1 || userAgent.indexOf('ipad')>-1 || userAgent.indexOf('ipod')>-1) {
					//Apple devices
					if (typeof(funcObj.ios) === 'function') {
						funcObj.ios();
						return;
					}
				}
				
				//other mobile devices
				if (typeof(funcObj.mobileEtc) === 'function') {
					funcObj.mobileEtc();
				}
				else {
					console.warn('browserFilter - Undefined Mobile client (recommendation : set "mobileEtc" function.)\n\nCheck out the client info below.\nPlatform : Mobile\nClient userAgent : '+userAgent);
				}
			}
			else {
				//PC browsers
				if (typeof(funcObj.pc) === 'function') {
					funcObj.pc();
					return;
				}
				
				var userAgent = navigator.userAgent;
				
				if (userAgent.indexOf('MSIE ') > 0) {
					//IE 10 or old IE browsers
					if (typeof(funcObj.oldIE) === 'function') {
						funcObj.oldIE();
						return;
					}
				}
				else if (userAgent.indexOf('Trident/') > 0) {
					//IE 11
					if (typeof(funcObj.IE11) === 'function') {
						funcObj.IE11();
						return;
					}
				}
				else if (userAgent.indexOf('Edge/') > 0) {
					//Edge (IE 12+)
					if (typeof(funcObj.edge) === 'function') {
						funcObj.edge();
						return;
					}
				}
				else if (userAgent.toLowerCase().indexOf('chrome') > 0 && navigator.vendor.toLowerCase().indexOf("google") > -1) {
					//Chrome
					if (typeof(funcObj.chrome) === 'function') {
						funcObj.chrome();
						return;
					}
				}
				else if (userAgent.toLowerCase().indexOf('firefox') > -1) {
					//Firefox
					if (typeof(funcObj.firefox) === 'function') {
						funcObj.firefox();
						return;
					}
				}
				else if (userAgent.indexOf('OPR')) {
					//Opera
					if (typeof(funcObj.opera) === 'function') {
						funcObj.opera();
						return;
					}
				}

				//other PC browsers
				if (typeof(funcObj.pcEtc) === 'function') {
					funcObj.pcEtc();
				}
				else {
					console.warn('browserFilter - Undefined PC client. (recommendation : set "pcEtc" function.)\n\nCheck out the client info below.\nPlatform : PC\nClient userAgent : '+userAgent);
				}
			}
		}
		else {
			//지원하지 않는 자바스크립트버전
			console.error('browserFilter - This browser does not support the JavaScript required for this function(browserFilter).')
			if (typeof(funcObj.error) === 'function')
				funcObj.error();
			else {
				console.warn('browserFilter - Error callback function undefined. (recommendation : set "error" function.)');
			}
		}
	},
	getURLParam: function() {
		var param = {};
		var url = location.href.split('#')[0];
		var str = url.split('?');
		var str2 = str[1].split('&');
		
		for (var i = 0; i < str2.length ;i++) {
			var str3 = str2[i].split('=');
			param[str3[0]] = str3[1];
		}
		if (param == '')
			console.log('VALUE NOT FOUND');
		else
			return param;
	},
	/**
	 * 값을받아 폼을 생성한뒤 제출하는 메소드
	 * get, post 메소드를 사용하며
	 * @param url : (String) form의 action속성에 들어갈 URL
	 * @param param : (Object) 전속할 파라미터 객체
	 * @param (target) : (target) form의 target속성
	 * @param (submit) : (boolean) 폼 생성 후 자동으로 submit 시킬 것인지(기본 true)
	 */
	sendParam: {
			targetURL: '',
			reqParam: {},
			target: '',
			submit: true,
			formID: 'sendParamDefaultFormID',
			get: function(url, param, target, submit) {
				this.targetURL = url;
				this.reqParam = param;
				this.target = target;
				this.submit = submit;
				if (typeof(submit) == 'undefined')
					this.submit = true;
				
				if (!sendParam.checkArguments())
					return;
				else {
					this.addForm('get');
					for (prop in this.reqParam) {
						this.addInput(prop, this.reqParam[prop]);
					}
					if (this.submit)
						this.submitForm();
				}
			},
			post: function(url, param, target, submit) {
				this.targetURL = url;
				this.reqParam = param;
				this.target = target;
				this.submit = submit;
				if (typeof(submit) == 'undefined')
					this.submit = true;
				
				if (!sendParam.checkArguments())
					return;
				else {
					this.addForm('post');
					for (prop in this.reqParam) {
						this.addInput(prop, this.reqParam[prop]);
					}
					if (this.submit)
						this.submitForm();
				}
			},
			checkArguments: function() {
				if (this.targetURL == '' || this.targetURL == null) {
					console.log("Need URL argument");
					return false;
				}
				if (this.submit == '' || this.submit == null) {
					return true;
				}
				else if (typeof(this.submit) != 'boolean') {
					console.log('Put boolean type to submit argument');
					return false;;
				}
				return true;
			},
			addForm: function(method) {
				var $form = $('<form></form>');
				$form.attr('action', this.targetURL);
				$form.attr('method', method);
				$form.attr('id', this.formID);
				if (!(this.target == '' || this.target == null))
					$form.attr('target', this.target);
				$form.appendTo('body');
			},
			addInput: function(name, value) {
				var $input = $('<input>');
				$input.attr('type', 'hidden');
				$input.attr('name', name);
				$input.attr('value', value);
				$input.appendTo('#'+this.formID);
			},
			submitForm: function() {
				if ($('#'+this.formID).length == 0) {
					alert('Form not found.');
				}
				else {
					$('#'+this.formID).submit();
					$('#'+this.formID).remove();
				}
			}
	},
	mask: {
		open: function({opacity, target}) {
			$('#yh-mask-default').remove();
			if (!target)
				target = 'body';
			$(target).append(
				'<div class="yh-mask" id="yh-mask-default"></div>'
			);
			if (opacity) {
				setTimeout(function() {
					$('#yh-mask-default').css('background-color', 'rgba(0, 0, 0, '+opacity+')');
				}, 100);
			}
		},
		close: function(closeCallbackFn) {
			$('#yh-mask-default').css('background-color', 'rgba(0, 0, 0, 0.01)');
			setTimeout(function() {
				$('#yh-mask-default').remove();
				if (typeof(closeCallbackFn) === 'function')
					closeCallbackFn();
			}, 500);
		}
	},
	loadingAnimation: {
		open: function({maskId, target}) {
			$('#loading-'+maskId).remove();
			if (!target)
				target = 'body';
			$(target).append('<div class="loading" id="loading-'+maskId+'"><div></div></div>');
			setTimeout(function() {
				$('#loading-'+maskId).css('opacity', '1');
			}, 100);
			
		},
		close: function(maskId, closeCallbackFn) {
			$('#loading-'+maskId).css('opacity', '0');
			setTimeout(function() {
				$('#loading-'+maskId).remove();
				if (typeof(closeCallbackFn) === 'function')
					closeCallbackFn();
			}, 500);
		}
	},
	popupLayer: {
		open: function(layerId) {
			var _this = this;
			var $htmlToAdd = $('<div class="popupLayer" id="popup'+layerId+'">'+
									'<div class="popupLayerWrapper">' +
										'<div id="popupCloseBtn" style="position: fixed; z-index: 1; right: 15px; float:right; font-size: 30px;">X</div>' +
										'<div class="popupLayerContent"></div>' +
									'</div>' +
								'</div>');
			$htmlToAdd.find('#popupCloseBtn').click(function() {_this.close(layerId);});
			$('body').append($htmlToAdd);
			
			setTimeout(function() {
				$('#popup'+layerId).css('opacity', '1');
			}, 100);
			
			return $htmlToAdd;
		},
		close: function(layerId) {
			$('#popup'+layerId).css('opacity', '0');
			setTimeout(function() {
				$('#popup'+layerId).remove();
			}, 500);
		}
	},
	toast: {
		push: function(msg) {
			var obj = {
				pc: function() {
					$$.toast.pc.push(msg);
				},
				mobile: function() {
					$$.toast.mobile.push(msg);
				}
			}
			$$.browserFilter(obj);
		},
		mobile: {
			/**
			 * 모바일용 toast 메세지를 띄운다.<br>
			 * 하단에 작게 반투명한 회색 박스로 만들어진다.<br>
			 * 텍스트가 두줄을 넘어가면 잘리므로 주의
			 * 
			 * @param msg (String) toast 메시지 
			 */
			push: function(msg) {
				$('.toastMsg_mobile').remove();
				var curTime = new Date();
				curTime = curTime.getTime();
				var alertId = 'alert'+curTime;
				$('body').append(
					'<div class="toastMsg_mobile" id="'+alertId+'">' +
						'<div>' + msg + '</div>' +
					'</div>'
				)
				setTimeout (function() {
					$('#'+alertId).css('transition', 'opacity 0.4s ease 0s');
					$('#'+alertId).css('opacity', '1');
					setTimeout(function() {
						$('#'+alertId).css('transition', 'opacity 1s ease-in 3s')
						$('#'+alertId).css('opacity', '0');
						setTimeout(function() {
							//$('#'+alertId).remove();
						}, 4200);
					}, 600);
				}, 100);
			}
		},
		pc: {
			push: function(msg) {
				$('.toastMsg').remove();
				var curTime = new Date();
				curTime = curTime.getTime();
				var alertId = 'alert'+curTime;
				$('body').append(
					'<div class="toastMsg" id="'+alertId+'">' +
						'<div>' + msg + '</div>' +
					'</div>'
				)
				setTimeout (function() {
					$('#'+alertId).css('transition', 'opacity 0.4s ease 0s');
					$('#'+alertId).css('opacity', '1');
					setTimeout(function() {
						$('#'+alertId).css('transition', 'opacity 1s ease-in 3s')
						$('#'+alertId).css('opacity', '0');
						setTimeout(function() {
							//$('#'+alertId).remove();
						}, 4200);
					}, 600);
				}, 100);
			}
		}
	}
}