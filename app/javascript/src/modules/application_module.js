// modular lodash module
var negate = require('lodash.negate');
var isNil = require('lodash.isnil');
var cloneDeep = require('lodash.clonedeep');

// This function can be used to execute another function just once; it's useful to call a function
// once in a vue template (to implement a kind of jquery's onDocumentReady).
// The id parameter is used to set a boolean for the test.
// The function is actually execute just once for each id.
const executeOnceIds = {};
function executeOnce(id, funct) {
  if (!executeOnceIds.hasOwnProperty(id)) {
    executeOnceIds[id] = true;
    funct();
  }
}

function isTouchSupported() {
  return "ontouchstart" in window || navigator.msMaxTouchPoints;
}

function isTouchDevice() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

function capitalize(string) {
  return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

const AJAX_LOCKS = {};
function ajax({ url, method = "POST", processData, contentType, data = {}, success = (() => {}), error = (() => {}), xhr }, complete = (() => {})) {
  const ajax_lock_key = `${url}-${JSON.stringify(data)}`;
  if (!exists(AJAX_LOCKS[ajax_lock_key])) {
    AJAX_LOCKS[url] = true;
    $.ajax({
      async: true, // TODO: Find for more info about this flag
      method: method,
      processData: processData,
      contentType: contentType,
      xhr: xhr,
      data: data,
      url: url,
      beforeSend(jqXHR) {
        jqXHR.setRequestHeader("X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content"));
      },
      success: (data, textStatus, jqXHR) => {
        delete AJAX_LOCKS[ajax_lock_key];
        success(data, textStatus, jqXHR);
      },
      error: (jqXHR, textStatus, errorThrown) => {
        delete AJAX_LOCKS[ajax_lock_key];
        error(jqXHR, textStatus, errorThrown);
      },
      complete: () => complete()
    });
  }
}

function postDataForm({ url, data , success = (() => {}), error = (() => {}) }, complete = (() => {})){
  return ajax({
    url: url,
    type: "POST",
    processData: false, // Necessary to upload attachments correctly
    contentType: false,
    data: buildFormData(data),
    success,
    error,
    complete
  });
}

function buildFormData(data) {
  const formData = new FormData();
  Object.keys(data).forEach(key => {
    if (typeof data[key] === "object" && key !== "file") {
      formData.append(key, JSON.stringify(data[key]));
    } else {
      formData.append(key, data[key]);
    }
  });
  return formData;
}

function post({ url, data, success = (() => {}), error = (() => {}) }, complete = (() => {})) {
  return ajax({
    url: url,
    type: "POST",
    data: JSON.stringify(data),
    contentType: "application/json",
    success,
    error,
    complete
  });
}

function ajaxGet({ url, data, success = (() => {}), error = (() => {}) }) {
  let urlWithData = `${url}?${$.param(data)}`;
  // Object.keys(data).forEach(key => {
  //   urlWithData = `${urlWithData}${key}=${data[key]}&`;
  // });

  return $.get({
    url: urlWithData,
    success,
    error
  });
}

function put({ url, data, success = (() => {}), error = (() => {}) }, complete = (() => {})) {
  return ajax({
    url: url,
    type: "PUT",
    data: JSON.stringify(data),
    contentType: "application/json",
    success,
    error,
    complete
  });
}

function ajaxDelete({ url, success = (() => {}), error = (() => {}) }, complete = (() => {})) {
  return ajax({
    url: url,
    type: "DELETE",
    contentType: "application/json",
    success,
    error,
    complete
  });
}

function removeNullProperties(originalObj){
  var obj = cloneDeep(originalObj);
  var propNames = Object.getOwnPropertyNames(obj);
  for (var i = 0; i < propNames.length; i++) {
    var propName = propNames[i];
    if (obj[propName] === null || obj[propName] === undefined) {
      delete obj[propName];
    }
  }
  return obj;
}

const exists = negate(isNil);

function acceptCookies(domain) {
  const url = domain || window.location.hostname;
  const d = new Date();
  d.setFullYear(d.getFullYear() + 1);
  document.cookie = `user_cookies=true;domain=${url};expires=${d.toUTCString};path=/;`;
}

function setCookie(name, value, expires) {
  const expiresString = exists(expires) ? `expires=${expires}` : `${expires}`;
  document.cookie = `${name}=${value};${expiresString};path=/;`;
}

function scrollToDirection(id, offset, direction) {
  const scrollId = id.charAt(0) === "#" ? id : `#${id}`;
  const margin = exists(offset) ? offset : 0;
  const position = $(scrollId).offset().top - margin + (direction === "bottom" ? $(scrollId).height() : 0);

  $("html, body").animate({
    scrollTop: position
  }, 600, "linear");
}

function scrollToTop(id, offset) {
  scrollToDirection(id, offset, "top");
}

function scrollToBottom(id, offset) {
  scrollToDirection(id, offset, "bottom");
}

function getFromQueryString(queryString, name) {
  const searchName = name.replace(/[[]/, "\\[").replace(/[\]]/, "\\]");
  const regex = new RegExp(`[\\?&]${searchName}=([^&#]*)`);
  const results = regex.exec(queryString);
  return exists(results) ? decodeURIComponent(results[1].replace(/\+/g, " ")) : null;
}

function getUrlParameter(name) {
  return getFromQueryString(location.search, name);
}

function getJSONUrlParameter(name) {
  const param = getUrlParameter(name);
  return param && JSON.parse(param);
}

function readCookie(name) {
  const matches = document.cookie.match(`(^|[^;]+)\\s*${name}\\s*=\\s*([^;]+)`);
  return exists(matches) ? matches[0] : null;
}

function deleteCookie(name) {
  document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
}

function isSafari() {
  return navigator.userAgent.indexOf("Safari") !== -1 && navigator.userAgent.indexOf("Chrome") === -1;
}

// Careful, this solution does a deepClone but it doesn't work in some edge cases (eg with a regex)
// Use lodash cloneDeep in this cases, it is slower by an huge margin (~ +50%) but it works in every case
// Form more info see https://stackoverflow.com/a/122704
function deepClone(item) {
  return JSON.parse(JSON.stringify(item));
}

function getTarget(field) {
  const newTab = get(field, "new_tab", false);
  return newTab ? "_blank" : "_self";
}

// exports
const ApplicationModule = {
  getTarget:getTarget,
  deepClone:deepClone,
  isSafari:isSafari,
  deleteCookie:deleteCookie,
  readCookie:readCookie,
  getJSONUrlParameter:getJSONUrlParameter,
  getUrlParameter:getUrlParameter,
  scrollToBottom:scrollToBottom,
  scrollToTop:scrollToTop,
  scrollToDirection:scrollToDirection,
  setCookie:setCookie,
  isTouchSupported:isTouchSupported,
  executeOnce:executeOnce,
  acceptCookies:acceptCookies,
  post:post,
  ajaxGet: ajaxGet,
  ajax:ajax,
  capitalize:capitalize,
  postDataForm: postDataForm,
  removeNullProperties: removeNullProperties,
};

export { ApplicationModule };
