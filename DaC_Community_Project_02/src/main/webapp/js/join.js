// 다음 주소 api
function openZipSearch() {
    new daum.Postcode({
    	oncomplete: function(data) {     
		var userAddr = ''; 
		if (data.userSelectedType === 'R') { 
			userAddr = data.roadAddress;
		} else {
			userAddr = data.jibunAddress;
		}

		$("#zip_code").val(data.zonecode);
		$("#userAddr").val(userAddr);
        }
    }).open();
}
    
// Email 중복 체크 팝업 오픈
function checkid(){
	var userEmail = document.getElementById("userEmail").value;
	if(userEmail)  //userid로 받음
	{
		url = "joinIdCheck.jsp?userEmail="+userEmail;
		window.open(url,"chkid","width=400,height=200");
	} else {
		alert("아이디를 입력하세요.");
	}
}