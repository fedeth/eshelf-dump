// Recaptcha module
function recaptchaIsActive() {
  return globalState.pageModel.recaptcha_v3 && globalState.pageModel.recaptcha_v3.site_key;
}

let waitForRecaptchaToken = (timeoutms, tokenType, callback) => new Promise((r, j)=> {
  var check = () => {
    if( typeof globalState.pageModel.recaptcha_v3[tokenType] == "string") {
      callback();
    }
    else if((timeoutms -= 100) < 0) {
      console.log('recptcha response timed out, bail out');
    }
    else {
      setTimeout(check, 100);
    }
  }
  setTimeout(check, 100)
});

function createRecaptchaToken(tokenName) {
  grecaptcha.ready(() => {
    grecaptcha.execute(globalState.pageModel.recaptcha_v3.site_key, {action: "registration"}).then(token => { 
      globalState.pageModel.recaptcha_v3[tokenName] = token;
      console.log(tokenName + "token generated");
    });
  });
}

function mayAddRegistrationRecaptcha() {
  let submitRegistrationForm = () => {
    let signUpToken = globalState.pageModel.recaptcha_v3["sign_up_token"];
    $("#new_user").prepend("<input type='hidden' name='recaptcha_v3_token' value=" + signUpToken + ">");
    return document.getElementById("new_user").submit();
  };
  if(recaptchaIsActive()) {
    createRecaptchaToken("sign_up_token");
    waitForRecaptchaToken(1000, "sign_up_token", submitRegistrationForm);
  } else {
    submitRegistrationForm();
  }
}

const recaptchaV3Mixin = {
  methods: {
    recaptchaIsActive,
    mayAddRegistrationRecaptcha,
    waitForRecaptchaToken,
    createRecaptchaToken
  },
};

const RecaptchaV3 = { recaptchaIsActive };

export { RecaptchaV3, recaptchaV3Mixin };