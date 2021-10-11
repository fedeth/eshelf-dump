import { ApplicationModule } from "src/modules/application_module.js";

function addComment(text, contentId, successCallback) {
  ApplicationModule.post({
    url: "/api/v1/add_comment",
    data: {text: text, content_id: contentId},
    success: (data) => {
      if(data.success) {
        console.log(data);
        if(successCallback) {
          successCallback(data);
        }
      }
    }
  });
}

function getComments(contentId, successCallback) {
  ApplicationModule.ajaxGet({
    url: "/api/v1/get_comments",
    data: {content_id: contentId},
    success: (data) => {
      if(data.success) {
        console.log(data);
        if(successCallback) {
          successCallback(data);
        }
      }
    }
  });
}

const commentsMixin = {
  data() {
    return {
      comments: []
    };
  },
  methods: {
    addComment,
    getComments
  },
};

export { commentsMixin };