	//8자리 이상, 대문자, 소문자, 숫자, 특수문자 모두 포함되어 있는 지 검사
    var reg = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    
    function join(){
        //값이 있을 때 true, 값이 없을 때 false
        if(userEmail.value == ""){
            alert("이메일을 입력해주세요.");
            userEmail.focus();
            return false;
        }
        if(idDuplication.value != "true"){
			alert("이메일 중복체크를 해주세요.");
			return false;

		}
        if(userPassword.value == ""){
            alert("비밀번호를 입력해주세요.");
            userPassword.focus();
            return false;
        }
        if(!(reg.test(userPassword.value))){
            alert("비밀번호는 8자리 이상이어야 하며, 대문자/소문자/숫자/특수문자 모두 포함해야 합니다.");
            userPassword.focus();
            return false;
        }
        if(userPassword.value != re_password.value){
            alert("비밀번호를 확인해주세요.");
            userPassword.focus();
            return false;
        }
        if(userName.value == ""){
            alert("이름을 입력해주세요.");
            userName.focus();
            return false;
        }
        if(userAddr.value == ""){
            alert("주소를 입력해주세요.");
            userAddr.focus();
            return false;
        }
		return true;
    }
